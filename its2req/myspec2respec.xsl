<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs h"
    xmlns:h="http://www.w3.org/1999/xhtml" version="2.0" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output indent="yes" method="html" encoding="UTF-8"/>
    <xsl:template match="/">
        <xsl:variable name="inputDoc" select="doc('https://www.w3.org/TR/2012/WD-its2req-20120524/Overview.html')"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
        <html lang="en">
            <head>
                <title>Requirements for Internationalization Tag Set (ITS) 2.0</title>
                <script src="https://www.w3.org/Tools/respec/respec-w3c-common" async="" class="remove" type="text/javascript">
                </script>
                <script class="remove" type="text/javascript">
                    var respecConfig = {
                    // specification status (e.g. WD, LCWD, WG-NOTE, etc.). If in doubt use ED.
                    specStatus:           "IG-NOTE",
                    publishDate:  "2017-01-21",
                    previousPublishDate:  "2012-05-24",
                    previousMaturity:  "FPWD",
                    noRecTrack:           true,
                    shortName:            "its2req",
                    copyrightStart:       "2017",
                    edDraftURI:           "http://w3c.github.io/its2req/",
                    
                    // if this is a LCWD, uncomment and set the end of its review period
                    // lcEnd: "2009-08-05",
                    
                    // editors, add as many as you like
                    // only "name" is required
                    editors:  [
                    { name: "Dave Lewis", mailto: "dave.lewis@cs.tcd.ie", company: "TCD" },
                    { name: "Arle Lommel", mailto: "arle@commonsenseadvisory.com", company: "Common Sense Advisory" },
                    { name: "Felix Sasaki", mailto: "fsasaki@w3.org", company: "DFKI / W3C Fellow" }
                    ],
                    wg:           "Internationalization Tag Set Interest Group",
                    wgURI:        "https://www.w3.org/International/its/ig/",
                    wgPublicList: "public-i18n-its-ig",
                    bugTracker: { new: "https://github.com/w3c/its2req/issues", open: "https://github.com/w3c/its2req/issues" } ,
                    otherLinks: [
                    {
                    key: "Github",
                    data: [
                    {
                    value: "repository",
                    href: "https://github.com/w3c/its2req"
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
                    <xsl:apply-templates
                        select="$inputDoc/h:html/h:body/h:div[h:h2/h:a[@id = 'abstract']]"/>
                </div>
                <div id="sotd">
                    <p>This document gathers metadata proposed within the <a
                            href="http://www.w3.org/International/multilingualweb/lt/"
                            >MultilingualWeb-LT Working Group</a> for the Internationalization Tag
                        Set Version 2.0 (ITS 2.0). The metadata targets web content (mainly HTML5)
                        and deep Web content, for example content stored in a content management
                        system (CMS) or XML files from which HTML pages are generated, that
                        facilitates its interaction with multilingual technologies and localization
                        processes. </p>

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
            select="/h:html/h:body/h:div[@class = 'toc']/h:table[@class = 'toc']/following-sibling::h:a/following-sibling::*"
            group-starting-with="h:h2">
            <section id="{preceding-sibling::h:a[1]/@id}">
                <h2>
                    <xsl:value-of select="replace(., '\d', '')"/>
                </h2>
                <xsl:for-each-group select="current-group()" group-starting-with="h:h3">
                    <xsl:if test="local-name() = 'h2'">
                        <xsl:apply-templates select="current-group()[not(position() = last())]"/>
                    </xsl:if>
                    <xsl:if test="not(local-name() = 'h2')">
                        <section id="{preceding-sibling::h:a[1]/@id}">
                            <h2>
                                <xsl:value-of select="replace(., '\d+.', '')"/>
                            </h2>
                            <xsl:for-each-group select="current-group()" group-starting-with="h:h4">
                                <xsl:if test="local-name() = 'h3'">
                                    <xsl:apply-templates
                                        select="current-group()[not(position() = last())]"/>
                                </xsl:if>
                                <xsl:if test="not(local-name() = 'h3')">
                                    <section id="{preceding-sibling::h:a[1]/@id}">
                                        <h2>
                                            <xsl:value-of select="replace(., '\d.\d+.\d+', '')"/>
                                        </h2>
                                        <xsl:apply-templates
                                            select="current-group()[not(position() = last())]"/>
                                    </section>
                                </xsl:if>
                            </xsl:for-each-group>
                        </section>
                    </xsl:if>
                </xsl:for-each-group>
            </section>
        </xsl:for-each-group>
    </xsl:template>
    <xsl:template
        match="h:ul | h:ol | h:li | h:p | h:i | h:dl | h:dd | h:dt | h:em | h:b | h:table | h:tr | h:td | h:span | h:br | h:th | h:pre | h:code">
        <xsl:element name="{name()}">
            <xsl:copy-of select="@*[not(name()='xml:space' or name()='clear')]"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="h:dl[not(child::*[position()= 1 and name()='dt'])]">
        <dl>
            <dt></dt>
            <xsl:apply-templates/>
        </dl>
    </xsl:template>
    <xsl:template match="h:a">
        <a>
            <xsl:copy-of select="@href | @id | @name | @class | @title | @rel"/>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="h:h1 | h:h2 | h:h3 | h:h4 | h:span[@class = 'mw-headline']"/>
</xsl:stylesheet>
