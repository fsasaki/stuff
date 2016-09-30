<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:h="http://www.w3.org/1999/xhtml">
    <xsl:import href="verbatim.xsl"/>
    <xsl:import href="parse.xsl"/>
    <xsl:import href="writeChart.xsl"/>
    <xsl:import href="expandParse.xsl"/>
    <xsl:output indent="yes" exclude-result-prefixes="h" method="html"/>
    <xsl:variable name="inputItems">
        <inputItems>
            <grammarInput>
                <xsl:for-each select="tokenize(/inputItems/grammarInput, '\n\r?')">
                    <xsl:if test="matches(., '\S+')"><xsl:text>&#xA;</xsl:text><xsl:value-of select="."/></xsl:if>
                </xsl:for-each>
            </grammarInput>
            <lexiconInput>
                <xsl:for-each select="tokenize(/inputItems/lexiconInput, '\n\r?')">
                    <xsl:if test="matches(., '\S+')"><xsl:text>&#xA;</xsl:text><xsl:value-of select="."/></xsl:if>
                </xsl:for-each>
            </lexiconInput>
            <inputString>
            <xsl:value-of select="/inputItems/inputString"/>
            </inputString>
        </inputItems>
    </xsl:variable>
    <xsl:variable name="lexiconAsXml">
        <lexikonAsXml>
            <xsl:for-each select="tokenize($inputItems/inputItems/lexiconInput, '\n\r?')">
                <xsl:if test="matches(., '\S')">
                    <t type="{replace(substring-before(.,':'),'\s+','')}">
                        <xsl:value-of select="replace(substring-after(., ':'), '\s+', '')"/>
                    </t>
                </xsl:if>
            </xsl:for-each>
        </lexikonAsXml>
    </xsl:variable>
    <xsl:variable name="lexicon" select="$lexiconAsXml//t"/>
    <xsl:variable name="grammar">
        <grammar>
            <xsl:for-each select="tokenize($inputItems/inputItems/grammarInput, '\n\r?')">
                <xsl:if test="matches(., '\S')">
                    <xsl:variable name="lhs" select="replace(substring-before(., '=>'), '\s+', '')"/>
                    <xsl:variable name="rhs" select="replace(substring-after(., '=>'), '\s+', '')"/>
                    <rule no="{position()-1}">
                        <lhs>
                            <nt>
                                <xsl:value-of select="$lhs"/>
                            </nt>
                        </lhs>
                        <rhs>
                            <xsl:for-each select="tokenize($rhs, ',')">
                                <xsl:choose>
                                    <xsl:when test="ends-with(., 't')">
                                        <t>
                                            <xsl:value-of select="replace(.,'(.*)t$','$1')"
                                            />
                                        </t>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <nt>
                                            <xsl:value-of select="."/>
                                        </nt>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </rhs>
                    </rule>
                </xsl:if>
            </xsl:for-each>
        </grammar>
    </xsl:variable>
    <xsl:template match="/">
        <div class="input output">
            <div class="string">
            <xsl:variable name="inputTokens"
                select="tokenize($inputItems/inputItems/inputString, '\s+')"/>
            <p>Input String:</p>
            <table>
                <tr>
                    <th>Position:</th>
                    <xsl:for-each select="$inputTokens">
                        <td>
                            <xsl:value-of select="position() - 1"/>
                        </td>
                        <td/>
                    </xsl:for-each>
                    <td>
                        <xsl:value-of select="count($inputTokens)"/>
                    </td>
                </tr>
                <tr>
                    <th>Tokens:</th>
                    <xsl:for-each select="$inputTokens">
                        <td/>
                        <td>
                            <xsl:value-of select="."/>
                        </td>
                    </xsl:for-each>
                    <td/>
                </tr>
                <!--       <tr><th>Token</th><xsl:for-each select="$inputTokens"><td colspan="3"><xsl:value-of select="."/></td></xsl:for-each></tr>-->
            </table>
            </div>
            <div class="grammar">
                <p>Grammar used: </p>
                <ul>
                    <xsl:apply-templates select="$grammar//rule"/>
                </ul>
            </div>
            <div class="lexicon">
                <p>Lexicon entries:</p>
                <ul>
                    <xsl:for-each select="$lexiconAsXml//t">
                        <li>Terminal <xsl:value-of select="."/> (Type <xsl:value-of select="@type"
                        />)<xsl:if test="not(position() = last())">,</xsl:if></li>
                    </xsl:for-each>
                </ul>
            </div>
        </div>
        <div class="parsingoutput">
            <xsl:variable name="parsingTable">
                <xsl:call-template name="main"/>
            </xsl:variable>
            <xsl:variable name="parseChart">
                <xsl:call-template name="main"/>
            </xsl:variable>
            <table>
                <tr>
                    <td valign="top">
                        <h2 id="chart">Chart</h2>
                        <p>Move over cells to get additional information.</p>
                        <xsl:call-template name="writeChart">
                            <xsl:with-param name="parseChart" select="$parseChart"/>
                        </xsl:call-template>
                    </td>
                    <td valign="top">
                        <h2 id="parse-tree">Parse tree(s) (if parse was successful)</h2>
                        <xsl:variable name="expandParse">
                            <xsl:call-template name="expandParse">
                                <xsl:with-param name="chart" select="$parseChart"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:for-each select="$expandParse/parseResults/*">
                            <hr/>
                            <pre>
                            <xsl:apply-templates mode="verbatim" select="self::*"/>
                            </pre>
                            <hr/>
                        </xsl:for-each>
                    </td>
                </tr>
            </table>
            <hr/>
        </div>
    </xsl:template>
    <xsl:template match="rule">
        <li>Rule no. <xsl:value-of select="concat(@no, ': ', lhs, ' => ')"/><xsl:for-each
                select="rhs/*"><xsl:choose><xsl:when test="name() = 'empty'"
                            >∅</xsl:when><xsl:otherwise><xsl:value-of select="."
                    /></xsl:otherwise></xsl:choose>
                <xsl:if test="position() &lt; last()">, </xsl:if></xsl:for-each></li>
    </xsl:template>
</xsl:stylesheet>
