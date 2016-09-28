<?xml version="1.0" encoding="UTF-8"?>
<!--
tbd:

canonicalization:
A language tag is in canonical form when:
   1. The tag is well-formed according the rules in Section 2.1 (Syntax) and Section 2.2 (Language Subtag Sources and Interpretation).
   2. Redundant or grandfathered tags that have a Preferred-Value mapping in the IANA registry (see Section 3.1 (Format of the IANA Language Subtag Registry)) MUST be replaced with their mapped value. These items either are deprecated mappings created before the adoption of this document (such as the mapping of "no-nyn" to "nn" or "i-klingon" to "tlh") or are the result of later registrations or additions to this document (for example, "zh-hakka" was deprecated in favor of the ISO 639-3 code 'hak' when this document was adopted). These mappings SHOULD be done before additional processing, since there can be additional changes to subtag values. These field-body of the Preferred-Value for grandfathered and redundant tags is an "extended language range" ([RFC4647] (Phillips, A. and M. Davis, “Matching of Language Tags,” September 2006.)) and might consist of more than one subtag.
   3. Subtags of type 'extlang' SHOULD be mapped to their Preferred-Value. The field-body of the Preferred-Value for extlangs is an "extended language range" and typically maps to a primary language subtag. For example, the subtag sequence "zh-hak" (Chinese, Hakka) would be replaced with the tag "hak" (Hakka).
   4. Other subtags that have a Preferred-Value field in the IANA registry (see Section 3.1 (Format of the IANA Language Subtag Registry)) MUST be replaced with their mapped value. Most of these are either Region subtags where the country name or designation has changed or clerical corrections to ISO 639-1.
   5. If more than one extension subtag sequence exists, the extension sequences are ordered into case-insensitive ASCII order by singleton subtag (that is, the subtag sequence '-a-babble' comes before '-b-warble').

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

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

<!-- Language Tag Analyzer (LTA) - version 0.2. constraint-check.xsl
     For documentation, see http://www.w3.org/2008/05/lta/
  -->
