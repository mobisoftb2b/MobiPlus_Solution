<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="ActiveUnits/CurrentUnit/Person2Unit_ToDate=''">
        <xsl:for-each select="ActiveUnits/CurrentUnit">
          <xsl:element name="div">
            <xsl:attribute name="class">message success</xsl:attribute>
            <xsl:element name="p">
              <xsl:element name="span">
                <xsl:value-of select="Unit_Name"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="ActiveUnits/CurrentUnit">
          <xsl:element name="div">
            <xsl:attribute name="class">message tip</xsl:attribute>
            <xsl:element name="p">
              <xsl:element name="span">
                <xsl:value-of select="Unit_Name"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
