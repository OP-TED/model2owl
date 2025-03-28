<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    
    
    
    <xsl:import href="common/checkers.xsl"/>
    <xsl:import href="html-conventions-lib/html-selectors.xsl"/>
    <xsl:import href="html-conventions-lib/class-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/class-attributes-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/enumeration-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/data-type-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/object-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/packages-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/association-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/generalization-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/dependency-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/realisation-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/general-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/connectors-with-same-name.xsl"/>
    <xsl:import href="html-conventions-lib/class-attributes-with-same-name.xsl"/>
    <xsl:variable name="reportType" select="'SVRL'"/>
    
    <xsl:template match="/">
        <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"  xmlns:f="http://https://github.com/costezki/model2owl#">

            <xsl:choose>
                <xsl:when
                    test="fn:namespace-uri(//*:Model) = $supportedUmlVersions and
                    fn:namespace-uri(//*:XMI) = 'http://www.omg.org/spec/XMI/20131001'">
            
                    <xsl:apply-templates/>
                    <xsl:call-template name="connectorsWithSameName"/>
                    <xsl:call-template name="classAttributesWithSameName"/>
                    <xsl:call-template name="generalConventions"/>
                </xsl:when>
                <xsl:otherwise>
                    <svrl:fired-rule context="/" />
                    <svrl:failed-assert test="/*/namespace::xmi = http://www.omg.org/spec/XMI/20131001 and /*/namespace::uml = $supportedUmlVersions">
                        <svrl:text>Wrong model version detected.Please make sure that the XMI file uses XMI version 2.5.1 and UML version 2.5.x (either 2.5 or 2.5.1).
                            The namespaces to check: uml="<xsl:sequence select='fn:string-join($supportedUmlVersions, " | ")'/>" and xmi="http://www.omg.org/spec/XMI/20131001"</svrl:text>
                    </svrl:failed-assert>
                </xsl:otherwise>
            </xsl:choose>
        </svrl:schematron-output>
    </xsl:template>
</xsl:stylesheet>


