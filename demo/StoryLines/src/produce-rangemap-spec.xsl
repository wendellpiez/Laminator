<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- Produces a blank range map suitable for extension-->
    
    <xsl:param name="range-types" select="'p','div'" as="xs:string*"/>
    
    <xsl:param name="document-title" as="xs:string?"/>
    
    <xsl:template name="make-rangemap" expand-text="true">
        <RANGEMAP padding="30" width="1200" font-size="8"
            font-family="'Cambria'" fill="lemonchiffon" fill-opacity="0.2">
            <title x="30" y="30" font-size="14">{ $document-title }{ $document-title ! ' -' } Range Map</title>
            <xsl:iterate select="$range-types">
                <course ranges="{ . }" w="40" drop="50" r="2" fill="lightgreen" stroke="black" fill-opacity="0.4">
                    <xsl:text>&#xA;<!-- force lf --></xsl:text>
                    <xsl:comment expand-text="false"> track signature="[who}Maddalo{]" drop="6" fill-opacity="0.2" stroke-width="2" stroke="pink" </xsl:comment>
                </course>
            </xsl:iterate>
        </RANGEMAP>
    </xsl:template>
    
</xsl:stylesheet>