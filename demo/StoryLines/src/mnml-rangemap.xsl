<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/2000/svg"
  xmlns:ml="http://wendellpiez.com/ns/xMNML" version="3.0">


<!-- Expected input: rangemap spec, with xMNML document as a parameter -->
  
  <xsl:param required="yes" name="xMNML" as="document-node()"/>

  <!-- Not assuming a wrapping range, we calculate the full width off the last text element -->
  <xsl:variable name="full-width" select="$xMNML/*/ml:text[last()]/(@off + @ext)"/>


  <xsl:variable name="sheetSpec" select="/RANGEMAP"/>


  <xsl:variable name="max-drop" select="$sheetSpec//*/(sum(ancestor-or-self::*/@drop) + ancestor-or-self::*[@w][1]/@w) => max()"/>

  <xsl:variable name="aspect" select="(/*/@aspect,4)[1]"/>
  
  
  <xsl:variable name="full-height"
    select="(2 * $pageMargin) + $max-drop + ($sheetSpec/@width div $aspect)"/>

  <xsl:template match="/*">
    <xsl:message terminate="yes">Cannot use input as a range map specification - expecting /RANGEMAP</xsl:message>
  </xsl:template>

  <xsl:template match="/RANGEMAP" priority="101">
    <svg width="{ @width }" height="{ $full-height }">
      <rect width="100%" height="100%">
        <xsl:copy-of select="$sheetSpec/(@fill, @fill-opacity)"/>
      </rect>
      <g>
        <xsl:apply-templates select="@*" mode="page-set"/>
        <xsl:apply-templates select="course"/>
        <xsl:apply-templates select="title"/>
      </g>
    </svg>
  </xsl:template>

  <xsl:template match="@*" mode="page-set"/>

  <xsl:template match="@font-family | @font-size" mode="page-set">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="course">
    <!-- Before we draw each track, we have an opportunity to draw for the course -->
    <!-- range/@ranges must be given as '*' or range names for anything to be drawn -->
    <xsl:variable name="range-signatures" select="tokenize(@ranges, '\s+')"/>
    <xsl:variable name="track-signatures" select="
        for $r in $range-signatures
        return
          child::track/($r || @signature)"/>

    <!-- Only drawing the ranges that will not also be drawn by tracks -->
    <xsl:apply-templates select="
        key('range-for-signature', $range-signatures, $xMNML)
        except key('range-for-signature', $track-signatures, $xMNML)" mode="draw">
      <xsl:with-param name="drawSpec" select="."/>
    </xsl:apply-templates>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Deeper tracks need to intersect with their ancestor tracks
    so nodes that come back from the track signature except nodes that come back from
    ancestors' track signatures
    we'll do this with a recursive walk up the tree shedding nodes as we go ... -->

  <xsl:template match="track" expand-text="true">
    <xsl:variable name="signing" select="
        for $r in ancestor::course/@ranges/tokenize(., '\s+')
        return
          ($r || @signature)"/>
    <xsl:variable name="ranges" select="key('range-for-signature', $signing, $xMNML)"/>
    <xsl:variable name="filtered-ranges" as="element()*">
      <!-- a no-op for range/track, but range//track/track will be filtered 'decumulatively' -->
      <xsl:apply-templates select="." mode="filter-patterns">
        <xsl:with-param name="ranges" select="$ranges"/>
      </xsl:apply-templates>
    </xsl:variable>

    <!-- Now we draw by visiting each range with the track in hand -->
    <xsl:apply-templates select="$filtered-ranges" mode="draw">
      <xsl:with-param name="drawSpec" select="."/>
    </xsl:apply-templates>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:mode name="filter-patterns" on-no-match="fail"/>

  <xsl:template match="track" mode="filter-patterns">
    <xsl:param name="ranges" select="()" as="element(ml:start)*"/>
    <xsl:variable name="signed-here" select="
        for $r in ancestor::course/@ranges/tokenize(., '\s+')
        return
          ($r || @signature)"/>
    <xsl:variable name="more_ranges" select="key('range-for-signature', $signed-here, $xMNML)"/>
    <xsl:apply-templates select="parent::*" mode="filter-patterns">
      <xsl:with-param name="ranges" select="$ranges intersect $more_ranges"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*" mode="filter-patterns">
    <xsl:param name="ranges" select="()" as="element(ml:start)*"/>
    <xsl:sequence select="$ranges"/>
  </xsl:template>


  <xsl:key name="range-for-signature" match="ml:start" use="ml:sign-range(.)"/>

  <!--
    Ranges, handled via ml:start element proxies, can be retrieved by signature.
    
    example: [para [class}l{][indent}2{]} ...
      signatures are
      *
      *[class}l{]
      *[indent}2{]
      para
      para[class}l{]
      para[indent}2{]
      
    Ranges are keyed to their signatures, permitting us to retrieve them by constructing the signature(s) we want
    -->
  <xsl:function name="ml:sign-range" as="xs:string+" expand-text="true">
    <xsl:param name="r" as="element(ml:start)"/>
    <xsl:text>*</xsl:text>
    <xsl:text>{ $r/@gi }</xsl:text>
    <xsl:for-each select="$r/child::ml:annotation">
      <xsl:text>{ '*[' || @gi || '}'}{ string(.) }{ '{]' }</xsl:text>
      <xsl:text>{ parent::ml:start/@gi || '[' || @gi || '}'}{ string(.) }{ '{]' }</xsl:text>
    </xsl:for-each>
  </xsl:function>

  <xsl:variable name="pageMargin" select="/*/@padding"/>

  <xsl:variable name="availableX" select="/*/@width - ($pageMargin * 2)"/>

  <xsl:function name="ml:scaleX">
    <xsl:param name="v" as="xs:double"/>
    <xsl:sequence select="($v div $full-width) * $availableX"/>
  </xsl:function>

  <xsl:function name="ml:placeX">
    <xsl:param name="v" as="xs:double"/>
    <xsl:sequence select="ml:scaleX($v) + $pageMargin"/>
  </xsl:function>

  <xsl:template match="ml:start" mode="draw" expand-text="true">
    <!-- $drawSpec can be a course or a course//track -->
    <xsl:param name="drawSpec" as="element(*)" required="yes"/>
    <xsl:variable name="here" select="."/>
    <xsl:variable name="x" select="ml:placeX(@off/number())"/>
    <xsl:variable name="width" select="ml:scaleX(@ext/number())"/>
    <xsl:variable name="y"
      select="($drawSpec/ancestor-or-self::*/@drop => sum()) + ($x div $aspect) + $pageMargin"/>
    <!--<xsl:variable name="y"      select="$full-height - $d"/>-->
    <xsl:variable name="height" select="$drawSpec/ancestor-or-self::*[@w][1]/@w + ($width div $aspect)"/>
    <xsl:variable name="rnd" select="($drawSpec/ancestor-or-self::*[@r][1]/@r, '5')[1]"/>
    <xsl:variable name="font-size"
      select="($drawSpec/ancestor-or-self::*[@font-size][1]/@font-size, '12')[1]"/>

    <xsl:if test="$height > 0">
      <rect rx="{ $rnd }" ry="{ $rnd }" x="{ $x }" y="{ $y }" width="{ $width }"
        height="{ $height }" stroke-width="0.1" fill="darkgrey" fill-opacity="0.2">
        <xsl:copy-of
          select="$drawSpec/ancestor-or-self::*/(@fill, @fill-opacity, @stroke, @stroke-width, @stroke-opacity)"
        />
      </rect>
    </xsl:if>

    <!-- the path lets us pop up the range name as a label when no label is given, but we can also label ' ' -->
    <g transform="translate({ $x } { $y })" font-size="{ $font-size }">
      <text dominant-baseline="hanging">
        <xsl:copy-of select="$drawSpec/label/@*"/>
        <xsl:text>{ ($drawSpec/label/ml:label-text(.,$here), @gi)[1] }</xsl:text>
      </text>
    </g>
  </xsl:template>

  <xsl:template match="title">
    <text>
      <xsl:copy-of select="../@font-size | ../@font-family"/>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </text>
  </xsl:template>

  <!-- braced notation to return annotation values - { n } returns annotation 'n' on the range -->
  <xsl:function name="ml:label-text" as="xs:string">
    <xsl:param name="l" as="element(label)"/>
    <xsl:param name="r" as="element(ml:start)"/>
    <xsl:analyze-string select="$l" regex="\{{(\i\c*)\}}">
      <xsl:matching-substring>
        <xsl:variable name="p" select="normalize-space(regex-group(1))"/>
        <xsl:value-of select="$r/ml:annotation[@gi = $p]"/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>

</xsl:stylesheet>