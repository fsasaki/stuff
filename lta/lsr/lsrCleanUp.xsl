<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:lta="http://www.w3.org/2008/05/lta/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="lta:unit">
    <xsl:element name="{concat('lta:',substring(lta:type,1,3))}"
      namespace="http://www.w3.org/2008/05/lta/">
      <xsl:call-template name="copyFields"/>
    </xsl:element>
  </xsl:template>
  <xsl:template name="copyFields">
    <xsl:for-each
      select="lta:type | lta:subtag | lta:tag | lta:added |  lta:scope | lta:deprecated | lta:preferredValue ">
      <xsl:attribute name="{substring(local-name(),1,2)}" select="normalize-space(.)"/>
    </xsl:for-each>
    <xsl:for-each select="lta:suppressScript">
      <xsl:attribute name="sup" select="."/>
    </xsl:for-each>
    <xsl:for-each select="lta:macrolanguage">
      <xsl:element name="lta:ma">
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:for-each>
    <xsl:for-each select="lta:desc">
      <xsl:element name="lta:ds">
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:for-each>
    <xsl:for-each select="lta:comment">
      <xsl:element name="lta:co">
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:for-each>
    <xsl:for-each select="lta:prefix">
      <xsl:element name="lta:pref">
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
