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
      <xsl:apply-templates select="(h1, h2, h3, h4, h5, h6)[1]" mode="sec-id"/>
    </xsl:variable>
    <xsl:if test="not( normalize-space($id))">
      <xsl:message>Section has no ID - cf "{ (h1, h2, h3, h4, h5, h6)[1] }"</xsl:message>
    </xsl:if>
    <sec id="{ ( $id[normalize-space(.)], generate-id() )[1] }">
      <xsl:apply-templates/>
    </sec>
  </xsl:template>
  
  <xsl:template match="h1 | h2 | h3 | h4 | h5" mode="sec-id">
      <xsl:analyze-string select="." regex="\[(.+)\]">
        <!-- Bracketed text is captured -->
        <xsl:matching-substring expand-text="true">{ regex-group(1) }</xsl:matching-substring>
      </xsl:analyze-string>
  </xsl:template>
  
  <xsl:template match="h1 | h2 | h3 | h4 | h5" expand-text="true">
    <xsl:if test="exists(preceding-sibling::*)">
      <xsl:message>WARNING: { name() }: '{ . }' IS OUT OF ORDER - should be #{ (.|ancestor::section)/'#' => string-join() }</xsl:message>
    </xsl:if>
    <title>
      <!--<xsl:text>#{ (.|ancestor::section)/'#' => string-join() } [</xsl:text>
      <xsl:apply-templates select="." mode="sec-id"/>
      <xsl:text>] </xsl:text>-->
      <xsl:apply-templates/>
    </title>
  </xsl:template>
  
  <xsl:template match="h1//text() | h2//text() | h3//text() | h4//text() | h5//text()">
    <xsl:analyze-string select="." regex="\[(.+)\]\s*">
      <!-- bracketed text is discarded with its trailing whitespace -->
      <xsl:non-matching-substring expand-text="true">{ . }</xsl:non-matching-substring>
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


