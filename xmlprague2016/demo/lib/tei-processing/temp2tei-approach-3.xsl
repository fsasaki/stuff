<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs h tei ixsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0" xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT">
    <xsl:key name="para-pos" match="*[local-name() = 'p']" use="@id"/>
    <xsl:output method="text"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="//tei:body//tei:p">
        <p>
            <xsl:variable name="position">n<xsl:number level="any"/></xsl:variable>
            <xsl:for-each select="id('xyz1xyz', ixsl:page())/*[1]">
                <xsl:apply-templates select="id($position)/node()" mode="writeAnnotation"/>
            </xsl:for-each>
        </p>
    </xsl:template>
    <xsl:template match="span[@class[starts-with(., 'convert-')]]" mode="writeAnnotation">
        <xsl:element name="{substring-after(@class,'convert-')}">
            <xsl:if test="string-length(@title) > 0">
                <xsl:call-template name="writeAttrs">
                    <xsl:with-param name="attList" select="@title"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:apply-templates mode="writeAnnotation"/>
        </xsl:element>
    </xsl:template>
    <xsl:template mode="writeAnnotation" match="span[@its-ta-ident-ref]">
        <hi>
            <xsl:attribute name="n">
                <xsl:value-of select="@its-ta-ident-ref"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </hi>
    </xsl:template>
    <xsl:template name="writeAttrs">
        <xsl:param name="attList"/>
        <xsl:variable name="name"
            select="substring-before(substring-after($attList, '@@@delim@@@name:'), '@@@value:')"/>
        <xsl:variable name="value"
            select="substring-before(substring-after($attList, '@@@value:'), '@@@delim@@@')"/>
        <xsl:if test="($name)">
            <xsl:attribute name="{$name}">
                <xsl:value-of select="$value"/>
            </xsl:attribute>
            <xsl:variable name="rest">
                <xsl:value-of
                    select="substring($attList, string-length(concat('@@@delim@@@name:', $name, '@@@value:', $value)) + 1)"
                />
            </xsl:variable>
            <xsl:if test="$rest">
                <xsl:call-template name="writeAttrs">
                    <xsl:with-param name="attList" select="$rest"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
