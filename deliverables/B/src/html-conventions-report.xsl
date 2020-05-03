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
    <xsl:output method="html" indent="yes"/>
    
    
    
    <xsl:import href="common/checkers.xsl"/>
    <xsl:import href="html-conventions-lib/html-selectors.xsl"/>
    <xsl:import href="html-conventions-lib/class-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/class-attributes-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/enumeration-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/enumeration-items-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/data-type-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/packages-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/association-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/generalization-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/dependency-html-conventions.xsl"/>
    
    
    <xsl:import href="html-conventions-lib/fragments/header.xsl"/>
    <xsl:import href="html-conventions-lib/fragments/introduction.xsl"/>
    <xsl:import href="html-conventions-lib/fragments/footer.xsl"/>
    
    
    <xsl:template match="/">
        <html lang="en">
            <xsl:call-template name="head"/>
            <body>
                <xsl:call-template name="title-header"/>
                <main>
                    <div id="toc" class="tocify"></div>
                    <xsl:call-template name="abstract"/>
                    <xsl:apply-templates/>
                </main>
                <xsl:call-template name="footer"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

