<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:mnml="http://wendellpiez.com/ns/xMNML"
    exclude-inline-prefixes="#all"
    type="mnml:TEST_LAYERS-BUILD"
    version="3.0">
    
    <p:import href="../../xMNML/in/sawtooth-syntax/sawteeth-to-xMNML.xpl"/>
    
    <p:output port="result" serialization="map{ 'indent': true() }"/>
    
    <p:input port="source" expand-text="false">
      <p:document content-type="text/plain" href="PLfragment.lmnl"/>
    </p:input>
  
    <mnml:sawteeth-to-xMNML/>
  
    <p:xslt>
      <p:with-input port="stylesheet">
        <p:document href="../in/xMNML-LAYERS.xsl"/>
      </p:with-input>
    </p:xslt>
  
  <!-- YES we can have an OHCO <p:delete match="mnml:range[@gi=('s','phr','np')]"/>-->
  
  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document href="../rules/LAYERS-detail.xsl"/>
    </p:with-input>
  </p:xslt>
    
</p:declare-step>
