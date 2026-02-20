<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  xmlns="http://wendellpiez.com/ns/xMNML"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xpath-default-namespace="http://wendellpiez.com/ns/xMNML">
  
  <!-- Reads a REPORT as produced by read-overlaps.xsl and groups the ranges
    by gi (generic identifier) showing their overlaps. -->
  
  <xsl:output indent="true"/>
  
  <xsl:variable name="xLMNL-document" select="/"/>
  
  <xsl:key name="range-by-rID" match="range" use="@rID"/>
  
  <xsl:variable name="overlappers" as="function(*)"
    select="function ($r as element()) as xs:string* { 
      $r/tokenize(@overlaps-start,'\s'), $r/tokenize(@overlaps-end,'\s') }"/>
  
<!-- overlaps are all text nodes whose preceding sibling contains ranges  -->
  <xsl:template match="/REPORT" expand-text="true">
     <REPORT>
       <!-- since overlaps are symmetrical we only need to look at one side - starts or ends -->
       <xsl:for-each-group select="range" group-by="@gi">
         <xsl:variable name="overlap-ids" select="current-group()/$overlappers(.) => distinct-values()"/>
         <range-type gi="{ current-grouping-key() }">
           <xsl:where-populated>
             <xsl:attribute name="overlaps">{ key('range-by-rID',$overlap-ids)/@gi => distinct-values() }</xsl:attribute>
           </xsl:where-populated>
         </range-type>
       </xsl:for-each-group>
     </REPORT>
  </xsl:template>
  
</xsl:stylesheet>