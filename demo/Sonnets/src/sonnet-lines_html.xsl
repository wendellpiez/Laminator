<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    expand-text="true"
    version="3.0">
    
    <xsl:template match="/">
        <html id="{ /*/@id }">
            <head>
                <title>{ /*/@title } by { /*/@author }</title>
            </head>
            <xsl:apply-templates/>
        </html>
    </xsl:template>
    
    <xsl:template match="/*">
        <body>
            <main>
                <div class="sonnet-bubbles" style="float:right">
                    <xsl:comment> svg here </xsl:comment>
                </div>
                <xsl:apply-templates/>
            </main>
        </body>
    </xsl:template>
    
    <xsl:template match="octave | sestet | quatrain | tercet | couplet">
        <div class="{ local-name() }">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="line">
        <p class="{ local-name() }">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    
    
    
    
</xsl:stylesheet>