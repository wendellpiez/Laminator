<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="3.0"
    xmlns:mnml="http://wendellpiez.com/ns/xMNML"
    xmlns="http://wendellpiez.com/ns/xMNML">
    
    <p:import href="../../lib/xMNML/up/sawtooth-syntax/sawteeth-to-xMNML.xpl"/>
    
    <p:input port="source">
        <p:document content-type="text/plain" href="data/Frankenstein1831.lmnl"/>
    </p:input>
    
    <p:variable name="basename" select="base-uri(/) => replace('.*/|\.lmnl$','')"/>
    
    <mnml:sawteeth-to-xMNML/>
    
    <!--<p:store href="cache/{ $basename }-xMNML.xml" serialization="map { 'indent': true() }"/>-->
    
    <!-- Not annotations, only tags -->
    <p:variable name="range-types" select="/*/*/@gi => distinct-values()"/>
    
    <p:xslt template-name="make-rangemap" parameters="map {
        'document-title': (/*/text[tokenize(@cf,'_| ')='docTitle'] => string-join('') ),
        'range-types': $range-types }">
        <p:with-input port="stylesheet" href="src/produce-rangemap-spec.xsl"/>
    </p:xslt>
    
    <p:store href="{ $basename}_range-map.xml" serialization="map { 'indent': true() }" 
        message="Produced range map spec for editing - see specs/{ $basename}_range-map.xml"/>
    
    
</p:declare-step>