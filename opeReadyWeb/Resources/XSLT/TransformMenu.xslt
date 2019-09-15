<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output indent="yes"/>
  <xsl:key name="val" match="value" use="@parentCode"/>
  <xsl:template match="data">
    <ul class="nav">
      <xsl:apply-templates select="key('val', '')"/>
    </ul>
  </xsl:template>

  <xsl:template match="value">
    <li>
    <xsl:choose>
      <xsl:when test="key('val', @code)">
        <li>
          <a href="#" class="headitem item1">
            <xsl:value-of select="."/>
          </a>
        </li>
        <ul>
          <xsl:apply-templates select="key('val', @code)"/>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <li>
          <a href="#" class="headitem item">
            <xsl:value-of select="."/>
          </a>
        </li>
      </xsl:otherwise>
    </xsl:choose>
    </li>
  </xsl:template>
</xsl:stylesheet>