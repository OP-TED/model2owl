<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:impl="urn:x-xspec:compile:xslt:impl"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
                xmlns:f="http://https://github.com/costezki/model2owl#"
                version="2.0"
                exclude-result-prefixes="impl">
   <xsl:import href="file:../../../src/html-conventions-lib/utils-html-conventions.xsl"/>
   <xsl:import href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:include href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/common/xspec-utils.xsl"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:variable name="x:xspec-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/deliverables/B/test/unitTests/test-html-conventions-lib/test-utils-html-convention.xspec</xsl:variable>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/reporter/format-xspec-report.xsl"</xsl:processing-instruction>
         <x:report stylesheet="file:../../../src/html-conventions-lib/utils-html-conventions.xsl"
                   date="{current-dateTime()}"
                   xspec="file:/home/dragos/src/model2owl/deliverables/B/test/unitTests/test-html-conventions-lib/test-utils-html-convention.xspec">
            <xsl:call-template name="x:d6e2"/>
            <xsl:call-template name="x:d6e7"/>
            <xsl:call-template name="x:d6e12"/>
            <xsl:call-template name="x:d6e17"/>
            <xsl:call-template name="x:d6e22"/>
            <xsl:call-template name="x:d6e27"/>
            <xsl:call-template name="x:d6e32"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:d6e2">
      <xsl:message>Generate a info in html</xsl:message>
      <x:scenario>
         <x:label>Generate a info in html</x:label>
         <x:call>
            <xsl:attribute name="function">f:generateHtmlInfo</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">infoMessage</xsl:attribute>
               <xsl:text>Info message</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="infoMessage-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>Info message</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="infoMessage" as="item()*">
               <xsl:for-each select="$infoMessage-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:generateHtmlInfo($infoMessage)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e6">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e6">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>has info message</xsl:message>
      <xsl:variable name="impl:expected" select="()"/>
      <xsl:variable name="impl:test-items" as="item()*">
         <xsl:choose>
            <xsl:when test="exists($x:result)                 and test:wrappable-sequence($x:result)">
               <xsl:sequence select="test:wrap-nodes($x:result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$x:result"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="impl:test-result" as="item()*">
         <xsl:choose>
            <xsl:when test="count($impl:test-items) eq 1">
               <xsl:for-each select="$impl:test-items">
                  <xsl:sequence select="//dd//text() = 'Info message'" version="2"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="//dd//text() = 'Info message'" version="2"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="impl:boolean-test"
                    as="xs:boolean"
                    select="$impl:test-result instance of xs:boolean"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="if ($impl:boolean-test) then boolean($impl:test-result)                     else test:deep-equal($impl:expected, $impl:test-result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>has info message</x:label>
         <xsl:if test="not($impl:boolean-test)">
            <xsl:call-template name="test:report-sequence">
               <xsl:with-param name="sequence" select="$impl:test-result"/>
               <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
            </xsl:call-template>
         </xsl:if>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?">
               <xsl:attribute name="test">//dd//text() = 'Info message'</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e7">
      <xsl:message>Generate a warning in html</xsl:message>
      <x:scenario>
         <x:label>Generate a warning in html</x:label>
         <x:call>
            <xsl:attribute name="function">f:generateHtmlWarning</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">warningMessage</xsl:attribute>
               <xsl:text>Warning message</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="warningMessage-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>Warning message</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="warningMessage" as="item()*">
               <xsl:for-each select="$warningMessage-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:generateHtmlWarning($warningMessage)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e11">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e11">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>has warning message</xsl:message>
      <xsl:variable name="impl:expected" select="()"/>
      <xsl:variable name="impl:test-items" as="item()*">
         <xsl:choose>
            <xsl:when test="exists($x:result)                 and test:wrappable-sequence($x:result)">
               <xsl:sequence select="test:wrap-nodes($x:result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$x:result"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="impl:test-result" as="item()*">
         <xsl:choose>
            <xsl:when test="count($impl:test-items) eq 1">
               <xsl:for-each select="$impl:test-items">
                  <xsl:sequence select="//dd//text() = 'Warning message'" version="2"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="//dd//text() = 'Warning message'" version="2"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="impl:boolean-test"
                    as="xs:boolean"
                    select="$impl:test-result instance of xs:boolean"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="if ($impl:boolean-test) then boolean($impl:test-result)                     else test:deep-equal($impl:expected, $impl:test-result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>has warning message</x:label>
         <xsl:if test="not($impl:boolean-test)">
            <xsl:call-template name="test:report-sequence">
               <xsl:with-param name="sequence" select="$impl:test-result"/>
               <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
            </xsl:call-template>
         </xsl:if>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?">
               <xsl:attribute name="test">//dd//text() = 'Warning message'</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e12">
      <xsl:message>Generate an error in html</xsl:message>
      <x:scenario>
         <x:label>Generate an error in html</x:label>
         <x:call>
            <xsl:attribute name="function">f:generateHtmlError</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">errorMessage</xsl:attribute>
               <xsl:text>This has no description</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="errorMessage-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>This has no description</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="errorMessage" as="item()*">
               <xsl:for-each select="$errorMessage-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:generateHtmlError($errorMessage)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e16">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e16">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>has error message</xsl:message>
      <xsl:variable name="impl:expected" select="()"/>
      <xsl:variable name="impl:test-items" as="item()*">
         <xsl:choose>
            <xsl:when test="exists($x:result)                 and test:wrappable-sequence($x:result)">
               <xsl:sequence select="test:wrap-nodes($x:result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$x:result"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="impl:test-result" as="item()*">
         <xsl:choose>
            <xsl:when test="count($impl:test-items) eq 1">
               <xsl:for-each select="$impl:test-items">
                  <xsl:sequence select="//dd//text() = 'This has no description'" version="2"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="//dd//text() = 'This has no description'" version="2"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="impl:boolean-test"
                    as="xs:boolean"
                    select="$impl:test-result instance of xs:boolean"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="if ($impl:boolean-test) then boolean($impl:test-result)                     else test:deep-equal($impl:expected, $impl:test-result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>has error message</x:label>
         <xsl:if test="not($impl:boolean-test)">
            <xsl:call-template name="test:report-sequence">
               <xsl:with-param name="sequence" select="$impl:test-result"/>
               <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
            </xsl:call-template>
         </xsl:if>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?">
               <xsl:attribute name="test">//dd//text() = 'This has no description'</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e17">
      <xsl:message>Get connector helper name when direction is Source -&gt; Destination and has no name</xsl:message>
      <x:scenario>
         <x:label>Get connector helper name when direction is Source -&gt; Destination and has no name</x:label>
         <x:call>
            <xsl:attribute name="function">f:getConnectorName</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">connector</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/deliverables/B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[18]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="connector-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/deliverables/B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="connector-doc"
                          as="document-node()"
                          select="doc($connector-doc-uri)"/>
            <xsl:variable name="connector" as="item()*">
               <xsl:for-each select="$connector-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[18]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:getConnectorName($connector)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e20">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e20">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>correct helper name for the connector</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>epo:AccessTerms &lt;-&gt; epo:Channel (+epo:hasRestrictedAccessAddress +source)</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" as="item()*">
         <xsl:for-each select="$impl:expected-doc">
            <xsl:sequence select="node()"/>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>correct helper name for the connector</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e22">
      <xsl:message>Get connector helper name when direction is Bi-Directional and has no name</xsl:message>
      <x:scenario>
         <x:label>Get connector helper name when direction is Bi-Directional and has no name</x:label>
         <x:call>
            <xsl:attribute name="function">f:getConnectorName</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">connector</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/deliverables/B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[134]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="connector-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/deliverables/B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="connector-doc"
                          as="document-node()"
                          select="doc($connector-doc-uri)"/>
            <xsl:variable name="connector" as="item()*">
               <xsl:for-each select="$connector-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[134]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:getConnectorName($connector)"/>
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
      <xsl:message>correct helper name for the connector</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>epo:Procedure &lt;-&gt; epo:Contract (+epo:isConcludedBy +epo:concludes)</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" as="item()*">
         <xsl:for-each select="$impl:expected-doc">
            <xsl:sequence select="node()"/>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>correct helper name for the connector</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e27">
      <xsl:message>Get connector name when it has a name and it is not required to construct a helper name</xsl:message>
      <x:scenario>
         <x:label>Get connector name when it has a name and it is not required to construct a helper name</x:label>
         <x:call>
            <xsl:attribute name="function">f:getConnectorName</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">connector</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/deliverables/B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[17]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="connector-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/deliverables/B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="connector-doc"
                          as="document-node()"
                          select="doc($connector-doc-uri)"/>
            <xsl:variable name="connector" as="item()*">
               <xsl:for-each select="$connector-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[17]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:getConnectorName($connector)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e30">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e30">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>correct helper name for the connector</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>test association</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" as="item()*">
         <xsl:for-each select="$impl:expected-doc">
            <xsl:sequence select="node()"/>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>correct helper name for the connector</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e32">
      <xsl:message>Get connector helper name when direction is unknown and has no name</xsl:message>
      <x:scenario>
         <x:label>Get connector helper name when direction is unknown and has no name</x:label>
         <x:call>
            <xsl:attribute name="function">f:getConnectorName</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">connector</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/deliverables/B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[19]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="connector-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/deliverables/B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="connector-doc"
                          as="document-node()"
                          select="doc($connector-doc-uri)"/>
            <xsl:variable name="connector" as="item()*">
               <xsl:for-each select="$connector-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[19]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:getConnectorName($connector)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e35">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e35">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>correct helper name for the connector</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>epo:AccessTerms X epo:Organisation (+epo:hasAdditionalInformationProvidedBy +)</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" as="item()*">
         <xsl:for-each select="$impl:expected-doc">
            <xsl:sequence select="node()"/>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>correct helper name for the connector</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>
