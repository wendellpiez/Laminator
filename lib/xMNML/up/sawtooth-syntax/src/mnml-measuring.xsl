<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://wendellpiez.com/ns/xMNML"
  exclude-result-prefixes="#all" version="3.0">

  <!--
    Calculates offsets on connected range markers
    Follows unescaping (in the prior process) or extent values will be off!
    
    
    
FILTER: select and remove (ranges and text)
MAP: rename ranges, introduce new ranges
REDUCE: serialize
    -->

  <xsl:mode on-no-match="fail" use-accumulators="counter"/>

  <xsl:accumulator name="counter" initial-value="0" as="xs:integer">
    <xsl:accumulator-rule match="text/text()" select="$value + string-length(.)"/>
  </xsl:accumulator>

  <xsl:key name="text-at" match="text" use="accumulator-before('counter')"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="@* | text()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="*">
    <xsl:element name="{ name() }" namespace="http://wendellpiez.com/ns/xMNML">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:key name="start-for-id" match="start" use="@rID"/>

  <xsl:key name="end-for-id" match="end" use="@rID"/>

  <xsl:template match="start">
    <xsl:variable name="ender" select="key('end-for-id', @rID)"/>
    <!-- Gratuitous since calculable, but easy to determine -->
    <start>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="off" select="accumulator-before('counter')"/>
      <xsl:attribute name="ext"
        select="$ender/accumulator-before('counter') - self::start/accumulator-before('counter')"/>
      <xsl:apply-templates/>
    </start>
  </xsl:template>
  
  <xsl:template match="empty">
    <empty>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="off" select="accumulator-before('counter')"/>
      <xsl:attribute name="ext">0</xsl:attribute>
      <xsl:apply-templates/>
    </empty>
  </xsl:template>

  <!--end markers are left for conveniece in reserializing -->
  <xsl:template match="end">
    <xsl:variable name="starter" select="key('start-for-id', @rID)"/>
    <end>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="off" select="accumulator-before('counter')"/>
      <xsl:attribute name="ext"
        select="self::end/accumulator-before('counter') - $starter/accumulator-before('counter')"/>
      <xsl:attribute name="rID" select="$starter/@rID"/>
      <xsl:apply-templates/>      
    </end>
  </xsl:template>

  <xsl:template match="@cf[string(.) => not()]"/>
    
  <xsl:template match="text">
    <text>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="off" select="accumulator-before('counter')"/>
      <xsl:attribute name="ext" select="string-length(.)"/>
      <xsl:apply-templates/>
    </text>
  </xsl:template>

</xsl:stylesheet>