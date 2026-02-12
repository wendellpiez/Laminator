<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML" exclude-inline-prefixes="#all" version="3.0">

  <!-- Bind any plain text to 'source' to check its MNML LMNL well-formedness -->
  
  <p:import href="../../lib/xMNML/up/sawtooth-syntax/mnml-lmnl_wf-check.xpl"/>

  <p:input port="source">
    <p:document content-type="text/plain" href="Frankenstein1831.lmnl"/>
  </p:input>

  <p:output port="result" serialization="map{ 'indent': true() }" pipe="result@wf-check"/>

  <p:output port="report" serialization="map{ 'indent': true() }" pipe="report@wf-check"/>
 
  <mnml:mnml-lmnl_wf-check name="wf-check"/>

</p:declare-step>