<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  xmlns="http://wendellpiez.com/ns/xMNML"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xpath-default-namespace="http://wendellpiez.com/ns/xMNML">
  
  <!-- Produces LAYERS (standoff) model from xLMNL.
       This model is optimized for certain operations
         including
           merging range sets over the same frontier
           filtering out ranges
           sorting ranges into separate layers (e.g. for MCH)
           modifying ranges (when not modifying contents)
  
  Cast it back into xLMNL by using the reverse 'inscription' pipeline
  
  
  
  -->
  
  <xsl:preserve-space elements="text"/>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:output indent="true"/>
  
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xsl:variable name="xLMNL-document" select="/"/>
  
  <xsl:template match="/LMNL">
     <LAYERS>
       <layer>
         <xsl:apply-templates select="start | empty"/>
       </layer>
       <frontier>
         <xsl:value-of select="text" separator=""/>
       </frontier>
     </LAYERS>
  </xsl:template>
  
  <xsl:key name="tags-by-rID" match="start | end | empty" use="@rID"/>
  
  <xsl:template match="start | empty">
    <!-- See XSLT ../../../demo/Analytics/src/read-overlaps.xsl for an approach that brings overlaps -->
    <range rID="{ @rID }" gi="{ @gi }" starting="{ @off }" ending="{ @off/number(.) + (@ext/number(.),0)[1] }">
      <xsl:copy-of select="@id"/>
      <xsl:apply-templates select="key('tags-by-rID',@rID)/annotation"/>
    </range>
  </xsl:template>
  
  <xsl:template match="end/annotation">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="place">end</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>