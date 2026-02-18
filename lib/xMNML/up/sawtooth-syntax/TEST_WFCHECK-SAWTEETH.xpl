<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:mnml="http://wendellpiez.com/ns/xMNML"
    exclude-inline-prefixes="#all"
    version="3.0">
    
    <p:import href="mnml-lmnl_wf-check.xpl"/>
    
    <p:output port="result" serialization="map{ 'indent': true() }"/>
    
    <p:input port="source" expand-text="false">
        <p:inline>
            <TESTS>
                <!-- NB in XML Calabash 3.0.16 okays must come first - or update Calabash -->
                <okay>[excerpt [author}Robert Frost{][date}1915{][title}The Housekeeper{]}
                    [s}[l [n}144{]}He manages to keep the upper hand{l]
                    [l [n}145{]}On his own farm.{s] [s}He's boss.{s] [s}But as to hens:{l]
                    [l [n}146{]}We fence our flowers in and the hens range.{l]{s]
                    {excerpt]
                </okay>
                

                <okay  nb="only an empty"       >[tag]</okay>
                <okay  nb="with an annotation"  >[well [ann}annotated{]}STUFF{well]</okay>
                <okay  nb="with two annotations">[well [ann}o{][tat}ed{]}STUFF{well]</okay>
                
                <okay  nb="annotated end tag" >[well}STUFF{well [ann}annotated{]]</okay>
                
                <broke nb="annotations can't be marked up">[badly [ann}annotated[markup]{]}STUFF{badly]</broke>
                <broke nb="annotations close only with {]">[badly [ann}annotated{ann]}STUFF{badly]</broke>
                
                <broke nb="unclosed tag"     >[unclosed</broke>
                <broke nb="broken annotation">[broken [ann}broken annotation{broken]</broke>
                <broke nb="broken annotation">[broken  ann}broken annotation{broken]</broke>
                
            </TESTS>
        </p:inline>
    </p:input>
    
    <p:for-each name="testing">
        <p:with-input select="/TESTS/*"/>    
        
        <p:variable name="echo" select="string(.)"/>
        
        <p:unwrap/>
        
        <mnml:mnml-lmnl_wf-check name="wf-check"/>
    
        <!-- jump back to input to clean up -->    
        <p:delete match="/*/text()">
            <p:with-input port="source" pipe="current@testing"/>            
        </p:delete>
        
        <!-- inserting test report WHEE or OOPS -->
        <p:insert position="first-child">
            <p:with-input port="insertion" pipe="report@wf-check"/>
        </p:insert>
        
        <p:add-attribute match="okay[child::OOPS]"  attribute-name="BUT" attribute-value="NOT_OKAY"/>
        <p:add-attribute match="broke[child::WHEE]" attribute-name="BUT" attribute-value="SAYS_OKAY"/>
        <p:delete match="/*/*/text()"/>
        <p:delete match="@file"/>
        
    </p:for-each>
    
    
    <p:wrap-sequence wrapper="REPORT"/>
    
</p:declare-step>