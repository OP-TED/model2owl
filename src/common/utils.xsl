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
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 22, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p>A set of useful utilities</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:import href="../../config/config-proxy.xsl"/>
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
                    $mockUnknownDomain"
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
        <xsl:sequence
            select="
                if (fn:contains($element/@name, ':')) then
                    fn:substring-after($element/@name, ':')
                else
                    $element/@name"
        />
    </xsl:function>

    <xd:doc>
        <xd:desc>Normalises the lexicalised QName string.</xd:desc>
        <xd:param name="lexicalQName"/>
        <xd:param name="isPascalCase"/>
        <xd:param name="changeCase"/>
    </xd:doc>
    <xsl:function name="f:normaliseLexicalQName" as="xs:string">
        <xsl:param name="lexicalQName" as="xs:string"/>
        <xsl:param name="isPascalCase" as="xs:boolean"/>
        <xsl:param name="changeCase" as="xs:boolean"/>

        <xsl:variable name="newPrefix">
            <xsl:variable name="prefix" select="fn:substring-before($lexicalQName, ':')"/>
            <xsl:value-of
                select="
                    if (boolean($prefix)) then
                        replace(
                        concat(
                        string-join(for $word in tokenize($prefix, '\s')
                        return
                            lower-case($word)), ':'),
                        '\s+', '')
                    else
                        ''"
            />
        </xsl:variable>

        <xsl:variable name="newLocalSegment">
            <xsl:variable name="localSegment"
                select="
                    if (contains($lexicalQName, ':')) then
                        fn:substring-after($lexicalQName, ':')
                    else
                        $lexicalQName"/>
            <!--  a qname cannot start with a digit, therefore fence it frith aprefix -->
            <xsl:variable name="safeDigitLocalSegment"
                select="
                    if (not(contains('0123456789', substring($localSegment, 1, 1)))) then
                        $localSegment
                    else
                        fn:concat($mockPrefixforLocalSegment, $localSegment)"/>

            <!-- leave only acceptable characters in the local segment  -->
            <xsl:variable name="safeCharLocalSegment"
                select="replace($safeDigitLocalSegment, '[^\w\d\s-_]', '')"/>
            <xsl:value-of
                select="
                    if (boolean($safeCharLocalSegment)) then
                        if ($isPascalCase and $changeCase) then
                            f:pascalCaseString($safeCharLocalSegment)
                        else
                            if (not($isPascalCase) and $changeCase) then
                                f:camelCaseString($safeCharLocalSegment)
                            else
                                $safeCharLocalSegment
                    else
                        $mockUnknownPrefix"
            />
        </xsl:variable>




        <xsl:sequence select="fn:concat($newPrefix, $newLocalSegment)"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Build the QName for a lexicalQName. The prefix definition is fetched from the
            global resource '$namespacePrefixes' or the default namespace is used.</xd:desc>
        <xd:param name="lexicalQName"/>
        <xd:param name="isPascalCase"/>
        <xd:param name="changeCase"/>
    </xd:doc>
    <xsl:function name="f:buildQNameFromLexicalQName" as="xs:QName">
        <xsl:param name="lexicalQName" as="xs:string"/>
        <xsl:param name="isPascalCase" as="xs:boolean"/>
        <xsl:param name="changeCase" as="xs:boolean"/>

        <xsl:variable name="normalisedLexicalQName"
            select="f:normaliseLexicalQName($lexicalQName, $isPascalCase, $changeCase)"/>

        <xsl:variable name="namespaceURI"
            select="f:getNamespaceURI(fn:substring-before($normalisedLexicalQName, ':'))"/>
        <xsl:sequence select="fn:QName($namespaceURI, $normalisedLexicalQName)"/>
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
        <xd:param name="isPascalCase"/>
        <xd:param name="changeCase"/>
    </xd:doc>
    <xsl:function name="f:buildURIfromLexicalQName" as="xs:anyURI">
        <xsl:param name="lexicalQName" as="xs:string"/>
        <xsl:param name="isPascalCase" as="xs:boolean"/>
        <xsl:param name="changeCase" as="xs:boolean"/>

        <xsl:variable name="qname"
            select="f:buildQNameFromLexicalQName($lexicalQName, $isPascalCase, $changeCase)"/>
        <xsl:variable name="namespaceURI" select="fn:namespace-uri-from-QName($qname)"/>
        <xsl:variable name="fragmentIdentifier"
            select="substring($namespaceURI, string-length($namespaceURI), 1)"/>
        <xsl:sequence
            select="
                if ($fragmentIdentifier = '#' or $fragmentIdentifier = '/') then
                    xs:anyURI(fn:concat(fn:namespace-uri-from-QName($qname), fn:local-name-from-QName($qname)))
                else
                    xs:anyURI(fn:concat(fn:namespace-uri-from-QName($qname), $defaultDelimiter, fn:local-name-from-QName($qname)))
                "/>
    </xsl:function>

    <xd:doc>
        <xd:desc>Builds a URI for the element using the element @name attribute. The name expests a
            prefix preceeded by colon (:). In case the prefix is absen then the default namespace is
            used, or if $isDefaultNamespaceContextualised is set to true then the package name
            (feteched using f:getContainingPackageName function) is used as default namespace.
            isPascalCase - indicates whether the first letter of the local segmetn shall be
            capitalised. isDefaultNamespaceContextualised - indicates whether the default namespace
            from the prefix definitions shall be used or the default namespace is contextualised to
            the containg package. </xd:desc>
        <xd:param name="element"/>
        <xd:param name="isDefaultNamespaceContextualised"/>
        <xd:param name="isPascalCase"/>
    </xd:doc>
    <xsl:function name="f:buildURIFromElement">
        <xsl:param name="element" as="node()"/>
        <xsl:param name="isPascalCase" as="xs:boolean"/>
        <xsl:param name="isDefaultNamespaceContextualised" as="xs:boolean"/>

        <xsl:sequence
            select="f:buildURIFromNode($element, $element/@name, $isPascalCase, $isDefaultNamespaceContextualised)"
        />
    </xsl:function>


    <xd:doc>
        <xd:desc> Create the attribute URI. If the attribute name starts with an upper case then
            prepent 'has' prefix to it.</xd:desc>
        <xd:param name="attribute"/>
        <xd:param name="isPascalCase"/>
        <xd:param name="isDefaultNamespaceContextualised"/>
    </xd:doc>
    <xsl:function name="f:buildURIFromAttribute">
        <xsl:param name="attribute" as="node()"/>
        <xsl:param name="isPascalCase" as="xs:boolean"/>
        <xsl:param name="isDefaultNamespaceContextualised" as="xs:boolean"/>

        <xsl:variable name="localName" select="f:getLocalSegmentForElements($attribute)"/>
        <xsl:variable name="prefix" select="fn:substring-before($attribute/@name, ':')"/>
        <xsl:variable name="expandedLocalName"
            select="
                if (substring($localName, 1, 1) = fn:upper-case(substring($localName, 1, 1))) then
                    fn:concat('has', $localName)
                else
                    $localName
                "/>
        <xsl:sequence
            select="f:buildURIFromNode($attribute, fn:concat($prefix,':',$expandedLocalName), $isPascalCase, $isDefaultNamespaceContextualised)"
        />
    </xsl:function>


    <xd:doc>
        <xd:desc>Create an URI from an XMI node that has name attribute</xd:desc>
        <xd:param name="element"/>
        <xd:param name="elementName"/>
        <xd:param name="isPascalCase"/>
        <xd:param name="isDefaultNamespaceContextualised"/>
    </xd:doc>
    <xsl:function name="f:buildURIFromNode">
        <xsl:param name="element" as="node()"/>
        <xsl:param name="elementName" as="xs:string"/>
        <xsl:param name="isPascalCase" as="xs:boolean"/>
        <xsl:param name="isDefaultNamespaceContextualised" as="xs:boolean"/>

        <xsl:variable name="defaultNamespacePrefix"
            select="
                if ($isDefaultNamespaceContextualised) then
                    f:getContainingPackageName($element)
                else
                    fn:string('')"/>

        <xsl:variable name="normalisedElementName"
            select="
                if (contains($elementName, ':')) then
                    $elementName
                else
                    concat($defaultNamespacePrefix, ':', $elementName)"/>

        <xsl:sequence select="f:buildURIfromLexicalQName($normalisedElementName, $isPascalCase, fn:true())"/>
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
                f:buildQNameFromLexicalQName($lexicalqName, fn:true(), fn:true())
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

</xsl:stylesheet>
