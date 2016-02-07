<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs h tei ixsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT">
    <xsl:param name="rdfoutput" as="xs:string">tbd</xsl:param>
    <xsl:output method="xml"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:teiHeader/*[last()]">
        <xsl:copy-of select="."/>
        <xenoData>
            <xsl:value-of select="$rdfoutput"/>
        </xenoData>
    </xsl:template>
</xsl:stylesheet>
