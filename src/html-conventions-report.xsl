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
    <xsl:import href="html-conventions-lib/data-type-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/object-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/packages-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/association-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/generalization-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/dependency-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/realisation-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/general-html-conventions.xsl"/>
    <xsl:import href="html-conventions-lib/info-box.xsl"/>
    <xsl:import href="html-conventions-lib/connectors-with-same-name.xsl"/>
    <xsl:import href="html-conventions-lib/class-attributes-with-same-name.xsl"/>
    <xsl:import href="html-conventions-lib/fragments/header.xsl"/>
    <xsl:import href="html-conventions-lib/fragments/introduction.xsl"/>
    <xsl:import href="html-conventions-lib/fragments/footer.xsl"/>
    <xsl:variable name="reportType" select="'HTML'"/>
    
    <xsl:template match="/">
        
        <html lang="en">
            <xsl:call-template name="head"/>
            <xsl:choose>
                <xsl:when
                    test="fn:namespace-uri(//*:Model) = $supportedUmlVersions and
                    fn:namespace-uri(//*:XMI) = 'http://www.omg.org/spec/XMI/20131001'">
                    <body>
                        <xsl:call-template name="title-header"/>
                        <main>
                            <div id="toc" class="tocify">
                                <div class="text-center">
                                    <p>
                                        <strong>Table of contents</strong>
                                    </p>
                                </div>
                            </div>
                            <div id="filters" class="tocify">
                                <p class="text-center">
                                    <strong>Constrain type</strong>
                                </p>
                                <div class="checkbox">
                                    <label for="filter-info">
                                        <input type="checkbox" value="infos" id="filter-info"/>
                                        Info</label>
                                </div>
                                <div class="checkbox">

                                    <label for="filter-warning">
                                        <input type="checkbox" value="warnings" id="filter-warning"
                                        /> Warning</label>
                                </div>
                                <div class="checkbox">
                                    <label for="filter-error">
                                        <input type="checkbox" value="errors" id="filter-error"/>
                                        Error</label>
                                </div>
                                <input type="button" class="filter-button btn btn-primary"
                                    value="Apply filter"/>
                            </div>
                            <xsl:call-template name="abstract"/>
                            <xsl:call-template name="infoBox"/>
                            <xsl:apply-templates/>
                            <xsl:call-template name="connectorsWithSameName"/>
                            <xsl:call-template name="classAttributesWithSameName"/>
                            <xsl:call-template name="generalConventions"/>
                        </main>
                        <xsl:call-template name="footer"/>
                    </body>
                </xsl:when>
                <xsl:otherwise>
                    <div class="alert alert-danger text-center">
                        <i class="fa fa-times-circle error" style="font-size: 60px;"/>
                        <h1 class="counter-skip">Wrong model version detected. </h1>
                        <br/>
                            <p>Please make sure that the XMI file uses XMI version 2.5.1 and UML version 2.5.x (either 2.5 or 2.5.1).</p> 
                        <p>The namespaces to check:</p>
                        <ul>
                            <li>xmi="http://www.omg.org/spec/XMI/20131001"</li>
                            <li>uml="<xsl:sequence select='fn:string-join($supportedUmlVersions, " | ")'/>"</li>
                        </ul>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </html>
    </xsl:template>
</xsl:stylesheet>


