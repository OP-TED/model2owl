<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="3.0"
	xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
	xmlns:x="http://www.jenitennison.com/xslt/xspec" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--
		This master stylesheet is a privately patched version of the original Schematron Step 3
		preprocessor.
	-->

	<!--
		Import the original Schematron Step 3 preprocessor
	-->
	<xsl:import href="../../lib/iso-schematron/iso_svrl_for_xslt2.xsl" />
	<xsl:include href="step3-override-process-assert.xsl"/>

	<!--
		Setting this parameter true activates the patch for @location containing text node
	-->
	<xsl:param as="xs:boolean" name="x:enable-schematron-text-location" select="false()" />

	<!--
		Workaround for schematron-select-full-path not working with text nodes
	-->
	<xsl:template as="node()+" match="element()" mode="stylesheetbody">
		<xsl:next-match />

		<xsl:if test="$x:enable-schematron-text-location">
			<axsl:template match="text()" mode="schematron-select-full-path">
				<xsl:comment expand-text="yes">This template was injected by {static-base-uri()}</xsl:comment>
				<axsl:apply-templates mode="#current" select="parent::element()" />
				<axsl:text>/text()[</axsl:text>
				<axsl:value-of select="count(preceding-sibling::text()) + 1" />
				<axsl:text>]</axsl:text>
			</axsl:template>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
