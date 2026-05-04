<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:mn="http://wendellpiez.com/ns/xMNML"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  expand-text="true">


<!-- Writes LMNL sawtooth notation from xMNML range model.
     Grateful to all LMNL developers!
-->
  
  <xsl:output method="text"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="text()">
    <xsl:value-of select="mn:lmnl-escape(.)"/>
  </xsl:template>
  
  <xsl:template match="comment() | processing-instruction()"/>
  
  <xsl:variable name="rcub" expand-text="false">}</xsl:variable>
  <xsl:variable name="lcub" expand-text="false">{</xsl:variable>
  
  <!-- This version writes any available 'id' -->
  <xsl:template match="start">
    <xsl:text>[{ @gi }{ @id/('#' || .) }</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>{ $rcub }</xsl:text>
  </xsl:template>
  
  <xsl:template match="empty">
    <xsl:text>[{ @gi }{ @id/('#' || .) }</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="end">
    <xsl:text>{ $lcub }{ @gi }{ @id/('#' || .) }</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>
  
  <xsl:template match="annotation" mode="tag">
    <xsl:if test="position()=1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:text>[{ @gi }{ $rcub }{ mn:lmnl-escape(.) }{ $lcub }]</xsl:text>
  </xsl:template>

  <!-- Escapes only open delimiters { and [ -->
  <xsl:function name="mn:lmnl-escape" as="xs:string">
    <xsl:param name="t" as="xs:string"/>
    <xsl:value-of>
    <xsl:analyze-string select="$t" regex="[\[\{{\\]">
      <xsl:matching-substring>\{ . }</xsl:matching-substring>
      <xsl:non-matching-substring>{ . }</xsl:non-matching-substring>
    </xsl:analyze-string>
    </xsl:value-of>
  </xsl:function>
  
  </xsl:stylesheet>
