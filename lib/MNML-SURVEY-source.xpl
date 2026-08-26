<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-inline-prefixes="#all" version="3.0">

  <p:import href="parse_mnml-lmnl.xpl"/>

  <p:input port="source" content-types="text/plain"/>

  <p:output port="result" 
    serialization="map{ 'indent': true(), 'omit-xml-declaration': true() }"/>


  <!-- THANKS TO EVERYONE WHO HAS HELPED US GET THIS FAR -->
  <mnml:parse_mnml-lmnl/>

<!--Working over xMNML for now.
TODO - fix up overlap tracking in LAYERS production;
work from LAYERS instead for more info (MCH etc)-->

  <p:xslt>
    <p:with-input port="stylesheet" expand-text="false">
      
      <xsl:stylesheet version="3.0" xpath-default-namespace="http://wendellpiez.com/ns/xMNML">
        <xsl:template match="/*">
          <xsl:variable name="ranges" select=".//start | .//empty"/>
          <report ranges="{ count( $ranges ) }" extent="{ string-length( /*/text => string-join('') ) }">
            <xsl:for-each-group select="$ranges" group-by="@gi">
              <xsl:sort select="count(current-group())"/>             
              <range gi="{ (current-grouping-key()[normalize-space(.)],'[ANON]')[1] }"
                count="{ current-group() => count() }">
                <xsl:for-each-group select="current-group()/annotation" group-by="@gi">
                  <annotation gi="{ (current-grouping-key()[normalize-space(.)],'[ANON]')[1] }"
                    count="{ current-group() => count() }"
                    distinct="{ current-group()/string(.) => distinct-values() => count()}"/>
                </xsl:for-each-group>
              </range>
            </xsl:for-each-group>
          </report>
        </xsl:template>
      </xsl:stylesheet>
    </p:with-input>
  </p:xslt>

  
  <!--Making XQuery a little easier -->
  
  <!--<p:namespace-delete prefixes="mnml"/>
  -->
  
  <!--<p:xquery expand-text="false">
    <p:with-input port="query">
      <p:inline content-type="text/plain">
'RANGES: ' ||
  /report/range ! (
  (@gi, ': ', @count, ' (',
   ( (@coverage div @count) => format-number('1.00') ), ')&#xA;' ) =>
    string-join('') )     
</p:inline>
    </p:with-input>
  </p:xquery>-->
  
</p:declare-step>