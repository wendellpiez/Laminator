<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML" exclude-inline-prefixes="#all" version="3.0"
  type="mnml:DEMO" name="demo">

  <!-- Writes all parse outputs to a controlled location
         with no error trapping -->

  <p:import href="sawteeth-to-xMNML.xpl"/>

  <p:input port="source" expand-text="false">
    <p:document content-type="text/plain" href="src/demo-sawteeth-source.lmnl"/>
  </p:input>

  <p:variable name="target_dir" select="'demo'"/>

  <mnml:sawteeth-to-xMNML name="build_xMNML" stop-on-tagging-error="no"/>

  <p:store href="{ $target_dir }/xMNML-result.xml" serialization="map { 'indent': true() }"
    message="See some processing results in the { $target_dir } folder ..."/>
  
  <p:delete match="@L | @ch"/>
  
  <p:store href="{ $target_dir }/xMNML-comparand.xml" serialization="map { 'indent': true() }"/>
  
  <!-- Providing the raw parsed result with a PI for visibility -->
  <p:insert match="/*" position="before" name="parsed-tags">  
    <p:with-input pipe="raw_parseresult@build_xMNML"/>
    <p:with-input port="insertion">
      <p:inline><?xml-stylesheet type="text/css" href="sawteeth.css"?></p:inline>
    </p:with-input>
  </p:insert>

  <p:store href="{ $target_dir }/iXMLparse-result.xml"/>


  <p:store href="{ $target_dir }/xMNML-interim.xml">
    <p:with-input pipe="interim_matched@build_xMNML"/>
  </p:store>

  


</p:declare-step>