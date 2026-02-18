<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:zone="http://wendellpiez.com/ns/xproc-zone"
    xmlns:mnml="http://wendellpiez.com/ns/xMNML"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    exclude-inline-prefixes="#all" name="main">
    
    <p:import href="../../lib/xMNML/up/sawtooth-syntax/sawteeth-to-xMNML.xpl"/>

    <p:output port="result" serialization="map{ 'indent': true() }"/>


    <mnml:sawteeth-to-xMNML name="xMNML">
        <p:with-input port="source">
            <p:document href="PLfragment.lmnl" content-type="text/plain"/>
        </p:with-input>
    </mnml:sawteeth-to-xMNML>
    
    <!-- The XSLT returns a <REPORT> document listing all ranges of the type(s) indicated, e.g.
           parameters="map { 'ranges': 's' }" to get 's' ranges [s} ... {s]
                s: sentences
                phr: phrases
                np: noun phrases
                l: lines    -->
    <p:xslt parameters="map { 'ranges': ('s','np' ) }">
        <p:with-input port="stylesheet" href="src/extract-ranges.xsl"/>
    </p:xslt>

    <p:store href="out/PL-range-survey.xml" serialization="map{ 'indent': true() }"
        message="-- Stored the range survey in out/PL-range-survey.xml"/>
    
</p:declare-step>
