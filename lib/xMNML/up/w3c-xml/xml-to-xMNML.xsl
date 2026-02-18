<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://wendellpiez.com/ns/xMNML"
    exclude-result-prefixes="#all" version="3.0" expand-text="true">
<!--

An easy way to go from any XML into MNML LMNL
means we are now able to skip writing it into LMNL syntax first and then parsing.
TODO: UNIT TEST
      VALIDATE RESULTS AGAINST SCHEMA
      
      -->
    <xsl:output indent="true"/>

    <xsl:mode on-no-match="fail" use-accumulators="offsets"/>

    <xsl:accumulator name="offsets" initial-value="0" as="xs:integer">
        <xsl:accumulator-rule match="text()" select="$value + string-length(.)"/>
    </xsl:accumulator>

    <xsl:template match="comment() | processing-instruction()"/>

    <xsl:template match="/">
        <LMNL>
            <xsl:apply-templates/>
        </LMNL>
    </xsl:template>

    <xsl:template match="*[empty(* | text())]">
        <empty gi="{ local-name()}" off="{ accumulator-before('offsets') }" ext="0">
            <xsl:attribute name="rID">
                <xsl:apply-templates select="." mode="rID"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*"/>
        </empty>
    </xsl:template>

    <xsl:template match="*">
        <start gi="{ local-name()}" off="{ accumulator-before('offsets') }"
            ext="{ accumulator-after('offsets') - accumulator-before('offsets') }">
            <xsl:attribute name="rID">
                <xsl:apply-templates select="." mode="rID"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*"/>
        </start>
        <xsl:apply-templates/>
        <end gi="{ local-name()}" off="{ accumulator-after('offsets') }"
            ext="{ accumulator-after('offsets') - accumulator-before('offsets') }">
            <xsl:attribute name="rID">
                <xsl:apply-templates select="." mode="rID"/>
            </xsl:attribute>
        </end>
    </xsl:template>

    <xsl:template match="@*">
        <annotation gi="local-name()">{ . }</annotation>
    </xsl:template>

    <xsl:template match="text()">
        <text>
            <xsl:attribute name="cf" separator=" ">
                <xsl:apply-templates select="ancestor::*" mode="rID"/>
            </xsl:attribute>
            <xsl:text>{ string(.) => replace('\\','\\\\') => replace('\[','\\[') => replace('\{','\\{') }</xsl:text>
        </text>
    </xsl:template>

    <xsl:variable name="zeroPadded"
        select="count(//*) => string() => replace('\d', '0') => replace('0$', '1')"/>

    <xsl:template match="*" mode="rID" as="xs:string">
        <xsl:variable name="n">
            <xsl:number count="*" format="{ $zeroPadded }" level="any"/>
        </xsl:variable>
        <xsl:text>r{ $n }_{ local-name() }</xsl:text>
    </xsl:template>
</xsl:stylesheet>