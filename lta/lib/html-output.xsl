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

<!-- Language Tag Analyzer (LTA) - version 0.2. html-output.xsl
     For documentation, see http://www.w3.org/2008/05/lta/
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
		xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/"
		xmlns:my="http://example.com/myns" xmlns:lta="http://www.w3.org/2008/05/lta/"
		xmlns="http://www.w3.org/1999/xhtml" xmlns:h="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="my saxon xs h lta">
	<xsl:output method="html"/>
<xsl:template name="html-output">
<xsl:param name="constrainedCheckedLanguagetag"/>
<div class="output">
              <h1>
		<xsl:apply-templates mode="writeMessage" select="$messages[@id='m1']/lta:unit[@xml:lang=$hl]"/>
	      </h1>
              <p>
		<xsl:apply-templates mode="writeMessage" select="$messages[@id='m2']/lta:unit[@xml:lang=$hl]">
		  <xsl:with-param name="variables">
		    <lta:var no="m2v1"><xsl:value-of  select="$inputlangtag"/></lta:var>
		  </xsl:with-param>
		</xsl:apply-templates>
	      </p>
              <p><xsl:apply-templates mode="writeMessage" select="$messages[@id='m3']/lta:unit[@xml:lang=$hl]"/>
<xsl:text> </xsl:text>
<xsl:choose>
            		<xsl:when test="not($constrainedCheckedLanguagetag//lta:error)">
            			<xsl:apply-templates mode="writeMessage" select="$messages[@id='m18']/lta:unit[@xml:lang=$hl]"/>            			
            		</xsl:when>
            		<xsl:otherwise>            			
            			<xsl:apply-templates mode="writeMessage" select="$messages[@id='m19']/lta:unit[@xml:lang=$hl]">
            				<xsl:with-param name="variables">
            					<lta:var no="m19v1"><xsl:value-of select="count($constrainedCheckedLanguagetag//lta:error | $constrainedCheckedLanguagetag/*/*[not(lta:registryInfo or self::lta:privateuse)])"></xsl:value-of></lta:var>
            				</xsl:with-param>
            			</xsl:apply-templates>          
            		</xsl:otherwise>
            	</xsl:choose>
</p>
	      <p>
		<xsl:apply-templates mode="writeMessage" select="$messages[@id='m4']/lta:unit[@xml:lang=$hl]">
		  <xsl:with-param name="variables">		  	
		    <lta:var no="m4v1"><xsl:value-of  select="count($constrainedCheckedLanguagetag/*/*[not(name()='lta:error')])"/></lta:var>
		  </xsl:with-param>
		</xsl:apply-templates>
	      </p>
	      <ul>
		<xsl:apply-templates select="$constrainedCheckedLanguagetag/*/*" mode="xhtmloutput">
			<xsl:with-param name="ccl" select="$constrainedCheckedLanguagetag" tunnel="yes"/>
		</xsl:apply-templates>
	      </ul><!--
            	<p>
            		<a href="http://www.sasakiatcf.com/felix/lta/">
            			<xsl:apply-templates mode="writeMessage" select="$messages[@id='m5']/lta:unit[@xml:lang=$hl]"/>
            		</a>
            	</p>-->
