<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="/">
		<xsl:for-each select="ActiveJobs/CurrentJob">
			<xsl:variable name="isMain">
				<xsl:value-of select="Person2Job_ToDate"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$isMain=''">
					<xsl:element name="div">
						<xsl:attribute name="class">message success</xsl:attribute>
						<xsl:element name="p">
							<xsl:element name="span">
								<xsl:value-of select="Job_Name"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="div">
						<xsl:attribute name="class">message tip</xsl:attribute>
						<xsl:element name="p">
							<xsl:element name="span">
								<xsl:value-of select="Job_Name"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
