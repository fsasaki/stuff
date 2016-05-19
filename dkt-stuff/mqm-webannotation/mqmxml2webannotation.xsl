<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
    <xsl:output indent="yes" method="text"/>
    <xsl:template match="/">
        <xsl:text>{
    "@graph": [</xsl:text>
        <xsl:for-each select="//issue">
            <xsl:call-template name="processIssues"/>
        </xsl:for-each>
        <xsl:text>],
    "@context": {
        "hasTarget": {
            "@id": "http://www.w3.org/ns/oa#hasTarget",
            "@type": "@id"
        },
        "hasSelector": {
            "@id": "http://www.w3.org/ns/oa#hasSelector",
            "@type": "@id"
        },
        "string": {
            "@id": "http://www.w3.org/ns/oa#string",
            "@type": "http://www.w3.org/2001/XMLSchema#string"
        } ,
        "issueType": {
            "@id": "http://dkt.dfki.de/ontologies/nif#mqmIssueType",
            "@type": "http://www.w3.org/2001/XMLSchema#string"
        },
        "dktnif": "http://dkt.dfki.de/ontologies/nif#",
        "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
        "xsd": "http://www.w3.org/2001/XMLSchema#",
        "rdfs": "http://www.w3.org/2000/01/rdf-schema#"
    }
}</xsl:text>
    </xsl:template>
    <xsl:template name="processIssues">
        <xsl:text>{</xsl:text>
        "@id": "<xsl:value-of select="concat('_:a',position())"/>",
        "@type": "http://www.w3.org/ns/oa#Annotation",
        "hasTarget": "<xsl:value-of select="concat('_:t',position())"/>"
        <xsl:text>}</xsl:text>
        <xsl:text>, </xsl:text>
        
        <xsl:text>{</xsl:text>
        "@id": "<xsl:value-of select="concat('_:t',position())"/>",
        "hasSelector": "<xsl:value-of select="concat('_:s',position())"/>",
        "issueType" : "<xsl:value-of select="@type"/>",
        "http://www.w3.org/ns/oa#string": "<xsl:value-of select="."/>"
        <xsl:text>}</xsl:text>
        <xsl:text>, </xsl:text>
        <xsl:variable name="element-path"><xsl:apply-templates select="." mode="get-full-path"/></xsl:variable>
        <xsl:text>{</xsl:text>
        "@id": "<xsl:value-of select="concat('_:s',position())"/>",
        "type" : "XPathSelector",
        "value" : "<xsl:value-of select="$element-path"/>"
        <xsl:text>}</xsl:text>
        <xsl:if test="not(position()= last())">, </xsl:if>
    </xsl:template>
    <xsl:template match="*|@*" mode="get-full-path">
        <xsl:apply-templates select="parent::*" mode="get-full-path"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:if test="self::* and parent::*"><xsl:text>[</xsl:text><xsl:number/><xsl:text>]</xsl:text></xsl:if>
        <xsl:if test="not(child::*)"><!-- /text()--></xsl:if>
    </xsl:template>
</xsl:stylesheet>
