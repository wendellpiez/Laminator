<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
 xmlns:mnml="http://wendellpiez.com/ns/xMNML"
 xmlns:laminator="https://github.com/wendellpiez/Laminator/ns"
 type="laminator:md-to-sts">
  
  <!-- Accepts an XML (XHTML) document on 'source' port
       and creates a clean XML representation of the data set -->
  
  <p:input port="source"/>
  
  <p:output port="sts-result" primary="true" pipe="result@sts-ready"/>
  
  <p:output port="html-interim" primary="false" pipe="result@clean_html"/>
  
  <p:output port="html-ready" primary="false" pipe="result@reading_html"/>
  
  <p:xslt name="clean_html">
    <p:with-input port="stylesheet" href="html-levitate.xsl"/>
  </p:xslt>
  
  <p:xslt>
    <p:with-input port="stylesheet" href="html-to-sts.xsl"/>
  </p:xslt>
  
  <p:insert position="before" match="/*" name="sts-ready">
    <p:with-input port="insertion">
      <p:inline>
      <?xml-model href="file:///C:/Users/wapie/Documents/Projects/Github/xproc-zone/projects/USArmy_FM6-22/lib/NISO-STS-interchange-1-MathML3-RNG/NISO-STS-interchange-1-mathml3.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
      </p:inline>
    </p:with-input>
  </p:insert>
  
  <p:xslt name="reading_html">
    <p:with-input port="stylesheet" href="sts-html.xsl"/>
  </p:xslt>
  
  
  
</p:declare-step>