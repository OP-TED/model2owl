<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:impl="urn:x-xspec:compile:xslt:impl"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:f="http://https://github.com/costezki/model2owl#"
                version="2.0"
                exclude-result-prefixes="impl">
   <xsl:import href="file:../../src/common/checkers.xsl"/>
   <xsl:import href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:include href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/common/xspec-utils.xsl"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:variable name="x:xspec-uri" as="xs:anyURI">file:/home/dragos/src/model2owl/test/unitTests/test-common/test-checkers.xspec</xsl:variable>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="file:/home/dragos/Oxygen%20XML%20Editor%2022/frameworks/xspec/src/reporter/format-xspec-report.xsl"</xsl:processing-instruction>
         <x:report stylesheet="file:../../src/common/checkers.xsl"
                   date="{current-dateTime()}"
                   xspec="file:/home/dragos/src/model2owl/test/unitTests/test-common/test-checkers.xspec">
            <xsl:call-template name="x:d6e2"/>
            <xsl:call-template name="x:d6e7"/>
            <xsl:call-template name="x:d6e12"/>
            <xsl:call-template name="x:d6e17"/>
            <xsl:call-template name="x:d6e22"/>
            <xsl:call-template name="x:d6e27"/>
            <xsl:call-template name="x:d6e32"/>
            <xsl:call-template name="x:d6e37"/>
            <xsl:call-template name="x:d6e42"/>
            <xsl:call-template name="x:d6e47"/>
            <xsl:call-template name="x:d6e52"/>
            <xsl:call-template name="x:d6e58"/>
            <xsl:call-template name="x:d6e63"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:d6e2">
      <xsl:message>Check valid normalized string</xsl:message>
      <x:scenario>
         <x:label>Check valid normalized string</x:label>
         <x:call>
            <xsl:attribute name="function">f:isValidNormalizedString</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>normalized:String</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>normalized:String</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isValidNormalizedString($input)"/>
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
      <xsl:message>is valid</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>is valid</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e7">
      <xsl:message>Check invalid normalized string</xsl:message>
      <x:scenario>
         <x:label>Check invalid normalized string</x:label>
         <x:call>
            <xsl:attribute name="function">f:isValidNormalizedString</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>Normalized Str!ng</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>Normalized Str!ng</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isValidNormalizedString($input)"/>
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
      <xsl:message>is invalid</xsl:message>
      <xsl:variable name="impl:expected" select="false()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>is invalid</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e12">
      <xsl:message>Check valid Qname string</xsl:message>
      <x:scenario>
         <x:label>Check valid Qname string</x:label>
         <x:call>
            <xsl:attribute name="function">f:isValidQname</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>normalized:String</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>normalized:String</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isValidQname($input)"/>
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
      <xsl:message>is valid</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>is valid</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e17">
      <xsl:message>Check invalid Qname string</xsl:message>
      <x:scenario>
         <x:label>Check invalid Qname string</x:label>
         <x:call>
            <xsl:attribute name="function">f:isValidQname</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>normalizedString</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>normalizedString</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isValidQname($input)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e21">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e21">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>is valid</xsl:message>
      <xsl:variable name="impl:expected" select="false()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>is valid</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e22">
      <xsl:message>Check if local name from Qname is camelCase with first letter uppercased</xsl:message>
      <x:scenario>
         <x:label>Check if local name from Qname is camelCase with first letter uppercased</x:label>
         <x:call>
            <xsl:attribute name="function">f:isQNameUpperCasedCamelCase</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>prefix:Local</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>prefix:Local</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isQNameUpperCasedCamelCase($input)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e26">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e26">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>boolean-true</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>boolean-true</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e27">
      <xsl:message>Local name from Qname is not camelCase with first letter uppercased</xsl:message>
      <x:scenario>
         <x:label>Local name from Qname is not camelCase with first letter uppercased</x:label>
         <x:call>
            <xsl:attribute name="function">f:isQNameUpperCasedCamelCase</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>prefix:localName</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>prefix:localName</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isQNameUpperCasedCamelCase($input)"/>
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
      <xsl:message>boolean-false</xsl:message>
      <xsl:variable name="impl:expected" select="false()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>boolean-false</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e32">
      <xsl:message>Check if local name from Qname is camelCase with first letter lowercased</xsl:message>
      <x:scenario>
         <x:label>Check if local name from Qname is camelCase with first letter lowercased</x:label>
         <x:call>
            <xsl:attribute name="function">f:isQNameLowerCasedCamelCase</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>prefix:localName</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>prefix:localName</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isQNameLowerCasedCamelCase($input)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e36">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e36">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>boolean-true</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>boolean-true</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e37">
      <xsl:message>Local name from Qname is not camelCase with first letter uppercased</xsl:message>
      <x:scenario>
         <x:label>Local name from Qname is not camelCase with first letter uppercased</x:label>
         <x:call>
            <xsl:attribute name="function">f:isQNameLowerCasedCamelCase</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>prefix:LocalName</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>prefix:LocalName</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isQNameLowerCasedCamelCase($input)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e41">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e41">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>boolean-false</xsl:message>
      <xsl:variable name="impl:expected" select="false()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>boolean-false</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e42">
      <xsl:message>Check if Qname prefix is a valid namespace</xsl:message>
      <x:scenario>
         <x:label>Check if Qname prefix is a valid namespace</x:label>
         <x:call>
            <xsl:attribute name="function">f:isValidNamespace</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>ccev:localName</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>ccev:localName</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isValidNamespace($input)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e46">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e46">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>boolean-true</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>boolean-true</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e47">
      <xsl:message>Check Qname prefix with a invalid namespace</xsl:message>
      <x:scenario>
         <x:label>Check Qname prefix with a invalid namespace</x:label>
         <x:call>
            <xsl:attribute name="function">f:isValidNamespace</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>prefix1:localNamea</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>prefix1:localNamea</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isValidNamespace($input)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e51">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e51">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>boolean-false</xsl:message>
      <xsl:variable name="impl:expected" select="false()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>boolean-false</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e52">
      <xsl:message>Check if a data-type is valid</xsl:message>
      <x:scenario>
         <x:label>Check if a data-type is valid </x:label>
         <x:call>
            <xsl:attribute name="function">f:isValidDataType</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>xsd:string</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>xsd:string</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isValidDataType($input)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e56">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e56">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>boolean-true</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>boolean-true</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e58">
      <xsl:message>Check if a data-type is valid when passing a UML data-type</xsl:message>
      <x:scenario>
         <x:label>Check if a data-type is valid when passing a UML data-type </x:label>
         <x:call>
            <xsl:attribute name="function">f:isValidDataType</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>String</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>String</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isValidDataType($input)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e62">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e62">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>boolean-true</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>boolean-true</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e63">
      <xsl:message>Check a invalid data-type</xsl:message>
      <x:scenario>
         <x:label>Check a invalid data-type</x:label>
         <x:call>
            <xsl:attribute name="function">f:isValidDataType</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>prefix:localName</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>prefix:localName</xsl:text>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="input" as="item()*">
               <xsl:for-each select="$input-doc">
                  <xsl:sequence select="node()"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isValidDataType($input)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e67">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e67">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>boolean-false</xsl:message>
      <xsl:variable name="impl:expected" select="false()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>boolean-false</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>
