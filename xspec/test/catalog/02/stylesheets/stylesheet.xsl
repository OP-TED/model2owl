<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template as="xs:string" name="imported">
		<xsl:context-item use="absent" />
		<xsl:sequence select="'OK'" />
	</xsl:template>
</xsl:stylesheet>
