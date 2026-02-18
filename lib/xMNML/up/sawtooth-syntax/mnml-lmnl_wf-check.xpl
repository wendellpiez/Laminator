<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:mnml="http://wendellpiez.com/ns/xMNML"
    exclude-inline-prefixes="#all"
    type="mnml:mnml-lmnl_wf-check"
    version="3.0">
    
    
    <!-- Accepts purportely MNML markup
        
        reports:
        
        does it parse
        if so, does it pass other tests for integrity as a range model
        
        ports:
          xMNML-result - for when it gets that far
          read_errors - what XML Calabash brings back
          naming errors?
          link_errors
            don't need to check offsets or character escaping
            
          
        options:
          report iXML results in failure mode
        
      MNML is a subset of LMNL. MNML markup takes the form of LMNL 'sawteeth'
      except annotations are simple values (strings or tokens), not LMNL layers
    
    Use cases: in oXygen on a LMNL syntax instance?
    -->
    
    <p:import href="sawteeth-to-xMNML.xpl"/>

    <p:output port="report" primary="true" serialization="map { 'indent': true(),
        'omit-xml-declaration': true() }"/>

    <p:output port="result" serialization="map { 'indent': true() }"
      pipe="result@parse_result"/>
    
    <p:input port="mnml-source" content-types="text/plain"/>
    
    <p:variable name="filename" select="p:document-property(.,'base-uri') => tokenize('/') => reverse() => head()"/>
    
    <p:variable name="echo" select="string(.) ! normalize-space(.)"/>
    
    <p:try>
        <mnml:sawteeth-to-xMNML/>
        <!-- Extend to Schematron and capture report here --> 
        <p:catch>
            <p:identity/>
            <p:wrap-sequence wrapper="RETURNS"/>
            <p:insert match="/*" position="first-child">
                <p:with-input port="insertion">
                    <INPUT>{ $echo }</INPUT>
                </p:with-input>
            </p:insert>
            <p:namespace-rename to="http://wendellpiez.com/ns/Laminator" apply-to="elements"/>
        </p:catch>
    </p:try>
    
    <p:identity name="parse_result"/>
    
    <p:choose>
        <p:when test="exists(/mnml:LMNL)">
            <p:identity>
                <p:with-input>
                    <WHEE file="{ $filename }" echo="{ substring($echo,1,40) }{ substring($echo,40)[normalize-space()] ! '...' }">All good ... seeing { name(/*)} in namespace { namespace-uri(/*) }</WHEE>
                </p:with-input>
            </p:identity>
        </p:when>
        <p:otherwise>
            <p:identity>
                <p:with-input>
                    <OOPS file="{ $filename }" echo="{ substring($echo,1,40) }{ substring($echo,40)[normalize-space()] ! '...' }">Errors are reported ...</OOPS>
                </p:with-input>
            </p:identity>
        </p:otherwise>
    </p:choose>
    
    <p:identity name="summary"/>
    
</p:declare-step>