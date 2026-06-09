<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns="http://wendellpiez.com/ns/xMNML"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xpath-default-namespace="http://wendellpiez.com/ns/xMNML"
  exclude-result-prefixes="xs math"
  version="3.0">
  
  <!--
    Repairs order of 'range' elements given in a layer, 
    normalizes LAYERS sets and annotates its 'layer' element(s)
    Should work even if @rID is out of order - uses only offsets
  
  -->
  
  <xsl:output indent="true"/>
  
  <xsl:mode on-no-match="shallow-copy"/>

  <!-- Saxon respects attribute order so this happens to work, for normalizing order of appearance -->
  <xsl:template match="*">
    <xsl:variable name="ordered" select="@off, @ext, @gi, @id, @rID, @cf"/>
    <xsl:copy>
      <xsl:apply-templates select="(@* except $ordered), $ordered"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:function name="mnml:overlaps" as="element(range)*">
    <xsl:param    name="r" as="element(range)"/>
    <xsl:variable name="s" select="$r/@starting/number()"/>
    <xsl:variable name="e" select="$r/@ending/number()"/>
    
    <xsl:sequence select="$r/parent::layer/
      ( range[@starting/number() lt $s][@ending/number() lt $e][@ending/number() gt $s] |
        range[@starting/number() gt $s][@ending/number() gt $e][@starting/number() lt $e] )"/>
  </xsl:function>

  <!-- XXX concepts TBD:
    process an MCH layer by producing as few as possible OHCO layers capturing all its ranges
      one layer produces multiple (but as few as possible)
      with an OHCO as input, it's a no-op
    collapse multiple layers into one
      including 'flattening' that inscribes a layer into another layer as milestones
    filter LAYERS (ohco) into XML and validate against a target schema
      using that schema as a configuration for the filtering?
  -->
    
  <!-- Annotating a layer and sorting its ranges into canonical order -->
  <xsl:template match="layer">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:where-populated>
        <xsl:attribute name="ranges" select="child::range/@gi => distinct-values()"/>
      </xsl:where-populated>
      <!--if sibling rivalry is found, mark them
          otherwise if no overlap is found mark as OHCO
          otherwise mark as MCH-->
      <xsl:variable name="contenders" select="child::range[@gi = mnml:overlaps(.)/@gi]"/>
      <xsl:choose>
        <xsl:when test="exists($contenders)">
          <xsl:attribute name="mixing" select="$contenders/@gi => distinct-values()" separator=" "/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="form" select="if ( exists(child::range/mnml:overlaps(.)) ) then 'mch' else 'ohco'"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates>
        <xsl:sort select="@starting" data-type="number"/>
        <xsl:sort select="@ending" order="descending"/>
        <xsl:sort select="@gi || @id/('#' || .)"/>
        <xsl:sort select="@rID"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="range">
    <xsl:copy>
      <xsl:copy-of select="@* except @overlaps"/>
      <xsl:where-populated>
        <xsl:attribute name="overlaps" select="mnml:overlaps(.)/@rID"/>
      </xsl:where-populated>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>