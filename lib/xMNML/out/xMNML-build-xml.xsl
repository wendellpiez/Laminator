<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xpath-default-namespace="http://wendellpiez.com/ns/xMNML"
  exclude-result-prefixes="#all" version="3.0">

  <xsl:output indent="true"/>

  <!-- Names of ranges to be promoted -->
  <xsl:param name="promote" as="xs:string" select="//(start|end)/@gi => distinct-values() => string-join(' ')"/>
  
  <!-- Names of ranges to be rendered at leaf level (flattened) -->
  <xsl:param name="reduce" as="xs:string" select="''"/>
  
  <xsl:variable name="promoting" select="tokenize($promote,'\s+')"/>
  <xsl:variable name="reducing"  select="tokenize($reduce, '\s+')"/>
  
  <!--

TBD   
todo - unit test this XSLT (if deployed)
  test $promote and $reduce

the approach
  accepts xMNML in
  groups /LMNL/text elements on successive values of @cf
    
    use a function for excluding @cf nominees from the hierarchy
    inside the group at the leaf level, provide wrappers for the excluded ranges
  
  test against Plutarch Alex example
    w/ and w/o 'match' elements in exclusion list
    
  -->
  
<!-- Preprocess input to annotate //text with ids of ranges to promote and to reduce (only) -->
     <!-- Then group over these -->
  
  <xsl:template match="/*">
    <xsl:message terminate="yes">Unable to process.</xsl:message>
  </xsl:template>
  
  <xsl:variable name="xMNML" select="/"/>
  
  <xsl:template match="/LMNL" priority="101">
    <xsl:element name="mnml:LMNL" namespace="http://wendellpiez.com/ns/xMNML">
      <xsl:copy-of select="@*"/>
      <xsl:call-template name="hoist"/>
    </xsl:element>
  </xsl:template>
  
  <!-- Names of nodes to be included in the hierarchy -->
  <xsl:function name="mnml:include" as="xs:boolean" cache="true">
    <xsl:param name="r" as="element()"/>
    <xsl:sequence select="$r/@gi = $promoting"/>
  </xsl:function>
  
  <!-- Names of nodes to be reduced to spans around text nodes -->
  <xsl:function name="mnml:split-out" as="xs:boolean" cache="true">
    <xsl:param name="r" as="element()"/>
    <xsl:sequence select="$r/@gi = $reducing"/>
  </xsl:function>
  
  <!--(Next: names of nodes to be represented with milestone elements?)-->
  
  <xsl:key name="range-starts" match="start | empty" use="@rID"/>
  
  <xsl:key name="empties-at-offset" match="empty" use="@off"/>
  
  <xsl:key name="range-ends"   match="end"           use="@rID"/>
  
  <!--Returns values from @cf to be included (as strings, for grouping keys) -->
  <xsl:function name="mnml:included-rIDs" as="xs:string*" cache="true">
    <xsl:param name="from" as="element(text)"/>
    <xsl:sequence select="key('range-starts', tokenize($from/@cf,'\s+'), $xMNML )[mnml:include(.)]/@rID"/>
  </xsl:function>
  
  <!--Returns values from @cf to be excluded (as strings, for grouping keys) -->
  <xsl:function name="mnml:split-out-rIDs" as="xs:string*" cache="true">
    <xsl:param name="from" as="element(text)"/>
    <xsl:sequence select="key('range-starts', tokenize($from/@cf,'\s+'), $xMNML )[mnml:split-out(.)]/@rID"/>
  </xsl:function>
  
  
  <xsl:template name="hoist">
    <xsl:param name="texts" select="child::text"/>
    <xsl:param name="l" select="1"/>
    <xsl:for-each-group select="$texts" group-adjacent="(mnml:included-rIDs(.)[$l],'') => head()">
      <xsl:variable name="range" select="key('range-starts',current-grouping-key())"/>
      <xsl:choose>
        <xsl:when test="exists($range)">
          <xsl:call-template name="make-element">
            <xsl:with-param name="range" select="$range"/>
            <xsl:with-param name="contents">
              <xsl:call-template name="grab-empties"/>
              <xsl:call-template name="hoist">
                <xsl:with-param name="l" select="$l + 1"/>
                <xsl:with-param name="texts" select="current-group()"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!-- if the grouping string is empty, we're down to text -->
          <xsl:apply-templates select="current-group()" mode="emit"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>
  
  <!-- Context is a 'start' range marker -->
  <xsl:template name="grab-empties">
    <xsl:if test="@off &lt; following-sibling::*[1]/@off">
      <xsl:apply-templates select="key('empties-at-offset',@off)[mnml:include(.)]" mode="emit"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="make-element">
    <xsl:param name="range" required="yes"/>
    <xsl:param name="contents" select="()"/>
    <xsl:variable name="end" select="key('range-ends',$range/@rID)"/><!-- no-op for empty -->
    <xsl:element name="{ $range/@gi }">
      <xsl:apply-templates mode="annotate-elements" select="$range, $end"/>
      <xsl:copy-of select="$contents"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="*" mode="annotate-elements">
    <!-- Demotes annotations into XML attributes -->
    <xsl:for-each-group select="annotation" group-by="@gi">
      <xsl:attribute name="{ current-grouping-key() }">
        <xsl:value-of select="current-group()" separator=" "/>
      </xsl:attribute>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="empty" mode="emit">
    <xsl:call-template name="make-element">
      <xsl:with-param name="range" select="."/>
    </xsl:call-template>
  </xsl:template>
  
  <!--Template calls itself recursively to unspool elements
      around each bit of text for ranges being split out -->
  <xsl:template match="text" mode="emit">
    <xsl:param name="wrappers" select="mnml:split-out-rIDs(.)"/>
    <xsl:variable name="range" select="key('range-starts', $wrappers[1], $xMNML)"/>
    <xsl:variable name="end" select="key('range-ends', $range/@rID)"/>
    
    <xsl:choose expand-text="true">
      <xsl:when test="exists($range)">
        <xsl:element name="{ $range/@gi }">
          <xsl:attribute name="mnml:sameAs">{ generate-id($range) }</xsl:attribute>
          <xsl:apply-templates mode="annotate-elements" select="$range, $end"/>
          <xsl:apply-templates select="self::text" mode="emit">
            <xsl:with-param name="wrappers" select="$wrappers => tail()"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise><!-- All the way at the bottom -->
        <xsl:call-template name="grab-empties"/>
        <xsl:text>{ string(.) }</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  
</xsl:stylesheet>