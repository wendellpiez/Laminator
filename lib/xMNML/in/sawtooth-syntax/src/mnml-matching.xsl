<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="3.0"
  expand-text="true">

  <!-- like mnml-matching.xsl, except will mark line and character offsets
    
    IN PROGRESS - this works, except the grammar must be modified so as not
    to drop any literal characters (even markup)
    permitting line and character counts to be accurate
    -->

  <xsl:param    as="xs:boolean" name="terminate-on-fail"  select="true()"/>
  <xsl:variable as="xs:string"  name="messages-terminate" select="if ($terminate-on-fail) then 'yes' else 'no'"/>
  
  <xsl:mode on-no-match="fail" use-accumulators="tag_stack char_offset line_offset"/>

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
    <xsl:accumulator-rule match="start" phase="start" select="($value, .)"/>
    <xsl:accumulator-rule match="end"   phase="end">
      <xsl:variable name="identifier" select="child::name"/>
      <xsl:sequence select="$value except ($value[child::name = $identifier][last()])"/>
    </xsl:accumulator-rule>
  </xsl:accumulator>
  
  <!--If there is more than one matching rule, the last in document order is used.
      https://www.w3.org/TR/xslt-30/#accumulator-informal-rules -->
  <xsl:accumulator name="char_offset" initial-value="0" as="xs:integer">
    <xsl:accumulator-rule match="text()"                  phase="end" select="$value + string-length(.)"/>
    <xsl:accumulator-rule match="text()[matches(.,'\n')]" phase="end" select="replace(.,'^.*\n','') => string-length()"/>
  </xsl:accumulator>
  
  <xsl:accumulator name="line_offset" initial-value="0" as="xs:integer">
    <xsl:accumulator-rule match="text | pad" select="$value + ( string-to-codepoints(.)[.=10] => count() )"/>
  </xsl:accumulator>
  
  <xsl:variable name="ID_delim" select="'='"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="comment() | processing-instruction()"/>
  
  <xsl:template match="/LMNL">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="annotation/text" priority="101">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="pad"/>
  
  <xsl:template match="text[string(.) => not()]" priority="11"/>
  
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
        <xsl:message terminate="true">Stack limit { $stack-limit } exceeded ... we have open ranges { accumulator-before('tag_stack')/child::name => string-join(', ') } ...</xsl:message>
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
      <xsl:apply-templates select="child::name"/>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="rID">
        <xsl:apply-templates select="." mode="rID"/>
      </xsl:attribute>
      <xsl:call-template name="mark_position"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="end">
    <xsl:variable name="matching" select="child::name"/>
    <xsl:variable name="isClosing"
      select="accumulator-before('tag_stack')[child::name=$matching][last()]"/>
    <xsl:if test="empty($isClosing)">
      <xsl:message terminate="{ $messages-terminate }">[mnml-matching] Range end tag {{{ child::name }] has no preceding start tag to close... open ranges include { accumulator-before('tag_stack')/child::name/('''' || . || '''') => string-join(', ') } - see line { accumulator-before('line_offset') + 1 }, position { accumulator-before('char_offset') + 1 }</xsl:message>
    </xsl:if>
    
    <xsl:copy>
      <xsl:apply-templates select="child::name"/>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="rID">
        <xsl:apply-templates select="$isClosing" mode="rID"/>
      </xsl:attribute>
      <xsl:call-template name="mark_position"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="mark_position">
    <xsl:attribute name="L"  select="accumulator-before('line_offset') + 1"/>
    <xsl:attribute name="ch" select="accumulator-before('char_offset') + 1"/> 
  </xsl:template>
  
  <!-- outside <text> all text in the input is markup -->
  <xsl:template match="text()"/>
  
  <xsl:template match="text/text()" priority="101">
    <!-- Unescaping by removing reverse solidi when preceded by { [ or \ -->
    <xsl:text>{ replace(.,'\\([\[\{\\])','$1') }</xsl:text>
  </xsl:template>

  <xsl:template match="annotation">
    <xsl:copy>
      <xsl:call-template name="mark_position"/>
      <xsl:attribute name="gi" select="child::gi"/>
      <xsl:apply-templates select="text"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template priority="101" match="name[contains(., $ID_delim)]">
    <xsl:attribute name="gi">{ tokenize(., $ID_delim)[1] }</xsl:attribute>
    <xsl:attribute name="id">{ tokenize(., $ID_delim)[2] }</xsl:attribute>
  </xsl:template>

  <xsl:template match="name">
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
    <xsl:text>r{ $n }_{ (child::name/replace(.,'=.*',''),'0')[1] }</xsl:text>
  </xsl:template>

</xsl:stylesheet>