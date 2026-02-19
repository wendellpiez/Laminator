<p:declare-step version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:zone="http://wendellpiez.com/ns/xproc-zone"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  exclude-inline-prefixes="#all" name="main">


  <p:output sequence="true" serialization="map { 'indent': true() }"/>
  
  <!-- For now, this pipeline lists xpl files with names starting with 'TEST'
  possible future: xspec tests
  
  for regression testing purposes these should all run! -->
  
  <p:directory-list path=".." include-filter="/TEST.*\.xpl$" max-depth="unbounded"/>
  
  <p:for-each>
    <p:with-input select="//c:file"/>
    
    <p:variable name="baseURI" select="resolve-uri(/*/@name,base-uri(.))"/>
    
    <!--<p:load href="{ resolve-uri(/*/@name,base-uri(.)) }"/>-->
    
    <p:identity>
      <p:with-input port="source" expand-text="true">
        <p:inline><file>{ $baseURI }</file></p:inline>
      </p:with-input>
    </p:identity>
  </p:for-each>

  <p:wrap-sequence wrapper="LIST"/>
  
</p:declare-step>
