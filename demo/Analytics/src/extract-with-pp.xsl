<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns="http://wendellpiez.com/ns/xMNML"
  xpath-default-namespace="http://wendellpiez.com/ns/xMNML" exclude-result-prefixes="#all"
  version="3.0">

  <!-- Practically the same as extract-with-lines.xsl,
    this XSLT is meant to be used on prose or anything with 'page' ranges
    
    ... to think about - how to refactor into a single XSLT
        1st step is to factor the locator logic into a function -->

  <xsl:output indent="true"/>

  <xsl:param name="range-types" as="xs:string" required="yes"/>

  <xsl:variable name="ranges" select="tokenize($range-types, '\s+')"/>

  <xsl:key name="text-for-range" match="text" use="tokenize(@cf, '\s+')"/>

  <xsl:key name="range-for-text" match="start" use="@rID"/>

  <xsl:template match="/*">
    <REPORT ranges="{ string-join($ranges,' ') }">
      <xsl:apply-templates select="start[@gi = $ranges]"/>
    </REPORT>
  </xsl:template>

  <xsl:template match="start" expand-text="true">
    <!-- $ll is all 'l' ranges covered by text in this range -->
    <xsl:variable name="pages"
      select="key('text-for-range', @rID)/key('range-for-text', tokenize(@cf, ' '))[@gi = 'page']"/>
    <xsl:variable name="where">
      <xsl:value-of select="($pages[1], $pages[last()])/annotation[@gi = 'n']" separator="-"/>
    </xsl:variable>
    <xsl:element name="{ @gi }" namespace="http://wendellpiez.com/ns/xMNML">
      <!-- we add @l for a single line, @ll for a range of lines -->
      <xsl:attribute name="p{$pages[2]/'p'}">{ $where }</xsl:attribute>
      <xsl:text>{ key('text-for-range',@rID) => string-join() => replace('&#xA;',' / ') }</xsl:text>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
