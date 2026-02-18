<p:declare-step version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:zone="http://wendellpiez.com/ns/xproc-zone" xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  exclude-inline-prefixes="#all" name="main">

  <p:import href="../../lib/xMNML/up/sawtooth-syntax/sawteeth-to-xMNML.xpl"/>


  <!-- more to come... -->
  
  <p:input port="filespec" sequence="true">
    <map name="Frankenstein1831" source="data/Frankenstein1831.lmnl"     spec="specs/TEI-novel_range-map.xml"/>
    <map name="PeregrinesEnd"    source="data/PeregrinesDemise_tei.lmnl" spec="specs/TEI-basic_range-map.xml"/>
    <map name="JulianandMaddalo" source="data/Julian_and_Maddalo.lmnl"   spec="specs/JM_range-map.xml"/>
  </p:input>

  <p:for-each>
    <p:with-input select="/map"/>
    <p:variable name="basename" select="/*/@name"/>
    <p:variable name="mapspec"  select="/*/@spec"/>
    
    <p:load href="{resolve-uri(/*/@source, static-base-uri())}" content-type="text/plain"/>

    <!-- First - parse the LMNL syntax (MNML LMNL) into xMNML format -->
    <mnml:sawteeth-to-xMNML/>

    <p:store href="cache/{ $basename }-xMNML.xml" serialization="map { 'indent': true() }"/>
    
    <p:variable name="xMNML" select="/"/>

    <!-- Produces an SVG range diagram passing the xMNML in as runtime parameter -->
    <p:xslt parameters="map { 'xMNML': $xMNML }">
      <p:with-input port="stylesheet" href="src/mnml-rangemap.xsl"/>
      <p:with-input port="source"     href="{ resolve-uri($mapspec, static-base-uri()) }"/>
    </p:xslt>

    <p:store href="out/{$basename}_range-map.svg" message="REFRESHED out/{$basename}_range-map.svg"
      serialization="map { 'indent': true(), 'omit-xml-declaration': true() }"/>
  </p:for-each>

</p:declare-step>
