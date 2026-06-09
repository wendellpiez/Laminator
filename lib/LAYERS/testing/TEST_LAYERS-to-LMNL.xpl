<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML" exclude-inline-prefixes="#all"
  type="mnml:TEST_LAYERS-TO-LMNL" version="3.0">

  <p:import href="../out/layers-write-sawteeth.xpl"/>

  <p:output port="result" serialization="map{ 'indent': true() }"/>

  <p:input port="source" expand-text="false">
    <p:document href="book02_layers.xml"/>
  </p:input>

  <!--<mnml:layers-write-sawteeth/>
    -->

  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document href="../out/merge-layers.xsl"/>
    </p:with-input>
  </p:xslt>
  
  <p:store href="writer/book02-merged-layers.xml" serialization="map { 'indent': true() }"
    message="Writing test results to writer/book02-merged-layers.xml"/>
  
  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document href="../out/inscribe-xMNML.xsl"/>
    </p:with-input>
  </p:xslt>
  
  <p:store href="writer/book02-xMNML.xml" serialization="map { 'indent': true() }"
    message="Writing test results to writer/book02-xMNML.xml"/>
  
  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document href="../../xMNML/out/xMNML-write-sawteeth.xsl"/>
    </p:with-input>
  </p:xslt>


  <p:store href="writer/book02.lmnl" message="Writing test results to writer/book02.lmnl"/>

</p:declare-step>
