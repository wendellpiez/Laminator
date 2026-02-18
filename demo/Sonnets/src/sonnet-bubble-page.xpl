<p:declare-step version="3.0" xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:zone="http://wendellpiez.com/ns/xproc-zone" xmlns:mnml="http://wendellpiez.com/ns/xMNML"
  xmlns:c="http://www.w3.org/ns/xproc-step" exclude-inline-prefixes="#all" name="sonnet-bubble-page"
  type="mnml:sonnet-bubble-page">

  <!-- Accepts a sonnet XML and makes an HTML page
       containing a hook for an SVG diagram -->
  
  <p:input port="source" primary="true">
    <p:document href="out/lines/timenorelief.xml"/>
  </p:input>
  
  <p:output port="result"/>

  <p:variable name="sonnet-title"  select="/*/@title/string(.)"/>
  <p:variable name="sonnet-author" select="/*/@author/string(.)"/>
  
  <p:xslt name="sonnet-page">
    <p:with-input port="stylesheet" href="sonnet-lines_html.xsl"/>
  </p:xslt>
  
  <p:insert match="head" position="first-child">
    <p:with-input port="insertion" expand-text="true">
      <title>{ $sonnet-title }, by { $sonnet-author }</title>
    </p:with-input>
  </p:insert>
  
  <p:insert match="head" position="last-child">
    <p:with-input port="insertion" xml:space="preserve" expand-text="false">
        <style type="text/css">
body { margin: 0em 1em }
p { margin: 0pt; padding-left: 2em; text-indent: -2em }          
        </style>
      </p:with-input>
  </p:insert>
  
  <p:insert match="main" position="first-child">
    <p:with-input port="insertion">
      <h1>{ $sonnet-title }</h1>
      <h2>{ $sonnet-author }</h2>
    </p:with-input>
  </p:insert>

</p:declare-step>
