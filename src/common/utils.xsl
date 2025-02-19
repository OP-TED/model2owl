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

    <xsl:param name="enrichedNamespacesPath"/>
    <xsl:variable name="internalNamespacePrefixes" select="
        if (boolean($enrichedNamespacesPath)) then
            fn:doc($enrichedNamespacesPath)
        else fn:error(xs:QName('missing-parameter'), 'enrichedNamespacesPath is not given.')
    "/>

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

        <xsl:variable name="fetch" select="f:getNamespaceValues($prefix, $internalNamespacePrefixes)"/>
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
        <xd:desc>
            Turns the local segment of a lexicalised qName into words, handling
            acronyms and camel case properly.
        </xd:desc>
        <xd:param name="lexicalqName"/>
    </xd:doc>
    <xsl:function name="f:lexicalQNameToWords" as="xs:string">
        <xsl:param name="lexicalqName" as="xs:string"/>
        <xsl:variable name="localName"
            select="fn:local-name-from-QName(f:buildQNameFromLexicalQName($lexicalqName))"/>
        <xsl:sequence 
            select="fn:string-join(f:getSegmentsFromCamelCaseText($localName), ' ')" />
    </xsl:function>

    <xd:doc>
        <xd:desc>
            Splits a camelCase name into a text. Supports acronyms.
        </xd:desc>
        <xd:param name="text"/>
    </xd:doc>
    <!-- The underlying function works on a reversed text as this makes
    identification of the segments easier. -->
    <xsl:function name="f:getSegmentsFromCamelCaseText" as="xs:string*">
        <xsl:param name="text" as="xs:string"/>
        <xsl:sequence 
            select="for $segment in f:_getSegmentsRec(functx:reverse-string($text))
            return functx:reverse-string($segment)" />
    </xsl:function>

    <xd:doc>
        <xd:desc>
            Splits a camelCase name into a text. Supports acronyms. Returns
            sequence of found text segments (words and acronyms).
        </xd:desc>
        <xd:param name="text"/>
    </xd:doc>
    <!-- 
    This is private, recursive function.
    The function preserves case of split words. For example:
    'hasLongName' => 'has Long Name' (not 'has long name').
    -->
    <xsl:function name="f:_getSegmentsRec" as="xs:string*">
        <xsl:param name="text" as="xs:string"/>
        <xsl:variable name="textLen" select="fn:string-length($text)"/>
        <xsl:variable name="currSegment" select="f:_getLeftSubstrByCaseChange($text)"/>
        <xsl:variable name="currSegmentLen" select="fn:string-length($currSegment)"/>
        <xsl:variable name="nextSegmentOffset"
            select="if (xs:integer($currSegmentLen) &lt; xs:integer($textLen))
                then $currSegmentLen + 1 else ()"/>
        <xsl:choose>
            <xsl:when test="fn:boolean($nextSegmentOffset) = fn:true()">
                <xsl:value-of select="(
                    $currSegment, 
                    f:_getSegmentsRec(fn:substring($text, $nextSegmentOffset))
                )"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="($currSegment)"/>  
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xd:doc>
        <xd:desc>
            Detects a left substring based on a letter case change. Supports
            acronyms.
        </xd:desc>
        <xd:param name="text"/>
        <xd:param name="index"/>
    </xd:doc>
    <xsl:function name="f:_getLeftSubstrByCaseChange" as="xs:string">
        <xsl:param name="text" as="xs:string"/>
        <xsl:sequence select="f:_getLeftSubstrByCaseChangeRec($text, 1)"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>
            Detects a left substring based on a letter case change. Supports
            acronyms.
        </xd:desc>
        <xd:param name="text"/>
        <xd:param name="index"/>
    </xd:doc>
    <!-- 
    This is a private, recursive function. 
    It's the basis for splitting camelCaseName into segments.
    The function returns such a left substring which letters (except for the
    ending*) has the same letter case as the first letter.
    Ending of the returned substring varies depending on the letter case transition:
    1) lower to upper: INCLUDE the last character with a diffferent case.
    2) upper to lower: EXCLUDE the last character with a diffferent case.
    -->
    <xsl:function name="f:_getLeftSubstrByCaseChangeRec" as="xs:string">
        <xsl:param name="text" as="xs:string"/>
        <xsl:param name="index" as="xs:integer"/>
        <xsl:variable name="firstChar" select="fn:substring($text, 1, 1)"/>
        <xsl:variable name="textLen" select="fn:string-length($text)"/>
        <xsl:sequence select="
        if (f:haveSameCase(fn:substring($text, $index, 1), $firstChar))
        then 
            if (xs:integer($index) &lt; xs:integer($textLen))
            then f:_getLeftSubstrByCaseChangeRec($text, $index + 1) 
            else $text
        else 
            if(f:isUpperCase($firstChar))
            then fn:substring($text, 1, $index - 1)
            else fn:substring($text, 1, $index)" 
        />
    </xsl:function>

    <xd:doc>
        <xd:desc>
            Checks if a character is uppercase.
        </xd:desc>
        <xd:param name="char"/>
    </xd:doc>
    <xsl:function name="f:isUpperCase" as="xs:boolean">
        <xsl:param name="char" as="xs:string"/>
        <xsl:sequence select="matches($char, '[A-Z]')"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>
            Checks if the two passed character have the same letter case
            (either lower case or upper case).
        </xd:desc>
        <xd:param name="char1"/>
        <xd:param name="char2"/>
    </xd:doc>
    <xsl:function name="f:haveSameCase" as="xs:boolean">
        <xsl:param name="char1" as="xs:string"/>
        <xsl:param name="char2" as="xs:string"/>
        <xsl:sequence select="f:isUpperCase($char1) = f:isUpperCase($char2)"/>
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
        <xd:desc>Normalise compact URI from prefix:localSegment to prefix-localSegment.
            Regular URI is not supported.
        </xd:desc>
        <xd:param name="uri"/>
    </xd:doc>
    <xsl:function name="f:normaliseURI">
        <xsl:param name="uri"/>
        <xsl:if test="fn:matches($uri, '^http([s]*)://(.+)$')">
            <xsl:sequence
                select="fn:error(
                    xs:QName('unsupported-uri'),
                    'The function supports only a compact URI',
                    ($uri)
                )" />
        </xsl:if>
        <xsl:sequence select="replace($uri, ':', '-')"/>
    </xsl:function>



    <xd:doc>
        <xd:desc>This function is used to combine 2 compact URIs to build the property shape URI
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

    <xd:doc>
        <xd:desc>This template declares set of namespaces to be defined in top element of an output file</xd:desc>
    </xd:doc>
    <xsl:template name="namespacesDeclaration">
        <xsl:for-each select="$internalNamespacePrefixes/*:prefixes/*:prefix">              
            <xsl:namespace name="{./@name}" select="./@value"/>
        </xsl:for-each>
    </xsl:template>


    <!-- Grouped Datatypes as Lists -->
    <xsl:variable name="numericDatatypes" as="xs:string*">
        <xsl:sequence select="'xsd:integer', 'xsd:decimal', 'xsd:double', 'xsd:float',
            'xsd:byte', 'xsd:short', 'xsd:int', 'xsd:long',
            'xsd:negativeInteger', 'xsd:nonNegativeInteger',
            'xsd:positiveInteger', 'xsd:nonPositiveInteger',
            'xsd:unsignedByte', 'xsd:unsignedShort',
            'xsd:unsignedInt', 'xsd:unsignedLong'"/>
    </xsl:variable>

    <xsl:variable name="booleanDatatypes" as="xs:string*">
        <xsl:sequence select="'xsd:boolean'"/>
    </xsl:variable>

    <xsl:variable name="dateTimeDatatypes" as="xs:string*">
        <xsl:sequence select="'xsd:date', 'xsd:time', 'xsd:dateTime', 'xsd:dateTimeStamp'"/>
    </xsl:variable>

    <xsl:variable name="stringDatatypes" as="xs:string*">
        <xsl:sequence select="'xsd:string', 'xsd:normalizedString', 'xsd:token',
            'xsd:Name', 'xsd:NCName', 'xsd:NMTOKEN',
            'xsd:language', 'rdf:PlainLiteral', 'rdf:langString'"/>
    </xsl:variable>


    <xd:doc>
        <xd:desc>
            This function validates the value entered by the user in a tag against its corresponding datatype.

            Due to XSLT limitations, specifically with the castable as expression, the validation process can't be done dynamically
            so multiple datatypes needs to be grouped in the validation process. For instance:

            Data types such as xsd:integer and xsd:double are grouped under xs:double for validation purposes.
            Similarly, other related data types are grouped into predefined variables.

            If a new custom data type is introduced, it must be added to the appropriate grouping variable to ensure validation.
            This is a workaround due limitations of XSLT
        </xd:desc>
        <xd:param name="tagValue"/>
        <xd:param name="datatypeQName"/>
    </xd:doc>
    <xsl:function name="f:validateTagValue" as="xs:boolean">
        <xsl:param name="tagValue" as="xs:string"/>
        <xsl:param name="datatypeQName" as="xs:string"/>

        <!-- Validation based on resolved datatype -->
        <xsl:choose>
            <!-- Numeric Types -->
            <xsl:when test="$datatypeQName = $numericDatatypes">
                <xsl:if test="not($tagValue castable as xs:double)">
                    <xsl:sequence select="fn:error(
                        xs:QName('invalidValueError'),
                        concat('Error: Value ', $tagValue, ' is not valid for numeric type ', $datatypeQName, '.')
                        )"/>
                </xsl:if>
            </xsl:when>

            <!-- Boolean Type -->
            <xsl:when test="$datatypeQName = $booleanDatatypes">
                <xsl:if test="not($tagValue castable as xs:boolean)">
                    <xsl:sequence select="fn:error(
                        xs:QName('invalidValueError'),
                        concat('Error: Value ', $tagValue, ' is not valid for boolean type ', $datatypeQName, '.')
                        )"/>
                </xsl:if>
            </xsl:when>

            <!-- Date and Time Types -->
            <xsl:when test="$datatypeQName = $dateTimeDatatypes">
                <xsl:if test="not($tagValue castable as xs:dateTime)">
                    <xsl:sequence select="fn:error(
                        xs:QName('invalidValueError'),
                        concat('Error: Value ', $tagValue, ' is not valid for date/time type ', $datatypeQName, '.')
                        )"/>
                </xsl:if>
            </xsl:when>

            <!-- Strings and Text Types -->
            <xsl:when test="$datatypeQName = $stringDatatypes">
                <!-- Strings are always valid -->
            </xsl:when>

            <!-- URI Validation -->
            <xsl:when test="$datatypeQName = 'xsd:anyURI'">
                <xsl:if test="not($tagValue castable as xs:anyURI)">
                    <xsl:sequence select="fn:error(
                        xs:QName('invalidValueError'),
                        concat('Error: Value ', $tagValue, ' is not a valid URI.')
                        )"/>
                </xsl:if>
            </xsl:when>

            <!-- Unsupported Types -->
            <xsl:otherwise>
                <xsl:sequence select="fn:error(
                    xs:QName('invalidValueError'),
                    concat('Error: Unsupported datatype ', $datatypeQName, '.')
                    )"/>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Return true for valid values -->
        <xsl:sequence select="fn:true()"/>
    </xsl:function>


    <xd:doc>
        <xd:desc>This template will return true or false if the an element should be filtered or not by looking at
        the status value
        :nodeInput can be an element or connector
        - If a `statusValue` is provided, it checks whether the value is part of the `excludedElementStatusesList`.
        - If no `statusValue` is provided (i.e., the status is undefined), the function falls back to using
          the `unspecifiedStatusInterpretation` as the default status value. It then checks whether this default
          status is part of the `excludedElementStatusesList`.

        </xd:desc>
        <xd:param name="nodeInput"/>
    </xd:doc>

    <xsl:function name="f:isExcludedByStatus">
        <xsl:param name="nodeInput" as="node()*"/>

        <!-- Get all tags for the element -->
        <xsl:variable name="tags"
            select="
                if (local-name($nodeInput) = 'connector') then
                    f:getConnectorTags($nodeInput)
                else
                    f:getElementTags($nodeInput)"/>

        <!-- Find the status tag -->
        <xsl:variable name="statusTag" select="
            for $tag in $tags
            return if ($tag/@name = $statusProperty) then $tag else ()"/>
        <!-- Extract the value of the status tag -->
        <xsl:variable name="statusValue" select="$statusTag/@value"/>

        <!-- Validation: Ensure statusValue is in validStatusesList -->
        <xsl:if test="$statusValue and not($statusValue = $validStatusesList)">
            <xsl:message terminate="yes"> Error: Invalid status value "<xsl:value-of
                    select="$statusValue"/>" for element with ID "<xsl:value-of
                    select="$nodeInput/@xmi:id"/>". Allowed values are: <xsl:value-of
                    select="string-join($validStatusesList, ', ')"/>. </xsl:message>
        </xsl:if>
        <!-- Determine if the element should be excluded -->
        <xsl:sequence
            select="
                if (not($statusValue)) then
                    $unspecifiedStatusInterpretation = $excludedElementStatusesList
                else
                    $statusValue = $excludedElementStatusesList
                "
        />
    </xsl:function>
    
    
    
    <xd:doc>
        <xd:desc>This function will return the target connector from a generalisation between 2 connectors</xd:desc>
        <xd:param name="generalisation"/>
    </xd:doc>
    <xsl:function name="f:getTargetConnectorFromGeneralisation">
        <xsl:param name="generalisation"/>
        <xsl:variable name="targetIdref" select="$generalisation/target/@xmi:idref" as="xs:string"/>
        <xsl:variable name="targetElement" select="f:getElementByIdRef($targetIdref, root($generalisation))"/>
        <xsl:variable name="targetConnectorIdref" select="$targetElement/@classifier" as="xs:string"/>
        <xsl:variable name="targetConnector"
            select="f:getConnectorByIdRef($targetConnectorIdref, root($generalisation))"/>
        <xsl:sequence select="$targetConnector"/>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>This function will return the source connector from a generalisation between 2 connectors</xd:desc>
        <xd:param name="generalisation"/>
    </xd:doc>
    <xsl:function name="f:getSourceConnectorFromGeneralisation">
        <xsl:param name="generalisation"/>
        <xsl:variable name="sourceIdref" select="$generalisation/source/@xmi:idref" as="xs:string"/>
        <xsl:variable name="sourceElement" select="f:getElementByIdRef($sourceIdref, root($generalisation))"/>
        <xsl:variable name="sourceConnectorIdref" select="$sourceElement/@classifier" as="xs:string"/>
        <xsl:variable name="sourceConnector"
            select="f:getConnectorByIdRef($sourceConnectorIdref, root($generalisation))"/>
        <xsl:sequence select="$sourceConnector"/>
    </xsl:function>

</xsl:stylesheet>
