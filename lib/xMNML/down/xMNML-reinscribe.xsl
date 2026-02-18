<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://wendellpiez.com/ns/xMNML"
    xmlns="http://wendellpiez.com/ns/xMNML"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:zone="http://wendellpiez.com/ns/xproc-zone"
    exclude-result-prefixes="#all"
    version="3.0">

  <xsl:mode on-no-match="fail"/>
  
  <xsl:mode name="clone" on-no-match="fail"/>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:preserve-space elements="text"/>
  
  <!-- new tags as range delimiters provided here at the top -->
  <xsl:param name="new_tags" select="()"/>
  
  <!-- Or: a calling XSLT can bring its own frontier and set of range markers
       and call mode 'inscribe' -->
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- Provide a function returning a boolean to exclude ranges -->
  <xsl:template match="/LMNL">
    <xsl:param name="retaining" select="true()"/>
    <xsl:param name="excluding" as="function(*)"
      select="function($n as element()) as xs:boolean { false() }"/>
    <xsl:variable name="old-tags" select="start[$retaining][$excluding(.) => not()]
      | end[$retaining][$excluding(.) => not()]
      | empty[$retaining][$excluding(.) => not()]"/>
    
    <xsl:variable name="filtered-new-tags" select="$new_tags[$excluding(.) => not()]"/>
    <xsl:variable name="tags" select="$old-tags | $filtered-new-tags"/>
    
    <xsl:if test="$old-tags/@rID = $filtered-new-tags/@rID">
      <xsl:message terminate="yes">@rID clash in LMNL tag merger - please repair</xsl:message>
    </xsl:if>
    
    <!-- Building a tree to sort markers into order -->
    <xsl:variable name="range_markers">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates select="$tags" mode="clone">
          <xsl:with-param name="marking" select="$filtered-new-tags"/>
          <!-- rewrite rIDs here, ensuring distinctiveness --> 
          
          <xsl:sort select="@off" order="ascending" data-type="number"/>
          <xsl:sort select="index-of( ('start','empty','end'), local-name() )" data-type="number" order="ascending"/>
          <xsl:sort select="@ext * (self::end/(-1), 1)[1]" data-type="number" order="descending"/>
          <xsl:sort select="@gi || @rID" data-type="text" order="{ (self::end/'ascending','descending') => head() }"/>
        </xsl:apply-templates>
      </xsl:copy>
    </xsl:variable>
    <!-- THIS TRAVERSAL WORKS BY PROCESSING THE TAGS OVER THE TEXT -->
    <xsl:apply-templates select="$range_markers" mode="inscribe">
      <xsl:with-param name="frontier" tunnel="true" select="//text => string-join()"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <!-- shouldn't match but just in case -->
  <xsl:template match="text" mode="clone"/>
  
  <xsl:template match="annotation" mode="clone">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template match="start | end | empty" mode="clone">
    <xsl:param name="marking" select="exists($new_tags)"/>
    <!-- marking only if new tags require us to distinguish new from old -->
    <!-- tags passed in should not have parent LMNL -->
    <xsl:variable name="mark" expand-text="true">{ (parent::LMNL/'original_', 'amending_') => head() }</xsl:variable>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="rID" expand-text="true">{$mark[$marking]}{ @rID }</xsl:attribute>
      <xsl:apply-templates mode="clone"/>
    </xsl:copy>
  </xsl:template>
  
 <!-- <xsl:output indent="true"/>-->
  <!--
    xMNML merger:
    
    - first, merge and sort range start/end/empty tag sequence
    - reinscribe over $frontier using this XSLT
    - reassign rIDs
    - validate
    - compare to results of tag writing approach
    -->
    
