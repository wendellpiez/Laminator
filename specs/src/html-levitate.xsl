<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:zone="http://wendellpiez.com/ns/xproc-zone"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  version="3.0">

  <!-- Makes HTML produced by html-enhance.xsl and converts it into a friendlier notation-->
  
  <xsl:mode on-no-match="shallow-copy"/>

  <!-- Because processing fails on unmatched nodes -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="html">
    <!--<xsl:assert test="zone:well-nested(//h1 | //h2 | //h3 | //h4 | //h5)">Header elements in source are not well nested.</xsl:assert>-->
    <xsl:copy expand-text="true">
      <head>
        <title>{ /descendant::h1[1] }</title></head>
      <xsl:apply-templates select="body"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="hr"/>
  
  <!-- Dropping signature line -->
  <xsl:template match="p[starts-with(.,'/wap')]"/>
  
  <xsl:template match="body">
    <body>
      <xsl:call-template name="level-groups">
        <!-- when we have only a single h1, we can drop its div wrapper by calling level 2  -->
        <xsl:with-param name="level" select="(child::h1[2]/1, 2)[1]"/>
      </xsl:call-template>
      
    </body>
  </xsl:template>
  
  <xsl:template name="level-groups">
    <xsl:param name="level" select="1" as="xs:integer"/>
    <xsl:param name="who" select="child::*"/>
    <xsl:variable name="starter" select="'h' || $level"/>
    <xsl:for-each-group select="$who" group-starting-with="*[local-name()=$starter]">
      <xsl:choose>
        <xsl:when test="self::*[local-name() != $starter]">
          <xsl:apply-templates select="current-group()"/>
        </xsl:when>
        <xsl:otherwise>
          <section>
            <xsl:call-template name="level-groups">
              <xsl:with-param name="level" select="$level + 1"/>
              <xsl:with-param name="who" select="current-group()"/>
            </xsl:call-template>
          </section>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  
</xsl:stylesheet>


