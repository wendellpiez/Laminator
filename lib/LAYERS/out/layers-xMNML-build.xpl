<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML" exclude-inline-prefixes="#all"
  type="mnml:layers-xMNML-build" version="3.0">

  <!-- Accepts a LAYERS instance, validates it and (found valid)
  produces xMNML and sawteeth (LMNL syntax)--> 

  <p:input port="source"/>

  <p:output primary="true"  port="xMNML"
    pipe="result@build_xMNML"    serialization="map { 'indent': true() }"/>
  
  <p:output primary="false" port="sawteeth"
    pipe="result@write_sawteeth"/>
  
  <!--<p:validate-with-relax-ng assert-valid="true()">
    <p:with-input href="../rules/MNML-LAYERS.rnc"/>
  </p:validate-with-relax-ng>-->
  
  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document href="../out/merge-layers.xsl"/>
    </p:with-input>
  </p:xslt>
  
  <p:xslt name="build_xMNML">
    <p:with-input port="stylesheet">
      <p:document href="inscribe-xMNML.xsl"/>
    </p:with-input>
  </p:xslt>

  <p:xslt name="write_sawteeth">
    <p:with-input port="stylesheet">
      <p:document href="../../xMNML/out/xMNML-write-sawteeth.xsl"/>
    </p:with-input>
  </p:xslt>

</p:declare-step>