<!DOCTYPE xsl:stylesheet [<!ENTITY rfc4646bis "http://www.inter-locale.com/ID/draft-ietf-ltru-4646bis-23#">]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
		xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/"
		xmlns:my="http://example.com/myns" xmlns:lta="http://www.w3.org/2008/05/lta/"
		xmlns="http://www.w3.org/1999/xhtml" xmlns:h="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="my saxon xs h lta">
  <!-- The subtag registry. Subtags: language, script, region, variant, 
       grandfathered, redundant-->
  <xsl:variable name="st-language" select="doc('../lsr/lsr.xml')/lta:lsr/lta:lan"/>
  <xsl:variable name="st-extlang" select="doc('../lsr/lsr.xml')/lta:lsr/lta:ext"/>
  <xsl:variable name="st-script" select="doc('../lsr/lsr.xml')/lta:lsr/lta:scr"/>
  <xsl:variable name="st-region" select="doc('../lsr/lsr.xml')/lta:lsr/lta:reg"/>
  <xsl:variable name="st-variant" select="doc('../lsr/lsr.xml')/lta:lsr/lta:var"/>
  <xsl:variable name="st-grandfathered" select="
						doc('../lsr/lsr.xml')/lta:lsr/lta:gra"/>
  <xsl:variable name="st-redundant" select="
    doc('../lsr/lsr.xml')/lta:lsr/lta:red"/>
  <!-- To copy everything to the output during constraints check -->
  <xsl:template match="node() | @*" mode="someConstraintsCheck">
    <xsl:param name="abnfCheckedLangtag"/>
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="someConstraintsCheck">
        <xsl:with-param name="abnfCheckedLangtag" select="$abnfCheckedLangtag"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  <!-- Language sub tag constraints check -->
  <xsl:template mode="someConstraintsCheck" match="lta:language">
    <xsl:param name="abnfCheckedLangtag"/>
    <xsl:copy>
      <xsl:copy-of select="@type"/>
      <lta:subtag><xsl:value-of select="."/></lta:subtag>
      <xsl:variable name="st" select="."/>
      <xsl:variable name="match"
		    select="
			    $st-language[@su[matches(.,concat('^',$st,'$'),'i')]]"/>
      <xsl:choose>
        <xsl:when test="$match">
          <lta:registryInfo>
            <xsl:copy-of select="$match"/>
          </lta:registryInfo>
        </xsl:when>
        <xsl:otherwise>
          <lta:error type="e002"><lta:errorText>Sub tag not in registry.</lta:errorText><lta:errorAddInfo><lta:subtag><xsl:value-of select="."/></lta:subtag><lta:link target="&rfc4646bis;primarylang">language</lta:link></lta:errorAddInfo></lta:error>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$abnfCheckedLangtag//lta:script[lower-case(.)=lower-case($match//@sup)]">
	<lta:error type="e005"><lta:errorText>Script should be supressed.</lta:errorText><lta:errorAddInfo><lta:subtag><xsl:value-of select="."/></lta:subtag><lta:script><xsl:value-of select="$match/lta:lan/@sup"/></lta:script><lta:link target="&rfc4646bis;supressscript">supress script</lta:link></lta:errorAddInfo></lta:error>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <!-- Extlang part constraints check -->
  <xsl:template mode="someConstraintsCheck" match="lta:extlang">
    <xsl:param name="abnfCheckedLangtag"/>
    <xsl:copy>      
      <lta:subtag><xsl:value-of select="."/></lta:subtag>
      <xsl:choose>
        <xsl:when test="matches(.,'([a-z]|[A-Z]){3}-')">
          <lta:error type="e004"><lta:errorText>Extlang subtag is too long.</lta:errorText>
            <lta:errorAddInfo><lta:subtag><xsl:value-of select="."/></lta:subtag></lta:errorAddInfo>
          </lta:error>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="st" select="."/>
          <xsl:variable name="match"
			select="
				$st-extlang[@su[matches(.,concat('^',$st,'$'),'i')]]"/>
          <xsl:choose>
            <xsl:when test="$match">
              <lta:registryInfo>
                <xsl:copy-of select="$match"/>
              </lta:registryInfo>
	      <xsl:if test="not(lower-case($abnfCheckedLangtag//lta:language)=lower-case($match/lta:pref))">
		<lta:error type="e006"><lta:errorText>Wrong prefix for extlang subtag.</lta:errorText><lta:errorAddInfo><lta:subtag><xsl:value-of select="."/></lta:subtag><lta:wrongPrefix><xsl:value-of select="$abnfCheckedLangtag//lta:language"/></lta:wrongPrefix><lta:correctPrefix><xsl:value-of select="$match/lta:pref"/></lta:correctPrefix><lta:link target="&rfc4646bis;extlangprefix">extlang prefix</lta:link></lta:errorAddInfo></lta:error>
	      </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <lta:error type="e002"><lta:errorText>Sub tag not in registry.</lta:errorText><lta:errorAddInfo><lta:subtag><xsl:value-of select="."/></lta:subtag></lta:errorAddInfo></lta:error>         
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>           
    </xsl:copy>
  </xsl:template>
  <!-- Script sub tag constraints check -->
  <xsl:template mode="someConstraintsCheck" match="lta:script">
    <xsl:param name="abnfCheckedLangtag"/>
    <xsl:copy>
      <xsl:copy-of select="@type"/>
      <lta:subtag><xsl:value-of select="."/></lta:subtag>
      <xsl:variable name="st" select="."/>
      <xsl:variable name="match"
		    select="
			    $st-script[@su[matches(.,concat('^',$st,'$'),'i')]]"/>
      <xsl:choose>
        <xsl:when test="$match">
          <lta:registryInfo>
            <xsl:copy-of select="$match"/>
          </lta:registryInfo>
        </xsl:when>
        <xsl:otherwise>
          <lta:error type="e002"><lta:errorText>Sub tag not in registry.</lta:errorText><lta:errorAddInfo><lta:subtag><xsl:value-of select="."/></lta:subtag></lta:errorAddInfo></lta:error>            
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  <!-- Region sub tag constraints check -->
  <xsl:template mode="someConstraintsCheck" match="lta:region">
    <xsl:param name="abnfCheckedLangtag"/>
    <xsl:copy>      
      <xsl:copy-of select="@type"/>
      <lta:subtag><xsl:value-of select="."/></lta:subtag>
      <xsl:variable name="st" select="."/>
      <xsl:variable name="match" select="$st-region[@su[matches(.,concat('^',$st,'$'),'i')]]"/>
      <xsl:choose>
        <xsl:when test="$match">
          <lta:registryInfo>
            <xsl:copy-of select="$match"/>
          </lta:registryInfo>
        </xsl:when>
        <xsl:otherwise>
          <lta:error type="e002"><lta:errorText>Sub tag not in registry.</lta:errorText><lta:errorAddInfo><lta:subtag><xsl:value-of select="."/></lta:subtag></lta:errorAddInfo></lta:error>           
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  <!-- Variant sub tag constraints check -->
  <xsl:function name="my:extendedFiltering">
    <xsl:param name="tag"/>
    <xsl:param name="languageRange"/>
    <xsl:variable name="stFromTag" select="my:getSubtag($tag)"/>
    <xsl:variable name="stFromRange" select="my:getSubtag($languageRange)"/>
    <xsl:choose>
      <!-- If there are no more subtags in the language tag's list, the match fails. -->
      <xsl:when test="$stFromTag='' and $stFromRange!=''">fail</xsl:when>
      <!-- Else, if the current subtag in the range's list matches the current subtag in the language tag's list, move to the next subtag in both lists and continue with the loop. -->
      <xsl:when test="$stFromTag=$stFromRange">
	<xsl:value-of select="my:extendedFiltering(substring-after($tag,concat($stFromTag,'-')),substring-after($languageRange,concat($stFromRange,'-')))"/>
      </xsl:when>
      <!-- -Else, if the language tag's subtag is a "singleton" (a single letter or digit, which includes the private-use subtag 'x') the match fails. -->
      <xsl:when test="matches($stFromTag,'^([a-z]|[A-Z]|\d)$')">fail</xsl:when>
      <!-- When the language range's list has no more subtags, the match succeeds. -->
      <xsl:when test="$stFromRange=''">match</xsl:when>
      <!-- Else, move to the next subtag in the language tag's list and continue with	the loop. -->
      <xsl:otherwise>
	<xsl:value-of select="my:extendedFiltering(substring-after($tag,concat($stFromTag,'-')),$languageRange)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xsl:template mode="someConstraintsCheck" match="lta:variant">
    <xsl:param name="abnfCheckedLangtag"/>
    <xsl:copy>
      <xsl:copy-of select="@type"/>
      <lta:subtag><xsl:value-of select="."/></lta:subtag>
      <xsl:variable name="st" select="."/>
      <xsl:variable name="match" select="$st-variant[@su[matches(.,concat('^',$st,'$'),'i')]]"/>
      <xsl:choose>
        <xsl:when test="$match">
          <lta:registryInfo>
            <xsl:copy-of select="$match"/>
          </lta:registryInfo>
	  <xsl:variable name="prefixCheck">
	    <!--  If the first subtag in the range does not match the first subtag in the tag, the overall match fails. Otherwise, continue filtering algorithm -->
	    <xsl:for-each select="$match//lta:pref[my:getSubtag(.)=my:getSubtag(lower-case($abnfCheckedLangtag/lta:Language-Tag/@input))]">
	      <xsl:if test="contains(my:extendedFiltering(lower-case($abnfCheckedLangtag/lta:Language-Tag/@input),.),'match')">
		<lta:matchedPrefix><xsl:value-of select="."/></lta:matchedPrefix>
	      </xsl:if>
	    </xsl:for-each>
	  </xsl:variable>
	  <xsl:choose>
	    <xsl:when test="$prefixCheck/lta:matchedPrefix">
	      <xsl:copy-of select="$prefixCheck"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <lta:error type="e008"><lta:errorText>Wrong prefix for variant</lta:errorText><lta:errorAddInfo><lta:subtag><xsl:value-of select="$st"/></lta:subtag><lta:link target="&rfc4646bis;prefixfield">wrong prefix for subtag</lta:link></lta:errorAddInfo></lta:error>   
	    </xsl:otherwise>
	  </xsl:choose>          
        </xsl:when>
        <xsl:otherwise>
          <lta:error type="e002"><lta:errorText>Sub tag not in registry.</lta:errorText><lta:errorAddInfo><lta:subtag><xsl:value-of select="."/></lta:subtag></lta:errorAddInfo></lta:error>   
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="count($abnfCheckedLangtag//lta:variant[lower-case(.)=lower-case($st)]) &gt; 1">
        <lta:error type="e007"><lta:errorText>Variant repetition</lta:errorText><lta:errorAddInfo><lta:subtag><xsl:value-of select="$st"/></lta:subtag></lta:errorAddInfo></lta:error>   
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <!-- Check for grandfathered and redundant tags -->
  <xsl:template mode="someConstraintsCheck" match="lta:irregular | lta:regular">
    <xsl:param name="abnfCheckedLangtag"/>
    <xsl:copy>
      <xsl:copy-of select="@type"/>
      <lta:subtag><xsl:value-of select="."/></lta:subtag>
      <xsl:variable name="st" select="."/>
      <xsl:variable name="match"
		    select="
			    $st-grandfathered[@ta[matches(.,concat('^',$st,'$'),'i')] | $st-redundant/lta:tag[matches(.,concat('^',$st,'$'),'i')]]"/>
      <xsl:choose>
        <xsl:when test="$match">
          <lta:registryInfo>
            <xsl:copy-of select="$match"/>
          </lta:registryInfo>
        </xsl:when>
        <xsl:otherwise>
          <lta:error type="e002"><lta:errorText>Sub tag not in registry.</lta:errorText><lta:errorAddInfo><lta:subtag><xsl:value-of select="."/></lta:subtag></lta:errorAddInfo></lta:error>   
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  <xsl:template mode="someConstraintsCheck" match="lta:extension">
    <!--  Each singleton subtag MUST appear at most one time in each tag
          (other than as a private use subtag).  That is, singleton
          subtags MUST NOT be repeated.  For example, the tag "en-a-bbb-a-
          ccc" is invalid because the subtag 'a' appears twice.  Note that
          the tag "en-a-bbb-x-a-ccc" is valid because the second
          appearance of the singleton 'a' is in a private use sequence. -->
    <xsl:param name="abnfCheckedLangtag"/>
    <xsl:variable name="prefix" select="substring-before(.,'-')"/>
    <xsl:copy>      
      <lta:subtag><xsl:value-of select="."></xsl:value-of></lta:subtag>
      <xsl:if
         test="
               count
               (
               $abnfCheckedLangtag//lta:extension[substring-before(.,'-') = $prefix]
               )		  
	       != 1
	       ">
        <lta:error type="e003"><lta:errorText>Singleton repetition</lta:errorText><lta:errorAddInfo><lta:singleton><xsl:value-of select="$prefix"/></lta:singleton></lta:errorAddInfo></lta:error>   
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="lta:privateuse" mode="someConstraintsCheck">
    <xsl:copy>
      <lta:subtag><xsl:value-of select="."/></lta:subtag>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
