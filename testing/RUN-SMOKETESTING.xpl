<p:declare-step version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:zone="http://wendellpiez.com/ns/xproc-zone"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  exclude-inline-prefixes="#all" name="main">

  <p:import href="../demo/baselines/TEST_xMNML-BUILD.xpl"/>
  
  <p:import href="../demo/baselines/TEST_LAYERS_ROUNDTRIP.xpl"/>
 
  <p:import href="../lib/LAYERS/testing/RUN_LAYERS-ROUNDTRIP.xpl"/>
  <!--<p:output port="xMNML-build"      serialization="map { 'indent': true() }" pipe="@xMNML-build"/>-->
  
  <!--<mnml:TEST_xMNML-BUILD name="xMNML-build" p:message="TESTING xMNML BUILD"/>-->
  
  <!--<p:sink/>-->
  
  <p:output port="baseline-layers-roundtrip" serialization="map { 'indent': true(), 'omit-xml-declaration': true() }"
    pipe="@baseline-layers-roundtrip"/>

  
  <mnml:TEST_LAYERS_ROUNDTRIP name="baseline-layers-roundtrip" p:message="TESTING BASELINE LAYERS roundtripping"/>
  
  <!--<p:sink/>
  
  <mnml:RUN_LAYERS-ROUNDTRIP name="layers-roundtrip-test" p:message="... and with LAYERS test ... "/>-->
  
</p:declare-step>
