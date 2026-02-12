<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:mnml="http://wendellpiez.com/ns/xMNML"
    exclude-inline-prefixes="#all"
    version="3.0">
    
    <p:import href="../../lib/xMNML-into/sawtooth-syntax/mnml-lmnl_wf-check.xpl"/>
    
    <p:output port="result" serialization="map{ 'indent': true() }"/>
    
    <p:directory-list path="." include-filter="\.lmnl$" max-depth="2"/>
    
    
<!-- 
    
    ,
     ,'Exequy.lmnl'
    
    -->
    
    <p:for-each>
        <p:with-input select="/descendant::c:file"/>    
        
        <p:load href="{ base-uri(/*) }" message="Loading { base-uri(/*) }"
          content-type="text/plain"/>
        
        <mnml:mnml-lmnl_wf-check name="wf-check"/>
        
    </p:for-each>
    
    <p:wrap-sequence wrapper="REPORT"/>
    
    <p:label-elements match="/*" attribute="valid" label="count(child::WHEE)"/>
    <p:label-elements match="/*" attribute="count" label="count(child::*)"/>
    
</p:declare-step>