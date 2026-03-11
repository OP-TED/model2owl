<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:f="http://https://github.com/costezki/model2owl#"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs xd xmi xsl fn f"
    version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 24, 2025</xd:p>
            <xd:p>This module defines how selected XMI elements representing
            datatypes are transformed into JSON-LD context</xd:p>
        </xd:desc>
    </xd:doc>


    <xsl:import href="../common/checkers.xsl"/>
    <xsl:import href="common-jsonld-context.xsl"/>

    <xsl:output method="xml" encoding="UTF-8"/>

    <xd:doc>
        <xd:desc>
            Rule D.02 Datatype — in JSON-LD context layer. 
            Specify a term for each UML datatype by assigning an absolute URI of
            the datatype to its name. Create the term mapping as a top-level
            entry of the context object.

            Rule D.08. Enumeration — in JSON-LD context layer.
            Specify a term for each UML enumeration by assigning an absolute URI
            of the enumeration to its name. Create the term mapping as a
            top-level entry of the context object.
        </xd:desc>
    </xd:doc>
    <xsl:template match="element[@xmi:type = ('uml:Enumeration', 'uml:DataType')]">
        <xsl:if test="not(f:isExcludedByStatus(.))">
            <xsl:variable name="elemPrefix" select="f:getPrefix(./@name)"/>
            <!-- Check if the UML element should be processed -->
            <xsl:if test="$generateReusedConceptsJSONLDcontext or $elemPrefix = $includedPrefixesList">
                <xsl:call-template name="simpleElementDeclaration"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>