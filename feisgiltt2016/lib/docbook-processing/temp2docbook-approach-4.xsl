<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:db="http://docbook.org/ns/docbook" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs h db ixsl" xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0"
    xmlns:h="http://www.w3.org/1999/xhtml" xmlns="http://docbook.org/ns/docbook" 
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT">
    <xsl:param name="rdfoutput" as="xs:string">tbd</xsl:param>
    <xsl:output method="xml" cdata-section-elements="programlisting db:programlisting"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/db:article/db:info/db:title">
        <title><xsl:value-of select="."/></title>
        <annotation>
            <programlisting>
                <xsl:value-of select="$rdfoutput"/>
            </programlisting>
        </annotation>
    </xsl:template>
</xsl:stylesheet>
