<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://wendellpiez.com/ns/xMNML"
    xmlns="http://wendellpiez.com/ns/xMNML"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mnml="http://wendellpiez.com/ns/xMNML"
    exclude-result-prefixes="#all"
    version="3.0">

  <xsl:mode on-no-match="fail"/>

  <xsl:param name="prefix" select="'i'"/>
  
  <!-- Imported XSLT gives us rID rewriting for free -->
  <xsl:import href="../../common/rID-rewrite.xsl"/>

  <!--Consolidates layers and rewrites their IDs -->
  <xsl:strip-space elements="*"/>
  <xsl:preserve-space elements="frontier"/>


  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
    <!--To limit the layers: override this template in an importing XSLT
      or filter the layers before using this XSLT -->
  <xsl:template match="/LAYERS">
    <!-- By default, producing all layers -->
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      
    <layer>
      <xsl:apply-templates select="layer/*">
        <xsl:sort select="@starting"           order="ascending"/>
        <xsl:sort select="@ending - @starting" order="descending"/>
      </xsl:apply-templates>
    </layer>
    <xsl:copy-of select="frontier"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="annotation">
    <xsl:copy-of select="."/>
  </xsl:template>
</xsl:stylesheet>