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
    
    
    
    <xsl:import href="html-model-glossary/fragments/header.xsl"/>
    <xsl:import href="html-model-glossary/fragments/footer.xsl"/>
    <xsl:import href="html-model-glossary/glossary.xsl"/>
    
    
    <xsl:template match="/">
        
        <html lang="en">
            <xsl:call-template name="head"/>
            <xsl:choose>
                <xsl:when
                    test="fn:namespace-uri(//*:Model) = $supportedUmlVersions and
                    fn:namespace-uri(//*:XMI) = 'http://www.omg.org/spec/XMI/20131001'">
                    <body>
                        <main class="container-fluid">
                            <div id="toc" class="tocify">
                                <div class="text-center">
                                    <p>
                                        <strong>Table of contents</strong>
                                    </p>
                                </div>
                            </div>
                            <div class="container">
                            <xsl:call-template name="glossary"/>
                            </div>
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
                            <li>uml="<xsl:sequence select='fn:string-join($supportedUmlVersions, " | ")'/>'"</li>
                        </ul>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </html>
    </xsl:template>
</xsl:stylesheet>


