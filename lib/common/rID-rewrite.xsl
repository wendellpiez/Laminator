<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://wendellpiez.com/ns/xMNML"
    xmlns="http://wendellpiez.com/ns/xMNML"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:zone="http://wendellpiez.com/ns/xproc-zone"
    exclude-result-prefixes="#all"
    version="3.0">

<!-- Rewrites all the range IDs
     Assumes rIDs coming in are all correct and distinct (start/end pairs)
  To do:
    unit test this 
    hook together with reinscription for normalized IDs in its result
    write
      xMNML LMNL serializer
      xMNML XML tree builder
        HTML production for display
        TEI integration (for Scholia)
      xLMNL range filter
      xLMNL Scholia merge
      xLMNL s/phr projector/inferencer (find this in Luminescent?)
        etc.
  -->
  
  <xsl:param name="prefix" as="xs:string"/>
  
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xsl:strip-space elements="*"/>

  <xsl:preserve-space elements="text"/>
  
  <xsl:template match="start | empty | range">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="." mode="rID-attribute"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="rID-attribute" match="*">
    <xsl:attribute name="rID">
      <xsl:apply-templates select="key('start-by-rID', @rID)" mode="rID"/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:key name="start-by-rID" match="start | empty | range" use="@rID"/>
  
  <xsl:template match="end">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="." mode="rID-attribute"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="text">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="cf" separator=" ">
        <xsl:apply-templates select="key('start-by-rID', tokenize(@cf,'\s+'))" mode="rID"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Rewrite all rID on start, (matching) end, and text cf -->
  
  <xsl:variable name="zeroPadded" select="count(/*/start | /*/empty /*/layer/range) =>
    string() => replace('\d', '0') => replace('0$', '1')"/>
  
  <!-- Some semantic redundancy / overloading in the ID, for transparency -->
  <xsl:template match="start | empty | range" mode="rID" as="xs:string">
    <xsl:variable name="n">
      <xsl:number count="start | empty | range" format="{ $zeroPadded }"/>
    </xsl:variable>
    <xsl:text expand-text="true">{ $prefix }_{ @gi }.{ $n }</xsl:text>
  </xsl:template>

</xsl:stylesheet>