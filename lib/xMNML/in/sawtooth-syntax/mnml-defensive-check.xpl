<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-inline-prefixes="#all" type="mnml:mnml-defensive-check" version="3.0">

  <!-- 
     Provides a pre-check of a document for viable tagging.
     
     Certain kinds of problems can be intercepted before a parse is attempted
     using this pipeline, which counts delimiters: in a
     correct LMNL document, after escape sequences are removed, the characters [ ] { }
     must be  balanced, i.e. the count of [ equals the count of ], and the same for { }
     
     This XProc errors out when this condition is not met.
     If it is met, the process next tries to parse the input as MNML LMNL.
     Outputs from any completed parse can be regarded as correct.
     
     TBD - add post-checks such as xMNML schema validation, Schematron checks?
     -->

  <p:import href="mnml-lmnl_wf-check.xpl"/>

  <p:output port="report" primary="true" serialization="map { 'indent': true(),
    'omit-xml-declaration': true() }"/>

  <!--<p:output port="result" pipe="result@wf-check" serialization="map { 'indent': true(),
    'omit-xml-declaration': true() }"/>-->

  <p:input port="mnml-source" content-types="text/plain"/>

  <p:option name="max-tagging-depth" as="xs:integer" select="200"/>

  <p:identity name="mnml_source"/>
  
  <p:variable name="filename"
    select="p:document-property(.,'base-uri') => tokenize('/') => reverse() => head()"/>

  <!-- We don't unescape escape sequences, but rather delete them entirely,
         since they throw off the counts -->
  <p:variable name="lmnl-string" select="replace(string(.),'\\([\[\{\\])','')"/>

  <!-- Now extracting substrings of only the delimiters, and measuring -->
  <p:variable name="lsbr" select="$lmnl-string => replace('[^\[]','') => string-length()"/>
  <p:variable name="rsbr" select="$lmnl-string => replace('[^\]]','') => string-length()"/>
  <p:variable name="lcbr" select="$lmnl-string => replace('[^\{]','') => string-length()"/>
  <p:variable name="rcbr" select="$lmnl-string => replace('[^\}]','') => string-length()"/>

  <!-- When the measures are the same, the bracketing is balanced -->
  <p:if test="not($lsbr = $rsbr) or not($lcbr = $rcbr)" name="precheck">
    <p:error code="BRACKET_COUNT_PRECHECK"/>
  </p:if>

  <!-- Error out if tagging appears to nest too deeply -->
  <mnml:mnml-lmnl_wf-check name="wf-check" max-tagging-depth="{$max-tagging-depth}" depends="precheck">
    <p:with-input port="source" pipe="mnml_source"/>
  </mnml:mnml-lmnl_wf-check>

</p:declare-step>