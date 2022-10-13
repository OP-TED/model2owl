<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="3.0"
	xmlns:serializer="x-urn:xspec:test:end-to-end:processor:serializer"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--
		This stylesheet module helps serialize the test result HTML.
	-->

	<!--
		Set of serialization parameters
			The parameters (except for @use-character-maps="fmt:disable-escaping") must be in sync
			with XSPEC_HOME/src/reporter/format-xspec-report.xsl.
	-->
	<xsl:output method="xhtml" name="serializer:output" />
</xsl:stylesheet>
