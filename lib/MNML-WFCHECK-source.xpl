<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML" exclude-inline-prefixes="#all" version="3.0">

  <p:import href="xMNML/in/sawtooth-syntax/mnml-lmnl_wf-check.xpl"/>

  <p:input port="source" content-types="text/plain"/>
    <!--<p:document href=" ../../../../sources/Luminescent/Ozymandias.lmnl" content-type="text/plain"/>
  </p:input>-->

  <p:output port="report" serialization="map{ 'indent': true(), 'omit-xml-declaration': true() }"
    pipe="report@wf-check"/>



  <mnml:mnml-lmnl_wf-check name="wf-check" show-errors="yes"/>

</p:declare-step>