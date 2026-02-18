<p:declare-step version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:zone="http://wendellpiez.com/ns/xproc-zone"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  exclude-inline-prefixes="#all" name="main">

  <p:import href="../../lib/xMNML/up/sawtooth-syntax/sawteeth-to-xMNML.xpl"/>
  
  <p:import href="src/sonnet-lines-xml.xpl"/>

  <p:import href="src/sonnet-bubble-page.xpl"/>
  
<!-- Uses imported pipeline to produce an updated sonnet bubbles page
     (HTML+SVG), and saves it.
     
  -->

  <p:directory-list path="../../sources/Sonneteer/sonnets/" include-filter="\.lmnl$"/>
  
  <p:for-each>
    <p:with-input select="/descendant::c:file"/>    
    
    <p:variable name="basename" select="replace(/*/@name,'\.lmnl$','')"/>
    
    <p:load href="{ base-uri(/*) }" message="Loading { base-uri(/*) }"
      content-type="text/plain"/>
    
    <mnml:sawteeth-to-xMNML name="xMNML"/>
    
    <p:store href="out/xmnml/{ $basename }-xMNML.xml" serialization="map { 'indent': true() }"
      message="Writing xMNML (cache file) out/xmnml/{ $basename }-xMNML.xml"/>
    
    <p:xslt name="sonnet-svg">
      <p:with-input port="stylesheet" href="src/sonnet-bw-bubbles.xsl"/>
    </p:xslt>
    
    <p:store href="out/bubbles/{ $basename }-bubbles.svg" serialization="map { 'indent': true() }"
      message="Writing SVG file out/bubbles/{ $basename }-bubbles.svg"/>
    
    <p:sink/>
    
    <!-- build XML from xLMNL -->
    <mnml:sonnet-lines-xml>
      <p:with-input port="source" pipe="@xMNML"/>
    </mnml:sonnet-lines-xml>
    
    <p:store href="out/lines/{ /*/@id }.xml" serialization="map { 'indent': true() }"
      message="Writing XML file out/lines/{ /*/@id }.xml"/>
    
    <p:variable name="sonnet-title"  select="/*/@title/string(.)"/>
    <p:variable name="sonnet-author" select="/*/@author/string(.)"/>
    
    <!-- Now an HTML page -->
    <mnml:sonnet-bubble-page/>
    
    <!-- And now merging the bubbles diagram -->
    <p:insert match="div[@class='sonnet-bubbles']" position="last-child">
      <p:with-input port="insertion" pipe="@sonnet-svg"/>
    </p:insert>
    
    <p:cast-content-type content-type="application/xml+xhtml"/>
    
    <p:store href="out/pages/{ $basename }.html" serialization="map { 'indent': true() }"
      message="Writing HTML file out/pages/{ $basename }.html"/>
  </p:for-each>

</p:declare-step>
