<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:mnml="http://wendellpiez.com/ns/xMNML"
    exclude-inline-prefixes="#all"
    version="3.0">
    
    <!-- Use this pipeline to regression test the xMNML build process
    
    Over LMNL inputs, this pipeline produces xMNML and then compares that to
    files (baselines) maintained in the `expected` folder 
                            
    -->
    
    <p:import href="../../lib/xMNML-into/sawtooth-syntax/sawteeth-to-xMNML.xpl"/>
    
    <p:import href="../../lib/xMNML-into/sawtooth-syntax/xMNML-cleaner.xpl"/>
    
    <p:output port="result" serialization="map { 'indent': true(), 'omit-xml-declaration': true() }"/>

    <!-- mnml:compare step expects 'source' to be xMNML sawteeth, 'expected' to be an xMNML document
    The source is parsed and cast into the xMNML range model and compared
    a cleanup step on both sides is used to normalize comparisons -->
    
    <p:declare-step type="mnml:go-nogo" name="compare-step">
        <p:input port="source" primary="true" content-types="text/plain"/>
        <p:input port="expected"/>
        <p:variable name="baseURI" select="p:document-property(.,'base-uri')"/>
        <mnml:cleanup name="expected-okay">
            <p:with-input port="source" pipe="expected@compare-step"/>
        </mnml:cleanup>
        <mnml:sawteeth-to-xMNML>
            <p:with-input port="source" pipe="source@compare-step"/>
        </mnml:sawteeth-to-xMNML>
        <mnml:cleanup/>
        <!-- Errors out if the documents don't appear equal -->
        <p:compare fail-if-not-equal="true" name="comparing"
            message="Checking { $baseURI } ...">
            <p:with-input port="alternate" pipe="result@expected-okay"/>
        </p:compare>
    </p:declare-step>
    
    <!-- Remember we error out on no go ... -->
    <mnml:go-nogo name="comparing-simple">
        <p:with-input port="source">
            <p:document  href="Housekeeper144-146.lmnl" content-type="text/plain"/>
        </p:with-input>
        <p:with-input port="expected" href="expected/Housekeeper-xMNML.xml"/>
    </mnml:go-nogo>
    
    <mnml:go-nogo name="comparing-edges">
        <p:with-input port="source">
            <p:document  href="PLfragment.lmnl" content-type="text/plain"/>
        </p:with-input>
        <p:with-input port="expected" href="expected/PLfragment-xMNML.xml"/>
    </mnml:go-nogo>
    
    <p:identity depends="comparing-simple comparing-edges">
        <p:with-input port="source">
            <LOOKING_GOOD>You have made it this far - Baseline xLMNL production is stable</LOOKING_GOOD>
        </p:with-input>
    </p:identity>
    
</p:declare-step>