<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xpath-default-namespace="http://wendellpiez.com/ns/xMNML"
    exclude-result-prefixes="xs math"
    expand-text="true"
    version="3.0">
    
    <!--
    xMNML XML ripper
    writes XML from xMNML by serializing tags
    emits a plain text document that 'appears to be' XML - good luck!
    
    for best results, filter out overlaps before using this stylesheet -
      use only over xMNML known not to have any!
      
      LIMITS: won't fix overlaps for you; tag order must be nicely nested;
      won't handle annotations with the same name;
      must be entirely enclosed in at least one range (start and end with matching tags)
      
     -->
    
    <xsl:output method="text"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:preserve-space elements="text"/>
    
    <xsl:template match="/*">
            <xsl:apply-templates/>
        
    </xsl:template>

    <xsl:key name="end-for-rID" match="end" use="rID"/>
    
    <xsl:param name="interdicted" select="'s','phr','np'"/>
    
    <xsl:template match="start[@gi=$interdicted] | end[@gi=$interdicted]"/>
    
    <!--Anonymous ranges are not handled! -->
    <xsl:template match="start | empty">
        <xsl:text>&lt;{ (@gi,'ANONYMOUS')[1] }</xsl:text>
        <xsl:iterate select="child::annotation, key('end-for-rID',@rID)/annotation">
            <xsl:text> { (@gi,'ANONYMOUS')[1] }="{ . }"</xsl:text>
        </xsl:iterate>
        <xsl:text>{ self::empty ! '/' }></xsl:text>
    </xsl:template>
    
    <xsl:template match="end">
        <xsl:text>&lt;/{ (@gi,'ANONYMOUS')[1] }></xsl:text>
    </xsl:template>
    
</xsl:stylesheet>