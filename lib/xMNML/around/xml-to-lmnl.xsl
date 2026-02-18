<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:mn="http://wendellpiez.com/ns/xMNML"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

<!--Consider replacing with an XSLT that writes xMNML for arbitrary XML
using ../mnml/xMNML-write-sawteeth.xsl for the final step
  
  XProc: xml-flattener.xsl makes xMNML
  -->

  <xsl:output method="text"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:apply-templates mode="start-tag" select="."/>
    <xsl:if test="exists(node())">
    <xsl:apply-templates/>
    <xsl:apply-templates mode="end-tag" select="."/>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template match="text()">
    <xsl:value-of select="mn:lmnl-escape(.)"/>
  </xsl:template>
  
  <xsl:template match="comment() | processing-instruction()"/>
  
  
  <xsl:template match="*" mode="start-tag">
    <xsl:variable name="scope" select=".."/>
    <!-- the scope of range retrieval is the document or annotation -->
    <xsl:text>[</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:apply-templates select="@*" mode="tag"/>
    <xsl:choose>
      <xsl:when test="empty(node())">
        <xsl:text>]</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*" mode="end-tag">
    <xsl:text>{</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>]</xsl:text>
  </xsl:template>  
  
  <xsl:template match="@*" mode="tag">
    <xsl:if test="position()=1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:text>[</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="mn:lmnl-escape(.)"/>
    <xsl:text>{]</xsl:text>
  </xsl:template>

  <xsl:variable name="chs" as="element()+">
    <mn:char name="lsqb" v="["/>
    <!-- These are LREs, so AVTs are recognized -->
    <mn:char name="lcub" v="{{"/>
    <mn:char name="rcub" v="}}"/>
    <mn:char name="rsqb" v="]"/>
  </xsl:variable>
        
  <xsl:function name="mn:lmnl-escape" as="xs:string">
    <xsl:param name="t" as="xs:string"/>
    <xsl:value-of>
    <xsl:analyze-string select="$t" regex="[\[\{{\]\}}]">
      <xsl:matching-substring>
        <xsl:apply-templates select="$chs[@v=regex-group(0)]"/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
    </xsl:value-of>
  </xsl:function>
  
  <!-- Somewhat overengineered for this treatment, but very replaceable -->
  <xsl:template match="mn:char[@name='lsqb']">\[</xsl:template>
  <xsl:template match="mn:char[@name='rsqb']">]</xsl:template>
  <xsl:template match="mn:char[@name='lcub']">\{</xsl:template>
  <xsl:template match="mn:char[@name='rcub']">}</xsl:template>
  
  </xsl:stylesheet>
