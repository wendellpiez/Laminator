<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://wendellpiez.com/ns/xMNML"
    version="3.0">
    
    <xsl:output method="text"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="/*/text"/>
    </xsl:template>
    
</xsl:stylesheet>