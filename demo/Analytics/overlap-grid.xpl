<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:zone="http://wendellpiez.com/ns/xproc-zone" xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xmlns:c="http://www.w3.org/ns/xproc-step" exclude-inline-prefixes="#all" name="main"
  type="mnml:overlap-grid">

  <p:import href="../../lib/xMNML/up/sawtooth-syntax/sawteeth-to-xMNML.xpl"/>

  <p:input port="source">
    <p:document href="../baselines/data/PLfragment.lmnl" content-type="text/plain"/>
  </p:input>

  <p:output port="summary" pipe="@synopsis" serialization="map{ 'indent': true() }"/>

  <p:variable name="basename" select="base-uri(/) => replace('.*/|\.lmnl$','')"/>

  <mnml:sawteeth-to-xMNML name="xMNML"/>


  <!-- The XSLT returns a <REPORT> document showing overlaps -->
  <p:xslt>
    <p:with-input port="stylesheet" href="src/read-overlaps.xsl"/>
  </p:xslt>
  
  <p:store href="out/{ $basename }-survey.xml" serialization="map{ 'indent': true() }"
    message="-- Stored a range survey ...... in out/{ $basename }-range-survey.xml"/>
  
  <!-- Next we group them ... -->
  <p:xslt>
    <p:with-input port="stylesheet" href="src/group-overlaps.xsl"/>
  </p:xslt>
  
  <p:add-attribute match="/*" attribute-name="id" attribute-value="{ $basename }"/>
  
  <p:store name="synopsis" href="out/{ $basename }-overlaps.xml" serialization="map{ 'indent': true() }"
    message="-- Stored an overlap summary ... in out/{ $basename }-range-overlaps.xml"/>
  
  <!-- And now draw ... -->
  <p:xslt>
    <p:with-input port="stylesheet" href="src/overlap-grid-svg.xsl"/>
  </p:xslt>

  <p:store href="out/{ $basename }-overlap-grid.svg" serialization="map{ 'indent': true() }"
    message="-- Stored an overlap grid in ..... out/{ $basename }-overlap-grid.svg"/>

  <!-- for SVG: Each start
  
    collects its start overlaps and end overlaps
    runs through all the starts to follow, in reverse order
    colors based on whether it overlaps and which
    table is filled with an extra empty cell?
  -->


</p:declare-step>
