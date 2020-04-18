<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:impl="urn:x-xspec:compile:xslt:impl"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:f="http://https://github.com/costezki/model2owl#"
                version="2.0"
                exclude-result-prefixes="impl">
   <xsl:import href="file:/home/dragos/src/model2owl/src/common/utils.xsl"/>
   <xsl:import href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:include href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/common/xspec-utils.xsl"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:variable name="x:xspec-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/unitTests/test-utils.xspec</xsl:variable>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/reporter/format-xspec-report.xsl"</xsl:processing-instruction>
         <x:report stylesheet="file:/home/dragos/src/model2owl/src/common/utils.xsl"
                   date="{current-dateTime()}"
                   xspec="file:/home/dragos/src/model2owl/test/unitTests/test-utils.xspec">
            <xsl:call-template name="x:d6e2"/>
            <xsl:call-template name="x:d6e8"/>
            <xsl:call-template name="x:d6e14"/>
            <xsl:call-template name="x:d6e20"/>
            <xsl:call-template name="x:d6e26"/>
            <xsl:call-template name="x:d6e32"/>
            <xsl:call-template name="x:d6e38"/>
            <xsl:call-template name="x:d6e43"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:d6e2">
      <xsl:message>Scenario 1 for testing function getXsdRdfDataTypeValues</xsl:message>
      <x:scenario>
         <x:label>Scenario 1 for testing function getXsdRdfDataTypeValues</x:label>
         <x:call>
            <xsl:attribute name="function">f:getXsdRdfDataTypeValues</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">qname</xsl:attribute>
               <xsl:text>xsd:gYearMonth</xsl:text>
            </x:param>
            <x:param>
               <xsl:attribute name="name">dataTypesDefinitions</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/testData/xsdAndRdfDataTypes.xml</xsl:attribute>
               <xsl:attribute name="select">/</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="qname-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>xsd:gYearMonth</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="qname" as="item()*">
               <xsl:for-each select="$qname-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="dataTypesDefinitions-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/testData/xsdAndRdfDataTypes.xml</xsl:variable>
            <xsl:variable name="dataTypesDefinitions-doc"
                          as="document-node()"
                          select="doc($dataTypesDefinitions-doc-uri)"/>
            <xsl:variable name="dataTypesDefinitions" as="item()*">
               <xsl:for-each select="$dataTypesDefinitions-doc">
                  <xsl:sequence select="/"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:getXsdRdfDataTypeValues($qname, $dataTypesDefinitions)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e7">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e7">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>data-type</xsl:message>
      <xsl:variable name="impl:expected" select="'xsd:gYearMonth'"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>data-type</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e8">
      <xsl:message>Scenario 2 for testing function getXsdRdfDataTypeValues</xsl:message>
      <x:scenario>
         <x:label>Scenario 2 for testing function getXsdRdfDataTypeValues</x:label>
         <x:call>
            <xsl:attribute name="function">f:getXsdRdfDataTypeValues</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">qname</xsl:attribute>
               <xsl:text>xsd:!#4354gYearMonth</xsl:text>
            </x:param>
            <x:param>
               <xsl:attribute name="name">dataTypesDefinitions</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/testData/xsdAndRdfDataTypes.xml</xsl:attribute>
               <xsl:attribute name="select">/</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="qname-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>xsd:!#4354gYearMonth</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="qname" as="item()*">
               <xsl:for-each select="$qname-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="dataTypesDefinitions-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/testData/xsdAndRdfDataTypes.xml</xsl:variable>
            <xsl:variable name="dataTypesDefinitions-doc"
                          as="document-node()"
                          select="doc($dataTypesDefinitions-doc-uri)"/>
            <xsl:variable name="dataTypesDefinitions" as="item()*">
               <xsl:for-each select="$dataTypesDefinitions-doc">
                  <xsl:sequence select="/"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:getXsdRdfDataTypeValues($qname, $dataTypesDefinitions)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e13">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e13">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>nothing</xsl:message>
      <xsl:variable name="impl:expected" select="''"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>nothing</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e14">
      <xsl:message>Scenario 1 for testing function getNamespaceValues</xsl:message>
      <x:scenario>
         <x:label>Scenario 1 for testing function getNamespaceValues </x:label>
         <x:call>
            <xsl:attribute name="function">f:getNamespaceValues</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">prefix</xsl:attribute>
               <xsl:text>ccev</xsl:text>
            </x:param>
            <x:param>
               <xsl:attribute name="name">namespaceDefinitions</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/testData/namespaces.xml</xsl:attribute>
               <xsl:attribute name="select">/</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="prefix-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>ccev</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="prefix" as="item()*">
               <xsl:for-each select="$prefix-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="namespaceDefinitions-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/testData/namespaces.xml</xsl:variable>
            <xsl:variable name="namespaceDefinitions-doc"
                          as="document-node()"
                          select="doc($namespaceDefinitions-doc-uri)"/>
            <xsl:variable name="namespaceDefinitions" as="item()*">
               <xsl:for-each select="$namespaceDefinitions-doc">
                  <xsl:sequence select="/"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:getNamespaceValues($prefix, $namespaceDefinitions)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e19">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e19">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>ccev base name</xsl:message>
      <xsl:variable name="impl:expected" select="'http://data.europa.eu/m8g/'"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>ccev base name</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e20">
      <xsl:message>Scenario 2 for testing function getNamespaceValues</xsl:message>
      <x:scenario>
         <x:label>Scenario 2 for testing function getNamespaceValues </x:label>
         <x:call>
            <xsl:attribute name="function">f:getNamespaceValues</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">prefix</xsl:attribute>
               <xsl:text>ccevrts</xsl:text>
            </x:param>
            <x:param>
               <xsl:attribute name="name">namespaceDefinitions</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/testData/namespaces.xml</xsl:attribute>
               <xsl:attribute name="select">/</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="prefix-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>ccevrts</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="prefix" as="item()*">
               <xsl:for-each select="$prefix-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="namespaceDefinitions-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/testData/namespaces.xml</xsl:variable>
            <xsl:variable name="namespaceDefinitions-doc"
                          as="document-node()"
                          select="doc($namespaceDefinitions-doc-uri)"/>
            <xsl:variable name="namespaceDefinitions" as="item()*">
               <xsl:for-each select="$namespaceDefinitions-doc">
                  <xsl:sequence select="/"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:getNamespaceValues($prefix, $namespaceDefinitions)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e25">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e25">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>return nothing</xsl:message>
      <xsl:variable name="impl:expected" select="''"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>return nothing</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e26">
      <xsl:message>Scenario 1 for testing function getUmlDataTypeValues</xsl:message>
      <x:scenario>
         <x:label>Scenario 1 for testing function getUmlDataTypeValues</x:label>
         <x:call>
            <xsl:attribute name="function">f:getUmlDataTypeValues</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">qname</xsl:attribute>
               <xsl:text>Date</xsl:text>
            </x:param>
            <x:param>
               <xsl:attribute name="name">umlDataTypeMappings</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/testData/umlToXsdDataTypes.xml</xsl:attribute>
               <xsl:attribute name="select">/</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="qname-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>Date</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="qname" as="item()*">
               <xsl:for-each select="$qname-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="umlDataTypeMappings-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/testData/umlToXsdDataTypes.xml</xsl:variable>
            <xsl:variable name="umlDataTypeMappings-doc"
                          as="document-node()"
                          select="doc($umlDataTypeMappings-doc-uri)"/>
            <xsl:variable name="umlDataTypeMappings" as="item()*">
               <xsl:for-each select="$umlDataTypeMappings-doc">
                  <xsl:sequence select="/"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:getUmlDataTypeValues($qname, $umlDataTypeMappings)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e31">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e31">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>data-type</xsl:message>
      <xsl:variable name="impl:expected" select="'xsd:date'"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>data-type</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e32">
      <xsl:message>Scenario 2 for testing function getUmlDataTypeValues</xsl:message>
      <x:scenario>
         <x:label>Scenario 2 for testing function getUmlDataTypeValues</x:label>
         <x:call>
            <xsl:attribute name="function">f:getUmlDataTypeValues</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">qname</xsl:attribute>
               <xsl:text>DateQ</xsl:text>
            </x:param>
            <x:param>
               <xsl:attribute name="name">umlDataTypeMappings</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/testData/umlToXsdDataTypes.xml</xsl:attribute>
               <xsl:attribute name="select">/</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="qname-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>DateQ</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="qname" as="item()*">
               <xsl:for-each select="$qname-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="umlDataTypeMappings-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/testData/umlToXsdDataTypes.xml</xsl:variable>
            <xsl:variable name="umlDataTypeMappings-doc"
                          as="document-node()"
                          select="doc($umlDataTypeMappings-doc-uri)"/>
            <xsl:variable name="umlDataTypeMappings" as="item()*">
               <xsl:for-each select="$umlDataTypeMappings-doc">
                  <xsl:sequence select="/"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:getUmlDataTypeValues($qname, $umlDataTypeMappings)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e37">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e37">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>nothing</xsl:message>
      <xsl:variable name="impl:expected" select="''"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>nothing</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e38">
      <xsl:message>Scenario 1 for testing function buildQNameFromLexicalQName</xsl:message>
      <x:scenario>
         <x:label>Scenario 1 for testing function buildQNameFromLexicalQName</x:label>
         <x:call>
            <xsl:attribute name="function">f:buildQNameFromLexicalQName</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">lexicalQName</xsl:attribute>
               <xsl:text>xsd:integer</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="lexicalQName-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>xsd:integer</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="lexicalQName" as="item()*">
               <xsl:for-each select="$lexicalQName-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:buildQNameFromLexicalQName($lexicalQName)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e42">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e42">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>nothing</xsl:message>
      <xsl:variable name="impl:expected"
                    select="fn:QName('http://www.w3.org/2001/XMLSchema#','xsd:integer')"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>nothing</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e43">
      <xsl:message>Scenario 2 for testing function buildQNameFromLexicalQName</xsl:message>
      <x:scenario>
         <x:label>Scenario 2 for testing function buildQNameFromLexicalQName</x:label>
         <x:call>
            <xsl:attribute name="function">f:buildQNameFromLexicalQName</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">lexicalQName</xsl:attribute>
               <xsl:text>xsd1:integer</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="lexicalQName-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>xsd1:integer</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="lexicalQName" as="item()*">
               <xsl:for-each select="$lexicalQName-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:buildQNameFromLexicalQName($lexicalQName)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e47">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e47">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>nothing</xsl:message>
      <xsl:variable name="impl:expected"
                    select="fn:QName('http://www.w3.org/2001/XMLSchema#','xsd:integer')"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>nothing</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>
