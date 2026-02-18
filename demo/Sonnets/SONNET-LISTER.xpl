<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="3.0"
    xmlns:svg="http://www.w3.org/2000/svg">
    
    <!--
    
    This pipeline reads interim (xMNML) persistent files
      saved in the local file system by pipeline SONNET-BUBBLER.xpl - run that one first.
    
    Produces a single Markdown file result listing the xMNML files
    with links to LMNL sources and snapshot diagrams.
    -->
    
    <p:directory-list path="out/xmnml/" include-filter="xml$"/>
    
    <p:for-each  xmlns="http://wendellpiez.com/ns/xMNML">
        <p:with-input select="//c:file"/>
        
        <p:load href="{ resolve-uri(/*/@name,base-uri(.)) }"/>
        
        <p:variable name="id" select="/*/start[@gi='sonneteer']/*[@gi='id']/string(.)"/>
        <p:variable name="author" select="/*/start[@gi='sonneteer']/*[@gi='author']/string(.)"/>
        <p:variable name="title" select="/*/start[@gi='sonneteer']/*[@gi='title']/string(.)"/>
        
        <p:identity message="Seeing '{ $title }' by { $author }">
            <p:with-input port="source" expand-text="true">
                <p:inline>&#xA;&#xA;---&#xA;&#xA;{ $author }: [{ $title }](../../sources/Sonneteer/sonnets/{$id}.lmnl)*&#xA;&#xA;![{ $title }](out/bubbles/{ $id }-bubbles.svg)</p:inline>
            </p:with-input>
        </p:identity>
    </p:for-each>
    
    <p:wrap-sequence wrapper="md"/>
    
    <p:insert match="/*" position="first-child">
        <p:with-input port="insertion" expand-text="true">
            <p:inline xml:space="preserve">
<head># Sonnet snapshots</head>

<line>With links to LMNL source data.</line>
</p:inline>
        </p:with-input>
    </p:insert>
    
    
    <p:string-replace match="/*" replace="string(.)"/>
    
    <p:store href="sonnet-list.md" message="... Storing sonnet-list.md ..."/>
     
</p:declare-step>