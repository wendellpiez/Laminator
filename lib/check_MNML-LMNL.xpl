<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="3.0"
  type="mnml:check_MNML-LMNL">
  
  <p:import href="xMNML/in/sawtooth-syntax/mnml-defensive-check.xpl"/>
  
  <p:input port="source" content-types="text/plain"/>
  
  <mnml:mnml-defensive-check name="xMNML"/>
  
  

</p:declare-step>