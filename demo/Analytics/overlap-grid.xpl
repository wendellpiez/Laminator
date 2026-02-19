<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:zone="http://wendellpiez.com/ns/xproc-zone"
    xmlns:mnml="http://wendellpiez.com/ns/xMNML"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    exclude-inline-prefixes="#all" name="main">
    
    <p:import href="../../lib/xMNML/up/sawtooth-syntax/sawteeth-to-xMNML.xpl"/>

    <!--<p:output port="result" serialization="map{ 'indent': true() }"/>-->


    <mnml:sawteeth-to-xMNML name="xMNML">
        <p:with-input port="source">
            <p:document href="../baselines/data/PLfragment.lmnl" content-type="text/plain"/>
        </p:with-input>
    </mnml:sawteeth-to-xMNML>
    
    <!-- The XSLT returns a <REPORT> document showing overlaps -->
    <p:xslt>
        <p:with-input port="stylesheet" href="src/read-overlaps.xsl"/>
    </p:xslt>

  <p:store href="out/PL-range-survey.xml" serialization="map{ 'indent': true() }"
    message="-- Stored the range survey in out/PL-range-survey.xml"/>
  
  <p:xslt>
    <p:with-input port="stylesheet" href="src/overlap-grid-svg.xsl"/>
  </p:xslt>
  
  <p:store href="out/PL-overlap-grid.svg" serialization="map{ 'indent': true() }"
    message="-- Stored the range survey in out/PL-overlap-grid.svg"/>
  
  
  <!-- for SVG: Each start
  
    collects its start overlaps and end overlaps
    runs through all the starts to follow, in reverse order
    colors based on whether it overlaps and which
    table is filled with an extra empty cell?
  -->
  
    
</p:declare-step>