<!-- Accepts xMNML, produces xMNML
    text elements are rewritten to a range set
    the range set is read from the document
      but can also be provided (i.e. supplemented or filtered)
    The resulting document is the same except
      text has been (re)split between ranges
      new ranges have start, end or empty markers in their correct positions
        (retrieve start-by-closeposition to write end markers)
    
    -->
  
  <xsl:accumulator name="tag_stack" initial-value="()" as="element()*">
    <xsl:accumulator-rule match="start" select="($value, .)"/>
    <xsl:accumulator-rule match="end">
      <xsl:variable name="rID" select="@rID"/>
      <xsl:sequence select="$value except ($value[@rID = $rID][last()])"/>
    </xsl:accumulator-rule>
  </xsl:accumulator>
  
  
  <xsl:mode name="inscribe" on-no-match="shallow-copy" use-accumulators="#all"/>
  
  <!-- matching markers sorted into a LMNL document, with the $frontier passed in
       as a tunnel parameter -->
  <xsl:template match="/LMNL" mode="inscribe">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:variable name="tags" select="start | empty | end"/>
      <!-- Also test for pair matching starts and ends and for ends following starts? -->
      <xsl:if test="some $p in (2 to count($tags)) satisfies ($tags[$p - 1]/@off/number(.) > $tags[$p]/@off/number(.))">
        <xsl:message expand-text="true" terminate="yes">
          <xsl:text>Ranges found out of order ... { $tags[@off > following-sibling::*[1]/@off]/@rID }</xsl:text>
        </xsl:message>
      </xsl:if>
      <!-- Now we know they are in order, we rip -->
      <xsl:apply-templates mode="inscribe"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="LMNL/text" priority="101"  mode="inscribe"/>
  
  <!-- next: try removing defense against 'text' siblings -->
  
  <xsl:template mode="inscribe"
    match="LMNL/*[not(following-sibling::*[empty(self::text)][1]/@off/number(.) = @off/number(.))]"
    expand-text="true">
    <xsl:param name="frontier" tunnel="true" required="true"/>
    <xsl:variable name="off" select="number(@off)"/>
    <xsl:variable name="next" select="following-sibling::*[empty(self::text)][1]"/>
    <xsl:variable name="next-off"
      select="($next/@off/number(.), string-length($frontier)) => head()"/>
    <xsl:variable name="incr" select="$next-off - $off"/>
    
    <xsl:next-match/>
    <xsl:if test="boolean($incr)">
    <text cf="{ accumulator-before('tag_stack')/@rID }"
      off="{ $off }" ext="{ $incr }">{ substring($frontier, ($off + 1), $incr ) }</text>
    </xsl:if>
  </xsl:template>
  
  <!-- Rewriting IDs on the way in or the way out needs to be routine
       Alpha-renaming also needs to be routine
  -->
  
  <xsl:key name="offset-starters" match="start | empty" use="@off"/>
  
  <xsl:key name="offset-enders"   match="end" use="@off"/>
  
  
  
  <!-- NG implementation? not yet tested --> 
  <xsl:function name="mnml:merge-ranges" xmlns:mnml="http://wendellpiez.com/LMNL/MNML">
    <xsl:param name="frontier" as="xs:string"/>
    <xsl:param name="tags" as="element()*"/>
    <xsl:variable name="tag-map" as="document-node()">
      <xsl:document>
        <xsl:sequence select="$tags"/>
          <!--<xsl:perform-sort select="$tags"><!-\- don't actually have to sort here, should work anyhow ...-\-> 
            <!-\- rewrite rIDs here, ensuring distinctiveness -\-> 
            <xsl:sort select="@off" data-type="number" order="ascending"/>
            <xsl:sort select="@ext * (self::end/(-1) ,1)[1]" data-type="number" order="descending"/>
          </xsl:perform-sort>-->
      </xsl:document>
    </xsl:variable>
    <!-- tags must all have @off and @ext -->
    <xsl:iterate select="1 to string-length($frontier)">
      <xsl:param name="remainder" select="$frontier"/>
      <xsl:variable name="here" select="string(.)"/>
      <xsl:variable name="open-here" select="$tag-map/*[(number(@off) le number($here)) and (number($here) lt number($here) + number(@ext)) ]"/>
      <xsl:variable name="starters" select="key('offset-starters',$here,$tag-map)"/>
      <xsl:variable name="enders"   select="key('offset-enders',$here,$tag-map)"/>
      
      <xsl:if test="exists($starters | $enders)">
        <xsl:apply-templates mode="merge" select="$starters"/>
        <xsl:value-of select="substring($remainder, 1, 1)"/>
        <xsl:apply-templates mode="merge" select="$enders"/>
      </xsl:if>
      
      <xsl:next-iteration>
        <xsl:with-param name="remainder" select="substring($remainder,2)" as="xs:string"/>
      </xsl:next-iteration>
      <!--first, start and empty tags
      then the text
      then the end tags-->
      
    </xsl:iterate>
    
  </xsl:function>
</xsl:stylesheet>