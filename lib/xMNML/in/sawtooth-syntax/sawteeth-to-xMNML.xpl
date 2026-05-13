<p:declare-step version="3.0"
  xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:cx="http://xmlcalabash.com/ns/extensions"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  exclude-inline-prefixes="#all"
  type="mnml:sawteeth-to-xMNML">
  
  <!-- Produces xMNML XML on the result port from LMNL syntax on 'source' input port -->
  
  <!-- Requires markup-blitz (included in current versions of XML Calabash) -->
  
  <p:input port="source" content-types="text/plain"/>
  
  <p:output port="result" primary="true" pipe="@xMNML"
    serialization="map { 'indent': true(), 'omit-xml-declaration': true() }"/>
  
  <!-- We also have secondary results in case visibility is wanted into interim results --> 
  <p:output port="raw_parseresult"  primary="false" pipe="result@parsed-tags"
    serialization="map { 'indent': true(), 'omit-xml-declaration': true() }"/>
  
  <p:output port="interim_matched" primary="false" pipe="result@matched"
    serialization="map { 'indent': true(), 'omit-xml-declaration': true() }"/>
  
  <!-- At 0, no check for nominal max tagging depth (number of unclosed ranges over text)
     will be performed - set this to some (integer) value in a calling pipeline
     for a more 'paranoid' parser run: it will error out if it goes too deep 
  -->
  <p:option name="max-tagging-depth" select="0" as="xs:nonNegativeInteger"/>
  
  <!-- [ten}[nine}[eight}... Here we go good luck -->
  
  <p:invisible-xml cx:processor="markup-blitz" name="parsed-tags">
     <p:with-input port="grammar">
        <p:document href="src/mnml-lmnl.ixml" content-type="text/plain"/>
     </p:with-input>
  </p:invisible-xml>
  
  <p:xslt name="matched" parameters="map { 'stack-limit': $max-tagging-depth }">
    <p:with-input port="stylesheet" href="src/mnml-matching.xsl"/>
  </p:xslt>
  
  <p:xslt name="matched-and-measured">
    <p:with-input port="stylesheet" href="src/mnml-measuring.xsl"/>
  </p:xslt>
  
  <p:identity name="xMNML"/>
  
</p:declare-step>
