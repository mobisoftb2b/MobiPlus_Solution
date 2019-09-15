<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/">
    <xsl:for-each select="UnitEvent/UnitEvent2Categories">
      <xsl:element name="div">
        <xsl:attribute name="class">message success closeable</xsl:attribute>
        <xsl:attribute name="te">
          <xsl:value-of select="UnitEvent_ID"/>
        </xsl:attribute>
        <xsl:attribute name="tecat">
          <xsl:value-of select="TrainingEventCategory_ID"/>
        </xsl:attribute>
        <xsl:element name="p">
          <xsl:element name="span">
            <xsl:value-of select="TrainingEventCategory_Name"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
