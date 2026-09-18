<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step version="3.0"
  xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:laminator="https://github.com/wendellpiez/Laminator/ns">
  
  <!-- This pipeline is the same as src/producer.xpl, except providing
       an error when p:markdown-to-html is not available -->
  
  <!--  Imports a pipeline (step declaration or library) -->
  <p:import href="src/md-to-sts.xpl"/>
  
  <!--Error early if we can't do it-->
  
  <!-- Loads a file as plain text -->
  <p:load href="src/spec/mnml-specification.md" content-type="text/plain"/>

  <!-- Error early if we can't do it -->
  <p:if test="p:step-available('p:markdown-to-html') => not()">
    <p:error code="NOMDSUPP">
      <p:with-input>
        <p:inline>Sorry, unable to run Markdown conversion - try XML Calabash</p:inline>
      </p:with-input>
    </p:error>
  </p:if>
  
  <!-- Makes HTML, if possible (supported in XML Calabash) -->
  <p:markdown-to-html use-when="p:step-available('p:markdown-to-html')"/>

  <!-- Calls an imported step -->
  <laminator:md-to-sts name="converted"/>
  
  
  <!-- Saves the result -->
  <p:store href="view/mnml-spec-sts.xml" message="SAVING view/mnml-spec-sts.xml ..."
    serialization="map { 'indent': true() }"/>
  
  <!-- Saves the result -->
  <p:store href="view/mnml-spec-working.html" message="SAVING view/mnml-spec-working.html ..."
    serialization="map { 'indent': true() }">
    <p:with-input pipe="html-ready@converted"/>
  </p:store>
  
  <p:xslt>
    <p:with-input port="stylesheet" href="src/xhtml-to-markdown.xsl"/>
  </p:xslt>
  
  <p:store href="MNML-LMNL_specification.md" message="SAVING MNML-LMNL_specification.md ..."
    serialization="map { 'indent': false(), 'method': 'text' }"/>
  
  
</p:declare-step>