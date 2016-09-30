<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs my" version="2.0"
    xmlns:my="example.com/my" >
    <xsl:function name="my:expand">
        <xsl:param name="struct"/>
        <xsl:param name="chart"/>
        <xsl:if test="$struct/@nt">
            <xsl:element name="{$struct/@nt}">
                <xsl:for-each select="$struct/constRef">
                    <xsl:variable name="constRef" select="."/>
                    <xsl:variable name="nestedConst" 
                        select="$chart/chart/constituents/constituent[@row=$constRef/@row]"/>
                    <xsl:copy-of select="my:expand($nestedConst/struct,$chart)"/>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
        <xsl:if test="$struct/@t">
            <xsl:element name="{$struct/@t}">
                <xsl:value-of select="$struct"/>
            </xsl:element>
        </xsl:if>
    </xsl:function>
    <xsl:template match="/" name="expandParse">
        <xsl:param name="chart"/>
        <parseResults>
            <xsl:variable name="length" select="count(tokenize($inputItems/inputItems/inputString,'\s+'))"/>
            <xsl:for-each
                select="$chart/chart/constituents/constituent[i=0 and j=$length]">
                <xsl:copy-of select="my:expand(./struct,$chart)"/>
            </xsl:for-each>
        </parseResults>
    </xsl:template>
</xsl:stylesheet>
