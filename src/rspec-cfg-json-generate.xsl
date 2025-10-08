<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:f="http://https://github.com/costezki/model2owl#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn array owl rdf rdfs dct f skos"
    version="3.0">
    
    <xsl:output method="text" media-type="application/json" indent="no"/>

    <xsl:import href="common/checkers.xsl"/>
    <xsl:import href="common/fetchers.xsl"/>
    

    <xsl:template match="/">
        <!-- compose root map -->
        <xsl:variable name="rootMap" as="map(*)"
            select="map{
                'config': map{
                    'referenceTagName': string($referenceTagName),
                    'propertyReferenceRespecLabel': string($propertyReferenceRespecLabel),
                    'classReferenceRespecLabel': string($classReferenceRespecLabel),
                    'showReferencesInRespec': boolean($showReferencesInRespec),
                    'mandatoryStatusTagName': string($mandatoryStatusTagName),
                    'usageNoteTagName': string($usageNoteTagName)
                }
            }"/>

        <!-- output -->
        <xsl:value-of
            select="serialize($rootMap, map{'method':'json','indent':true()})"
        />
    </xsl:template>

</xsl:stylesheet>