<?xml version="1.0" encoding="UTF-8"?>
<!--
    W3C® SOFTWARE NOTICE AND LICENSE
    http://www.w3.org/Consortium/Legal/2002/copyright-software-20021231

    This work (and included software, documentation such as READMEs, or other related items) is being provided by the copyright holders under the following license. By obtaining, using and/or copying this work, you (the licensee) agree that you have read, understood, and will comply with the following terms and conditions.

    Permission to copy, modify, and distribute this software and its documentation, with or without modification, for any purpose and without fee or royalty is hereby granted, provided that you include the following on ALL copies of the software and documentation or portions thereof, including modifications:

    1. The full text of this NOTICE in a location viewable to users of the redistributed or derivative work.
    2. Any pre-existing intellectual property disclaimers, notices, or terms and conditions. If none exist, the W3C Software Short Notice should be included (hypertext is preferred, text is permitted) within the body of any redistributed or derivative code.
    3. Notice of any changes or modifications to the files, including the date changes were made. (We recommend you provide URIs to the location from which the code is derived.)

    THIS SOFTWARE AND DOCUMENTATION IS PROVIDED "AS IS," AND COPYRIGHT HOLDERS MAKE NO REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO, WARRANTIES OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE OR THAT THE USE OF THE SOFTWARE OR DOCUMENTATION WILL NOT INFRINGE ANY THIRD PARTY PATENTS, COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS.

    COPYRIGHT HOLDERS WILL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF ANY USE OF THE SOFTWARE OR DOCUMENTATION.

    The name and trademarks of copyright holders may NOT be used in advertising or publicity pertaining to the software without specific, written prior permission. Title to copyright in this software and any associated documentation will at all times remain with copyright holders.

    ____________________________________

    This formulation of W3C's notice and license became active on December 31 2002. This version removes the copyright ownership notice such that this license can be used with materials other than those owned by the W3C, reflects that ERCIM is now a host of the W3C, includes references to this specific dated version of the license, and removes the ambiguous grant of "use". Otherwise, this version is the same as the previous version and is written so as to preserve the Free Software Foundation's assessment of GPL compatibility and OSI's certification under the Open Source Definition. Please see our Copyright FAQ for common questions about using materials from our site, including specific terms and conditions for packages like libwww, Amaya, and Jigsaw. Other questions about this notice can be directed to site-policy@w3.org.
    
  -->

<!-- Language Tag Analyzer (LTA) - version 0.3
     For documentation, see http://www.w3.org/2008/05/lta/
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
		xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/"
		xmlns:my="http://example.com/myns" xmlns:lta="http://www.w3.org/2008/05/lta/"
		xmlns="http://www.w3.org/1999/xhtml" xmlns:h="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="my saxon xs h lta">
  <xsl:include href="verbatim.xsl"/>
  <xsl:include href="abnf-check.xsl"/>
  <xsl:include href="constraint-check.xsl"/>
  <xsl:include href="html-output.xsl"/>
  <xsl:include href="rdf-output.xsl"/>
  <xsl:param name="input"/>
  <xsl:param name="inputlangtag" select="$input"/>
  <xsl:param name="output">html</xsl:param>
  <xsl:param name="langtag" select="lower-case($inputlangtag)"/>
  <xsl:param name="hl">en</xsl:param>
  <xsl:output indent="yes" method="xhtml" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
	      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" name="xhtmloutput"
	      encoding="UTF-8"/>
  <xsl:output indent="yes" method="xml" name="xmloutput" encoding="UTF-8" exclude-result-prefixes="xsi" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   media-type="text/plain"/>
  <xsl:output indent="yes" encoding="UTF-8" method="text" name="rdf" media-type="text/plain"/>
  <!-- The file with localized messages for HTML output -->
  <xsl:variable name="messages" select="doc('messages.xml')/lta:messages/lta:message"/>
  <xsl:template match="/">    
    <!-- Step 1: check wellformed-ness -->
    <xsl:variable name="abnfCheckedLangtag">
      <xsl:call-template name="abnf-check">
	<xsl:with-param name="inputlangtag" select="$inputlangtag"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- Step 2: check registry and other constraints on wellformed language tag -->
    <xsl:variable name="constrainedCheckedLanguagetag">
          <xsl:apply-templates select="$abnfCheckedLangtag" mode="someConstraintsCheck">
            <xsl:with-param name="abnfCheckedLangtag" select="$abnfCheckedLangtag"/>
          </xsl:apply-templates>
    </xsl:variable>
    <!-- Step 3: choose output format: HTML, XML or RDF -->
    <xsl:choose>
      <xsl:when test="$output='xml'">
          <xsl:copy-of select="$constrainedCheckedLanguagetag"/>
      </xsl:when>
      <xsl:when test="$output='rdf'">
          <xsl:apply-templates select="$constrainedCheckedLanguagetag" mode="rdf"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:call-template name="html-output">
          <xsl:with-param name="constrainedCheckedLanguagetag" select="$constrainedCheckedLanguagetag" />
          </xsl:call-template>
	</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
