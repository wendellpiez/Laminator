<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:mnml="http://wendellpiez.com/ns/xMNML" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-inline-prefixes="#all" type="mnml:mnml-defensive-check" version="3.0">

  <!-- 
     
     For pre-checking syntax - it is possible for some kinds of inputs to build
     uselessly deep traversal trees if start tags appear without matching end tags.
     This pipelines prevents that from happening by counting the delimiters: in a
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

  <p:variable name="filename"
    select="p:document-property(.,'base-uri') => tokenize('/') => reverse() => head()"/>

  <!-- We don't unescape escape sequences, but rather delete them entirely,
         since they throw off the counts -->
  <p:variable name="lmnl-string" select="replace(string(.),'\\([\[\{\\])','')"/>
  <p:variable name="echo" select="$lmnl-string ! normalize-space(.)"/>

  <p:variable name="lsbr" select="$lmnl-string => replace('[^\[]','') => string-length()"/>
  <p:variable name="rsbr" select="$lmnl-string => replace('[^\]]','') => string-length()"/>
  <p:variable name="lcbr" select="$lmnl-string => replace('[^\{]','') => string-length()"/>
  <p:variable name="rcbr" select="$lmnl-string => replace('[^\}]','') => string-length()"/>

  <p:if test="not($lsbr = $rsbr) or not($lcbr = $rcbr)">
    <p:error code="BRACKET_COUNT_PRECHECK"/>
  </p:if>

  <!-- Error out if tagging appears to nest too deeply -->
  <mnml:mnml-lmnl_wf-check name="wf-check" max-tagging-depth="{$max-tagging-depth}"/>

</p:declare-step>