</div>
  </xsl:template>
  <xsl:template match="lta:error[@type='e001']" mode="xhtmloutput" priority="4">
    <li>
      <xsl:apply-templates mode="writeMessage" select="$messages[@id='m6']/lta:unit[@xml:lang=$hl]">
	<xsl:with-param name="variables">
		<lta:var no="m6v1"><xsl:value-of select="lta:errorAddInfo/lta:restTag"/></lta:var>
		<lta:var no="m6v2"><xsl:for-each select="lta:errorAddInfo/lta:potentialSubTags/lta:link">
			<a href="{@target}"><xsl:value-of select="."/></a>
		</xsl:for-each></lta:var>
	</xsl:with-param>
      </xsl:apply-templates>
    </li>
  </xsl:template>
  <xsl:template match="lta:language | lta:extlang | lta:script | lta:region | lta:variant | lta:extension | lta:privateuse | lta:irregular | lta:regular" mode="xhtmloutput">
  	<xsl:param name="ccl" tunnel="yes"/>
  	<li>  	<b><xsl:value-of select="lta:tag | lta:subtag"/></b>:
  	<xsl:if test="lta:registryInfo"><ul>
  			<li>
  		<xsl:apply-templates mode="writeMessage" select="$messages[@id='m7']/lta:unit[@xml:lang=$hl]">
  			<xsl:with-param name="variables">
  				<lta:var no="m7v1"><xsl:value-of select="lta:registryInfo/*/@su | lta:registryInfo/*/@ta"/></lta:var>
  				<lta:var no="m7v2"><xsl:value-of select="lta:registryInfo/*/@ty"/></lta:var>
  				<lta:var no="m7v3"><xsl:value-of select="lta:registryInfo/*/@ad"/></lta:var>
  			</xsl:with-param>
  		</xsl:apply-templates>
  		<xsl:apply-templates mode="writeMessage" select="$messages[@id='m8']/lta:unit[@xml:lang=$hl]"/>
  		<ul>
  			<xsl:if test="lta:registryInfo/lta:gra/@ta[.='i-default'] or lta:registryInfo/lta:lan/@su[.='mul' or .='und' or .='zxx']">
  				<li><xsl:apply-templates mode="writeMessage" select="$messages[@id='m24']/lta:unit[@xml:lang=$hl]">
  					<xsl:with-param name="variables"/>
  				</xsl:apply-templates></li>  			
  			</xsl:if>
  			<xsl:if test="lta:registryInfo/*/@pr">
  				<li><xsl:apply-templates mode="writeMessage" select="$messages[@id='m20']/lta:unit[@xml:lang=$hl]">
  					<xsl:with-param name="variables"/>
  				</xsl:apply-templates><xsl:value-of select="lta:registryInfo/*/@pr"/></li>
  			</xsl:if>
  			<xsl:if test="lta:registryInfo/*/@de">
  				<li><xsl:apply-templates mode="writeMessage" select="$messages[@id='m21']/lta:unit[@xml:lang=$hl]">
  					<xsl:with-param name="variables"/>
  				</xsl:apply-templates><xsl:value-of select="lta:registryInfo/*/@de"/></li>
  			</xsl:if>
  			<xsl:if test="lta:registryInfo/*/lta:ma">
  				<li><xsl:apply-templates mode="writeMessage" select="$messages[@id='m22']/lta:unit[@xml:lang=$hl]">
  					<xsl:with-param name="variables"/>
  				</xsl:apply-templates><xsl:value-of select="lta:registryInfo/*/lta:ma"/></li>
  			</xsl:if>
  			<xsl:if test="lta:registryInfo/*/@sc">
  				<li><xsl:apply-templates mode="writeMessage" select="$messages[@id='m23']/lta:unit[@xml:lang=$hl]"/>
  					<xsl:value-of select="lta:registryInfo/*/@sc"/></li>
  			</xsl:if>
  			<xsl:for-each select="lta:registryInfo/*/lta:ds">
  				<li><xsl:apply-templates mode="writeMessage" select="$messages[@id='m26']/lta:unit[@xml:lang=$hl]"/>
  					<xsl:value-of select="."/>
  				</li>
  			</xsl:for-each>
  			<xsl:for-each select="lta:registryInfo/*/lta:co">
  				<li><xsl:apply-templates mode="writeMessage" select="$messages[@id='m25']/lta:unit[@xml:lang=$hl]"/>
  					<xsl:value-of select="."/>
  				</li>
  			</xsl:for-each>
  		</ul>  			
  			
  			</li>
  			
  		</ul></xsl:if>
  		<xsl:if test="(not(lta:registryInfo) and not(self::lta:privateuse or self::lta:extension)) or lta:error[not(@type='e001' or @type='e002')]"><ul><xsl:if test="not(lta:registryInfo)"><li>
  			<xsl:apply-templates mode="writeMessage" select="$messages[@id='m9']/lta:unit[@xml:lang=$hl]">
  				<xsl:with-param name="variables">
  					<lta:var no="m9v1"><xsl:value-of select="lta:subtag | lta:tag"/></lta:var>
  					<lta:var no="m9v2"><xsl:value-of select="local-name((lta:subtag | lta:tag)/parent::*)"/></lta:var>
  				</xsl:with-param>
  			</xsl:apply-templates></li></xsl:if>
  		<xsl:for-each select="lta:error[not(@type='e001' or @type='e002')]"><xsl:apply-templates select="self::*"></xsl:apply-templates></xsl:for-each>
  		</ul></xsl:if>
  		<xsl:if test="self::lta:privateuse">private use subtag</xsl:if>
  		<xsl:if test="self::lta:extension[@extension-prefix='t']">extension sub tag, 't' extension [RFC6497] </xsl:if>
  		<xsl:if test="self::lta:extension[@extension-prefix='u']">extension sub tag, 'u' extension [RFC6067] </xsl:if>
  		<xsl:if test="self::lta:extension[not(@extension-prefix='u' or @extension-prefix='t')]">unknown extension sub tag '<xsl:value-of select="@extension-prefix"/>'</xsl:if>
  	</li>
  	</xsl:template>
      	<xsl:template match="lta:error[@type='e003']">
      		<xsl:param name="ccl" tunnel="yes"/>
      		<li>
      		<xsl:apply-templates mode="writeMessage" select="$messages[@id='m12']/lta:unit[@xml:lang=$hl]">
      			<xsl:with-param name="variables">
      				<lta:var no="m12v1"><xsl:value-of select="lta:errorAddInfo/lta:singleton"/></lta:var>
      				<lta:var no="m12v2"><xsl:value-of select="parent::*/lta:subtag"/></lta:var>
      			</xsl:with-param>
      		</xsl:apply-templates></li>
      	</xsl:template>
      	<xsl:template match="lta:error[@type='e004']">
      		<xsl:param name="ccl" tunnel="yes"/><li>
      		<xsl:apply-templates mode="writeMessage" select="$messages[@id='m13']/lta:unit[@xml:lang=$hl]">
      			<xsl:with-param name="variables">
      				<lta:var no="m13v1"><xsl:value-of select="lta:error[@type='e004']/lta:errorAddInfo/lta:subtag"/></lta:var>
      			</xsl:with-param>
      		</xsl:apply-templates></li>
      	</xsl:template>
      	<xsl:template match="lta:error[@type='e005']">
      		<xsl:param name="ccl" tunnel="yes"/>
      		<li>
      		<xsl:apply-templates mode="writeMessage" select="$messages[@id='m14']/lta:unit[@xml:lang=$hl]">
      			<xsl:with-param name="variables">
      				<lta:var no="m14v1"><xsl:value-of select="lta:errorAddInfo/lta:subtag"/></lta:var>
      				<lta:var no="m14v2"><xsl:value-of select="$ccl//lta:script/lta:subtag"/></lta:var>
      			</xsl:with-param>
      		</xsl:apply-templates></li>
      	</xsl:template>
	<xsl:template match="lta:error[@type='e006']">
		<xsl:param name="ccl" tunnel="yes"/><li>
      		<xsl:apply-templates mode="writeMessage" select="$messages[@id='m15']/lta:unit[@xml:lang=$hl]">
      			<xsl:with-param name="variables">
      				<lta:var no="m15v1"><xsl:value-of select="lta:errorAddInfo/lta:wrongPrefix"/></lta:var>
      				<lta:var no="m15v2"><xsl:value-of select="lta:errorAddInfo/lta:correctPrefix"/></lta:var>
      			</xsl:with-param>
      		</xsl:apply-templates></li>
      	</xsl:template>
      	<xsl:template match="lta:error[@type='e007']">
      		<xsl:param name="ccl" tunnel="yes"/><li>
      		<xsl:apply-templates mode="writeMessage" select="$messages[@id='m16']/lta:unit[@xml:lang=$hl]">
      			<xsl:with-param name="variables"/>
      		</xsl:apply-templates></li>
      	</xsl:template>
	<xsl:template match="lta:error[@type='e008']">
		<xsl:param name="ccl" tunnel="yes"/><li>
			<xsl:apply-templates mode="writeMessage" select="$messages[@id='m17']/lta:unit[@xml:lang=$hl]">
				<xsl:with-param name="variables">
					<lta:var no="m17v1"><xsl:value-of select="parent::*/lta:registryInfo/lta:var/lta:pref"/></lta:var>
				</xsl:with-param>
			</xsl:apply-templates></li>
	</xsl:template>
  <xsl:template match="h:*| @*" mode="writeMessage">
    <xsl:copy>
      <xsl:apply-templates select ="node() | @*" mode="writeMessage"/>
    </xsl:copy>
  </xsl:template>
  <!-- Template for variables in HTML output -->
  <xsl:template match="lta:var" mode="writeMessage">
    <xsl:param name="variables"/>
    <xsl:variable name="no" select="./@no"/>
    <xsl:apply-templates select="$variables/lta:var[@no=$no]/node()" mode="copy"/>  	
  </xsl:template>
	<xsl:template match="element()" mode="copy">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="node()" mode="copy"/>
		</xsl:copy>		
		<xsl:text>&#x20;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
