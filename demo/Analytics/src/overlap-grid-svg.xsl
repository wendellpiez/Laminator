<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  xmlns="http://www.w3.org/2000/svg"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xpath-default-namespace="http://wendellpiez.com/ns/xMNML">
  
  
  <xsl:variable name="page-margin"  select="10"/>
  <xsl:variable name="banner-width" select="40"/>
  <xsl:variable name="box-size"     select="10"/>
  <xsl:variable name="box-padding"  select="2"/>
  
  <xsl:variable name="box-space"    select="$box-size + (2 * $box-padding)"/>
  <xsl:variable name="page-width"   select="count(*/range) * (2 * $box-space) + (2 * $page-margin)"/>
  
  <xsl:template match="REPORT">
    <svg width="{ $page-width}" height="{ $page-width + $banner-width }">
      <rect width="100%" height="100%" fill="white" fill-opacity="0.6"/>
      
      <g transform="translate({ $page-margin } { $page-margin + $banner-width })">
        <xsl:apply-templates select="range"/>
      </g>
    </svg>
  </xsl:template>
  
  <xsl:variable name="color1" as="xs:string">blue</xsl:variable>
  <xsl:variable name="color2" as="xs:string">orange</xsl:variable>
  <xsl:variable name="blank"  as="xs:string">white</xsl:variable>
  
  <xsl:template match="range">
    <xsl:variable name="y" select="(position() * $box-space) + $box-padding"/>
    <xsl:variable name="start-overlaps" select="tokenize(@overlaps-start,'\s+')"/>
    <xsl:variable name="end-overlaps"   select="tokenize(@overlaps-end, '\s+')"/>
    <xsl:iterate select="../range">
      <xsl:variable name="here" select="."/>
      <xsl:variable name="color" select="($color1[$here/@rID = $start-overlaps],
        $color2[$here/@rID = $end-overlaps], $blank) => head()"/>
      <xsl:variable name="x" select="(position() * $box-space) + $box-padding"/>
      <rect x="{ $x }" y="{ $y }" width="{ $box-space }" height="{ $box-space}"
        fill="{ $color }" fill-opacity="1" stroke-width="0.1" stroke="gainsboro"/>      
    </xsl:iterate>
  </xsl:template>
  
</xsl:stylesheet>