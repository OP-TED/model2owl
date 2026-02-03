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
            <xsl:call-template name="classProprietiesFromAssociationsByClass">
                <xsl:with-param name="classElement" select="."/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="propsFromDependencies" as="array(*)">
            <xsl:call-template name="classProprietiesFromDependenciesByClass">
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
            'properties':  $properties,
            'classType': 'definition'
            }"
        />
    </xsl:template>


    <xd:doc>
        <xd:desc>
        Generates details for a referenced class not defined in the module but
        expressed through a set of relations (associations or dependencies)
        defined in the module. This template builds a map(*) similar to the one
        built for defined classes. The affected class is identified as a domain
        for the all relations provided. The generated class will have minimal
        information compared to classes defined by the `classDetails` template.

        The function works on the internal representation of relations (see
        the definition of `f:createRelation`).
        </xd:desc>
        <xd:param name="relations"/>
    </xd:doc>
    <xsl:template name="referencedClassDetails" as="map(*)">
        <xsl:param name="relations" as="element()*"/>
        <xsl:param name="root" as="node()"/>
        <xsl:variable name="className" select="$relations[1]/source/@name"/>
        <xsl:variable name="classURI" select="f:buildURIfromLexicalQName($className)"/>
        <xsl:variable name="classNamePrefix" select="fn:substring-before($className, ':')"/>
        <xsl:variable name="classLabel" select="f:lexicalQNameToWords($className, fn:true())"/>
        <xsl:variable name="classUsage" select="if ($classNamePrefix = $includedPrefixesList) then 'main' else 'supportive'"/>

        <xsl:variable name="connectors">
            <xsl:for-each select="$relations">
                <xsl:sequence select="f:getConnectorByIdRef(./@connectorIdRef, $root)"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="associationRelations"
              select="$relations[@type = 'Association']"/>
        <xsl:variable name="dependencyConnectors"
              select="$connectors/connector[properties/@ea_type = 'Dependency']"/>
        <xsl:variable name="propsFromAssociations" as="array(*)">
            <xsl:choose>
            <xsl:when test="exists($associationRelations)">
                <xsl:call-template name="classProprietiesFromAssociations">
                <xsl:with-param name="associations" select="$associationRelations"/>
                <xsl:with-param name="root" select="$root"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="array{}"/>
            </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="propsFromDependencies" as="array(*)">
            <xsl:choose>
            <xsl:when test="exists($dependencyConnectors)">
                <xsl:call-template name="classProprietiesFromDependencies">
                <xsl:with-param name="dependencies" select="$dependencyConnectors"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="array{}"/>
            </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- Merge properties arrays -->
        <xsl:variable name="propertiesUnsorted" as="array(*)"
            select="array:join(($propsFromAssociations, $propsFromDependencies))"/>

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

        <!-- Emit a single map(*) -->
        <xsl:sequence
            select="
            map{
            'uri':  string($classURI),
            'name': string($className),
            'label':       map{'en': $classLabel},
            'properties':  $properties,
            'classType': 'reference',
            'rawTags': map {'class-usage-scope': $classUsage}
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
                let $parentElement := (root($classElement)//element[@xmi:type = 'uml:Class' and @name = $classParentName])[1],
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
        <xsl:variable name="root" select="root($classElement)"/>

        <xsl:sequence
            select="
            array{
            for $attribute in $attributes
            return 
                let $defaultLabel := f:lexicalQNameToWords($attribute/@name, fn:true()),
                    $attributeLabel := f:getCustomLabelOrDefault($attribute, $defaultLabel),
                    $propertyPrefix := fn:substring-before($attribute/@name, ':'),
                    $attributeRangeCurie := $attribute/properties/@type,
                    $attributeRangeDefaultLabel := f:lexicalQNameToWords($attributeRangeCurie, fn:true()),
                    $targetClassElement := ($root//element[@name = $attributeRangeCurie])[1],
                    $attributeRangeLabel := (
                        if ($targetClassElement) then
                            f:getCustomLabelOrDefault($targetClassElement, $attributeRangeDefaultLabel) 
                        else 
                            $attributeRangeDefaultLabel
                    )
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
                'range_uri':  f:buildURIfromLexicalQName($attributeRangeCurie),
                'range_puri':  f:buildURIfromLexicalQName($attributeRangeCurie),
                'range_curie': string($attributeRangeCurie),
                'range_label': map{'en': $attributeRangeLabel}
                }
                },
                'cardinality': concat($attribute/bounds/@lower, '..', $attribute/bounds/@upper),
                'propertyType': 'datatype property',
                'propertyOrigin': if ($propertyPrefix = $includedPrefixesList) then 'internal' else 'reused',
                'tags': f:tagsToMap(f:getElementTags($attribute))
                }
            }"
        />
    </xsl:template>

    <!-- PROPERTIES FROM ASSOCIATIONS -->
    <xsl:template name="classProprietiesFromAssociationsByClass" as="array(*)">
        <xsl:param name="classElement" as="element()"/>
        
        <xsl:variable name="connectorTypes" select="('Association')"/>
        <xsl:variable name="associations"
            select="f:getOutgoingRelationsByType($classElement, $connectorTypes)//relation"/>

        <xsl:call-template name="classProprietiesFromAssociations">
            <xsl:with-param name="associations" select="$associations"/>
            <xsl:with-param name="root" select="root($classElement)"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="classProprietiesFromAssociations" as="array(*)">
        <xsl:param name="associations"/>
        <xsl:param name="root" as="node()"/>
        <xsl:variable name="haveTheSameDomain"
            select="
                if (count(distinct-values($associations/source/@name)) = 1) then
                    ''
                else
                    fn:error(xs:QName('association-domain'), concat($associations, ' - Associations have different domain classes.'))"/>
        <xsl:sequence
            select="
            array{
            for $association in $associations
            return
                let $defaultLabel := f:lexicalQNameToWords($association/@name, fn:true()),
                    $associationLabel := f:getCustomLabelOrDefaultFromConnector($association, $defaultLabel),
                    $propertyPrefix := fn:substring-before($association/@name, ':'),
                    $associationRangeCurie := $association/target/@name,
                    $associationRangeDefaultLabel := f:lexicalQNameToWords($associationRangeCurie, fn:true()),
                    $targetClassElement := ($root//element[@name = $associationRangeCurie])[1],
                    $associationRangeLabel := (if ($targetClassElement) 
                    then f:getCustomLabelOrDefault($targetClassElement, $associationRangeDefaultLabel) 
                    else $associationRangeDefaultLabel)
                return map{
                'uri':   f:buildURIfromLexicalQName($association/@name),
                'name':  string($association/@name),
                'label': map{'en': $associationLabel},
                'description': map{'en': normalize-space(f:formatDocStringForJson(f:getCombinedDocumentationForRelation($association)))},
                'usage': map{},
                'domain': array{
                map{
                'uri':  f:buildURIfromLexicalQName($association/source/@name),
                'name': string($association/source/@name)
                }
                },
                'range': array{
                map{
                'range_uri':  f:buildURIfromLexicalQName($associationRangeCurie),
                'range_puri':  f:buildURIfromLexicalQName($associationRangeCurie),
                'range_curie': string($associationRangeCurie),
                'range_label': map{'en': $associationRangeLabel}
                }
                },
                'cardinality': string($association/@multiplicity),
                'propertyType': 'object property',
                'propertyOrigin': if ($propertyPrefix = $includedPrefixesList) then 'internal' else 'reused',
                'tags': f:tagsToMap(f:getConnectorTagsByRelation($association, $root))
                }
            }"
        />
    </xsl:template>


    <!-- PROPERTIES FROM DEPENDENCIES → array(*) of map(*) -->
    <xsl:template name="classProprietiesFromDependenciesByClass" as="array(*)">
        <xsl:param name="classElement" as="element()"/>
        <xsl:variable name="dependencies"
            select="
                root($classElement)//connector
                [properties/@ea_type = 'Dependency'
                and source[model/@type = 'Class' and model/@name = $classElement/@name]
                and target[model/@type = 'Enumeration']]"/>
        <xsl:call-template name="classProprietiesFromDependencies">
            <xsl:with-param name="dependencies" select="$dependencies"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="classProprietiesFromDependencies" as="array(*)">
        <xsl:param name="dependencies"/>
        <xsl:variable name="haveTheSameDomain"
            select="
                if (count(distinct-values($dependencies/source/model/@name)) = 1) then
                    ''
                else
                    fn:error(xs:QName('dependency-domain'), concat($dependencies, ' - Dependencies have different domain classes.'))"/>
        <xsl:sequence
            select="
            array{
            for $dependency in $dependencies
            return
                let $dependencyName := $dependency/target/role/@name,
                    $defaultLabel := f:lexicalQNameToWords($dependencyName, fn:true()),
                    $dependencyLabel := f:getCustomLabelOrDefaultFromConnector($dependency, $defaultLabel),
                    $propertyPrefix := fn:substring-before($dependencyName, ':')
                return map{
                'uri':   f:buildURIfromLexicalQName($dependencyName),
                'name':  string($dependencyName),
                'label': map{'en': $dependencyLabel},
                'description': map{'en': normalize-space(f:formatDocStringForJson(f:getCombinedDocumentationForConnector($dependency)))},
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
                'controlled_vocabulary': map{
                    'uri':  f:buildURIfromLexicalQName($dependency/target/model/@name),
                    'name': string($dependency/target/model/@name)
                },
                'cardinality': string($dependency/target/type/@multiplicity),
                'propertyType': 'object property',
                'propertyOrigin': if ($propertyPrefix = $includedPrefixesList) then 'internal' else 'reused',
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