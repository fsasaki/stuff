<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
    <xsl:param name="inputDocUri">de.csv</xsl:param>
    <xsl:output indent="yes"/>
    <xsl:template match="/">
        <xsl:variable name="inputDoc" select="unparsed-text($inputDocUri)"/>
        <annotations xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:noNamespaceSchemaLocation="http://qt21.eu/downloads/annotations.xsd"
            xmlns:xs="http://www.w3.org/2001/XMLSchema">
            <xsl:for-each select="tokenize($inputDoc, '\n')">
                <xsl:variable name="line" select="."/>
                <xsl:variable name="linePos" select="position()"/>
                <xsl:if test="position() &gt; 1 and not(position() = last())">
                    <annotGrp source="qtleap">
                        <xsl:variable name="lineDelim"
                            select="replace($line, '&quot;,&quot;', '###delim###')"/>
                        <xsl:variable name="items" select="tokenize($lineDelim, '###delim###')"/>
                        <xsl:for-each select="$items">
                            <xsl:variable name="item" select="."/>
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="concat('i_', substring($item, 2))"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="original_id">
                                        <xsl:value-of select="substring($item, 2)"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:when test="position() = 2">
                                    <src xml:lang="en">
                                        <xsl:value-of select="."/>
                                    </src>
                                </xsl:when>
                                <xsl:when test="position() = 3">
                                    <targets xml:lang="de">
                                        <target row_number="{$linePos - 1}" engine="null">
                                            <targetSeg>
                                                <xsl:value-of select="."/>
                                            </targetSeg>
                                            <annotatedTargets>
                                                <annotatedTarget annotator="A">
                                                  <xsl:call-template name="replaceThing">
                                                  <xsl:with-param name="string" select="$items[4]"/>
                                                  </xsl:call-template>
                                                </annotatedTarget>
                                                <annotatedTarget annotator="B">
                                                  <xsl:call-template name="replaceThing">
                                                  <xsl:with-param name="string" select="$items[5]"/>
                                                  </xsl:call-template>
                                                </annotatedTarget>
                                            </annotatedTargets>
                                        </target>
                                    </targets>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </annotGrp>
                </xsl:if>
            </xsl:for-each>
        </annotations>
    </xsl:template>
    <xsl:template name="replaceThing">
        <xsl:param name="string"/>
        <xsl:variable name="annotation" select="$string"/>
        <xsl:variable name="annotationReplace1"
            select="replace($annotation, '&quot;&quot;&quot;&quot;', '#qqq#')"/>
        <xsl:variable name="annotationReplace2"
            select="replace($annotationReplace1, '&quot;&quot;', '&quot;')"/>
        <xsl:variable name="annotationReplace3"
            select="replace($annotationReplace2, '&amp;', '&amp;amp;')"/>
        <xsl:variable name="annotationReplace4"
            select="replace($annotationReplace3, '#qqq#', '&quot;&quot;')"/>
        <xsl:variable name="annotationReplace5"
            select="replace($annotationReplace4, '&lt; ', '&amp;lt; ')"/>
        <xsl:variable name="annotationReplace6"
            select="replace($annotationReplace5, 'mqm:issue', 'issue')"/>
        <xsl:variable name="annotationReplace7"
            select="replace($annotationReplace6, 'xml:id', 'id')"/>
        <xsl:variable name="annotationReplace8"
            select="replace($annotationReplace7, 'note=&quot;&quot;', '')"/>
        <xsl:variable name="annotationReplace9"
            select="replace($annotationReplace8, 'severity=&quot;(.*?)&quot;', '')"/>
        <xsl:variable name="annotationReplace10"
            select="replace($annotationReplace9, 'agent=&quot;(.*?)&quot;', '')"/>
        <xsl:variable name="annotationReplace11"
            select="replace($annotationReplace10, 'note=&quot;(.*?)&quot;', '')"/>
        <xsl:value-of select="$annotationReplace11" disable-output-escaping="yes"/>
    </xsl:template>
</xsl:stylesheet>
