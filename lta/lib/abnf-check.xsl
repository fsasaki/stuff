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

<!-- Language Tag Analyzer (LTA) - version 0.2. abnf-check.xsl
     For documentation, see http://www.w3.org/2008/05/lta/
-->
<!DOCTYPE xsl:stylesheet [<!ENTITY rfc4646bis "http://tools.ietf.org/html/draft-ietf-ltru-4646bis-23#">]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
		xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/"
		xmlns:my="http://example.com/myns" xmlns:lta="http://www.w3.org/2008/05/lta/"
		xmlns="http://www.w3.org/1999/xhtml" xmlns:h="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="my saxon xs h lta">
  <xsl:include href="abnf.xsl"/>
  <xsl:template name="abnf-check">
    <xsl:param name="inputlangtag"/>
    <!-- check wellformed-ness -->
    <lta:Language-Tag input="{$inputlangtag}">
      <xsl:message>irregular: <xsl:value-of select="my:constructTest($irregular,$langtag)"/></xsl:message>
      <xsl:message>regular: <xsl:value-of select="my:constructTest($regular,$langtag)"/></xsl:message>
      <xsl:message>private use: <xsl:value-of select="my:constructTest($privateuse,$langtag)"/></xsl:message>
      <xsl:message>registered language sub tag: <xsl:value-of select="my:constructTest($registeredLanguageSubtag,$langtag)"/></xsl:message>
      <xsl:message>reserved for future use: <xsl:value-of select="my:constructTest($reservedForFutureUse,$langtag)"/></xsl:message>
      <xsl:message>language shortest ISO 639: <xsl:value-of select="my:constructTest($languageShortestIso639,$langtag)"/></xsl:message>
      <xsl:message>region iso 3166 code: <xsl:value-of select="(my:constructTest($regionIso3166-1Code,$langtag))"/></xsl:message>
      <xsl:message>region unm 49: <xsl:value-of select="my:constructTest($regionUnM49Code,$langtag)"/></xsl:message>
      <xsl:message>variant type 1: <xsl:value-of select="my:constructTest($variantType1,$langtag)"/></xsl:message>
      <xsl:message>variant type 2: <xsl:value-of select="my:constructTest($variantType2,$langtag)"/></xsl:message>
      <xsl:message>script: <xsl:value-of select="my:constructTest($script,$langtag)"/></xsl:message>
      <xsl:choose>
        <!-- Testing irregular tags -->
        <xsl:when test="matches($langtag,'^((en-gb-oed)|(i-ami)|(i-bnn)|(i-default)|(i-enochian)|(i-hak)   |(i-klingon)|(i-lux)|(i-mingo)|(i-navajo)|(i-pwn)|(i-tao)|(i-tay)|(i-tsu)|(sgn-be-fr)|(sgn-be-nl)|(sgn-ch-de))$')">
          <lta:irregular>
            <xsl:value-of select="$langtag"/>
          </lta:irregular>
        </xsl:when>
        <!-- Testing regular tags -->        
        <xsl:when test="matches($langtag,'^((art-lojban)|(cel-gaulish)|(no-bok)|(no-nyn)|(zh-guoyu)|(zh-hakka)|(zh-min)|(zh-min-nan)|(zh-xiang))$')">
          <lta:regular>
            <xsl:value-of select="$langtag"/>
          </lta:regular>
        </xsl:when>
        <!-- Testing privateuse tags -->
        <xsl:when test="matches($langtag,'^x(-(([a-z]|[A-Z])|(\d)){1,8})+$')">
          <lta:privateuse>
            <xsl:value-of select="$langtag"/>
          </lta:privateuse>
        </xsl:when>
        <xsl:otherwise>
          <!-- Call test of language sub tag -->
          <xsl:call-template name="languageTest">
            <xsl:with-param name="restTag" select="$langtag"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </lta:Language-Tag>
  </xsl:template>
  <!-- Template for test of language sub tag -->
  <xsl:template name="languageTest">
    <xsl:param name="restTag"/>
    <xsl:variable name="subTag" select="my:getSubtag($restTag)"/>
    <xsl:variable name="newRestTag" select="substring-after($restTag,concat($subTag,'-'))"/>
    <!-- Testing registered language subtag -->
    <xsl:choose>
      <xsl:when test="matches($subTag,'^([a-z]|[A-Z]){5,8}$')">
        <lta:language type="registered language subtag">
          <xsl:value-of select="$subTag"/>
        </lta:language>
	<xsl:choose>
	  <xsl:when test="substring-after($restTag,$subTag)='-'">
	    <lta:error type="e001"><lta:errorText>Not wellformed.</lta:errorText><lta:errorAddInfo><lta:restTag>-</lta:restTag><lta:potentialSubTags><lta:link target="&rfc4646bis;section-2.2.2">extlang</lta:link><lta:link target="&rfc4646bis;section-2.2.3">script</lta:link><lta:link target="&rfc4646bis;section-2.2.4">region</lta:link><lta:link target="&rfc4646bis;section-2.2.5">variant</lta:link><lta:link target="&rfc4646bis;section-2.2.6">extension</lta:link><lta:link target="&rfc4646bis;section-2.2.7">private use</lta:link> </lta:potentialSubTags><lta:link target="&rfc4646bis;ABNF">ABNF</lta:link><lta:link target="&rfc4646bis;well-formed"></lta:link></lta:errorAddInfo></lta:error>
	  </xsl:when>
          <xsl:when test="$newRestTag!=''">
            <xsl:call-template name="scriptTest">
              <xsl:with-param name="restTag" select="$newRestTag"/>
            </xsl:call-template>
          </xsl:when>
	</xsl:choose>
      </xsl:when>
      <!-- Testing reserved for future use -->      
      <xsl:when test="matches($subTag,'^([a-z]|[A-Z]){4}$')">
        <lta:language type="reserved for future use">
          <xsl:value-of select="$subTag"/>
        </lta:language>
	<xsl:choose>
	  <xsl:when test="substring-after($restTag,$subTag)='-'">
	    <lta:error type="e001"><lta:errorText>Not wellformed.</lta:errorText><lta:errorAddInfo><lta:restTag>-</lta:restTag><lta:potentialSubTags><lta:link target="&rfc4646bis;section-2.2.2">extlang</lta:link><lta:link target="&rfc4646bis;section-2.2.3">script</lta:link><lta:link target="&rfc4646bis;section-2.2.4">region</lta:link><lta:link target="&rfc4646bis;section-2.2.5">variant</lta:link><lta:link target="&rfc4646bis;section-2.2.6">extension</lta:link><lta:link target="&rfc4646bis;section-2.2.7">private use</lta:link> </lta:potentialSubTags><lta:link target="&rfc4646bis;ABNF">ABNF</lta:link><lta:link target="&rfc4646bis;well-formed"></lta:link></lta:errorAddInfo></lta:error>
	  </xsl:when>
          <xsl:when test="$newRestTag!=''">
            <xsl:call-template name="scriptTest">
              <xsl:with-param name="restTag" select="$newRestTag"/>
            </xsl:call-template>
          </xsl:when>
	</xsl:choose>
      </xsl:when>
      <!--  Testing language shortest ISO 639 code  -->      
      <xsl:when test="matches($subTag,'^([a-z]|[A-Z]){2,3}$')">
        <lta:language type="shortest ISO 639 code">
          <xsl:value-of select="$subTag"/>
	</lta:language>
	<xsl:choose>
	  <xsl:when test="substring-after($restTag,$subTag)='-'">
	    <lta:error type="e001"><lta:errorText>Not wellformed.</lta:errorText><lta:errorAddInfo><lta:restTag>-</lta:restTag><lta:potentialSubTags><lta:link target="&rfc4646bis;section-2.2.2">extlang</lta:link><lta:link target="&rfc4646bis;section-2.2.3">script</lta:link><lta:link target="&rfc4646bis;section-2.2.4">region</lta:link><lta:link target="&rfc4646bis;section-2.2.5">variant</lta:link><lta:link target="&rfc4646bis;section-2.2.6">extension</lta:link><lta:link target="&rfc4646bis;section-2.2.7">private use</lta:link> </lta:potentialSubTags><lta:link target="&rfc4646bis;ABNF">ABNF</lta:link><lta:link target="&rfc4646bis;well-formed"></lta:link></lta:errorAddInfo></lta:error>
	  </xsl:when>
          <xsl:when test="$newRestTag!=''">
            <xsl:call-template name="extlangTest">
              <xsl:with-param name="restTag" select="$newRestTag"/>
            </xsl:call-template>  
	  </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <lta:error type="e001"><lta:errorText>Not wellformed.</lta:errorText><lta:errorAddInfo><lta:restTag><xsl:value-of select="$restTag"/></lta:restTag><lta:potentialSubTags><lta:link target="&rfc4646bis;section-2.2.1">primary language</lta:link><lta:link target="&rfc4646bis;section-2.2.7">private use</lta:link> <lta:link target="&rfc4646bis;section-2.2.8">regular</lta:link> <lta:link target="&rfc4646bis;section-2.2.8">irregular</lta:link></lta:potentialSubTags></lta:errorAddInfo></lta:error>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="extlangTest">
    <xsl:param name="restTag"/>
    <!-- 1) check for extlang = 3ALPHA *2("-" 3ALPHA), 1)a) create @extlang="." and remove it (if present), apply script template with new rest ..., 2) apply script template with old rest. -->
    <xsl:choose>
      <xsl:when test="matches($restTag,concat('^',$extlang1,'$')) or matches($restTag,concat('^',$extlang1,'-.*'))">
	<xsl:variable name="extlangValue">
	  <xsl:choose>
	    <xsl:when test="matches($restTag,concat('^',$extlang3,'$')) or matches($restTag,concat('^',$extlang3,'-.*'))">
	      <xsl:value-of select="substring($restTag,1,11)"/>
	    </xsl:when>
	    <xsl:when test="matches($restTag,concat('^',$extlang2,'$')) or matches($restTag,concat('^',$extlang2,'-.*'))">
	      <xsl:value-of select="substring($restTag,1,7)"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="substring($restTag,1,3)"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:element name="lta:extlang">
	  <xsl:value-of select="$extlangValue"/>
	</xsl:element>
	<xsl:variable name="newRestTag" select="substring-after($restTag,concat($extlangValue,'-'))"/>
	<xsl:choose>
	  <xsl:when test="substring-after($restTag,$extlangValue)='-'">	    
	    <lta:error type="e001"><lta:errorText>Not wellformed.</lta:errorText><lta:errorAddInfo><lta:restTag>-</lta:restTag><lta:potentialSubTags><lta:link target="&rfc4646bis;section-2.2.3">script</lta:link><lta:link target="&rfc4646bis;section-2.2.4">region</lta:link><lta:link target="&rfc4646bis;section-2.2.5">variant</lta:link><lta:link target="&rfc4646bis;section-2.2.6">extension</lta:link><lta:link target="&rfc4646bis;section-2.2.7">private use</lta:link> </lta:potentialSubTags><lta:link target="&rfc4646bis;ABNF">ABNF</lta:link><lta:link target="&rfc4646bis;well-formed"></lta:link></lta:errorAddInfo></lta:error>
	  </xsl:when>
          <xsl:when test="$newRestTag!=''">
	    <xsl:call-template name="scriptTest">
              <xsl:with-param name="restTag" select="$newRestTag"/>
	    </xsl:call-template>       
	  </xsl:when>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="scriptTest">
          <xsl:with-param name="restTag" select="$restTag"/>
	</xsl:call-template>       
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="scriptTest">
    <xsl:param name="restTag"/>
    <xsl:variable name="subTag" select="my:getSubtag($restTag)"/>
    <xsl:variable name="newRestTag" select="substring-after($restTag,concat($subTag,'-'))"/>
    <!-- If a script is given, create output and call a template for region checking with
	 new rest. If no script is recognized, call a template for
	 region checking with same rest. 
      -->
    <xsl:choose>
      <xsl:when test="matches($subTag,'^([a-z]|[A-Z]){4}$')">
        <lta:script>
          <xsl:value-of select="$subTag"/>
        </lta:script>
	<xsl:choose>
	  <xsl:when test="substring-after($restTag,$subTag)='-'">
	    <lta:error type="e001"><lta:errorText>Not wellformed.</lta:errorText><lta:errorAddInfo><lta:restTag>-</lta:restTag><lta:potentialSubTags><lta:link target="&rfc4646bis;section-2.2.4">region</lta:link><lta:link target="&rfc4646bis;section-2.2.5">variant</lta:link><lta:link target="&rfc4646bis;section-2.2.6">extension</lta:link><lta:link target="&rfc4646bis;section-2.2.7">private use</lta:link> </lta:potentialSubTags><lta:link target="&rfc4646bis;ABNF">ABNF</lta:link><lta:link target="&rfc4646bis;well-formed"></lta:link></lta:errorAddInfo></lta:error>
	  </xsl:when>
          <xsl:when test="$newRestTag!=''">
            <xsl:call-template name="regionTest">
              <xsl:with-param name="restTag" select="$newRestTag"/>
              <xsl:with-param name="potentialSubtags" select="''"/>
            </xsl:call-template>
          </xsl:when>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="regionTest">
          <xsl:with-param name="restTag" select="$restTag"/>
          <xsl:with-param name="potentialSubtags"><lta:link target="&rfc4646bis;section-2.2.2">extlang</lta:link><lta:link target="&rfc4646bis;section-2.2.3">script</lta:link></xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="regionTest">
    <xsl:param name="restTag"/>
    <xsl:param name="potentialSubtags"/>
    <xsl:variable name="subTag" select="my:getSubtag($restTag)"/>
    <xsl:variable name="newRestTag" select="substring-after($restTag,concat($subTag,'-'))"/>
    <!-- If a region is given, create output and call a template for variant checking with
	 new rest. If no region is recognized, call a template for
	 variant checking with same rest.
      -->
    <xsl:choose>
      <xsl:when test="matches($subTag,'^([a-z]|[A-Z]){2}$')">
        <lta:region type="ISO 3166-1 code">
          <xsl:value-of select="$subTag"/>
        </lta:region>
	<xsl:choose>
	  <xsl:when test="substring-after($restTag,$subTag)='-'">
	    <lta:error type="e001"><lta:errorText>Not wellformed.</lta:errorText><lta:errorAddInfo><lta:restTag>-</lta:restTag><lta:potentialSubTags><lta:link target="&rfc4646bis;section-2.2.5">variant</lta:link><lta:link target="&rfc4646bis;section-2.2.6">extension</lta:link><lta:link target="&rfc4646bis;section-2.2.7">private use</lta:link> </lta:potentialSubTags><lta:link target="&rfc4646bis;ABNF">ABNF</lta:link><lta:link target="&rfc4646bis;well-formed"></lta:link></lta:errorAddInfo></lta:error>
	  </xsl:when>
          <xsl:when test="$newRestTag!=''">
            <xsl:call-template name="variantTest">
              <xsl:with-param name="restTag" select="$newRestTag"/>
              <xsl:with-param name="potentialSubtags" select="''"/>
            </xsl:call-template>
          </xsl:when>
	</xsl:choose>
      </xsl:when>
      <xsl:when test="matches($subTag,'^(\d){3}$')">
        <lta:region type="UN M.49 code">
          <xsl:value-of select="$subTag"/>
        </lta:region>
	<xsl:choose>
	  <xsl:when test="substring-after($restTag,$subTag)='-'">	    
	    <lta:error type="e001"><lta:errorText>Not wellformed.</lta:errorText><lta:errorAddInfo><lta:restTag>-</lta:restTag><lta:potentialSubTags>variant extension privatuse</lta:potentialSubTags></lta:errorAddInfo></lta:error>
	  </xsl:when>
          <xsl:when test="$newRestTag!=''">
            <xsl:call-template name="variantTest">
              <xsl:with-param name="restTag" select="$newRestTag"/>
              <xsl:with-param name="potentialSubtags" select="''"/>
            </xsl:call-template>
          </xsl:when>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="variantTest">
          <xsl:with-param name="restTag" select="$restTag"/>
          <xsl:with-param name="potentialSubtags">
            <xsl:copy-of select="$potentialSubtags"/>
            <lta:link target="&rfc4646bis;section-2.2.4">region</lta:link>
            </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="variantTest">
    <xsl:param name="restTag"/>
    <xsl:param name="potentialSubtags"/>
    <xsl:variable name="subTag" select="my:getSubtag($restTag)"/>
    <!-- If a variant is given, create output and call a template for another variant checking with
	 new rest. If no variant is recognized, call a template for
	 extension checking with same rest.
      -->
    <xsl:variable name="newRestTag" select="substring-after($restTag,concat($subTag,'-'))"/>
    <xsl:choose>
      <xsl:when
        test="matches($subTag,'^(([a-z]|[A-Z])|(\d)){5,8}$') or matches($subTag,'^(\d)((([a-z]|[A-Z])|(\d))){3}$')">
        <lta:variant>
          <xsl:value-of select="$subTag"/>
        </lta:variant>
	<xsl:choose>
	  <xsl:when test="substring-after($restTag,$subTag)='-'">
	    <lta:error type="e001"><lta:errorText>Not wellformed.</lta:errorText><lta:errorAddInfo><lta:restTag>-</lta:restTag><lta:potentialSubTags><lta:link target="&rfc4646bis;section-2.2.5">variant</lta:link><lta:link target="&rfc4646bis;section-2.2.6">extension</lta:link><lta:link target="&rfc4646bis;section-2.2.7">private use</lta:link> </lta:potentialSubTags><lta:link target="&rfc4646bis;ABNF">ABNF</lta:link><lta:link target="&rfc4646bis;well-formed"></lta:link></lta:errorAddInfo></lta:error>	    
	  </xsl:when>
          <xsl:when test="$newRestTag!=''">
            <xsl:call-template name="variantTest">
              <xsl:with-param name="restTag" select="$newRestTag"/>
              <xsl:with-param name="potentialSubtags" select="''"/>
            </xsl:call-template>
          </xsl:when>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="extensionTest">
          <xsl:with-param name="restTag" select="$restTag"/>
          <xsl:with-param name="potentialSubtags">
            <xsl:copy-of select="$potentialSubtags"/>
            <lta:link target="&rfc4646bis;section-2.2.5">variant</lta:link>
            </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="extensionTest">
    <xsl:param name="restTag"/>
    <xsl:param name="potentialSubtags"/>
    <xsl:variable name="subTag"
		  select="
			  substring-before($restTag,
			  replace($restTag,'^(([a-w]|[y-z]|[A-W]|[Y-Z]|[0-9])(-(([a-z]|[A-Z])|(\d)){2,8})+)','')
			  )"/>
    <xsl:variable name="newRestTag" select="substring-after($restTag,concat($subTag,'-'))"/>
    <xsl:choose>
      <!-- Extension tag and some rest -->
      <xsl:when test="matches($subTag,'^([a-w]|[y-z]|[A-W]|[Y-Z]|[0-9])(-([a-z]|[A-Z]|\d){2,8})*')">
        <lta:extension>
          <xsl:value-of select="$subTag"/>
        </lta:extension>
        <xsl:call-template name="extensionTest">
          <xsl:with-param name="restTag" select="$newRestTag"/>
          <xsl:with-param name="potentialSubtags" select="''"/>
        </xsl:call-template>
      </xsl:when>
      <!-- Only one extension tag -->
      <xsl:when
         test="$subTag='' and matches($restTag,'^(([a-w]|[y-z]|[A-W]|[Y-Z]|[0-9])(-(([a-z]|[A-Z])|(\d)){2,8})+)')">
        <lta:extension>
          <xsl:value-of select="$restTag"/>
        </lta:extension>
      </xsl:when>
      <!-- No extension tag, check for private use -->
      <xsl:when test="matches($restTag,'^x(-(([a-z]|[A-Z])|(\d)){1,8})+$')">
        <lta:privateuse>
          <xsl:value-of select="$restTag"/>
        </lta:privateuse>
      </xsl:when>
      <xsl:otherwise>      
        <lta:error type="e001"><lta:errorText>Not wellformed.</lta:errorText><lta:errorAddInfo><lta:restTag><xsl:value-of select="$restTag"/></lta:restTag><lta:potentialSubTags><xsl:copy-of  select="$potentialSubtags"/><lta:link target="&rfc4646bis;section-2.2.6">extension</lta:link><lta:link target="&rfc4646bis;section-2.2.7">private use</lta:link></lta:potentialSubTags></lta:errorAddInfo></lta:error>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
