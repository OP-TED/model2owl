<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn f functx array"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:functx="http://www.functx.com"
    xmlns:f="http://https://github.com/costezki/model2owl#" version="3.0">

    <xsl:import href="../common/utils.xsl"/>
    <xsl:import href="../common/formatters.xsl"/>


    <xsl:template name="classDetails" as="map(*)">
        <xsl:variable name="className" select="./@name"/>
        <xsl:variable name="classURI" select="f:buildURIFromElement(.)"/>
        <xsl:variable name="classNamePrefix" select="fn:substring-before($className, ':')"/>
        <xsl:variable name="classUsage" select="if ($classNamePrefix = $includedPrefixesList) then 'main' else 'supportive'"/>
        <xsl:variable name="doc"
            select="normalize-space(f:formatDocStringForJson(./properties/@documentation))"/>

        <!-- Build parents and properties as arrays -->
        <xsl:variable name="parents" as="array(*)">
            <xsl:call-template name="classParents">
                <xsl:with-param name="classElement" select="."/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="propsFromAttributes" as="array(*)">
            <xsl:call-template name="classProprietiesFromAttributes">
                <xsl:with-param name="classElement" select="."/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="propsFromAssociations" as="array(*)">
            <xsl:call-template name="classProprietiesFromAssociations">
                <xsl:with-param name="classElement" select="."/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="propsFromDependencies" as="array(*)">
            <xsl:call-template name="classProprietiesFromDependencies">
                <xsl:with-param name="classElement" select="."/>
            </xsl:call-template>
        </xsl:variable>

        <!-- Merge properties arrays -->
        <xsl:variable name="properties" as="array(*)"
            select="array:join(($propsFromAttributes, $propsFromAssociations, $propsFromDependencies))"/>

        <!-- Emit a single map(*) -->
        <xsl:sequence
            select="
            map{
            'uri':  string($classURI),
            'name': string($className),
            'rawTags': map {'class-usage-scope': $classUsage},
            'label':       map{'en': f:lexicalQNameToWords($className, fn:true())},
            'description': map{'en': $doc},
            'usage':       map{'en': $doc},
            'parents':     $parents,
            'properties':  $properties
            }"
        />
    </xsl:template>


    <xsl:template name="classParents" as="array(*)">
        <xsl:param name="classElement" as="element()"/>

        <xsl:variable name="classParentsNames"
            select="
                root($classElement)//connector
                [properties/@ea_type = 'Generalization'
                and source[model/@type = 'Class' and model/@name = $classElement/@name]
                and target[model/@type = 'Class']]
                /target/model/@name"/>

        <xsl:sequence
            select="
            array{
            for $classParentName in $classParentsNames
            return map{
            'scoped_uri':   f:buildURIfromLexicalQName($classParentName),
            'name':  string($classParentName),
            'label': map{'en': f:lexicalQNameToWords($classParentName, fn:true())}
            }
            }"
        />
    </xsl:template>


    <!-- PROPERTIES FROM ATTRIBUTES → array(*) of map(*) -->
    <xsl:template name="classProprietiesFromAttributes" as="array(*)">
        <xsl:param name="classElement" as="element()"/>
        <xsl:variable name="attributes" select="$classElement/attributes/attribute"/>

        <xsl:sequence
            select="
            array{
            for $attribute in $attributes
            return map{
            'uri':   f:buildURIfromLexicalQName($attribute/@name),
            'name':  string($attribute/@name),
            'label': map{'en': f:lexicalQNameToWords($attribute/@name, fn:true())},
            'description': map{'en': normalize-space(f:formatDocStringForJson($attribute/documentation/@value))},
            'usage': map{}, 
            'domain': array{
            map{
            'uri':  f:buildURIfromLexicalQName($classElement/@name),
            'name': string($classElement/@name)
            }
            },
            'range': array{
            map{
            'uri':  f:buildURIfromLexicalQName($attribute/properties/@type),
            'name': string($attribute/properties/@type)
            }
            },
            'cardinality': concat($attribute/bounds/@lower, '..', $attribute/bounds/@upper)
            }
            }"
        />
    </xsl:template>


    <!-- PROPERTIES FROM ASSOCIATIONS -->
    <xsl:template name="classProprietiesFromAssociations" as="array(*)">
        <xsl:param name="classElement" as="element()"/>
        <xsl:variable name="associations"
            select="
                root($classElement)//connector
                [properties/@ea_type = 'Association'
                and source[model/@type = 'Class' and model/@name = $classElement/@name]
                and target[model/@type = 'Class']]"/>

        <xsl:sequence
            select="
            array{
            for $association in $associations
            return map{
            'uri':   f:buildURIfromLexicalQName($association/target/role/@name),
            'name':  string($association/target/role/@name),
            'label': map{'en': f:lexicalQNameToWords($association/target/role/@name, fn:true())},
            'description': map{'en': normalize-space(f:formatDocStringForJson($association/target/documentation/@value))},
            'usage': map{},
            'domain': array{
            map{
            'uri':  f:buildURIfromLexicalQName($association/source/model/@name),
            'name': string($association/source/model/@name)
            }
            },
            'scopedrange': array{
            map{
            'range_uri':  f:buildURIfromLexicalQName($association/target/model/@name),
            'range_puri':  f:buildURIfromLexicalQName($association/target/model/@name),
            'range_label': map{'en': string($association/target/model/@name)}
            }
            },
            'cardinality': string($association/target/type/@multiplicity)
            }
            }"
        />
    </xsl:template>


    <!-- PROPERTIES FROM DEPENDENCIES → array(*) of map(*) -->
    <xsl:template name="classProprietiesFromDependencies" as="array(*)">
        <xsl:param name="classElement" as="element()"/>
        <xsl:variable name="dependencies"
            select="
                root($classElement)//connector
                [properties/@ea_type = 'Dependency'
                and source[model/@type = 'Class' and model/@name = $classElement/@name]
                and target[model/@type = 'Enumeration']]"/>

        <xsl:sequence
            select="
            array{
            for $dependency in $dependencies
            return map{
            'uri':   f:buildURIfromLexicalQName($dependency/target/role/@name),
            'name':  string($dependency/target/role/@name),
            'label': map{'en': f:lexicalQNameToWords($dependency/target/role/@name, fn:true())},
            'description': map{'en': normalize-space(f:formatDocStringForJson($dependency/target/documentation/@value))},
            'usage': map{},
            'domain': array{
            map{
            'uri':  f:buildURIfromLexicalQName($dependency/source/model/@name),
            'name': string($dependency/source/model/@name)
            }
            },
            'range': array{
            map{
            'uri':  f:buildURIfromLexicalQName('skos:Concept'),
            'name': 'skos:Concept'
            }
            },
            'cardinality': string($dependency/target/type/@multiplicity)
            }
            }"
        />
    </xsl:template>

    <xsl:template name="datatypesDetails" as="map(*)">
        <xsl:variable name="datatypeQName" select="./@name"/>
        <xsl:variable name="datatypeUri" select="string(f:buildURIfromLexicalQName($datatypeQName))"/>
        <xsl:variable name="datatypeLabel" select="string(f:lexicalQNameToWords($datatypeQName, fn:true()))"/>
        <xsl:variable name="datatypeDescription" select="./properties/@documentation"/>
        <xsl:sequence select="
            map{
            'label':       map{'en': $datatypeLabel},
            'description': map{'en': $datatypeDescription},
            'uri':         string($datatypeUri),
            'scopeduri':   string($datatypeQName)
            }"/>
</xsl:template>



</xsl:stylesheet>