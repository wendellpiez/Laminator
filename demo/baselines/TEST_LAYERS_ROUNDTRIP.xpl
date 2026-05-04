<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:mnml="http://wendellpiez.com/ns/xMNML"
    exclude-inline-prefixes="#all"
    version="3.0">
    
    <!-- Use this pipeline to regression test the xMNML build process
    
    Over LMNL inputs, this pipeline produces xMNML, converts to the LAYERS
    model, then converts it back, and compares the xMNML before and after.
    If they are not the same, it errors.
                            
    -->
    
    <p:import href="../../lib/parse_MNML-LMNL.xpl"/>
    
    
    
    <p:output port="result" serialization="map { 'indent': true(), 'omit-xml-declaration': true() }"/>

    <!-- mnml:compare step expects 'source' to be xMNML sawteeth, 'expected' to be an xMNML document
    The source is parsed and cast into the xMNML range model and compared
    a cleanup step on both sides is used to normalize comparisons -->
    
    <!-- Reads a LMNL document, parses it, builds a LAYERS model, converts that back to xLMNL,
    compares with the parsed xLMNL in, and errors if they are not the same -->
    
    <p:declare-step type="mnml:checks-out" name="compare-step">
        <p:input port="source" primary="true" content-types="text/plain"/>
        <p:variable name="baseURI" select="p:document-property(.,'base-uri')"/>
        
        <mnml:parse_MNML-LMNL name="building">
            <p:with-input port="source" pipe="source@compare-step"/>
        </mnml:parse_MNML-LMNL>
        
        <p:xslt name="comparable-source">
          <p:with-input port="stylesheet" href="../../lib/xMNML/rules/xMNML-make-comparable.xsl"/>
        </p:xslt>
      
        <!-- Converting the LAYERS model presented back to xMNML -->
        <p:xslt>
          <p:with-input port="source"     pipe="LAYERS@building"/>   
          <p:with-input port="stylesheet" href="../../lib/LAYERS/out/inscribe-xMNML.xsl"/>
        </p:xslt>
        
        <p:xslt name="comparable-back">
          <p:with-input port="stylesheet" href="../../lib/xMNML/rules/xMNML-make-comparable.xsl"/>
        </p:xslt>
      
      
        <!-- Errors out if the documents don't appear equal -->
        <p:compare fail-if-not-equal="true" name="comparing"
            message="Checking { $baseURI } ...">
            <p:with-input port="alternate" pipe="@comparable-source"/>
        </p:compare>
    </p:declare-step>
    
    <!-- Remember we error out on no go ... -->
    <!--<mnml:checks-out name="comparing-simple">
        <p:with-input port="source">
            <p:document  href="data/Housekeeper144-146.lmnl" content-type="text/plain"/>
        </p:with-input>
    </mnml:checks-out>-->
    
    <mnml:checks-out name="comparing-edges">
        <p:with-input port="source">
            <p:document  href="data/PLfragment.lmnl" content-type="text/plain"/>
        </p:with-input>
    </mnml:checks-out>
    
    <p:identity depends="comparing-edges">
        <p:with-input port="source">
            <LOOKING_GOOD>You have made it this far - Baseline xLMNL production is stable</LOOKING_GOOD>
        </p:with-input>
    </p:identity>
    
</p:declare-step>