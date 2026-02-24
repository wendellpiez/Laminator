<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="3.0">

  <p:import href="../../lib/xMNML/up/sawtooth-syntax/sawteeth-to-xMNML.xpl"/>

  <!--<p:output port="reports" serialization="map { 'indent': true() }"/>-->

  <p:input port="source" sequence="true">

    <!-- It works on Peregrine's Demise - including a long quote ... -->
    <!--<p:document content-type="text/plain" href="../StoryLines/data/PeregrinesDemise_tei.lmnl"/>-->
    <p:document content-type="text/plain" href="../StoryLines/data/Frankenstein1831.lmnl"/>
    
  </p:input>

  <!--<p:option name="range-types" select="'q said quote'"/>-->
  
  <p:declare-step type="mnml:extract-quotes">
    <p:input port="source" content-types="text/plain"/>
    <p:output port="result" content-types="application/xml"/>

    <mnml:sawteeth-to-xMNML name="xMNML"/>
    <p:xslt parameters="map { 'range-types': 'q said quote' }">
      <p:with-input port="stylesheet" href="src/extract-with-pp.xsl"/>
    </p:xslt>
  </p:declare-step>

  <p:for-each>
    <p:variable name="basename" select="base-uri(/) => replace('(.*/|\.lmnl$|-xMNML\.xml$)','')"/>

    <mnml:extract-quotes/>

    <p:add-attribute match="/*" attribute-name="id" attribute-value="{ $basename }"/>
  </p:for-each>

  <p:wrap-sequence wrapper="EXTRACTS"/>

  <p:namespace-rename apply-to="elements" to="http://wendellpiez.com/ns/xMNML"/>
  
  <p:store href="out/collected_quotes.xml" serialization="map{ 'indent': true() }"
    message="-- Stored a quotes collection in out/collected_quotes.xml"/>
  
</p:declare-step>