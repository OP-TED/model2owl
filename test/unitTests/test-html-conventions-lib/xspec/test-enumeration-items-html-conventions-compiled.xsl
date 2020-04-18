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
   <xsl:import href="file:../../../src/html-conventions-lib/enumeration-items-html-conventions.xsl"/>
   <xsl:import href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:include href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/common/xspec-utils.xsl"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:variable name="x:xspec-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/unitTests/test-html-conventions-lib/test-enumeration-items-html-conventions.xspec</xsl:variable>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/reporter/format-xspec-report.xsl"</xsl:processing-instruction>
         <x:report stylesheet="file:../../../src/html-conventions-lib/enumeration-items-html-conventions.xsl"
                   date="{current-dateTime()}"
                   xspec="file:/home/dragos/src/model2owl/test/unitTests/test-html-conventions-lib/test-enumeration-items-html-conventions.xspec">
            <xsl:call-template name="x:d6e2"/>
            <xsl:call-template name="x:d6e8"/>
            <xsl:call-template name="x:d6e14"/>
            <xsl:call-template name="x:d6e19"/>
            <xsl:call-template name="x:d6e24"/>
            <xsl:call-template name="x:d6e28"/>
            <xsl:call-template name="x:d6e32"/>
            <xsl:call-template name="x:d6e36"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:d6e2">
      <xsl:message>Scenario for testing template with match '[uml:Enumeration']/attributes/attribute - finding attributes with unmet conventions</xsl:message>
      <x:scenario>
         <x:label>Scenario for testing template with match '[uml:Enumeration']/attributes/attribute - finding attributes with unmet conventions</x:label>
         <x:context>
            <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
            <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[2]</xsl:attribute>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="impl:context-doc"
                          as="document-node()"
                          select="doc($impl:context-doc-uri)"/>
            <xsl:variable name="impl:context" as="item()*">
               <xsl:for-each select="$impl:context-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[2]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:apply-templates select="$impl:context"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e4">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
         <xsl:call-template name="x:d6e5">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
         <xsl:call-template name="x:d6e6">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
         <xsl:call-template name="x:d6e7">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e4">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>there is an heading with the enumeration name</xsl:message>
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
                  <xsl:sequence select="boolean(/h1)" version="2"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="boolean(/h1)" version="2"/>
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
         <x:label>there is an heading with the enumeration name</x:label>
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
               <xsl:attribute name="test">boolean(/h1)</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e5">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>there is an Description List element</xsl:message>
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
                  <xsl:sequence select="boolean(/dl)" version="2"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="boolean(/dl)" version="2"/>
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
         <x:label>there is an Description List element</x:label>
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
               <xsl:attribute name="test">boolean(/dl)</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e6">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>there is an Description Term element</xsl:message>
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
                  <xsl:sequence select="boolean(dl/dt)" version="2"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="boolean(dl/dt)" version="2"/>
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
         <x:label>there is an Description Term element</x:label>
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
               <xsl:attribute name="test">boolean(dl/dt)</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e7">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>there is an Description Details element</xsl:message>
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
                  <xsl:sequence select="boolean(dl/dd)" version="2"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="boolean(dl/dd)" version="2"/>
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
         <x:label>there is an Description Details element</x:label>
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
               <xsl:attribute name="test">boolean(dl/dd)</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e8">
      <xsl:message>Scenario for testing template with match '[uml:Enumeration']/attributes/attribute - finding attributes with all conventions met</xsl:message>
      <x:scenario>
         <x:label>Scenario for testing template with match '[uml:Enumeration']/attributes/attribute - finding attributes with all conventions met</x:label>
         <x:context>
            <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
            <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[1]</xsl:attribute>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="impl:context-doc"
                          as="document-node()"
                          select="doc($impl:context-doc-uri)"/>
            <xsl:variable name="impl:context" as="item()*">
               <xsl:for-each select="$impl:context-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[1]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:apply-templates select="$impl:context"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e10">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
         <xsl:call-template name="x:d6e11">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
         <xsl:call-template name="x:d6e12">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
         <xsl:call-template name="x:d6e13">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e10">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>there is an heading with the enumeration name</xsl:message>
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
                  <xsl:sequence select="boolean(/h1)" version="2"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="boolean(/h1)" version="2"/>
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
         <x:label>there is an heading with the enumeration name</x:label>
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
               <xsl:attribute name="test">boolean(/h1)</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e11">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>there is an Description List element</xsl:message>
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
                  <xsl:sequence select="boolean(/dl)" version="2"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="boolean(/dl)" version="2"/>
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
         <x:label>there is an Description List element</x:label>
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
               <xsl:attribute name="test">boolean(/dl)</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e12">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>there is an Description Term element</xsl:message>
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
                  <xsl:sequence select="boolean(dl/dt)" version="2"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="boolean(dl/dt)" version="2"/>
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
         <x:label>there is an Description Term element</x:label>
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
               <xsl:attribute name="test">boolean(dl/dt)</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e13">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>there is no Description Details element</xsl:message>
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
                  <xsl:sequence select="not(boolean(dl/dd))" version="2"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="not(boolean(dl/dd))" version="2"/>
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
         <x:label>there is no Description Details element</x:label>
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
               <xsl:attribute name="test">not(boolean(dl/dd))</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e14">
      <xsl:message>Scenario for getting the enumeration name</xsl:message>
      <x:scenario>
         <x:label>Scenario for getting the enumeration name</x:label>
         <x:call>
            <xsl:attribute name="template">getEnumerationName</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">enumerationItem</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[1]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="enumerationItem-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="enumerationItem-doc"
                          as="document-node()"
                          select="doc($enumerationItem-doc-uri)"/>
            <xsl:variable name="enumerationItem" as="item()*">
               <xsl:for-each select="$enumerationItem-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[1]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:call-template name="getEnumerationName">
               <xsl:with-param name="enumerationItem" select="$enumerationItem"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e17">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e17">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>correct enumeration name</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>accelerated-procedure-justification-type</xsl:text>
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
         <x:label>correct enumeration name</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e19">
      <xsl:message>Scenario for getting the enumeration item name</xsl:message>
      <x:scenario>
         <x:label>Scenario for getting the enumeration item name</x:label>
         <x:call>
            <xsl:attribute name="template">getEnumerationItemName</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">enumerationItem</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[1]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="enumerationItem-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="enumerationItem-doc"
                          as="document-node()"
                          select="doc($enumerationItem-doc-uri)"/>
            <xsl:variable name="enumerationItem" as="item()*">
               <xsl:for-each select="$enumerationItem-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[1]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:call-template name="getEnumerationItemName">
               <xsl:with-param name="enumerationItem" select="$enumerationItem"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e22">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e22">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>correct enumeration item name</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>PIN_REDUCE_TIME_LIMIT</xsl:text>
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
         <x:label>correct enumeration item name</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e24">
      <xsl:message>Scenario for finding a enumeration item name that is not a valid normalized string</xsl:message>
      <x:scenario>
         <x:label>Scenario for finding a enumeration item name that is not a valid normalized string</x:label>
         <x:call>
            <xsl:attribute name="template">enumerationNameConventionChecker</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">enumerationItem</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[2]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="enumerationItem-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="enumerationItem-doc"
                          as="document-node()"
                          select="doc($enumerationItem-doc-uri)"/>
            <xsl:variable name="enumerationItem" as="item()*">
               <xsl:for-each select="$enumerationItem-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[2]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:call-template name="enumerationNameConventionChecker">
               <xsl:with-param name="enumerationItem" select="$enumerationItem"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e27">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e27">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>expect to find a Description Details element</xsl:message>
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
                  <xsl:sequence select="boolean(/dd)" version="2"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="boolean(/dd)" version="2"/>
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
         <x:label>expect to find a Description Details element</x:label>
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
               <xsl:attribute name="test">boolean(/dd)</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e28">
      <xsl:message>Scenario for finding a enumeration item name that is a valid normalized string</xsl:message>
      <x:scenario>
         <x:label>Scenario for finding a enumeration item name that is a valid normalized string</x:label>
         <x:call>
            <xsl:attribute name="template">enumerationNameConventionChecker</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">enumerationItem</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[1]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="enumerationItem-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="enumerationItem-doc"
                          as="document-node()"
                          select="doc($enumerationItem-doc-uri)"/>
            <xsl:variable name="enumerationItem" as="item()*">
               <xsl:for-each select="$enumerationItem-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[1]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:call-template name="enumerationNameConventionChecker">
               <xsl:with-param name="enumerationItem" select="$enumerationItem"/>
            </xsl:call-template>
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
      <xsl:message>expect to do nothing</xsl:message>
      <xsl:variable name="impl:expected" select="()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>expect to do nothing</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e32">
      <xsl:message>Scenario for finding an enumeration item without an initial value</xsl:message>
      <x:scenario>
         <x:label>Scenario for finding an enumeration item without an initial value</x:label>
         <x:call>
            <xsl:attribute name="template">enumerationItemInitialValueChecker</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">enumerationItem</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[2]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="enumerationItem-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="enumerationItem-doc"
                          as="document-node()"
                          select="doc($enumerationItem-doc-uri)"/>
            <xsl:variable name="enumerationItem" as="item()*">
               <xsl:for-each select="$enumerationItem-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[2]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:call-template name="enumerationItemInitialValueChecker">
               <xsl:with-param name="enumerationItem" select="$enumerationItem"/>
            </xsl:call-template>
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
      <xsl:message>expect to find a Description Details element</xsl:message>
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
                  <xsl:sequence select="boolean(/dd)" version="2"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="boolean(/dd)" version="2"/>
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
         <x:label>expect to find a Description Details element</x:label>
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
               <xsl:attribute name="test">boolean(/dd)</xsl:attribute>
            </xsl:with-param>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e36">
      <xsl:message>Scenario for finding an enumeration item with initial value</xsl:message>
      <x:scenario>
         <x:label>Scenario for finding an enumeration item with initial value</x:label>
         <x:call>
            <xsl:attribute name="template">enumerationItemInitialValueChecker</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">enumerationItem</xsl:attribute>
               <xsl:attribute name="href">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[1]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="enumerationItem-doc-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/unitTests/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="enumerationItem-doc"
                          as="document-node()"
                          select="doc($enumerationItem-doc-uri)"/>
            <xsl:variable name="enumerationItem" as="item()*">
               <xsl:for-each select="$enumerationItem-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[158]/attributes/attribute[1]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:call-template name="enumerationItemInitialValueChecker">
               <xsl:with-param name="enumerationItem" select="$enumerationItem"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e39">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e39">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>expect to do nothing</xsl:message>
      <xsl:variable name="impl:expected" select="()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>expect to do nothing</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>
