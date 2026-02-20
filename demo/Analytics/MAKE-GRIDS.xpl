<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="3.0">
  
  <p:import href="overlap-grid.xpl"/>
  
  <p:output port="reports" serialization="map { 'indent': true() }"/>
  
  <p:input port="source" sequence="true">
    <!--<p:document content-type="text/plain" href="../baselines/data/Housekeeper144-146.lmnl"/>-->
    <p:document content-type="text/plain" href="../StoryLines/data/Frankenstein1831.lmnl"/>
  </p:input>

  <p:for-each>
    <mnml:overlap-grid/>
  </p:for-each>
  
  <p:wrap-sequence wrapper="REPORTS" xmlns="http://wendellpiez.com/ns/xMNML"/>
  
</p:declare-step>