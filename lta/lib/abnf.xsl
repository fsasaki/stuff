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

<!-- Language Tag Analyzer (LTA) - version 0.2. abnf.xsl
     For documentation, see http://www.w3.org/2008/05/lta/
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
		xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/"
		xmlns:my="http://example.com/myns" xmlns:lta="http://www.w3.org/2008/05/lta/"
		xmlns="http://www.w3.org/1999/xhtml" xmlns:h="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="my saxon xs h lta">
  <!-- The ABNF from the revision of RFC 4646 - to be updated! -->
  <xsl:variable name="ALPHA" select="'([a-z]|[A-Z])'"/>
  <xsl:variable name="DIGIT" select="'(\d)'"/>
  <xsl:variable name="alphanum" select="concat('(',$ALPHA,'|',$DIGIT,')')"/>
  <xsl:variable name="privateuse" select="concat('x(-',$alphanum,'{1,8})+')"/>
   <xsl:variable name="irregular"
    select="lower-case('((en-GB-oed)|(i-ami)|(i-bnn)|(i-default)|(i-enochian)|(i-hak)
		|(i-klingon)|(i-lux)|(i-mingo)|(i-navajo)|(i-pwn)|(i-tao)|(i-tay)|(i-tsu)|(sgn-BE-FR)|(sgn-BE-NL)|(sgn-CH-DE))')"/>
  <xsl:variable name="regular"
    select="lower-case('((art-lojban)|(cel-gaulish)|(no-bok)|(no-nyn)|(zh-guoyu)|(zh-hakka)|(zh-min)|(zh-min-nan)|(zh-xiang))')"/>
  <xsl:variable name="languageShortestIso639" select="concat($ALPHA,'{2,3}')"/>
  <xsl:variable name="extlang1" select="concat($ALPHA,'{3}')"/>
  <xsl:variable name="extlang2" select="concat($ALPHA,'{3}-',$ALPHA,'{3}')"/>
  <xsl:variable name="extlang3" select="concat($ALPHA,'{3}-',$ALPHA,'{3}-',$ALPHA,'{3}')"/>
  <xsl:variable name="reservedForFutureUse" select="concat($ALPHA,'{4}')"/>
  <xsl:variable name="registeredLanguageSubtag" select="concat($ALPHA,'{5,8}')"/>
  <xsl:variable name="script" select="concat($ALPHA,'{4}')"/>
  <xsl:variable name="regionIso3166-1Code" select="concat($ALPHA,'{2}')"/>
  <xsl:variable name="regionUnM49Code" select="concat($DIGIT,'{3}')"/>
  <xsl:variable name="variantType1" select="concat($alphanum,'{5,8}')"/>
  <xsl:variable name="variantType2" select="concat($DIGIT,'(',$alphanum,'){3}')"/>
  <xsl:variable name="singleton" select="'[a-w]|[y-z]|[A-W]|[Y-Z]|[0-9]'"/>
  <xsl:variable name="extension" select="concat('(',$singleton,'(-',$alphanum,'{2,8})+)+')"/>
  <!-- Function to construct subtag test. Input is a regex from the ABNF and the actual subtag (or complete tag in case of privateuse and irregular) to be tested. -->
  <xsl:function name="my:constructTest">
    <xsl:param name="regex"/>
    <xsl:param name="subtag"/>
    <xsl:variable name="part1">matches('</xsl:variable> 
    <xsl:variable name="part2">','^</xsl:variable>
    <xsl:variable name="part3">$')</xsl:variable>
    <xsl:value-of select="concat($part1,$subtag,$part2,$regex,$part3)"/>
  </xsl:function>
  <!-- Function to get a subtag, used not for irregular or privateuse tags -->
  <xsl:function name="my:getSubtag">
    <xsl:param name="restTag"/>
    <xsl:choose>
      <xsl:when test="contains($restTag,'-')">
        <xsl:value-of select="substring-before($restTag,'-')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$restTag"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>
