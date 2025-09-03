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

    
    <xsl:import href="rspec/rspec-generation.xsl"/>
    <xsl:import href="common/checkers.xsl"/>
    <xsl:import href="common/fetchers.xsl"/>
    

    <xsl:template match="/">
        <!-- metadata as map(*) -->
        <xsl:variable name="metadataMap" as="map(*)">
            <xsl:call-template name="metadata"/>
        </xsl:variable>

        <!-- prefixes as array(*) -->
        <xsl:variable name="prefixesArray" as="array(*)">
            <xsl:call-template name="usedPrefixes"/>
        </xsl:variable>

        <!-- classes as array(*) via mode that returns map(*) per class -->
        <xsl:variable name="classMaps" as="map(*)*">
            <xsl:apply-templates
                select="/xmi:XMI/xmi:Extension/elements/element[@xmi:type = 'uml:Class']"
                mode="class-json"/>

        </xsl:variable>

        <!-- datatypes as array(*) via mode that returns map(*) per datatype -->
        <!-- Combine UML DataTypes and distinct class attribute types -->
        <xsl:variable name="umlDatatypeMaps" as="map(*)*">
            <xsl:apply-templates
                select="/xmi:XMI/xmi:Extension/elements/element[@xmi:type = 'uml:DataType']"
                mode="datatype-json"/>
        </xsl:variable>
        
        <!-- Get distinct class attribute types -->
        <xsl:variable name="classAttributeTypeNames" select="f:getDistinctClassAttributeTypes(root(.))"/>
        <xsl:variable name="root" select="root(.)"/>
        <xsl:variable name="classAttributeTypeMaps" as="map(*)*">
            <xsl:for-each select="$classAttributeTypeNames">
                <xsl:variable name="attributeTypeName" select="."/>
                <!-- Only include if not already in UML DataTypes -->
                <xsl:if test="not($root//element[@xmi:type = 'uml:DataType' and @name = $attributeTypeName])">
                    <xsl:sequence select="map{
                        'label':       map{'en': f:lexicalQNameToWords($attributeTypeName, fn:true())},
                        'description': map{'en': ''},
                        'uri':         string(f:buildURIfromLexicalQName($attributeTypeName)),
                        'scopeduri':   string($attributeTypeName)
                    }"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        
        <!-- Combine both into single sequence -->
        <xsl:variable name="datatypeMaps" as="map(*)*" select="($umlDatatypeMaps, $classAttributeTypeMaps)"/>

        <xsl:variable name="classesArray" as="array(*)" select="array{$classMaps}"/>
        <xsl:variable name="datatypesArray" as="array(*)" select="array{$datatypeMaps}"/>

        <!-- compose root map -->
        <xsl:variable name="rootMap" as="map(*)"
            select="map{
            'metadata':  $metadataMap,
            'prefixes':  $prefixesArray,
            'classes':   $classesArray,
            'datatypes': $datatypesArray
            }"/>

        <!-- output -->
        <xsl:value-of
            select="replace(
            serialize($rootMap, map{'method':'json','indent':true()}),
            '\\/',                        
            '/'                           
            )"
        />
    </xsl:template>
    
 
    <xsl:template name="usedPrefixes" as="array(*)">
        <xsl:variable name="allPrefixNames" select="f:getAllNamespacesUsed(root(.))"/>
        <!-- Build sequence of maps -->
        <xsl:variable name="prefixMapSequence" as="map(*)*">
            <xsl:for-each select="$allPrefixNames">
                <xsl:variable name="prefixName"  select="."/>
                <xsl:variable name="prefixUri"
                    select="$namespacePrefixes/*:prefixes/*:prefix/@value[../@name = $prefixName]"/>
                <xsl:sequence select="map{
                    'uri':  string($prefixUri),
                    'name': string($prefixName)
                    }"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:sequence select="array{ $prefixMapSequence }"/>
    </xsl:template>
    
    <!-- =========================================================
       METADATA: return map(*)
       ========================================================= -->
    <xsl:template name="metadata" as="map(*)">
        <xsl:sequence select="
            map{
            'title':        string($ontologyTitleCore),
            
            'navigation':   map{
            'self': string($navigationSelf),
            'prev': string($navigationPrev),
            'next': string($navigationNext)
            },
            
            'issued':               string($issuedDate),
            'standaardregisterurl': string($standaardregisterURL),
            'repositoryurl':        string($repositoryURL),
            'changelogurl':         string($changelogURL),
            'feedbackurl':          string($feedbackURL),
            'status':               string($status),
            'statuslabel':          string($statusLabel),
            
            'documentconfig': map{
            'statuslabel':        string($documentConfigStatusLabel),
            'editorDocumentroot': string($documentConfigEditorDocumentRoot)
            },
            
            'license':     string($license),
            'filename':    string($filename),
            
            'description': fn:normalize-space(f:formatDocStringForJson($respecDescription)),
            
            'dependencies': $dependencies,
            'contributors':      array{ for $contributor in $contributors return $contributor }
            }"/>
    </xsl:template>
    
    <xsl:template match="element[@xmi:type='uml:Class']" mode="class-json" as="map(*)">
        <xsl:call-template name="classDetails"/>
    </xsl:template>
    
    <xsl:template match="element[@xmi:type='uml:DataType']" mode="datatype-json" as="map(*)">
        <xsl:call-template name="datatypesDetails"/>
    </xsl:template>
    
</xsl:stylesheet>