<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs h"
    xmlns:h="http://www.w3.org/1999/xhtml" version="2.0">
    <xsl:output indent="yes" method="html"/>
    <xsl:template match="/">
        <xsl:variable name="inputDoc" select="doc('https://www.w3.org/TR/2013/WD-mlw-metadata-us-impl-20130307/Overview.html')"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
        <html lang="en">
            <head>
                <title>Metadata for the Multilingual Web - Usage Scenarios and
                    Implementations</title>
                <script src="https://www.w3.org/Tools/respec/respec-w3c-common" async="" class="remove" type="text/javascript">
                </script>
                <script class="remove" type="text/javascript">
                    var respecConfig = {
                    // specification status (e.g. WD, LCWD, WG-NOTE, etc.). If in doubt use ED.
                    specStatus:           "IG-NOTE",
                    publishDate:  "2017-01-21",
                    previousPublishDate:  "2013-03-07",
                    previousMaturity:  "FPWD",
                    noRecTrack:           true,
                    shortName:            "mlw-metadata-us-impl",
                    copyrightStart:       "2017",
                    edDraftURI:           "http://w3c.github.io/mlw-metadata-us-impl/",
                    
                    // if this is a LCWD, uncomment and set the end of its review period
                    // lcEnd: "2009-08-05",
                    
                    // editors, add as many as you like
                    // only "name" is required
                    editors:  [
                    { name: "Christian Lieske", mailto: "christian.lieske@sap.com", company: "SAP SE" }
                    ],
                    wg:           "Internationalization Tag Set Interest Group",
                    wgURI:        "https://www.w3.org/International/its/ig/",
                    wgPublicList: "public-i18n-its-ig",
                    bugTracker: { new: "https://github.com/w3c/mlw-metadata-us-impl/issues", open: "https://github.com/w3c/mlw-metadata-us-impl/issues" } ,
                    otherLinks: [
                    {
                    key: "Github",
                    data: [
                    {
                    value: "repository",
                    href: "https://github.com/w3c/mlw-metadata-us-impl"
                    }
                    ]
                    }
                    ],
                    
                    // URI of the patent status for this WG, for Rec-track documents
                    // !!!! IMPORTANT !!!!
                    // This is important for Rec-track documents, do not copy a patent URI from a random
                    // document unless you know what you're doing. If in doubt ask your friendly neighbourhood
                    // Team Contact.
                    charterDisclosureURI:  "https://www.w3.org/International/its/ig/charter-2016",
                    // !!!! IMPORTANT !!!! MAKE THE ABOVE BLINK IN YOUR HEAD
                    };
                </script>
            </head>
            <body>
                <div id="abstract">
                    <xsl:apply-templates select="$inputDoc/h:html/h:body/h:div[h:h2/h:a[@id = 'abstract']]"/>
                </div>
                <div id="sotd">
                    <p>This document describes usage scenarios and related implementations for <a
                            href="http://www.w3.org/TR/its20/">Internationalization Tag Set (ITS)
                            2.0</a>. ITS 2.0 enhances the foundation to integrate both automated and
                        manual processing of human language into core Web technologies.</p>

                    <p>The work described in this document receives funding by the European
                        Commission (project <a
                            href="http://cordis.europa.eu/fp7/ict/language-technologies/project-multilingualweb-lt_en.html"
                            >MultilingualWeb-LT (LT-Web)</a> ) through the Seventh Framework
                        Programme (FP7) in the area of Language Technologies (Grant Agreement No.
                        287815).</p>
                </div>
                <xsl:apply-templates select="$inputDoc/h:html/h:body"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="h:h2[h:a[@name = 'status']]"/>
    <xsl:template match="node()[preceding-sibling::h:h2[h:a[@id = 'status']]]"/>
    <xsl:template match="h:body">
        <xsl:for-each-group
            select="/h:html/h:body/h:div[@class = 'toc']/following-sibling::h:a/following-sibling::*"
            group-starting-with="h:h1">
            <section id="{preceding-sibling::h:a[1]/@id}">
                <h2>
                    <xsl:value-of select="replace(., '\d', '')"/>
                </h2>
                <xsl:choose>
                    <xsl:when test="local-name(current-group()[2]) = 'p'">
                        <xsl:apply-templates select="current-group()[position() &gt; 1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each-group
                            select="current-group()/following-sibling::h:a/following-sibling::*"
                            group-starting-with="h:h2">
                            <section id="{preceding-sibling::h:a[1]/@id}">
                                <h2>
                                    <xsl:value-of select="replace(., '\d.', '')"/>
                                </h2>
                                <xsl:for-each-group select="current-group()"
                                    group-starting-with="h:h3">
                                    <xsl:if test="not(local-name()='h2')">
                                    <section id="{preceding-sibling::h:a[1]/@id}">
                                        <h2>
                                            <xsl:value-of select="replace(., '\d.\d+.\d', '')"/>
                                        </h2>
                                        <xsl:apply-templates select="current-group()[not(position()=last())]"/>
                                    </section>
                                    </xsl:if>
                                </xsl:for-each-group>
                            </section>
                        </xsl:for-each-group>
                    </xsl:otherwise>
                </xsl:choose>
            </section>
        </xsl:for-each-group>
    </xsl:template>
    <xsl:template match="h:a[@href]">
        <a href="{@href}">
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
    <xsl:template match="h:ul | h:li | h:p | h:i">
        <xsl:element name="{name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h:h1 | h:h2 | h:h3"/>
</xsl:stylesheet>
