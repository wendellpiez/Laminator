<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML" exclude-inline-prefixes="#all" version="3.0">

  <!-- Refresh the set of xLMNL files, with intermediates for inspection
                            
    -->

  <p:import href="../../lib/xMNML/up/sawtooth-syntax/sawteeth-to-xMNML.xpl"/>


  <p:directory-list path="data" include-filter="\.lmnl$"/>

  <p:for-each>
    <p:with-input select="/descendant::c:file"/>

    <p:variable name="basename" select="replace(/*/@name,'\.lmnl$','')"/>

    <p:load href="{ base-uri(/*) }" message="Loading { base-uri(/*) }" content-type="text/plain"/>

    <mnml:sawteeth-to-xMNML name="xMNML"/>

    <p:store href="cache/3_xmnml/{ $basename }-xMNML.xml" serialization="map { 'indent': true() }"
      message="Writing xMNML cache file - - - - - - - - - - - - - - - - - cache/3_xmnml/{ $basename }-xMNML.xml"/>
    
    <p:store href="cache/1_parsed/{ $basename }.xml" serialization="map { 'indent': true() }"
      message="Writing iXML parse result xMNML cache file - - - - - - - - cache/1_parsed/{ $basename }.xml">
      <p:with-input port="source" pipe="raw_parseresult@xMNML"/>
    </p:store>
    
    <p:store href="cache/2_linked/{ $basename }.xml" serialization="map { 'indent': true() }"
      message="Writing intermediate XML (linked, not measured) cache file cache/2_linked/{ $basename }.xml">
      <p:with-input port="source" pipe="interim_linked@xMNML"/></p:store>
    
    
  </p:for-each>

</p:declare-step>
