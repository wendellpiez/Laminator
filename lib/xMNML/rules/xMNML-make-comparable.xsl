<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns="http://wendellpiez.com/ns/xMNML"
  xpath-default-namespace="http://wendellpiez.com/ns/xMNML"
  exclude-result-prefixes="xs math"
  version="3.0">
  
  <xsl:output indent="true"/>
  
  <xsl:mode on-no-match="shallow-copy"/>

  <xsl:strip-space elements="*"/>
  
  <xsl:preserve-space elements="text"/>
  
  <!-- Saxon respects attribute order so this happens to work, for normalizing order of appearance -->
  <xsl:template match="*">
    <xsl:variable name="ordered" select="@off, @ext, @gi, @id, @rID, @cf"/>
    <xsl:copy>
      <xsl:apply-templates select="(@* except $ordered), $ordered"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- Sorting tags fairly aggressively into a canonical order
       (should be the same as ../rules/LAYERS-detail.xsl -->
  <xsl:template match="LMNL">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
        <xsl:for-each-group select="*" group-by="@off">
          <xsl:sort select="@off" data-type="number"/>
          <xsl:apply-templates select="current-group()/self::end">
            <xsl:sort select="@ext" order="descending"/>
            <xsl:sort select="@gi || @id/('#'||.)"/>
            <xsl:sort select="@rID"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="current-group()/self::empty"/>
          <xsl:apply-templates select="current-group()/self::start">
            <xsl:sort select="@ext" order="ascending"/>
            <xsl:sort select="@gi || @id/('#'||.)" order="descending"/>
            <xsl:sort select="@rID" order="descending"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="current-group()/self::text"/>
        </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>