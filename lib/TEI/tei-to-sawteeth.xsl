<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output method="text"/>
    
  <xsl:import href="../common/xml-to-lmnl.xsl"/>
  
  <xsl:template match="pb">
    <xsl:text expand-text="true">{{page][page [n}}{ @n }{{]}}</xsl:text>  
  </xsl:template>
  
  <xsl:template match="body" mode="start-tag">
    <xsl:next-match/>
    <xsl:text>[page}</xsl:text>
  </xsl:template>
  
  <xsl:template match="body" mode="end-tag">
    <xsl:text>{page]</xsl:text>
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="p">
    <xsl:if test="not(@part = 'Y')">
      <xsl:apply-templates select="." mode="start-tag"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="not(following::p[1]/@part = 'Y')">
      <xsl:apply-templates select="." mode="end-tag"/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
