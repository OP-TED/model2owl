<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd xsl uml xmi umldi fn"
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI" xmlns:functx="http://www.functx.com"
    xmlns:f="http://https://github.com/costezki/model2owl#" version="3.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 22, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>A set of useful utilities</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:import href="../../config-proxy.xsl"/>
    <xsl:import href="fetchers.xsl"/>
    <xsl:import href="functx-1.0.1-doc.xsl"/>

    <xd:doc>
        <xd:desc> Lookup a data-type in the xsd and rdf accepted data-type document (usually an
            external file with xsd and rdf data-types definitions) and return false or the data-type
            name if it exists</xd:desc>
        <xd:param name="qname"/>
        <xd:param name="dataTypesDefinitions"/>
    </xd:doc>
    <xsl:function name="f:getXsdRdfDataTypeValues" as="xs:string">
        <xsl:param name="qname"/>
        <xsl:param name="dataTypesDefinitions"/>

        <xsl:sequence
            select="string($dataTypesDefinitions/*:datatypes/*:datatype[@qname = $qname]/@qname)"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Lookup a prefix in the namespaceDefinitions and return the namespace URI
            corresponding to the prefix or the mock of an unknow URI the prefix is not
            found</xd:desc>
        <xd:param name="prefix"/>
        <xd:param name="namespaceDefinitions"/>
    </xd:doc>

    <xsl:function name="f:getNamespaceValues" as="xs:string">
        <xsl:param name="prefix"/>
        <xsl:param name="namespaceDefinitions"/>

        <xsl:sequence
            select="string($namespaceDefinitions/*:prefixes/*:prefix/@value[../@name = $prefix])"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Lookup prefix and return namespace URI from the global prefix definitions defined
            in a global variable pointing to an external file with namespace definitions, see
            config-parameters.xsl </xd:desc>
        <xd:param name="prefix"/>
    </xd:doc>
    <xsl:function name="f:getNamespaceURI" as="xs:string">
        <xsl:param name="prefix"/>

        <xsl:variable name="fetch" select="f:getNamespaceValues($prefix, $namespacePrefixes)"/>
        <xsl:sequence
            select="
                if (boolean($fetch)) then
                    string($fetch)
                else
                    fn:error(xs:QName('prefixes'), concat($prefix, ' is not found. Please check namespaces'))
                "
        />
    </xsl:function>

    <xd:doc>
        <xd:desc> Lookup an uml data-type in the docmuents that presents a mapping with the xsd
            data-type(usually an external file with mapping between uml data-type and xsd data-type)
            and if found convert data-type from uml to xsd or return false</xd:desc>
        <xd:param name="qname"/>
        <xd:param name="umlDataTypeMappings"/>
    </xd:doc>
    <xsl:function name="f:getUmlDataTypeValues" as="xs:string">
        <xsl:param name="qname"/>
        <xsl:param name="umlDataTypeMappings"/>
        <xsl:variable name="dataType"
            select="$umlDataTypeMappings/*:mappings/*:mapping/*:from/@qname = $qname"/>
        <xsl:sequence
            select="string($umlDataTypeMappings/*:mappings/*:mapping/*:to[../*:from/@qname = $qname]/@qname)"
        />
    </xsl:function>

    <xd:doc>
        <xd:desc>Get the local segment from elements and attributes</xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:function name="f:getLocalSegmentForElements">
        <xsl:param name="element"/>
        <xsl:sequence select="f:getLocalSegment($element/@name)"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Get the local segment from a Qname (prefix:LocalSegment)</xd:desc>
        <xd:param name="name"/>
    </xd:doc>
    <xsl:function name="f:getLocalSegment">
        <xsl:param name="name"/>
        <xsl:sequence
            select="
                if (fn:contains($name, ':')) then
                    fn:substring-after($name, ':')
                else
                    $name"
        />
    </xsl:function>


    <xd:doc>
        <xd:desc>Build the QName for a lexicalQName. The prefix definition is fetched from the
            global resource '$namespacePrefixes' or the default namespace is used.</xd:desc>
        <xd:param name="lexicalQName"/>
    </xd:doc>
    <xsl:function name="f:buildQNameFromLexicalQName" as="xs:QName">
        <xsl:param name="lexicalQName" as="xs:string"/>

        <xsl:variable name="prefix"
            select="
                if (fn:contains($lexicalQName, ':')) then
                    if (boolean(fn:substring-before($lexicalQName, ':'))) then
                        fn:substring-before($lexicalQName, ':')
                    else
                        ''
                else
                    if ($defaultNamespaceInterpretation) then
                        ''
                    else
                        fn:error(xs:QName('prefix'), concat($lexicalQName, ' - Incorrect lexicalised QName. Should be prefix:localSegment or :localSegment format'))"/>

        <xsl:variable name="namespaceURI" select="f:getNamespaceURI($prefix)"/>
        <xsl:variable name="qname"
            select="
                if (fn:substring-before($lexicalQName, ':') != '') then
                    $lexicalQName
                else
                    if ($defaultNamespaceInterpretation and not(fn:contains($lexicalQName, ':'))) then
                        $lexicalQName
                    else
                        fn:substring-after($lexicalQName, ':')"/>

        <xsl:sequence select="fn:QName($namespaceURI, $qname)"/>
    </xsl:function>

    <xd:doc>
        <xd:desc> generates URI from the lexicalQName. The prefix definition is fetched from the
            global resource '$namespacePrefixes'. The base URI must have a fragment identifier (hash
            '#' , or slash '/') by default the slash '/' is assumed. In order to be compatible with
            'fn:resolve-uri' the ending fragment identifier from the base URI is moved to the
            begining of the local segment. THis could probably changed by relying on a simple
            concatenation, but at the cost of missing some additional checks that the
            'fn:resolve-uri' does. Finally concatenation solution WON! </xd:desc>
        <xd:param name="lexicalQName"/>
    </xd:doc>
    <xsl:function name="f:buildURIfromLexicalQName" as="xs:anyURI">
        <xsl:param name="lexicalQName" as="xs:string"/>

        <xsl:variable name="qname" select="f:buildQNameFromLexicalQName($lexicalQName)"/>
        <xsl:variable name="namespaceURI" select="fn:namespace-uri-from-QName($qname)"/>
        <xsl:variable name="fragmentIdentifier"
            select="substring($namespaceURI, string-length($namespaceURI), 1)"/>
        <xsl:sequence
            select="
                if ($fragmentIdentifier = '#' or $fragmentIdentifier = '/') then
                    xs:anyURI(fn:concat(fn:namespace-uri-from-QName($qname), fn:local-name-from-QName($qname)))
                else
                    xs:anyURI(fn:concat(fn:namespace-uri-from-QName($qname), $defaultDelimiter, fn:local-name-from-QName($qname)))
                "
        />
    </xsl:function>


    <xd:doc>
        <xd:desc>Builds a URI for the element using the element @name attribute. The name expests a
            prefix preceeded by colon (:). </xd:desc>
        <xd:param name="element"/>
    </xd:doc>
    <xsl:function name="f:buildURIFromElement">
        <xsl:param name="element" as="node()"/>
        <xsl:variable name="elementName" select="$element/@name"/>

        <xsl:sequence select="f:buildURIfromLexicalQName($elementName)"/>
    </xsl:function>


    <xd:doc>
        <xd:desc>Removes spaces and camelCases the string</xd:desc>
        <xd:param name="input"/>
    </xd:doc>
    <xsl:function name="f:camelCaseString">
        <xsl:param name="input" as="xs:string"/>
        <xsl:sequence
            select="
                replace(concat(
                lower-case(substring($input, 1, 1)),
                substring(string-join(for $word in tokenize($input, '\s')
                return
                    concat(
                    upper-case(substring($word, 1, 1)),
                    substring($word, 2)), '')
                , 2)), '\s+', '')"
        />
    </xsl:function>

    <xd:doc>
        <xd:desc>Removes spaces and PascalCases the string</xd:desc>
        <xd:param name="input"/>
    </xd:doc>
    <xsl:function name="f:pascalCaseString">
        <xsl:param name="input" as="xs:string"/>
        <xsl:variable name="cc" select="f:camelCaseString($input)"/>
        <xsl:sequence select="fn:concat(upper-case(substring($cc, 1, 1)), substring($cc, 2))"/>
    </xsl:function>




    <xd:doc>
        <xd:desc>Turns the local segment of a lexicalised qName into words</xd:desc>
        <xd:param name="lexicalqName"/>
    </xd:doc>
    <xsl:function name="f:lexicalQNameToWords" as="xs:string">
        <xsl:param name="lexicalqName" as="xs:string"/>

        <xsl:sequence
            select="
                functx:capitalize-first(
                fn:lower-case(
                functx:camel-case-to-words(
                fn:local-name-from-QName(
                f:buildQNameFromLexicalQName($lexicalqName)
                ), ' ')
                ))"
        />
    </xsl:function>

    <xd:doc>
        <xd:desc/>
        <xd:param name="multiplicityString"/>
    </xd:doc>
    <xsl:function name="f:getMultiplicityMinFromString">
        <xsl:param name="multiplicityString"/>
        <xsl:variable name="min" select="fn:substring-before($multiplicityString, '..')"/>
        <xsl:sequence
            select="
                if ($min = '' or $min = '*' or $min = '0') then
                    ()
                else
                    $min"
        />
    </xsl:function>

    <xd:doc>
        <xd:desc/>
        <xd:param name="multiplicityString"/>
    </xd:doc>
    <xsl:function name="f:getMultiplicityMaxFromString">
        <xsl:param name="multiplicityString"/>
        <xsl:variable name="max" select="fn:substring-after($multiplicityString, '..')"/>
        <xsl:sequence
            select="
                if ($max = '' or $max = '*') then
                    ()
                else
                    $max"
        />
    </xsl:function>

    <xd:doc>
        <xd:desc/>
        <xd:param name="multiplicityString"/>
    </xd:doc>
    <xsl:function name="f:normalizeMultiplicity">
        <xsl:param name="multiplicityString"/>
        <xsl:sequence
            select="
                if (fn:contains($multiplicityString, '..')) then
                    $multiplicityString
                else
                    if (not(boolean($multiplicityString)) or $multiplicityString = '' or $multiplicityString = '*') then
                        ()
                    else
                        fn:concat($multiplicityString, '..', $multiplicityString)"
        />
    </xsl:function>


    <xd:doc>
        <xd:desc>Compare strings from a sequence to see if they are equal </xd:desc>
        <xd:param name="stringToCompare"/>
    </xd:doc>
    <xsl:function name="f:areStringsEqual" as="xs:boolean">
        <xsl:param name="stringToCompare" as="xs:string*"/>
        <xsl:variable name="firstString" select="$stringToCompare[1]"/>
        <xsl:sequence
            select="
                every $i in $stringToCompare
                    satisfies $i = $firstString"
        />
    </xsl:function>

    <xd:doc>
        <xd:desc/>
        <xd:param name="attributeMultiplicityValue"/>
    </xd:doc>
    <xsl:function name="f:getAttributeValueToDisplay">
        <xsl:param name="attributeMultiplicityValue"/>
        <xsl:sequence
            select="
                if ($attributeMultiplicityValue = ('', '*', '0')) then
                    ()
                else
                    $attributeMultiplicityValue"
        />
    </xsl:function>

    <xd:doc>
        <xd:desc>Check if connector target and source are in the model</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>

    <!--    TODO Deprecate this and replace with f:connector-to-or-from-external-resource-->

    <xsl:function name="f:checkIfConnectorTargetAndSourceElementsExists">
        <xsl:param name="connector"/>
        <xsl:variable name="targetElementId" select="$connector/target/@xmi:idref"/>
        <xsl:variable name="sourceElementId" select="$connector/source/@xmi:idref"/>
        <xsl:variable name="root" select="root($connector)"/>
        <xsl:sequence
            select="
                if (f:getElementByIdRef($targetElementId, $root) and f:getElementByIdRef($sourceElementId, $root)) then
                    fn:true()
                else
                    fn:false()"
        />
    </xsl:function>

    <xd:doc>
        <xd:desc>Check if the connector is used to or from external classes</xd:desc>
        <xd:param name="connectorName"/>
        <xd:param name="root"/>
    </xd:doc>



    <xsl:function name="f:connector-to-or-from-external-resource">
        <xsl:param name="connectorName"/>
        <xsl:param name="root"/>
        <xsl:variable name="connectorElements" select="f:getConnectorByName($connectorName, $root)"/>
        <xsl:choose>
            <xsl:when test="fn:count($connectorElements) > 1">
                <xsl:variable name="targetClasses"
                    select="
                        for $connector in $connectorElements
                        return
                            if (f:getElementByIdRef($connector/target/@xmi:idref, $root)/@name) then
                                fn:true()
                            else
                                fn:false()"/>
                <xsl:variable name="sourceClasses"
                    select="
                        for $connector in $connectorElements
                        return
                            if (f:getElementByIdRef($connector/source/@xmi:idref, $root)/@name) then
                                fn:true()
                            else
                                fn:false()"/>
                <xsl:variable name="externalTargetClasses"
                    select="
                        every $i in $targetClasses
                            satisfies $i = fn:false()"/>
                <xsl:variable name="externalSourceClasses"
                    select="
                        every $i in $sourceClasses
                            satisfies $i = fn:false()"/>
                <xsl:sequence
                    select="
                        if ($externalSourceClasses or $externalTargetClasses) then
                            fn:true()
                        else
                            fn:false()"/>

            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="targetClass"
                    select="f:getElementByIdRef($connectorElements/target/@xmi:idref, $root)/@name"/>
                <xsl:variable name="sourceClass"
                    select="f:getElementByIdRef($connectorElements/source/@xmi:idref, $root)/@name"/>
                <xsl:sequence
                    select="
                        if ($targetClass and $sourceClass) then
                            fn:false()
                        else
                            fn:true()"
                />
            </xsl:otherwise>
        </xsl:choose>


    </xsl:function>


    <xd:doc>
        <xd:desc>Normalise URI from prefix:localSegment to prefix-localSegment</xd:desc>
        <xd:param name="uri"/>
    </xd:doc>
    <xsl:function name="f:normaliseURI">
        <xsl:param name="uri"/>
        <xsl:sequence select="replace($uri, ':', '-')"/>
    </xsl:function>



    <xd:doc>
        <xd:desc>This function is used to combine 2 URIs to build the property shape URI
            shape-base-uri:{SourceClassURI}-{PropertyOrAttributeURI} Example: Class URI -
            prefix:Procedure Attribute URI - prefix:hasScope Result will be
            http://base.uri/data-shape/prefix-Procedure-prefix-hasScope</xd:desc>
        <xd:param name="firstUri"/>
        <xd:param name="secondUri"/>
    </xd:doc>
    <xsl:function name="f:buildPropertyShapeURI">
        <xsl:param name="firstUri"/>
        <xsl:param name="secondUri"/>
        <xsl:variable name="normalisedFirstUri" select="f:normaliseURI($firstUri)"/>
        <xsl:variable name="normalisedSecondUri" select="f:normaliseURI($secondUri)"/>
        <xsl:sequence
            select="fn:concat($base-shape-uri, $defaultDelimiter, $normalisedFirstUri, '-', $normalisedSecondUri)"/>

    </xsl:function>

    <xd:doc>
        <xd:desc> This function is used to build the shape URI from a given URI
            shape-base-uri:{ClassURI} Example: Class URI - prefix:Human Result will be
            http://base.uri/data-shape/prefix-Human </xd:desc>
        <xd:param name="uri"/>
    </xd:doc>
    <xsl:function name="f:buildShapeURI">
        <xsl:param name="uri"/>
        <xsl:sequence select="fn:concat($base-shape-uri, $defaultDelimiter, f:normaliseURI($uri))"/>
    </xsl:function>


    <xd:doc>
        <xd:desc> This function will return true or false if the connector is used for reused
            classes based on roles names</xd:desc>
        <xd:param name="connector"/>
    </xd:doc>
    <xsl:function name="f:connectorToReusedClasses">
        <xsl:param name="connector"/>
        <xsl:variable name="targetRoleNameURI"
            select="
                if (boolean($connector/target/role/@name)) then
                    f:buildURIfromLexicalQName($connector/target/role/@name)
                else
                    ()"/>
        <xsl:variable name="sourceRoleNameURI"
            select="
                if (boolean($connector/source/role/@name)) then
                    f:buildURIfromLexicalQName($connector/source/role/@name)
                else
                    ()"/>
        <xsl:sequence
            select="
                if (fn:contains($targetRoleNameURI, $base-ontology-uri) or fn:contains($sourceRoleNameURI, $base-ontology-uri)) then
                    fn:false()
                else
                    fn:true()"
        />
    </xsl:function>

    <xd:doc>
        <xd:desc> This function will take connector name (from roles) and will return true or false
            if the connector is used for reused classes </xd:desc>
        <xd:param name="connectorName"/>
    </xd:doc>
    <xsl:function name="f:connectorToReusedClassesByName">
        <xsl:param name="connectorName"/>
        <xsl:sequence
            select="
                if (fn:contains(f:buildURIfromLexicalQName($connectorName), $base-ontology-uri)) then
                    fn:false()
                else
                    fn:true()"
        />
    </xsl:function>

</xsl:stylesheet>
