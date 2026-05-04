<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:mnml="http://wendellpiez.com/ns/xMNML"
    exclude-inline-prefixes="#all"
    version="3.0">
  
  <!-- Calls the local copy of PLfragment by default, but any LMNL instance should do it -->
  <p:import href="../../xMNML/in/sawtooth-syntax/sawteeth-to-xMNML.xpl"/>
  
  <p:output port="result" serialization="map{ 'indent': true() }"/>
  
  <p:input port="source" expand-text="false">
    <p:document content-type="text/plain" href="PLfragment.lmnl"/>
  </p:input>
  
  <p:variable name="baseFile" select="replace( p:document-property(.,'base-uri'), '.*/', '')"/>
  <p:variable name="basename" select="replace( $baseFile, '\..*$', '')"/>
  
  <mnml:sawteeth-to-xMNML name="parsing"/>
  
  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document href="../../xMNML/rules/xMNML-make-comparable.xsl"/>
    </p:with-input>
  </p:xslt>
  
  <p:store name="comparable-parsed" href="out/_1-xMNMLout/{$basename}-xMNML.xml" message="Storing out/_1-xMNMLout/{$basename}-xMNML.xml" serialization="map{ 'indent': true() }"/>
  
  <p:xslt>
    <p:with-input port="source" pipe="@parsing"/>
    <p:with-input port="stylesheet">
      <p:document href="../in/xMNML-LAYERS.xsl"/>
    </p:with-input>
  </p:xslt>
  
  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document href="../rules/LAYERS-detail.xsl"/>
    </p:with-input>
  </p:xslt>
  
  <p:store href="out/_2-layers/{$basename}.xml" message="Storing out/_2-layers/{$basename}.xml" serialization="map{ 'indent': true() }"/>
    
  <p:xslt>
      <p:with-input port="stylesheet">
        <p:document href="../out/inscribe-xMNML.xsl"/>
      </p:with-input>
  </p:xslt>

  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document href="../../xMNML/rules/xMNML-make-comparable.xsl"/>
    </p:with-input>
  </p:xslt>

  <p:store name="comparable-backagain" href="out/_3-xMNMLback/{$basename}-xMNML.xml" message="Storing out/_3-xMNMLback/{$basename}-xMNML.xml" serialization="map{ 'indent': true() }"/>
    
  <p:compare fail-if-not-equal="true" name="comparing"
    message="Comparing there and back again on { $baseFile } ...">
    <p:with-input port="source"    pipe="@comparable-backagain"/>
    <p:with-input port="alternate" pipe="@comparable-parsed"/>
  </p:compare>
 
  <p:identity message="Looking good so far ...">
    <p:with-input port="source">
      <p:inline><LOOKING_GOOD>Congratulations - Seeing a successful parse-and-rewrite of { $baseFile } into xLMNL and through the LAYERS model...</LOOKING_GOOD></p:inline>
      <p:pipe step="comparing" port="differences"/>
    </p:with-input>
  </p:identity>
  
</p:declare-step>