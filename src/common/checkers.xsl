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
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:functx="http://www.functx.com"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#" version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>A set of useful boolean test functions</xd:desc>
    </xd:doc>

    <xsl:import href="utils.xsl"/>
    <xsl:import href="../../config-proxy.xsl"/>

    <xsl:variable name="uppercaseLetters" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xd:doc>
        <xd:desc>Checks any string if it is normalized and it contains only allowed characters </xd:desc>
        <xd:param name="input"/>
    </xd:doc>

    <xsl:function name="f:isValidNormalizedString" as="xs:boolean">
        <xsl:param name="input"/>
        <xsl:sequence select="xs:boolean(fn:matches($input, $allowedStrings))"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Checks any string is a valid Qname </xd:desc>
        <xd:param name="input"/>
    </xd:doc>

    <xsl:function name="f:isValidQname" as="xs:boolean">
        <xsl:param name="input"/>
        <xsl:choose>
            <xsl:when test="fn:contains($input, ':')">
                <xsl:choose>
                    <xsl:when
                        test="
                            (f:isValidNormalizedString($input)) and
                            (fn:string-length(fn:substring-before($input, ':')) > 0) and
                            (fn:string-length(fn:substring-after($input, ':')) > 0)">
                        <xsl:sequence select="fn:true()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="fn:false()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xd:doc>
        <xd:desc>Checks if the first letter of the local segment is lower-case or upper-case </xd:desc>
        <xd:param name="input"/>
    </xd:doc>


    <xsl:function name="f:firstLetterFromQnameLocalSegment" as="xs:string">
        <xsl:param name="input"/>
        <xsl:variable name="localNameFromQName" select="fn:substring-after($input, ':')"/>
        <xsl:variable name="firstLetter" select="fn:substring($localNameFromQName, 1, 1)"/>
        <xsl:variable name="startsWithCapitalizedLetter"
            select="fn:contains($uppercaseLetters, $firstLetter)"/>
        <xsl:choose>
            <xsl:when test="$startsWithCapitalizedLetter = fn:true()">
                <xsl:value-of select="'upper-case'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'lower-case'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xd:doc>
        <xd:desc>Checks if local segment from any Qname is camelCase with first letter upper-cased </xd:desc>
        <xd:param name="input"/>
    </xd:doc>

    <xsl:function name="f:isQNameUpperCasedCamelCase" as="xs:boolean">
        <xsl:param name="input"/>
        <!--        <xsl:variable name="inputIsNormalizedString" select="f:isValidNormalizedString($input)"/>-->
        <xsl:variable name="letterType" select="f:firstLetterFromQnameLocalSegment($input)"/>
        <xsl:choose>
            <xsl:when test="($letterType = 'upper-case') and (f:isValidQname($input))">
                <xsl:sequence select="fn:true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xd:doc>
        <xd:desc>Checks if local segment from any Qname is camelCase with first letter lower-cased </xd:desc>
        <xd:param name="input"/>
    </xd:doc>

    <xsl:function name="f:isQNameLowerCasedCamelCase" as="xs:boolean">
        <xsl:param name="input"/>
        <!--        <xsl:variable name="inputIsNormalizedString" select="f:isValidNormalizedString($input)"/>-->
        <xsl:variable name="letterType" select="f:firstLetterFromQnameLocalSegment($input)"/>

        <xsl:choose>
            <xsl:when test="($letterType = 'lower-case') and (f:isValidQname($input))">
                <xsl:sequence select="fn:true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="fn:false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>


    <xd:doc>
        <xd:desc>Check if the namespace is valid</xd:desc>
        <xd:param name="input"/>
    </xd:doc>

    <xsl:function name="f:isValidNamespace" as="xs:boolean">
        <xsl:param name="input"/>
        <xsl:variable name="prefixToCheck" select="fn:substring-before($input, ':')"/>
        <xsl:sequence
            select="
                if (boolean($prefixToCheck)) then
                    boolean(f:getNamespaceValues($prefixToCheck, $namespacePrefixes))
                else
                    fn:false()
                "
        />
    </xsl:function>

    <xd:doc>
        <xd:desc>Check if the data-type is among the valid ones</xd:desc>
        <xd:param name="input"/>
    </xd:doc>
    <xsl:function name="f:isValidDataType" as="xs:boolean">
        <xsl:param name="input"/>
        <xsl:sequence
            select="
                if (boolean(f:getXsdRdfDataTypeValues($input, $xsdAndRdfDataTypes)))
                then
                    fn:true()
                else
                    fn:false()
                "
        />
    </xsl:function>




    <xd:doc>
        <xd:desc> Check if the attribute type is acceptable as the range of an object property. It
            is eitehr an element of the model of type ('uml:Class', 'uml:Enumeration') or it is
            listed as an exeception in $acceptableTypesForObjectProperties</xd:desc>
        <xd:param name="attributeElement"/>
    </xd:doc>
    <xsl:function name="f:isAttributeTypeValidForObjectProperty">
        <xsl:param name="attributeElement" as="node()"/>
        <!--<xsl:variable name="acceptableElementTypes" select="('uml:Class', 'uml:Enumeration')"/>-->
        <!--f:getElementByName($attributeElement/properties/@type, root($attributeElement))/@xmi:type = $acceptableElementTypes)-->
        <xsl:sequence
            select="
                if ($attributeElement/properties/@type = $acceptableTypesForObjectProperties)
                then
                    fn:true()
                else
                    fn:false()"
        />
    </xsl:function>

    <xd:doc>
        <xd:desc> Check if the attribute type is acceptable as the range of an datatype property. It
            must be listed as a valid XSD datatype or an UML type. </xd:desc>
        <xd:param name="attributeElement"/>
    </xd:doc>
    <xsl:function name="f:isAttributeTypeValidForDatatypeProperty">
        <xsl:param name="attributeElement"/>
        <xsl:sequence
            select="
                if (f:isValidDataType($attributeElement/properties/@type)) then
                    fn:true()
                else
                    fn:false()"
        />
    </xsl:function>


    <xd:doc>
        <xd:desc>Check if the connector stereotype is acceptable</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:function name="f:isConnectorStereotypeValid">
        <xsl:param name="connector" as="node()"/>
        <xsl:choose>
            <xsl:when
                test="boolean($connector/properties/@stereotype) or boolean($connector/*/role/@stereotype)">
                <xsl:sequence
                    select="
                        if (($connector/properties/@ea_type = 'Generalization' and $connector/properties/@stereotype = $stereotypeValidOnGeneralisations or $connector/*/role/@stereotype = $stereotypeValidOnGeneralisations) or
                        ($connector/properties/@ea_type = 'Association' and $connector/properties/@stereotype = $stereotypeValidOnAssociations or $connector/*/role/@stereotype = $stereotypeValidOnGeneralisations) or
                        ($connector/properties/@ea_type = 'Dependency' and $connector/properties/@stereotype = $stereotypeValidOnDependencies or $connector/*/role/@stereotype = $stereotypeValidOnDependencies)
                        )
                        then
                            true()
                        else
                            false()"/>

            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="true()"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>

    <xd:doc>
        <xd:desc>Check if the element stereotype is acceptable</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:function name="f:isElementStereotypeValid">
        <xsl:param name="element" as="node()"/>
        <xsl:sequence
            select="
                if (($element/@xmi:type = 'uml:Class' and
                not(boolean($element/properties/@stereotype)) or
                $element/properties/@stereotype = $stereotypeValidOnClasses) or
                ($element/@xmi:type = 'uml:Enumeration' and
                not(boolean($element/properties/@stereotype)) or
                $element/properties/@stereotype = $stereotypeValidOnEnumerations) or
                ($element/@xmi:type = 'uml:DataType' and
                not(boolean($element/properties/@stereotype)) or
                $element/properties/@stereotype = $stereotypeValidOnDatatypes) or
                ($element/@xmi:type = 'uml:Package' and
                not(boolean($element/properties/@stereotype)) or
                $element/properties/@stereotype = $stereotypeValidOnPackages) or
                ($element/@xmi:type = 'uml:Object' and
                not(boolean($element/properties/@stereotype)) or
                $element/properties/@stereotype = $stereotypeValidOnObjects)
                ) then
                    fn:true()
                else
                    fn:false()
                "
        />
    </xsl:function>

    <xd:doc>
        <xd:desc>Check if the attribute stereotype is acceptable</xd:desc>
        <xd:param name="attribute"/>
    </xd:doc>
    <xsl:function name="f:isAttributeStereotypeValid">
        <xsl:param name="attribute" as="node()"/>
        <xsl:sequence
            select="
                if (not(boolean($attribute/stereotype/@stereotype)) or
                $attribute/stereotype/@stereotype = $stereotypeValidOnAttributes)
                then
                    fn:true()
                else
                    fn:false()"
        />
    </xsl:function>


    <xd:doc>
        <xd:desc>For a given class attribute checks whether is an ongoing connector which has target
            role name similiar to the attribute name</xd:desc>
        <xd:param name="attribute"/>
    </xd:doc>
    <xsl:function name="f:hasAttributeCorrespondingDependecy">
        <xsl:param name="attribute"/>
        <xsl:variable name="classIdRef" select="$attribute/../../@xmi:idref"/>
        <xsl:variable name="targetRoleNamesOfDependencyConnectors"
            select="
                root($attribute)//connector[source/@xmi:idref = $classIdRef and
                properties/@ea_type = 'Dependency' and
                target/model/@type = 'Enumeration']/target/role/string(@name)"/>

        <xsl:variable name="normalisedPossibleCases"
            select="
                for $name in $targetRoleNamesOfDependencyConnectors
                return
                    if (boolean(substring-after($name, ':')))
                    then
                        lower-case(substring-after($name, ':'))
                    else
                        lower-case($name)"/>
        <xsl:variable name="normalisedAttributeName"
            select="
                if (boolean(substring-after($attribute/@name, ':')))
                then
                    lower-case(substring-after($attribute/@name, ':'))
                else
                    lower-case($attribute/@name)"/>

        <xsl:sequence
            select="
                if ($normalisedAttributeName = $normalisedPossibleCases or
                concat('has', $normalisedAttributeName) = $normalisedPossibleCases)
                then
                    true()
                else
                    false()
                "
        />
    </xsl:function>


    <xd:doc>
        <xd:desc>Check is a name prefix is missing</xd:desc>
        <xd:param name="name"/>
    </xd:doc>
    <xsl:function name="f:isNamePrefixMissing">
        <xsl:param name="name"/>
        <xsl:sequence
            select="
                if (fn:contains($name, ':'))
                then
                    fn:false()
                else
                    fn:true()"
        />
    </xsl:function>


    <xd:doc>
        <xd:desc>Check name local segment is missing</xd:desc>
        <xd:param name="name"/>
    </xd:doc>
    <xsl:function name="f:isNameLocalSegmentMissing">
        <xsl:param name="name"/>
        <xsl:variable name="localSegment" select="f:getLocalSegment($name)"/>
        <xsl:sequence select="not(boolean($localSegment))"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Checks regex for prefix</xd:desc>
        <xd:param name="name"/>
    </xd:doc>
    <xsl:function name="f:isInvalidNamePrefix">
        <xsl:param name="name"/>
        <xsl:variable name="prefix" select="fn:substring-before($name, ':')"/>
        <xsl:sequence
            select="
                if (fn:matches($prefix, '^[a-zA-Z0-9-_]+$'))
                then
                    fn:false()
                else
                    fn:true()
                "
        />
    </xsl:function>

    <xd:doc>
        <xd:desc>Checks regex for local segment</xd:desc>
        <xd:param name="name"/>
    </xd:doc>
    <xsl:function name="f:isInvalidLocalSegmentName">
        <xsl:param name="name"/>
        <xsl:variable name="localSegment" select="f:getLocalSegment($name)"/>
        <xsl:sequence
            select="
                if (fn:matches($localSegment, '^[a-zA-Z0-9_\-\s]+$'))
                then
                    fn:false()
                else
                    fn:true()
                "
        />
    </xsl:function>

    <xd:doc>
        <xd:desc>Checks if first character is invalid in the local segment</xd:desc>
        <xd:param name="name"/>
    </xd:doc>

    <xsl:function name="f:isValidFirstCharacterInLocalSegment">
        <xsl:param name="name"/>
        <xsl:variable name="localSegment" select="f:getLocalSegment($name)"/>
        <xsl:sequence
            select="
                if (fn:matches(fn:substring($localSegment, 1, 1), '^[a-zA-Z_]+$')) then
                    fn:true()
                else
                    fn:false()"
        />
    </xsl:function>


    <xd:doc>
        <xd:desc>Checks if the local segment contains delimiters (spaces)</xd:desc>
        <xd:param name="name"/>
    </xd:doc>

    <xsl:function name="f:isDelimitersInLocalSegment">
        <xsl:param name="name"/>
        <xsl:variable name="localSegment" select="f:getLocalSegment($name)"/>
        <xsl:variable name="delimiters" select="'[\s]'"/>
        <xsl:sequence
            select="
                if (fn:matches($localSegment, $delimiters)) then
                    fn:true()
                else
                    fn:false()"
        />
    </xsl:function>


    <xd:doc>
        <xd:desc>Checks if tag name is one of the following cases : namespace:localName
            namespace:localName@en namespace:localName^^xsd:integer namespace:localName&lt;&gt; </xd:desc>
        <xd:param name="tagName"/>
    </xd:doc>

    <xsl:function name="f:isValidTagName">
        <xsl:param name="tagName"/>
        <xsl:sequence
            select="
                if (
                fn:matches($tagName, '^[a-z][-a-z0-9]*:[-a-zA-Z0-9_]+$') or
                fn:matches($tagName, '^[a-z][-a-z0-9]*:[-a-zA-Z0-9_]+@[a-zA-Z]+$') or
                fn:matches($tagName, '^[a-z][-a-z0-9]*:[-a-zA-Z0-9]+\^\^[a-z][-a-z0-9]*:[-a-zA-Z0-9]+$') or
                fn:matches($tagName, '^[a-z][-a-z0-9]*:[-a-zA-Z0-9_]+&lt;&gt;$')) then
                    fn:true()
                else
                    fn:false()"
        />
    </xsl:function>

    <xd:doc>
        <xd:desc>Check if the element or attribute is missing the name</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:function name="f:isElementNameMissing">
        <xsl:param name="element" as="node()"/>
        <xsl:sequence
            select="
                if ($element/@name = '' or not($element/@name))
                then
                    fn:true()
                else
                    fn:false()
                "
        />
    </xsl:function>

    <xd:doc>
        <xd:desc>Check is an element name prefix is missing</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:function name="f:isElementNamePrefixMissing">
        <xsl:param name="element" as="node()"/>
        <xsl:sequence select="f:isNamePrefixMissing($element/@name)"/>
    </xsl:function>


    <xd:doc>
        <xd:desc>Check is an element name local segment is missing</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:function name="f:isElementNameLocalSegmentMissing">
        <xsl:param name="element" as="node()"/>
        <xsl:sequence select="f:isNameLocalSegmentMissing($element/@name)"/>
    </xsl:function>


    <xd:doc>
        <xd:desc>Checks regex for element name prefix</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:function name="f:isInvalidElementNamePrefix">
        <xsl:param name="element"/>
        <xsl:sequence select="f:isInvalidNamePrefix($element/@name)"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Checks regex for element name local segment</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:function name="f:isInvalidElementLocalSegmentName">
        <xsl:param name="element"/>
        <xsl:sequence select="f:isInvalidLocalSegmentName($element/@name)"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Checks if first character is invalid in the element name local segment</xd:desc>
        <xd:param name="element"/>
    </xd:doc>

    <xsl:function name="f:isValidElementFirstCharacterInLocalSegment">
        <xsl:param name="element"/>
        <xsl:sequence select="f:isValidFirstCharacterInLocalSegment($element/@name)"/>
    </xsl:function>


    <xd:doc>
        <xd:desc>Checks if the element name local segment contains delimiters (spaces)</xd:desc>
        <xd:param name="element"/>
    </xd:doc>

    <xsl:function name="f:isDelimitersInElementLocalSegment">
        <xsl:param name="element"/>
        <xsl:variable name="delimiters" select="'[\s]'"/>
        <xsl:sequence select="f:isDelimitersInLocalSegment($element/@name)"/>
    </xsl:function>

    <xd:doc>
        <xd:desc> This function will check if a given list of namespaces are defined in
            enriched-namespaces.xml file. If not all the namespaces were defined it will return a
            list with those namespaces</xd:desc>
        <xd:param name="listOfNamespaces"/>
    </xd:doc>
    <xsl:function name="f:isAllNamespacesDefined">
        <xsl:param name="listOfNamespaces"/>
        <xsl:variable name="definedNamespaces"
            select="($internalNamespacePrefixes/*:prefixes/*:prefix/@name)"/>
        <xsl:variable name="listOfNotDefinedNamespaces"
            select="functx:value-except($listOfNamespaces, $definedNamespaces)"/>
        <xsl:sequence
            select="
                if (count($listOfNotDefinedNamespaces) = 0) then
                    fn:true()
                else
                    $listOfNotDefinedNamespaces"/>

    </xsl:function>

    <xd:doc>
        <xd:desc> This function checks whether an enumeration has a constraint level property (tag)
            assigned and if its value is either "permissive" or "restrictive". The function returns
            a boolean result: - `true()` if tag exists with the expected property and value. -
            `false()` if no matching tag is found or if the enumeration has no tags. </xd:desc>
        <xd:param name="enumeration"/>
    </xd:doc>
    <xsl:function name="f:hasEnumerationAConstraintLevelProperty" as="xs:boolean">
        <xsl:param name="enumeration" as="element()"/>

        <xsl:variable name="enumerationTags" select="f:getElementTags($enumeration)"/>

        <xsl:sequence
            select="
                some $tag in $enumerationTags
                    satisfies ($tag/@name = $cvConstraintLevelProperty and $tag/@value = ('permissive', 'restrictive'))
                "
        />
    </xsl:function>



    <xd:doc>
        <xd:desc>This function check whether the souces or target of the connectors associated with a generalisation are the 
        same and will return true or false </xd:desc>
        <xd:param name="generalisation"/>
    </xd:doc>
    <xsl:function name="f:generalisationConnectorsHasOppositeDirections">
        <xsl:param name="generalisation"/>
        <xsl:variable name="targetConnector"
            select="f:getTargetConnectorFromGeneralisation($generalisation)"/>
        <xsl:variable name="sourceConnector"
            select="f:getSourceConnectorFromGeneralisation($generalisation)"/>
        <xsl:sequence
            select="
                if (($targetConnector/source/model/@name = $sourceConnector/source/model/@name) or 
                ($targetConnector/target/model/@name = $sourceConnector/target/model/@name)) then
                    false()
                else
                    true()"
        />
    </xsl:function>
    
    
    <xd:doc>
        <xd:desc>
            Given a generalisation between two associations (a source association and a target association), 
            this function checks for two possible cases:
            
            1. **Same Target, Different Sources**  
            - If both associations share the **same target** but have **different sources**,  
            a generalisation should exist between the **source of the target association** and  
            the **source of the source association**.  
            - **Example:**  
            ```
            (ex:concept1 → ex:concept2) → (ex:concept3 → ex:concept2)
            ```
            Expected generalisation:  
            ```
            ex:concept1 → ex:concept3
            ```
            
            2. **Same Source, Different Targets**  
            - If both associations share the **same source** but have **different targets**,  
            a generalisation should exist between the **target of the source association** and  
            the **target of the target association**.  
            - **Example:**  
            ```
            (ex:concept1 → ex:concept2) → (ex:concept1 → ex:concept3)
            ```
            Expected generalisation:  
            ```
            ex:concept2 → ex:concept3
            ```
            3. **Different Sources, Different Targets**  
            - If both associations have **different sources** and **different targets**,  
            **two** generalisations must exist:  
            1. Between the **source of the target association** and the **source of the source association**.  
            2. Between the **target of the source association** and the **target of the target association**.  
            - **Example:**  
            ```
            (ex:concept1 → ex:concept2) → (ex:concept3 → ex:concept4)
            ```
            **Expected generalisations:**  
            ```
            ex:concept1 → ex:concept3
            ex:concept2 → ex:concept4
            ```
        </xd:desc>
        <xd:param name="generalisation"/>
    </xd:doc>
    <xsl:function name="f:generalisationMissingOrIncorrect">
        <xsl:param name="generalisation"/>
        <xsl:variable name="targetConnector"
            select="f:getTargetConnectorFromGeneralisation($generalisation)"/>
        <xsl:variable name="sourceConnector"
            select="f:getSourceConnectorFromGeneralisation($generalisation)"/>

        <!-- Extract target model names -->
        <xsl:variable name="targetFromTargetConnector" select="$targetConnector/target/model/@name"/>
        <xsl:variable name="targetFromSourceConnector" select="$sourceConnector/target/model/@name"/>

        <!-- Extract source model names -->
        <xsl:variable name="sourceFromTargetConnector" select="$targetConnector/source/model/@name"/>
        <xsl:variable name="sourceFromSourceConnector" select="$sourceConnector/source/model/@name"/>
        <!-- Case 1: Same Target, Different Sources -->
        <xsl:if test="$targetFromTargetConnector = $targetFromSourceConnector">
            <xsl:sequence
                select="not(fn:exists(root($generalisation)//connector[./properties/@ea_type = 'Generalization' and ./source/model/@name = $sourceFromSourceConnector and ./target/model/@name = $sourceFromTargetConnector]))"
            />
        </xsl:if>
        <!-- Case 2: Same Source, Different Targets -->
        <xsl:if test="$sourceFromTargetConnector = $sourceFromSourceConnector">
            <xsl:sequence
                select="not(fn:exists(root($generalisation)//connector[./properties/@ea_type = 'Generalization' and ./source/model/@name = $targetFromSourceConnector and ./target/model/@name = $targetFromTargetConnector]))"
            />
        </xsl:if>

        <!-- Case 3: Different Sources, Different Targets -->
        <xsl:if
            test="$sourceFromTargetConnector != $sourceFromSourceConnector and $targetFromTargetConnector != $targetFromSourceConnector">
            <xsl:sequence
                select="
                    not(
                    fn:exists(root($generalisation)//connector[
                    ./properties/@ea_type = 'Generalization'
                    and ./source/model/@name = $sourceFromSourceConnector
                    and ./target/model/@name = $sourceFromTargetConnector
                    ])
                    and
                    fn:exists(root($generalisation)//connector[
                    ./properties/@ea_type = 'Generalization'
                    and ./source/model/@name = $targetFromSourceConnector
                    and ./target/model/@name = $targetFromTargetConnector
                    ])
                    )"
            />
        </xsl:if>


    </xsl:function>
    
    
    
    



</xsl:stylesheet>