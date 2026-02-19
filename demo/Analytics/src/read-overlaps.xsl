<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  xmlns="http://wendellpiez.com/ns/xMNML"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xpath-default-namespace="http://wendellpiez.com/ns/xMNML">
  
  <!-- Reads an xMNML instance and writes a REPORT listing ranges overlapping one another. -->
  
  <xsl:output indent="true"/>
  
  <xsl:variable name="xLMNL-document" select="/"/>
  
<!-- overlaps are all text nodes whose preceding sibling contains ranges  -->
  <xsl:template match="/LMNL">
     <REPORT>
       <xsl:apply-templates select="start"/>
     </REPORT>
  </xsl:template>
  
  <xsl:template match="start">
    <xsl:variable name="overlapping-start" select="mnml:starting-overlaps(.)"/>
    <xsl:variable name="overlapping-end"   select="mnml:ending-overlaps(.)"/>
    <range rID="{ @rID}" starting="{ @off }" ending="{ @off + @ext }">
      <xsl:if test="exists($overlapping-start)">
        <xsl:attribute name="overlaps-start" select="$overlapping-start" separator=" "/>
      </xsl:if>
      <xsl:if test="exists($overlapping-end)">
        <xsl:attribute name="overlaps-end"   select="$overlapping-end"   separator=" "/>
      </xsl:if>
    </range>
  </xsl:template>
  
  <!--Given a range, returns overlaps of that range
    get all the ranges covered by its first text
    and all those covered by its last text
    if both sets contain members not in the other, we have overlap with those ranges
    (starting and ending)
    
  all the ranges covered by all the first and last texts in this range
  if any appear -->
  
  <xsl:key name="texts-for-range" match="text" use="mnml:rangeIDs(.)"/>
  
  <xsl:function name="mnml:rangeIDs" as="xs:string*" cache="true">
    <xsl:param name="whose" as="element(text)"/>
    <xsl:sequence select="$whose/@cf  => tokenize('\s+')"/>
  </xsl:function>
  
  <xsl:function name="mnml:starting-overlaps" as="xs:string*">
    <xsl:param name="r" as="element()"/><!-- $r should be start, end or empty -->
    
    <xsl:variable name="text-first" select="key('texts-for-range', $r/@rID, $xLMNL-document)[1]"/>
    <xsl:variable name="text-last"  select="key('texts-for-range', $r/@rID, $xLMNL-document)[last()]"/>
    
    <!-- Should fail out nicely enough even on empty ranges or ranges that happen to be [empty}{empty] -->
    <xsl:variable name="text-first-ranges" select="$text-first/mnml:rangeIDs(.)"/>
    <xsl:variable name="text-last-ranges"  select="$text-last/mnml:rangeIDs(.)"/>
    <xsl:variable name="ends-inside"       select="$text-first-ranges[not(. = $text-last-ranges)]"/>
    
    <xsl:sequence select="$ends-inside[ . = $text-first/preceding-sibling::text[1]/mnml:rangeIDs(.) ]"/>
  </xsl:function> 
  
  <xsl:function name="mnml:ending-overlaps" as="xs:string*">
    <xsl:param name="r" as="element()"/>    <!-- $r should be start, end or empty -->

    <xsl:variable name="text-first" select="key('texts-for-range', $r/@rID, $xLMNL-document)[1]"/>
    <xsl:variable name="text-last" select="key('texts-for-range', $r/@rID, $xLMNL-document)[last()]"/>
    
    <xsl:variable name="text-first-ranges" select="$text-first/mnml:rangeIDs(.)"/>
    <xsl:variable name="text-last-ranges"  select="$text-last/mnml:rangeIDs(.)"/>
    <xsl:variable name="starts-inside"     select="$text-last-ranges[not(. = $text-first-ranges)]"/>

    <xsl:sequence select="$starts-inside[. = $text-last/following-sibling::text[1]/mnml:rangeIDs(.)]"/>
  </xsl:function> 
  
  <!--
    Diagnostic template kept for posterity
    
    <xsl:template match="start[@rID='r05_phr']" expand-text="true">
    <xsl:message> Seeing range { @gi } with ID { @rID }</xsl:message>
    <xsl:variable name="texts" select="key('texts-for-range',@rID)"/>
    <xsl:message> ... it says "{ string-join($texts,'') }"</xsl:message>
    
    <xsl:variable name="r" select="."/>
    <xsl:variable name="text-first" select="key('texts-for-range', $r/@rID, $xLMNL-document)[1]"/>
    <xsl:variable name="text-last"  select="key('texts-for-range', $r/@rID, $xLMNL-document)[last()]"/>
    <xsl:variable name="text-first-ranges" select="mnml:rangeIDs( $text-first)"/>
    <xsl:variable name="text-last-ranges"  select="mnml:rangeIDs( $text-last)"/>
    
    <xsl:message> ... text-first-ranges is { $text-first-ranges }</xsl:message>
    <xsl:message> ... text-last-ranges is { $text-last-ranges }</xsl:message>
    
    <xsl:variable name="ends-inside" select="$text-first-ranges[not(. = $text-last-ranges)]"/>
    <xsl:variable name="starts-inside" select="$text-last-ranges[not(. = $text-first-ranges)]"/>
    
    <xsl:message> ... ends-inside is {   $ends-inside }</xsl:message>
    <xsl:message> ... starts-inside is { $starts-inside }</xsl:message>
    
    <xsl:variable name="overlaps-start" select="$ends-inside[   . = mnml:rangeIDs($text-first/preceding-sibling::text[1])]"/>
    <xsl:variable name="overlaps-end"   select="$starts-inside[ . = mnml:rangeIDs($text-last/following-sibling::text[1])]"/>
        
    <xsl:message> so overlapping at the start we should see ... { $overlaps-start }</xsl:message>
    <xsl:message> and at the end ... { $overlaps-end }</xsl:message>
    
    <xsl:next-match/>
  </xsl:template>-->
  
</xsl:stylesheet>