<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:zone="http://wendellpiez.com/ns/xproc-zone" xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:c="http://www.w3.org/ns/xproc-step" exclude-inline-prefixes="#all"
  name="main" type="mnml:simple-q-extraction">

  <p:import href="../../lib/xMNML/up/sawtooth-syntax/sawteeth-to-xMNML.xpl"/>

  <p:input port="source">
    <p:document href="../baselines/data/PLfragment.lmnl" content-type="text/plain"/>
  </p:input>

  <p:output port="result" serialization="map{ 'indent': true() }"/>

  <p:option name="range-types" select="'s np'"/>
  
  <p:variable name="basename" select="base-uri(/) => replace('.*/|\.lmnl$','')"/>
  
  <mnml:sawteeth-to-xMNML name="xMNML"/> 

  
  <!-- The XSLT returns a <REPORT> document listing all ranges of the type(s) indicated, e.g.
           parameters="map { 'ranges': 's' }" to get 's' ranges [s} ... {s]
                s: sentences
                phr: phrases
                np: noun phrases
                l: lines    -->
  <p:xslt parameters="map { 'range-types': $range-types }">
    <p:with-input port="stylesheet" href="src/extract-with-lines.xsl"/>
  </p:xslt>

  <p:variable name="dest" select="string(.)">
    <p:inline>out/{ $basename}_{ replace($range-types,'\s+','-') }_extract.xml</p:inline>
  </p:variable>
  
  <p:store href="{ $dest }" serialization="map{ 'indent': true() }"
    message="-- Stored the range survey in { $dest }"/>

</p:declare-step>
