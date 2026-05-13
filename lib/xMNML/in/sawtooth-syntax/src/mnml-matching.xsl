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

  <!-- Set stack limit to something reasonable (maybe 100?) if you wish to parse defensively
  and raise alarms if tagging gets too deep -->

  <xsl:param name="stack-limit" as="xs:integer" select="0"/>
  
  <!-- $limiting is on or off -->
  <xsl:variable name="limiting" select="$stack-limit gt 0"/>
  
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

  <xsl:variable name="ID_delim" select="'='"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/LMNL">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text[string(.) => not()]"/>

  <!-- Ordinary case - if our stack limit is the default 0, we just go -->
  <xsl:template match="text">
    <xsl:variable name="within" as="xs:string*">
      <xsl:apply-templates select="accumulator-before('tag_stack')" mode="rID"/>
    </xsl:variable>
    <xsl:copy>
      <xsl:attribute name="cf" separator=" " select="$within"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <!-- nb - if performance is ever found to be an issue and we wish to forego
       stack tracing, we could layer it out into an importing XSLT -->
  
  <!-- If stack-limit is set and greater than zero, it is used as a limiter
    defending the process from getting hung up processing thousands of tags
    if opens appear without closes ... a pathological condition that should not
    occur in benign data and can be defended against by checking bracket matching
    prior to the parse (which should line up after escape sequences are removed) -->
  <xsl:template match="text[$limiting]" priority="101">
    <xsl:choose>
      <xsl:when test="count(accumulator-before('tag_stack')) gt $stack-limit">
        <xsl:message terminate="true">Stack limit { $stack-limit } was exceeded ... we have open ranges { accumulator-before('tag_stack')/@name => string-join(', ') } ...</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="within" as="xs:string*">
          <xsl:apply-templates select="accumulator-before('tag_stack')" mode="rID"/>
        </xsl:variable>
        <xsl:copy>
          <xsl:attribute name="cf" separator=" " select="$within"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
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

  <xsl:template priority="101" match="@name[contains(., $ID_delim)]">
    <xsl:attribute name="gi">{ tokenize(., $ID_delim)[1] }</xsl:attribute>
    <xsl:attribute name="id">{ tokenize(., $ID_delim)[2] }</xsl:attribute>
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
    <xsl:text>r{ $n }{ @name/('_' || replace(.,'=.*','')) }</xsl:text>
  </xsl:template>

</xsl:stylesheet>