<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:f="http://https://github.com/costezki/model2owl#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs xd xsl xmi fn f"
    version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 23, 2025</xd:p>
            <xd:p>
                This module constructs the JSON-LD context file for the input
                model.
            </xd:p>
        </xd:desc>
    </xd:doc>


    <xsl:import href="jsonld-context-lib/elements-jsonld-context.xsl"/>
    <xsl:import href="jsonld-context-lib/connectors-jsonld-context.xsl"/>
    <xsl:import href="jsonld-context-lib/datatypes-jsonld-context.xsl"/>
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xd:doc>
        <xd:desc>The main template for JSON-LD context file</xd:desc>
    </xd:doc>
    <xsl:template match="/" >
        <xsl:variable name="json-xml" as="element(fn:map)">
            <fn:map>
                <fn:map key="@context">
                    <xsl:apply-templates select="xmi:XMI/xmi:Extension/elements/element"/>
                    <xsl:call-template name="connectorsDeclaration"/>
                </fn:map>
            </fn:map>
        </xsl:variable>
        <xsl:value-of select="xml-to-json($json-xml, map { 'indent': true() })"/>
    </xsl:template>

</xsl:stylesheet>