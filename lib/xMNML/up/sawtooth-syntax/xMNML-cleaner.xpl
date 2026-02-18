<p:declare-step version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:cx="http://xmlcalabash.com/ns/extensions" xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  exclude-inline-prefixes="#all"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  type="mnml:cleanup">

  <!-- Strips whitespace everywhere except inside 'text' elements -->
  
  <p:input port="source"/>
  
  <p:output port="result"/>
  
  <p:xslt>
    <p:with-input port="stylesheet">
      <p:inline expand-text="false">
        <xsl:stylesheet version="3.0">
          <xsl:strip-space elements="*"/>
          <xsl:preserve-space elements="text"
            xpath-default-namespace="http://wendellpiez.com/ns/xMNML"/>
          <xsl:template match="/"><xsl:copy-of select="/"/></xsl:template>
        </xsl:stylesheet>
      </p:inline>
    </p:with-input>
  </p:xslt>

</p:declare-step>
