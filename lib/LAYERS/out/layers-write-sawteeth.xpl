<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML" exclude-inline-prefixes="#all"
  type="mnml:layers-write-sawteeth" version="3.0">

  <!--TODO XXX - TEST, also set up a unit test to catch regressions -->
  
  <!--Input: a LAYERS document
  Output: a LMNL instance
  
  two steps:
    1. convert into xMNML (tag sequence)
    2. write in LMNL syntax using xMNML/out serializer-->

  <p:input port="source"/>
  
  <p:output port="result" serialization="map { 'indent': true() }"/>

  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document href="../out/merge-layers.xsl"/>
    </p:with-input>
  </p:xslt>
  
  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document href="inscribe-xMNML.xsl"/>
    </p:with-input>
  </p:xslt>

  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document href="../../xMNML/out/xMNML-write-sawteeth.xsl"/>
    </p:with-input>
  </p:xslt>

</p:declare-step>
