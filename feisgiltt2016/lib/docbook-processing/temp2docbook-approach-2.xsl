<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:db="http://docbook.org/ns/docbook" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs h db ixsl" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.0"
    xmlns:h="http://www.w3.org/1999/xhtml" xmlns="http://docbook.org/ns/docbook"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT">
    <xsl:output method="xml" cdata-section-elements="programlisting db:programlisting"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="db:programlisting">
        <programlisting>
        <xsl:value-of select="."/>
            </programlisting>
    </xsl:template>
    <xsl:template match="db:para">
        <para>
            <xsl:variable name="position">n<xsl:number level="any"/></xsl:variable>
            <xsl:for-each select="id('xyz1xyz', ixsl:page())/*[1]">
                <xsl:apply-templates select="id($position)/node()" mode="writeAnnotation"/>
            </xsl:for-each>
        </para>
    </xsl:template>
    <xsl:template match="span[@class[starts-with(., 'convert-')]]" mode="writeAnnotation">
        <xsl:choose>
            <xsl:when test="@class = 'convert-code'">
                <code>
                    <xsl:value-of select="."/>
                </code>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{substring-after(@class,'convert-')}">
                    <xsl:if test="string-length(@title) > 0">
                        <xsl:call-template name="writeAttrs">
                            <xsl:with-param name="attList" select="@title"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:apply-templates mode="writeAnnotation"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template mode="writeAnnotation" match="span[@its-ta-ident-ref or @its-ta-class-ref]"
        priority="2">
        <emphasis>
<!--          <xsl:if test="@its-ta-ident-ref">
                <xsl:attribute name="xlink:href">
                    <xsl:value-of select="@its-ta-ident-ref"/>
                </xsl:attribute>
                <xsl:attribute name="url"><xsl:value-of select="@its-ta-ident-ref"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="not(@its-ta-ident-ref)">
                <xsl:attribute name="xlink:href">non</xsl:attribute>
                <xsl:attribute name="url"></xsl:attribute>
            </xsl:if>
            <xsl:if test="@its-ta-class-ref">
                <xsl:attribute name="xlink:role">
                    <xsl:value-of select="@its-ta-class-ref"/>
                </xsl:attribute>   </xsl:if> -->   
                <xsl:if test="@its-ta-class-ref='http://dbpedia.org/ontology/Person'">
                    <xsl:attribute name="vocab">http://schema.org/</xsl:attribute>
                    <xsl:attribute name="typeof">Person</xsl:attribute>
                    <xsl:attribute name="property">name</xsl:attribute>
                    <xsl:if test="@its-ta-ident-ref">
                        <xsl:attribute name="resource"><xsl:value-of select="@its-ta-ident-ref"/></xsl:attribute>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="@its-ta-class-ref='http://dbpedia.org/ontology/Place'">
                    <xsl:attribute name="vocab">http://schema.org/</xsl:attribute>
                    <xsl:attribute name="typeof">Place</xsl:attribute>
                    <xsl:attribute name="property">name</xsl:attribute>
                    <xsl:if test="@its-ta-ident-ref">
                        <xsl:attribute name="resource"><xsl:value-of select="@its-ta-ident-ref"/></xsl:attribute>
                    </xsl:if>
                </xsl:if>
            <xsl:if test="@its-ta-class-ref='http://www.w3.org/2002/07/owl#Thing'">
                <xsl:attribute name="vocab">http://schema.org/</xsl:attribute>
                <xsl:attribute name="typeof">Thing</xsl:attribute>
                <xsl:attribute name="property">name</xsl:attribute>
                <xsl:if test="@its-ta-ident-ref">
                    <xsl:attribute name="resource"><xsl:value-of select="@its-ta-ident-ref"/></xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:value-of select="."/>
        </emphasis>
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
