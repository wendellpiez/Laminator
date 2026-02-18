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

  <!--<xsl:variable name="specs" xmlns="http://wendellpiez.com/ns/xMNML">
  <background-color>none</background-color>
  <left-margin>40</left-margin>
  <top-margin>0</top-margin>
  <spacing>60</spacing>
  <title>
    <indent>40</indent>
    <drop>40</drop>
    <line-height>40</line-height>
    <font-size>24</font-size>
    <font-family>serif</font-family>
  </title>
  
</xsl:variable>-->
 
  <xsl:variable name="lmnl-document" select="/*"/>
  
  <!--<xsl:variable name="ranges" xmlns="http://wendellpiez.com/ns/xMNML">
    <circles color="white" fill-opacity="0" stroke="black" stroke-width="1">
      <ranges>quatrain tercet couplet line s phr</ranges>
    </circles>
  </xsl:variable>-->
  
  <xsl:key name="ranges-by-name" match="start | empty" use="@gi"/>
  
  <xsl:variable name="max-height"
    select="max($lmnl-document/start/@ext)"/>
  
  <!--<xsl:variable name="max-height"
    select="count($ranges/boxes) * $specs/spacing"/>-->
  
  <xsl:variable name="full-width" select="$max-height"/>
  
  <xsl:template match="/">
    <svg width="{($full-width div 2) + 20}" height="{($max-height div 2) + 20}"
      viewBox="0 0 {$full-width + 40} {$max-height + 40}">
      
      <g transform="translate({$full-width div 2} 400)">
  
        <xsl:for-each select="//start">
          
          <xsl:variable name="length" select="@ext"/>
          
          <xsl:variable name="start-y"  select="@off - 400"/>
          <xsl:variable name="end-y"    select="(@off + @ext) - 400"/>
          <xsl:variable name="radius"   select="($end-y - $start-y) div 2"/>
          <xsl:variable name="center-y" select="$start-y + $radius"/> 
          
          
          <xsl:variable name="style">fill:none;stroke:black;stroke-width:1px</xsl:variable>
          <circle style="{$style}" cy="{$center-y}" cx="0" r="{$radius}"/>
          
        </xsl:for-each>
        
      </g>
    </svg>
  </xsl:template>

</xsl:stylesheet>