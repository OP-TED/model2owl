<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="coverage_no-hit_included.xsl" />

	<xsl:template as="element(ever)" match="never">
		<ever />
	</xsl:template>

</xsl:stylesheet>
