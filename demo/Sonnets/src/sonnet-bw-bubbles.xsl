<?xml version="1.0"?>
<xsl:stylesheet version="3.0"
  xmlns="http://www.w3.org/2000/svg"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  xmlns:m="http://wendellpiez.com/ns/xMNML"
  xpath-default-namespace="http://wendellpiez.com/ns/xMNML">
  
  <xsl:output  indent="true"/>

  <xsl:variable name="lmnl-document" select="/*"/>
  
  <xsl:variable name="diameter"
    select="max($lmnl-document/start/@ext)"/>
  
  <xsl:variable name="radius"
    select="$diameter div 2"/>
  
  <xsl:template match="/">
    <svg width="{$radius + 20}" height="{$radius + 20}"
      viewBox="0 0 {$diameter + 40} {$diameter + 40}">
      
      <!--<rect fill="black" height="100%" width="100%"/>-->
      
      <g transform="translate({$radius + 20} 20)">
  
        <xsl:apply-templates select="//start"/>
          
      </g>
    </svg>
  </xsl:template>
  
  <xsl:template match="start">
    <xsl:variable name="start-y"  select="@off"/>
    <xsl:variable name="end-y"    select="@off + @ext"/>
    <xsl:variable name="radius"   select="($end-y - $start-y) div 2"/>
    <xsl:variable name="center-y" select="$start-y + $radius"/>

    <xsl:variable name="style">fill:white;fill-opacity:0.3;stroke:black;stroke-width:1px</xsl:variable>
    <circle style="{$style}" cy="{$center-y}" cx="0" r="{$radius}"/>
  </xsl:template>

</xsl:stylesheet>