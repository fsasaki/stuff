<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs my" version="2.0"
    xmlns:my="example.com/my" xml:space="default" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output indent="no"/>
    <xsl:template name="writeChart">
        <xsl:param name="parseChart"/>
        <table border="1">
            <tr>
                <th>Row number</th>
                <th>Hypotheses</th>
                <th>Constituents</th>
            </tr>
            <xsl:variable name="rowNumbers"
                select="max((count($parseChart//chart/constituents/constituent), count($parseChart/chart/hypotheses/hypothesis)))"/>
            <xsl:for-each select="for $ i in (1 to $rowNumbers) return $i">
                <xsl:variable name="currentRow" select="."/>
                <xsl:variable name="currentHypothesis"
                    select="$parseChart/chart/hypotheses/hypothesis[@row=$currentRow]"/>
                <xsl:variable name="currentConstituent"
                select="$parseChart//chart/constituents/constituent[@row=$currentRow]"/>
                <tr>
                    <td><xsl:value-of select="$currentRow"/>.</td>
                    <xsl:choose>
                        <xsl:when test="not($currentHypothesis)">
                            <td>-</td>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="hypothesisInfo">
                                <xsl:for-each select="$currentHypothesis">
                                    <xsl:apply-templates select="@when"/>
                                </xsl:for-each>
                            </xsl:variable>
                            <td title="{normalize-space($hypothesisInfo)}">
                                <xsl:text>&lt;</xsl:text>
                                <xsl:for-each select="$currentHypothesis">
                                    <xsl:apply-templates/>
                                </xsl:for-each>
                            </td>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="not($currentConstituent)">
                            <td>-</td>
                        </xsl:when>
                        <xsl:otherwise>
                            <td>
                                <xsl:attribute name="title">
                                    <xsl:choose>
                                        <xsl:when test="$currentConstituent/@rowNumberHypothesis"
                                            >Generated via combination of hypothesis with a constituent. Hypothesis used: <xsl:value-of
                                                select="$currentConstituent/@rowNumberHypothesis"
                                            />. Constituent used: <xsl:value-of select="$currentConstituent//constRef[last()]/@row"/>.</xsl:when>
                                        <xsl:otherwise>Generated via lexicon lookup.</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:text>&lt;</xsl:text>
                                <xsl:apply-templates select="$currentConstituent"/>
                            </td>
                        </xsl:otherwise>
                    </xsl:choose>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>
    <xsl:template match="@when[.='derivedFromGrammar']">Generation via grammar. Grammar rule: <xsl:value-of select="../@no"/>.</xsl:template>
    <xsl:template match="@when[.='inital']">Generation via initialization.</xsl:template>
    <xsl:template match="@when[.='combinationCase1']">Generation via combination of hypothesis with a constituent. Hypothesis used: <xsl:value-of select="../@hypothesisUsed"/>. Constituent used: <xsl:value-of select="../@constituentUsed"/></xsl:template>
    <xsl:template match="i">
        <xsl:value-of select="."/>
        <xsl:text>, </xsl:text>
    </xsl:template>
    <xsl:template match="j">
        <xsl:value-of select="."/>
        <xsl:text>, [ </xsl:text>
    </xsl:template>
    <xsl:template match="current">
        <xsl:text>$ </xsl:text>
    </xsl:template>
    <xsl:template match="constRef">
        <xsl:text>KON(</xsl:text>
        <xsl:value-of select="@row"/>
        <xsl:text>) </xsl:text>
        <xsl:if test="not(self::*/following-sibling::*)">
            <xsl:text>]</xsl:text>
            <small>
                <xsl:value-of select="../@nt"/>
            </small>
            <xsl:text>&gt;</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="t|nt">
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
        <xsl:if test="not(self::*/following-sibling::*)">
            <xsl:text>]</xsl:text>
            <small>
                <xsl:value-of select="../@nt"/>
            </small>
            <xsl:text>&gt;</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="token">
        <xsl:value-of select="."/>
        <xsl:text> ]</xsl:text>
        <small>
            <xsl:value-of select="../@t"/>
        </small>
        <xsl:text>&gt;</xsl:text>
    </xsl:template>
</xsl:stylesheet>