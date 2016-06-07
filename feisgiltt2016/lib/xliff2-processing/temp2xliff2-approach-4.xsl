<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs h xlf ixsl"
    xmlns:xlf="urn:oasis:names:tc:xliff:document:2.0" version="2.0" xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns="urn:oasis:names:tc:xliff:document:2.0" xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT">
    <xsl:param name="rdfoutput" as="xs:string">tbd</xsl:param>
    <xsl:output method="xml"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node()| @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xlf:file">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <notes>
            <note>
                <xsl:value-of select="$rdfoutput"/>
            </note>
            </notes>
            <xsl:copy-of select="./node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
