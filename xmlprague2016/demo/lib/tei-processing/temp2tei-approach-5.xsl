<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs h tei ixsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT">
    <xsl:param name="rdfoutput" as="xs:string">tbd</xsl:param>
    <xsl:output method="xml"/>
    <xsl:template match="*|@*" mode="get-full-path">
        <xsl:apply-templates select="parent::*" mode="get-full-path"/>
        <xsl:text>/</xsl:text>
        <xsl:if test="count(. | ../@*) = count(../@*)">@</xsl:if>
        <xsl:value-of select="name()"/>
        <xsl:if test="self::element() and parent::element()">
            <xsl:text>[</xsl:text>
            <xsl:number/>
            <xsl:text>]</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:teiHeader/*[last()]">
        <xsl:copy-of select="."/>
        <xenoData>
            <xsl:text>[</xsl:text>
            <xsl:for-each select="//tei:hi[@vocab]">
                <xsl:variable name="fullPath"><xsl:apply-templates mode="get-full-path" select="self::*"/></xsl:variable>
                <xsl:variable name="id"><xsl:text>a</xsl:text><xsl:number level="any"/></xsl:variable>
                <xsl:text>&#xA;{ "id" : "http://example.com/myannotations/</xsl:text><xsl:value-of select="$id"/><xsl:text>",</xsl:text>
                <xsl:text>&#xA;"type": "Annotation", &#xA;"target": { &#xA;"type": "SpecificResource", &#xA;"source": "http://example.com/myfile.xml",  &#xA;"selector": { &#xA;"type": "FragmentSelector", &#xA;"conformsTo": "http://www.w3.org/TR/xpath/", &#xA;"value": "</xsl:text>
                <xsl:value-of select="$fullPath"/>
                <xsl:text>" }, &#xA;"itsrdf:taClassRef" : "</xsl:text>
                <xsl:value-of select="concat(@vocab,@typeof)"/>
                <xsl:text>", &#xA;"itsrdf:taIdentRef" : "</xsl:text>
                <xsl:value-of select="@resource"/>
                <xsl:text>"</xsl:text>
                <xsl:text>}}</xsl:text>
                <xsl:if test="not(position() = last())"> , </xsl:if>
            </xsl:for-each>
            <xsl:text>]</xsl:text>
        </xenoData>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:hi[@vocab]">
        <xsl:variable name="id"><xsl:text>a</xsl:text><xsl:number level="any"/></xsl:variable>
        <emphasis id="{$id}"><xsl:value-of select="."/></emphasis>
    </xsl:template>
</xsl:stylesheet>
