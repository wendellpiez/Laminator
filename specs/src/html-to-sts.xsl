<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.w3.org/1999/xhtml"
  xmlns:zone="http://wendellpiez.com/ns/xproc-zone"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  version="3.0">

  
  <xsl:mode on-no-match="text-only-copy"/>

  <!-- Because processing fails on unmatched nodes -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="html">
    <standard>
      <xsl:apply-templates/>
    </standard>
  </xsl:template>
  
  <xsl:template match="html/head">
    <front>
      <std-meta>
        <title-wrap>
      <xsl:apply-templates/>
        </title-wrap>
      </std-meta>
    </front>
  </xsl:template>
  
  <xsl:template match="html/head/title">
    <main>
      <xsl:apply-templates/>
    </main>
  </xsl:template>
  
  <xsl:template match="hr"/>
  
  <!-- Dropping signature line -->
  <xsl:template match="p[starts-with(.,'/wap')]"/>
  
  <xsl:template match="body">
    <body>
      <xsl:apply-templates/>
    </body>
  </xsl:template>
  
  <xsl:template match="body/h1"/>
  
  <xsl:template match="section" expand-text="true">
    <xsl:variable name="id">
      <xsl:apply-templates select="h2[1] | h3[1] | h4[1] | h5[1]" mode="sec-id"/>
    </xsl:variable>
    <xsl:if test="not( matches($id,'\i\c*') )">
      <xsl:message terminate="yes">div has no good section ID, only '{ $id }'</xsl:message>
    </xsl:if>
    <sec id="{ $id }">
      <xsl:apply-templates/>
    </sec>
  </xsl:template>
  
  <xsl:template match="h2 | h3 | h4 | h5" mode="sec-id">
      <xsl:analyze-string select="." regex="\[(.+)\]">
        <xsl:matching-substring>
          <xsl:text expand-text="true">{ regex-group(1) }</xsl:text>
        </xsl:matching-substring>
      </xsl:analyze-string>
  </xsl:template>
  
  <xsl:template match="h2 | h3 | h4 | h5">
    <xsl:if test="exists(preceding-sibling::*)" expand-text="true">
      <xsl:message>WARNING: { name() }: '{ . }' IS OUT OF ORDER - should be #{ (.|ancestor::section)/'#' => string-join() }</xsl:message>
    </xsl:if>
    <title>
      <xsl:apply-templates mode="title-strip"/>
    </title>
  </xsl:template>
  
  <xsl:template match="text()" mode="title-strip">
    <xsl:analyze-string select="." regex="\[(.+)\]\s*">
      <xsl:non-matching-substring>
        <xsl:text expand-text="true">{ . }</xsl:text>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>
  
  <xsl:template match="p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  
  <xsl:template match="ul">
    <list>
      <xsl:apply-templates/>
    </list>
  </xsl:template>
  
  <xsl:template match="li">
    <list-item>
      <xsl:apply-templates/>
    </list-item>
  </xsl:template>
  
  <xsl:template match="li[empty(p)]">
    <list-item>
      <p>
        <xsl:apply-templates/>
      </p>
    </list-item>
  </xsl:template>
  
  <xsl:template match="strong">
    <bold>
      <xsl:apply-templates/>
    </bold>
  </xsl:template>
  
  <xsl:template match="em">
    <italic>
      <xsl:apply-templates/>
    </italic>
  </xsl:template>
  
  <xsl:template match="code">
    <code>
      <xsl:apply-templates/>
      </code>
  </xsl:template>
  
  <xsl:template match="a">
    <ext-link xlink:href="{ @href }">
      <xsl:apply-templates/>
    </ext-link>
  </xsl:template>

</xsl:stylesheet>


