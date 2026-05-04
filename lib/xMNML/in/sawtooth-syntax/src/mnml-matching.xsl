<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="3.0"
  expand-text="true">

  <!--
    Consumes tokens produced from mnml-lmnl.ixml parse
    
    produces an annotated copy ready for casting into a range model
    -->

  <xsl:mode on-no-match="fail" use-accumulators="tag_stack"/>

  <xsl:mode name="walk" on-no-match="fail" use-accumulators="tag_stack"/>
  
  <xsl:mode name="rID"  on-no-match="fail" use-accumulators="tag_stack"/>
  
  <!-- The accumulator  'tag_stack' tracks the open ranges by keeping 'start'
      elements in a sequence and removing them again as the matching 'end'
      elements are seen.
    Because the accumulator does not increment within the sibling
      tag markers (elements), but only with the markers themselves,
      the accumulator-after() function will return the same as
      accumulator-before(), for any given element.
    Accordingly, the template matching 'end', which tags the end tag
    with its corresponding start tag, looks at its predecessor start tag
    
    In addition to matching up tags, this XSLT prepares us for the next step
    by translating character escape sequences into the characters they represent
    - so offsets will be counted accordingly and the text thereafter will be 'clean'.

  -->

  <xsl:accumulator name="tag_stack" initial-value="()" as="element()*">
    <xsl:accumulator-rule match="start" select="($value, .)"/>
    <xsl:accumulator-rule match="end">
      <xsl:variable name="rID" select="@name"/>
      <xsl:sequence select="$value except ($value[@name = $rID][last()])"/>
    </xsl:accumulator-rule>
  </xsl:accumulator>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/LMNL">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text[string(.) => not()]"/>

  <xsl:template match="text">
    <xsl:variable name="within" as="xs:string*">
      <xsl:apply-templates select="accumulator-before('tag_stack')" mode="rID"/>
    </xsl:variable>
    <xsl:copy>
      <xsl:attribute name="cf" separator=" " select="$within"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="start | empty">    
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="rID">
        <xsl:apply-templates select="." mode="rID"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="end">
    <xsl:variable name="matching" select="@name"/>
    <xsl:variable name="isClosing"
      select="((preceding-sibling::start[1]|preceding-sibling::end[1])[last()]/accumulator-after('tag_stack'))
      [@name=$matching][last()]"/>
    
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="rID">
        <xsl:apply-templates select="$isClosing" mode="rID"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()">
    <!-- Unescaping by removing reverse solidi when preceded by { [ or \ -->
    <xsl:text>{ replace(.,'\\([\[\{\\])','$1') }</xsl:text>
  </xsl:template>

  <xsl:template match="annotation">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template priority="101" match="@name[contains(., '#')]">
    <xsl:attribute name="gi">{ tokenize(., '#')[1] }</xsl:attribute>
    <xsl:attribute name="id">{ tokenize(., '#')[2] }</xsl:attribute>
  </xsl:template>

  <xsl:template match="@name">
    <xsl:attribute name="gi">{ . }</xsl:attribute>
  </xsl:template>

  <xsl:variable name="zeroPadded" select="
      count(/*/start | /*/empty) =>
      string() => replace('\d', '0') => replace('0$', '1')"/>

  <!-- Some semantic redundancy / overloading in the ID, for transparency -->
  <xsl:template match="start | empty" mode="rID">
    <xsl:variable name="n">
      <xsl:number count="start | empty" format="{ $zeroPadded }"/>
    </xsl:variable>
    <xsl:text>r{ $n }{ @name/('_' || replace(.,'#.*','')) }</xsl:text>
  </xsl:template>

</xsl:stylesheet>