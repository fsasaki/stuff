<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs h ixsl sml xsi"
    xmlns:sml="http://www.stratml.net" version="2.0" xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns="http://www.stratml.net" xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT">
    <xsl:key name="para-pos" match="*[local-name() = 'p']" use="@id"/>
    <xsl:output method="xml"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node()| @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="replace(.,'&amp;','&amp;amp;')"/>
    </xsl:template>
    <xsl:template match="//sml:Description">
        <Description>
            <xsl:variable name="position">n<xsl:number level="any"/></xsl:variable>
            <xsl:for-each select="id('xyz1xyz', ixsl:page())/*[1]">
                <xsl:apply-templates select="id($position)/node()" mode="writeAnnotation"/>
            </xsl:for-each>
        </Description>
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
    <xsl:template mode="writeAnnotation" match="span[@its-ta-ident-ref or @its-ta-class-ref]">
        <xsl:variable name="countAnnotations"><xsl:number count="span[@its-ta-ident-ref or @its-ta-class-ref]" level="any"/></xsl:variable>
        <xsl:processing-instruction name="fa-start">
            <xsl:value-of select="concat('no=&quot;',$countAnnotations,'&quot;')"/>
            <xsl:for-each  select="@its-ta-ident-ref, @its-ta-class-ref">
            <xsl:value-of select="concat('&#160;',name(),'=&quot;',.,'&quot;')"/>
                <xsl:if test="not(last())">,</xsl:if>
                </xsl:for-each>
        </xsl:processing-instruction>
        <xsl:value-of select="." disable-output-escaping="no"/>
        <xsl:processing-instruction name="fa-end">
            <xsl:value-of select="concat('no=&quot;',$countAnnotations,'&quot;')"/>
        </xsl:processing-instruction>
    </xsl:template>
    <xsl:template match="text()" mode="writeAnnotation">
        <xsl:value-of select="." disable-output-escaping="no"/>
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
