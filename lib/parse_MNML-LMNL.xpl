<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="3.0"
  type="mnml:parse_MNML-LMNL">
  
  
  <p:import href="xMNML/in/sawtooth-syntax/sawteeth-to-xMNML.xpl"/>
  
  <p:input port="source" content-types="text/plain"/>
  
  <p:output port="xMNML"  primary="true"  pipe="@xMNML"/>
  
  <p:output port="LAYERS" primary="false" pipe="@detail-ranges"/>
  
  
  <mnml:sawteeth-to-xMNML name="xMNML"/>
  
  <p:xslt name="index-ranges">
    <p:with-input port="stylesheet" href="LAYERS/in/xMNML-LAYERS.xsl"/>
  </p:xslt>
  
  <p:xslt name="detail-ranges">
    <p:with-input port="stylesheet" href="LAYERS/rules/LAYERS-detail.xsl"/>
  </p:xslt>
  
  
</p:declare-step>