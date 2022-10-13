<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="3.0"
	xmlns:x="http://www.jenitennison.com/xslt/xspec" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--
		Resolves URI (of an XML document) with the currently enabled catalog,
		working around an XML resolver bug
	-->
	<xsl:function as="xs:anyURI" name="x:resolve-xml-uri-with-catalog">
		<xsl:param as="xs:string" name="xml-uri" />

		<!-- https://sourceforge.net/p/saxon/mailman/message/36339785/
			"document-uri() returns the (absolutized) requested URI, while base-uri() returns
			the actual document location after catalog resolution." -->
		<xsl:sequence select="
				$xml-uri
				=> doc()
				=> x:base-uri()" />
	</xsl:function>

	<!--
		Returns the document actual URI (i.e. resolved with the currently enabled catalog),
		working around an XML resolver bug. This doesn't work in Saxon 11 or later, so
                go back to base-uri() in that case. Saxon 11 and later use a different resolver
                so perhaps the resolver bug is no longer present.
	-->
	<xsl:function use-when="system-property('xsl:product-name') = 'SAXON'
                                and xs:integer(substring-before(substring-after(system-property('xsl:product-version'), ' '), '.')) gt 10"
                      as="xs:anyURI" name="x:document-actual-uri">
		<xsl:param as="document-node()" name="doc" />

		<xsl:sequence
			select="base-uri($doc)" />
	</xsl:function>

	<xsl:function use-when="system-property('xsl:product-name') != 'SAXON'
                                or xs:integer(substring-before(substring-after(system-property('xsl:product-version'), ' '), '.')) le 10"
                      as="xs:anyURI" name="x:document-actual-uri">
		<xsl:param as="document-node()" name="doc" />

		<xsl:sequence
			select="
				$doc
				=> document-uri()
				=> x:resolve-xml-uri-with-catalog()" />
	</xsl:function>

	<!--
		Performs fn:base-uri(), working around an XML resolver bug
	-->
	<xsl:function as="xs:anyURI" name="x:base-uri">
		<xsl:param as="node()" name="node" />

		<!-- Fix invalid URI such as 'file:C:/dir/file'
			https://issues.apache.org/jira/browse/XMLCOMMONS-24 -->
		<xsl:sequence
			select="
				$node
				=> base-uri()
				=> replace('^(file:)([^/])', '$1/$2')
				=> xs:anyURI()"
		 />
	</xsl:function>

</xsl:stylesheet>
