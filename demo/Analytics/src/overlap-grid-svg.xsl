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
  <xsl:variable name="box-size"     select="11"/>
  <xsl:variable name="box-padding"  select="1"/>
  
  <xsl:variable name="box-space"    select="$box-size + (2 * $box-padding)"/>
  <xsl:variable name="page-width"   select="(count(*/range) * $box-space) + (2 * $page-margin) + $box-space"/>
  
  <xsl:template match="REPORT">
    <svg width="100%" height="100%" preserveAspectRatio="xMidYMid meet"
      viewBox="0 0 { $page-width} { $page-width + $banner-width }">
      <!--<rect width="100%" height="100%" fill="white" stroke="black" fill-opacity="0.6"/>-->
      
      <g transform="translate({ $page-margin } { $page-margin + $banner-width })">
        <xsl:apply-templates select="range"/>
      </g>
    </svg>
  </xsl:template>
  
  
  <xsl:variable name="color-enclosing" as="xs:string">darkgrey</xsl:variable>
  <xsl:variable name="color-before"    as="xs:string">midnightblue</xsl:variable>
  <xsl:variable name="color_start-ov"  as="xs:string">skyblue</xsl:variable>
  <xsl:variable name="color-enclosed"  as="xs:string">white</xsl:variable>
  <xsl:variable name="color-end-ov"    as="xs:string">lightgreen</xsl:variable>
  <xsl:variable name="color-after"     as="xs:string">darkgreen</xsl:variable>
  <xsl:variable name="blank"           as="xs:string">white</xsl:variable>
  
  <xsl:template match="range">
    <xsl:variable name="there" select="."/>
    <xsl:variable name="there-start" as="xs:integer" select="@starting"/>
    <xsl:variable name="there-end"   as="xs:integer" select="@ending"/>
    <xsl:variable name="y" select="(position() - 1) * $box-space"/>
    <xsl:variable name="end-overlaps" select="tokenize(@overlaps-start,'\s+')"/>
    <xsl:variable name="start-overlaps"   select="tokenize(@overlaps-end, '\s+')"/>
    <xsl:iterate select="../range">
      <xsl:variable name="here" select="."/>
      <xsl:variable name="here-start" as="xs:integer" select="@starting"/>
      <xsl:variable name="here-end"   as="xs:integer" select="@ending"/>
      <xsl:variable name="color" as="xs:string">
        <xsl:choose expand-text="true">
          <xsl:when test="$here/@rID = $start-overlaps"                                      >{ $color_start-ov }</xsl:when>
          <xsl:when test="$here/@rID = $end-overlaps"                                        >{ $color-end-ov }</xsl:when>
          <xsl:when test="($there-start &gt;= $here-start) and ($there-end &lt;= $here-end)" >{ $color-enclosed }</xsl:when>
          <xsl:when test="($there-start &lt;= $here-start) and ($there-end &gt;= $here-end)" >{ $color-enclosing }</xsl:when>
          <xsl:when test="($there-start &lt; $here-start)"                                   >{ $color-before }</xsl:when>
          <xsl:when test="($there-end &gt; $here-end)"                                       >{ $color-after }</xsl:when>
          <xsl:otherwise>{ $blank }</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="x" select="(position() - 1) * $box-space"/>
      <rect x="{ $x }" y="{ $y }" width="{ $box-size }" height="{ $box-size }" title="{ $here/@rID } / { $there/@rID}"
        fill="{ $color }" fill-opacity="1" stroke-width="0.1" stroke="gainsboro"/>      
    </xsl:iterate>
  </xsl:template>
  
</xsl:stylesheet>