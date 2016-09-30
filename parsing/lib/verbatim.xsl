<xsl:stylesheet xmlns:sch="http://www.ascc.net/xml/schematron"
  xmlns:h="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:its="http://www.w3.org/2005/11/its"
  xmlns:rng="http://relaxng.org/ns/structure/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:dbk="http://docbook.org/ns/docbook" xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

  <xsl:param name="spaceCharacter">&#160;</xsl:param>
  
  <xsl:template name="lineBreak">
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="text()" mode="verbatim">

    <xsl:choose>
      <xsl:when test="normalize-space(.) = ''">
        <xsl:for-each select="following-sibling::*[1]">
          <xsl:call-template name="lineBreak"/>
          <xsl:call-template name="makeIndent"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="wraptext">
          <xsl:with-param name="indent">
            <xsl:for-each select="parent::*">
              <xsl:call-template name="makeIndent"/>
            </xsl:for-each>
          </xsl:with-param>
          <xsl:with-param name="text">
            <xsl:value-of select="."/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="wraptext">
    <xsl:param name="indent"/>
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="$text = '&#10;'"/>
      <xsl:when test="contains($text, '&#10;')">
        <xsl:value-of select="substring-before($text, '&#10;')"/>
        <xsl:call-template name="lineBreak">
          <xsl:with-param name="id">6</xsl:with-param>
        </xsl:call-template>
        <xsl:value-of select="$indent"/>
        <xsl:call-template name="wraptext">
          <xsl:with-param name="indent">
            <xsl:value-of select="$indent"/>
          </xsl:with-param>
          <xsl:with-param name="text">
            <xsl:value-of select="substring-after($text, '&#10;')"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="verbatim">
    <xsl:call-template name="lineBreak"/>
    <xsl:call-template name="makeIndent"/>

    <h:span class="element">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="local-name(.)"/>

    <xsl:choose>
      <xsl:when test="child::node()">
        <xsl:text>&gt;</xsl:text>
        <xsl:apply-templates mode="verbatim"/>

        <xsl:choose>
          <xsl:when test="child::node()[last()]/self::text()[normalize-space(.) = '']">
            <xsl:call-template name="lineBreak"/>
            <xsl:call-template name="makeIndent"/>
          </xsl:when>
          <xsl:when test="child::node()[last()]/self::*">
            <xsl:call-template name="lineBreak"/>
            <xsl:call-template name="makeIndent"/>
          </xsl:when>
        </xsl:choose>
        <xsl:text>&lt;/</xsl:text>
        <xsl:value-of select="local-name(.)"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>/&gt;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    </h:span>
  </xsl:template>

  <xsl:template name="makeIndent">
    <xsl:for-each select="ancestor::*">
      <xsl:value-of select="$spaceCharacter"/>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>