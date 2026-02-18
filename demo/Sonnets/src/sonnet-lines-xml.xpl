<p:declare-step version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:zone="http://wendellpiez.com/ns/xproc-zone" xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xmlns:c="http://www.w3.org/ns/xproc-step" exclude-inline-prefixes="#all" name="sonnet-lines-xml"
  type="mnml:sonnet-lines-xml">

  <!-- Accepts xLMNL input for Sonneteer and returns an XML sonnet
    Assumes input is well-nested already!
    since we write XML the cheap way (for demonstration purposes)
    
  -->

  <p:input port="source">
    <!-- for testing -->
    <p:document href="out/xmnml/ledaandswan_xMNML.xml" content-type="text/plain"/>
  </p:input>

  <p:output port="result"/>

  <!-- Names of ranges to remove from XML view -->
  <p:variable name="exclude-ranges" select="'s', 'phr', 'np'"/>
  
  <!-- Alternatively, a keep-ranges (white list) would include sonneteer, sonnet, quatrain etc. -->
  
  <p:variable name="scrubbing" select="$exclude-ranges ! ('''' || . || '''') => string-join(', ')"/>

  <p:delete match="start[@gi=({$scrubbing})] | end[@gi=({$scrubbing})]"/>

  <!-- put inside a try/catch - for now, any error breaks the pipeline -->
  <p:group name="make-xml">
    <p:xslt>
      <p:with-input port="stylesheet" href="../../../lib/xMNML/down/xMNML-xml-ripper.xsl"/>
    </p:xslt>

    <p:cast-content-type content-type="application/xml"/>
  </p:group>


</p:declare-step>
