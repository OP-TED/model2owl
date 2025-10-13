<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc fn f functx array map"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:functx="http://www.functx.com"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:f="http://https://github.com/costezki/model2owl#" version="3.0">

    <xsl:import href="../common/utils.xsl"/>
    <xsl:import href="../common/formatters.xsl"/>


    <xd:doc>
        <xd:desc>Get custom label from tags if available</xd:desc>
        <xd:param name="element"/>
        <xd:param name="defaultLabel"/>
    </xd:doc>
    <xsl:function name="f:getCustomLabelOrDefault" as="xs:string">
        <xsl:param name="element" as="element()"/>
        <xsl:param name="defaultLabel" as="xs:string"/>
        
        <xsl:variable name="tags" select="f:getElementTags($element)"/>
        
        <!-- Check for custom term label tag if available -->
        <xsl:variable name="customLabel" select="
            if ($tags[@name = concat($customTermLabelTagName, '@en')]) then
                ($tags[@name = concat($customTermLabelTagName, '@en')]/@value)[1]
            else if ($tags[@name = $customTermLabelTagName]) then
                ($tags[@name = $customTermLabelTagName]/@value)[1]
            else
                ''
        "/>
        
        <xsl:sequence select="if (string-length($customLabel) > 0) then string($customLabel) else $defaultLabel"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Get custom label from connector tags if available</xd:desc>
        <xd:param name="connector"/>
        <xd:param name="defaultLabel"/>
    </xd:doc>
    <xsl:function name="f:getCustomLabelOrDefaultFromConnector" as="xs:string">
        <xsl:param name="connector" as="element()"/>
        <xsl:param name="defaultLabel" as="xs:string"/>
        
        <xsl:variable name="tags" select="f:getConnectorTags($connector)"/>
        
        <!-- Check for custom term label tag if available -->
        <xsl:variable name="customLabel" select="
            if ($tags[@name = concat($customTermLabelTagName, '@en')]) then
                ($tags[@name = concat($customTermLabelTagName, '@en')]/@value)[1]
            else if ($tags[@name = $customTermLabelTagName]) then
                ($tags[@name = $customTermLabelTagName]/@value)[1]
            else
                ''
        "/>
        
        <xsl:sequence select="if (string-length($customLabel) > 0) then string($customLabel) else $defaultLabel"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Convert tags to a map format for JSON output</xd:desc>
        <xd:param name="tags"/>
    </xd:doc>
    <xsl:function name="f:tagsToMap" as="map(*)">
        <xsl:param name="tags"/>
        <xsl:choose>
            <xsl:when test="exists($tags)">
                <xsl:variable name="tagEntries" as="map(*)*">
                    <xsl:for-each select="$tags">
                        <xsl:sequence select="map{string(./@name): string(./@value)}"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:sequence select="map:merge($tagEntries)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="map{}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

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
        <xsl:variable name="propertiesUnsorted" as="array(*)"
            select="array:join(($propsFromAttributes, $propsFromAssociations, $propsFromDependencies))"/>

        <!-- Sort properties alphabetically by label.en -->
        <xsl:variable name="properties" as="array(*)">
            <xsl:variable name="propertiesSequence" as="map(*)*">
                <xsl:for-each select="1 to array:size($propertiesUnsorted)">
                    <xsl:sequence select="array:get($propertiesUnsorted, .)"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="sortedProperties" as="map(*)*">
                <xsl:for-each select="$propertiesSequence">
                    <xsl:sort select="map:get(., 'label')?en" order="ascending"/>
                    <xsl:sequence select="."/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="array{$sortedProperties}"/>
        </xsl:variable>

        <!-- Get label (use custom label from tag if available, otherwise generate from name) -->
        <xsl:variable name="classLabel" select="f:getCustomLabelOrDefault(., f:lexicalQNameToWords($className, fn:true()))"/>

        <!-- Emit a single map(*) -->
        <xsl:sequence
            select="
            map{
            'uri':  string($classURI),
            'name': string($className),
            'rawTags': map {'class-usage-scope': $classUsage},
            'tags': f:tagsToMap(f:getElementTags(.)),
            'label':       map{'en': $classLabel},
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
            return
                let $parentElement := root($classElement)//element[@xmi:type = 'uml:Class' and @name = $classParentName],
                    $defaultLabel := f:lexicalQNameToWords($classParentName, fn:true()),
                    $parentLabel := if ($parentElement) then f:getCustomLabelOrDefault($parentElement, $defaultLabel) else $defaultLabel
                return map{
                'scoped_uri':   f:buildURIfromLexicalQName($classParentName),
                'name':  string($classParentName),
                'label': map{'en': $parentLabel}
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
            return 
                let $defaultLabel := f:lexicalQNameToWords($attribute/@name, fn:true()),
                    $attributeLabel := f:getCustomLabelOrDefault($attribute, $defaultLabel)
                return map{
                'uri':   f:buildURIfromLexicalQName($attribute/@name),
                'name':  string($attribute/@name),
                'label': map{'en': $attributeLabel},
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
                'range_uri':  f:buildURIfromLexicalQName($attribute/properties/@type),
                'range_puri':  f:buildURIfromLexicalQName($attribute/properties/@type),
                'range_curie': string($attribute/properties/@type),
                'range_label': map{'en': f:lexicalQNameToWords($attribute/properties/@type, fn:true())}
                }
                },
                'cardinality': concat($attribute/bounds/@lower, '..', $attribute/bounds/@upper),
                'tags': f:tagsToMap(f:getElementTags($attribute))
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
            return
                let $defaultLabel := f:lexicalQNameToWords($association/target/role/@name, fn:true()),
                    $associationLabel := f:getCustomLabelOrDefaultFromConnector($association, $defaultLabel)
                return map{
                'uri':   f:buildURIfromLexicalQName($association/target/role/@name),
                'name':  string($association/target/role/@name),
                'label': map{'en': $associationLabel},
                'description': map{'en': normalize-space(f:formatDocStringForJson(f:getDocumentationForConnector($association)))},
                'usage': map{},
                'domain': array{
                map{
                'uri':  f:buildURIfromLexicalQName($association/source/model/@name),
                'name': string($association/source/model/@name)
                }
                },
                'range': array{
                map{
                'range_uri':  f:buildURIfromLexicalQName($association/target/model/@name),
                'range_puri':  f:buildURIfromLexicalQName($association/target/model/@name),
                'range_curie': string($association/target/model/@name),
                'range_label': map{'en': f:lexicalQNameToWords($association/target/model/@name, fn:true())}
                }
                },
                'cardinality': string($association/target/type/@multiplicity),
                'tags': f:tagsToMap(f:getConnectorTags($association))
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
            return
                let $defaultLabel := f:lexicalQNameToWords($dependency/target/role/@name, fn:true()),
                    $dependencyLabel := f:getCustomLabelOrDefaultFromConnector($dependency, $defaultLabel)
                return map{
                'uri':   f:buildURIfromLexicalQName($dependency/target/role/@name),
                'name':  string($dependency/target/role/@name),
                'label': map{'en': $dependencyLabel},
                'description': map{'en': normalize-space(f:formatDocStringForJson(f:getDocumentationForConnector($dependency)))},
                'usage': map{},
                'domain': array{
                map{
                'uri':  f:buildURIfromLexicalQName($dependency/source/model/@name),
                'name': string($dependency/source/model/@name)
                }
                },
                'range': array{
                map{
                'range_uri':  f:buildURIfromLexicalQName('skos:Concept'),
                'range_puri':  f:buildURIfromLexicalQName('skos:Concept'),
                'range_curie': 'skos:Concept',
                'range_label': map{'en': 'Concept'}
                }
                },
                'cardinality': string($dependency/target/type/@multiplicity),
                'tags': f:tagsToMap(f:getConnectorTags($dependency))
                }
            }"
        />
    </xsl:template>

    <xsl:template name="datatypesDetails" as="map(*)">
        <xsl:variable name="datatypeQName" select="./@name"/>
        <xsl:variable name="datatypeUri" select="string(f:buildURIfromLexicalQName($datatypeQName))"/>
        <xsl:variable name="datatypeLabel" select="string(f:lexicalQNameToWords($datatypeQName, fn:true()))"/>
        <xsl:variable name="datatypeDescription" select="string(./properties/@documentation)"/>
        <xsl:sequence select="
            map{
            'label':       map{'en': $datatypeLabel},
            'description': map{'en': $datatypeDescription},
            'uri':         string($datatypeUri),
            'scopeduri':   string($datatypeQName)
            }"/>
</xsl:template>



</xsl:stylesheet>