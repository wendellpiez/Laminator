<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  xmlns="http://www.w3.org/2000/svg"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xpath-default-namespace="http://wendellpiez.com/ns/xMNML"
  expand-text="true">
  
  
  <xsl:variable name="page-margin"  select="10"/>
  <xsl:variable name="banner-width" select="40"/>
  <xsl:variable name="box-size"     select="10"/>
  <xsl:variable name="box-padding"  select="1"/>
  
  <xsl:variable name="box-space"    select="$box-size + (2 * $box-padding)"/>
  <xsl:variable name="page-width"   select="(count(*/range-type) * $box-space) + (2 * $page-margin) + $box-space"/>
  
  <xsl:template match="REPORT">
    <svg width="100%" height="100%" preserveAspectRatio="xMidYMid meet"
      viewBox="0 0 { $page-width} { $page-width + $banner-width }">
      <!--<rect width="100%" height="100%" fill="white" stroke="black" fill-opacity="0.6"/>-->
      
      <xsl:apply-templates select="range-type" mode="labels"/>
      <g transform="translate({ $page-margin } { $page-margin + $banner-width })">
        <xsl:apply-templates select="range-type"/>
      </g>
    </svg>
  </xsl:template>
  
  <xsl:template match="range-type" mode="labels">
    <xsl:variable name="off" select="count(. | preceding-sibling::range-type)"/>
    <text font-size="6" text-anchor="start"
      transform="translate( { $page-width - ($off * $box-space) - ($box-space div 2) } { $page-margin + $banner-width - 2 } ) rotate(-35)">{ @gi }</text>
  </xsl:template>
 
  <xsl:template match="range-type">
    <xsl:variable name="there" select="."/>
    <xsl:variable name="overlappers" select="tokenize(@overlaps,'\s')"/>
    <xsl:variable name="off" select="count(preceding-sibling::range-type)"/>
    <xsl:variable name="y" select="(position() - 1) * $box-space"/>
    <text font-size="6" text-anchor="end" x="{ $page-margin - 2 }"
      y="{ $off * $box-space + ($box-space div 2) }">{ @gi }</text>
    
    <xsl:for-each select=". | following-sibling::range-type">
      
      <xsl:sort select="position()" order="descending"/>
      <xsl:variable name="here" select="."/>
      <xsl:variable name="overlaps" select="$here/@gi = $overlappers"/>
      <xsl:variable name="x" select="position() * $box-space"/>
      <rect x="{ $x }" y="{ $y }" width="{ $box-size }" height="{ $box-size }"
        fill-opacity="1" stroke-width="0.1" stroke="black"
        fill="{ if ($overlaps) then 'blue' else 'whitesmoke' }" title="{ $here/@gi } / { $there/@gi }"/>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>