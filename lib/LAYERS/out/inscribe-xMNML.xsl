<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://wendellpiez.com/ns/xMNML"
    xmlns="http://wendellpiez.com/ns/xMNML"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mnml="http://wendellpiez.com/ns/xMNML"
    exclude-result-prefixes="#all"
    version="3.0">

  <xsl:mode on-no-match="fail"/>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:preserve-space elements="text"/>
  
  <!-- The forerunning XSLT rewrote an xLMNL document when new tags were supplied.
  This version assumes all ranges come in from the LAYERS source document -->
  
  <!-- new tags as range delimiters provided here at the top -->
  <!--<xsl:param name="new_tags" select="()"/>-->
  
  <!-- Or: a calling XSLT can bring its own frontier and set of range markers
       and call mode 'inscribe' -->
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:variable name="LAYERS" select="/"/>
  
  <xsl:key name="starting-at" match="range[not(@starting = @ending)]" use="@starting"/>
  <xsl:key name="empties-at"  match="range[@starting = @ending]"      use="@starting"/>
  <xsl:key name="ending-at"   match="range[not(@starting = @ending)]" use="@ending"/>

  <!-- indexes ranges for retrieval as open -->
  <!--<xsl:key name="open-here" match="range"
    use="(.|following-sibling::range)[not(@starting >= current()/@ending)]/@starting"/>-->
  
  <!-- TRY THIS?! -->
  <xsl:key name="open-here" match="range" use="( @starting/xs:integer(.) to (@ending/xs:integer(.) - 1) ) ! string(.)"/>
  
  <!--<xsl:key name="open-here" match="range">
    <xsl:variable name="limits" select="../range/(@starting | @ending) => distinct-values()"/>
    <xsl:variable name="starts-at" select="@starting"/>
    <xsl:variable name="ends-at" select="@ending"/>
    <xsl:sequence select="$limits[not(. &lt; $starts-at)][not(. > $ends-at)]"/>
  </xsl:key>-->
    
  <!--<xsl:function name="mnml:open-at" as="element(range)*" cache="true">
    <xsl:param name="layer"  as="element(layer)"/>
    <xsl:param name="offset" as="xs:integer"/>
    <xsl:sequence select="$layer/range[@starting &lt;= $offset][@ending >= $offset]"/>
  </xsl:function>-->

  <xsl:template match="/LAYERS">
    <xsl:apply-templates select="layer[1]"/>
  </xsl:template>
  
  <xsl:template match="/LAYERS/layer" expand-text="true">
    <xsl:variable name="frontier" select="string(parent::LAYERS/child::frontier)"/>
    <LMNL>
      <!--<xsl:message>yowza { name() } ... { count(child::range) } ranges are here ... { child::range/(@starting | @ending)/xs:integer(.) => distinct-values() }</xsl:message>-->
      <!--iterate over limits =  -->
      <!--emitting sequence of : end range markers, empty markers, start range markers, text-->
      <xsl:variable name="limits" select="string-length($frontier), child::range/(@starting | @ending)"/>
      <!-- Iterating over strings not numbers since we use them as keys -->
      <xsl:iterate select="( ($limits!xs:integer(.)) => distinct-values() => sort() ) ! string(.)" expand-text="true">
        <xsl:param    name="prev" select="'0'"/>
        <xsl:variable name="here" select="."/>
        <!--<xsl:message>Seeing { $here } with { $prev }</xsl:message>-->
        <xsl:if test="not($prev = $here)">
          <xsl:variable name="offset" select="number($prev)"/>
          <xsl:variable name="extent" select="number($here) - number($prev)"/>
          <text off="{ $offset }" ext="{ $extent }">
            <xsl:if test="exists($LAYERS/key('open-here',$prev))">
              <xsl:attribute name="cf" select="$LAYERS/key('open-here',$prev)/@rID => sort() => string-join(' ')"/>
            </xsl:if>
            <xsl:text>{ substring($frontier, ($offset + 1), $extent) }</xsl:text></text>
        </xsl:if>
        <xsl:apply-templates select="$LAYERS/key('ending-at',   $here)"   mode="end-tag">
          <xsl:sort select="@starting" order="descending" data-type="number"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$LAYERS/key('empties-at',  $here)"  mode="empty-tag"/>
        <xsl:apply-templates select="$LAYERS/key('starting-at', $here)" mode="start-tag">
          <xsl:sort select="@ending" order="descending" data-type="number"/>
        </xsl:apply-templates>
        <xsl:next-iteration>
          <xsl:with-param name="prev" select="$here"/>
        </xsl:next-iteration>
      </xsl:iterate>
    </LMNL>
  </xsl:template>
  
  <xsl:template match="range" mode="start-tag" expand-text="true">
    <start>
      <xsl:copy-of select="@gi, @rID, @id"/>
      <xsl:attribute name="off">{ @starting }</xsl:attribute>
      <xsl:attribute name="ext">{ @ending - @starting}</xsl:attribute>
      <xsl:copy-of select="annotation[not(@place='end')]"/>
    </start>
  </xsl:template>
  
  <xsl:template match="range" mode="empty-tag">
    <empty off="{ @ending }" ext="0">
      <xsl:copy-of select="@gi, @rID, @id"/>
      <xsl:copy-of select="annotation"/>
    </empty>
  </xsl:template>
  
  <xsl:template match="range" mode="end-tag">
    <end off="{ @ending }" ext="{ @ending - @starting }">
      <xsl:copy-of select="@gi, @rID, @id"/>
      <xsl:apply-templates select="annotation[@place='end']"/>
    </end>
  </xsl:template>
  
  <xsl:template match="annotation">
    <xsl:copy>
      <xsl:copy-of select="@* except @place"/>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>