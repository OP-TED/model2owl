<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:impl="urn:x-xspec:compile:xslt:impl"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:f="http://https://github.com/costezki/model2owl#"
                xmlns:uml="http://www.omg.org/spec/UML/20131001"
                xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
                xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
                xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC"
                xmlns:owl="http://www.w3.org/2002/07/owl#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                version="2.0"
                exclude-result-prefixes="impl">
   <xsl:import href="file:../../../src/common/checkers.xsl"/>
   <xsl:import href="file:/home/lps/work/software/OxygenXMLEditor22/frameworks/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:include href="file:/home/lps/work/software/OxygenXMLEditor22/frameworks/xspec/src/common/xspec-utils.xsl"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:variable name="x:xspec-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/unitTests/test-common/test-checkers.xspec</xsl:variable>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="file:/home/lps/work/software/OxygenXMLEditor22/frameworks/xspec/src/reporter/format-xspec-report.xsl"</xsl:processing-instruction>
         <x:report stylesheet="file:../../../src/common/checkers.xsl"
                   date="{current-dateTime()}"
                   xspec="file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/unitTests/test-common/test-checkers.xspec">
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
            <xsl:call-template name="x:d6e68"/>
            <xsl:call-template name="x:d6e73"/>
            <xsl:call-template name="x:d6e78"/>
            <xsl:call-template name="x:d6e82"/>
            <xsl:call-template name="x:d6e86"/>
            <xsl:call-template name="x:d6e90"/>
            <xsl:call-template name="x:d6e94"/>
            <xsl:call-template name="x:d6e98"/>
            <xsl:call-template name="x:d6e102"/>
            <xsl:call-template name="x:d6e107"/>
            <xsl:call-template name="x:d6e111"/>
            <xsl:call-template name="x:d6e115"/>
            <xsl:call-template name="x:d6e119"/>
            <xsl:call-template name="x:d6e123"/>
            <xsl:call-template name="x:d6e127"/>
            <xsl:call-template name="x:d6e131"/>
            <xsl:call-template name="x:d6e135"/>
            <xsl:call-template name="x:d6e139"/>
            <xsl:call-template name="x:d6e144"/>
            <xsl:call-template name="x:d6e149"/>
            <xsl:call-template name="x:d6e153"/>
            <xsl:call-template name="x:d6e157"/>
            <xsl:call-template name="x:d6e161"/>
            <xsl:call-template name="x:d6e165"/>
            <xsl:call-template name="x:d6e169"/>
            <xsl:call-template name="x:d6e173"/>
            <xsl:call-template name="x:d6e177"/>
            <xsl:call-template name="x:d6e181"/>
            <xsl:call-template name="x:d6e185"/>
            <xsl:call-template name="x:d6e189"/>
            <xsl:call-template name="x:d6e194"/>
            <xsl:call-template name="x:d6e198"/>
            <xsl:call-template name="x:d6e202"/>
            <xsl:call-template name="x:d6e206"/>
            <xsl:call-template name="x:d6e210"/>
            <xsl:call-template name="x:d6e214"/>
            <xsl:call-template name="x:d6e218"/>
            <xsl:call-template name="x:d6e222"/>
            <xsl:call-template name="x:d6e226"/>
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
      <xsl:message>Check Qname prefix with a invalid namespace</xsl:message>
      <x:scenario>
         <x:label>Check Qname prefix with a invalid namespace</x:label>
         <x:call>
            <xsl:attribute name="function">f:isValidNamespace</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>localName</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>localName</xsl:text>
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
         <xsl:call-template name="x:d6e56">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e56">
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
   <xsl:template name="x:d6e58">
      <xsl:message>Check Qname prefix with a invalid namespace</xsl:message>
      <x:scenario>
         <x:label>Check Qname prefix with a invalid namespace</x:label>
         <x:call>
            <xsl:attribute name="function">f:isValidNamespace</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">input</xsl:attribute>
               <xsl:text>:localName</xsl:text>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="input-doc" as="document-node()">
               <xsl:document>
                  <xsl:text>:localName</xsl:text>
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
         <xsl:call-template name="x:d6e62">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e62">
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
   <xsl:template name="x:d6e63">
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
         <xsl:call-template name="x:d6e67">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e67">
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
   <xsl:template name="x:d6e68">
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
         <xsl:call-template name="x:d6e72">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e72">
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
   <xsl:template name="x:d6e73">
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
         <xsl:call-template name="x:d6e77">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e77">
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
   <xsl:template name="x:d6e78">
      <xsl:message>Check if a isAttributeTypeValidForObjectProperty is valid</xsl:message>
      <x:scenario>
         <x:label>Check if a isAttributeTypeValidForObjectProperty is valid </x:label>
         <x:call>
            <xsl:attribute name="function">f:isAttributeTypeValidForObjectProperty</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">attributeElement</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[37]/attributes[1]/attribute[1]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="attributeElement-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="attributeElement-doc"
                          as="document-node()"
                          select="doc($attributeElement-doc-uri)"/>
            <xsl:variable name="attributeElement" as="item()*">
               <xsl:for-each select="$attributeElement-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[37]/attributes[1]/attribute[1]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isAttributeTypeValidForObjectProperty($attributeElement)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e81">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e81">
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
   <xsl:template name="x:d6e82">
      <xsl:message>Check if a isAttributeTypeValidForObjectProperty is valid when passing a UML data-type</xsl:message>
      <x:scenario>
         <x:label>Check if a isAttributeTypeValidForObjectProperty is valid when passing a UML data-type </x:label>
         <x:call>
            <xsl:attribute name="function">f:isAttributeTypeValidForObjectProperty</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">attributeElement</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[76]/attributes[1]/attribute[4]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="attributeElement-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="attributeElement-doc"
                          as="document-node()"
                          select="doc($attributeElement-doc-uri)"/>
            <xsl:variable name="attributeElement" as="item()*">
               <xsl:for-each select="$attributeElement-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[76]/attributes[1]/attribute[4]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isAttributeTypeValidForObjectProperty($attributeElement)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e85">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e85">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>boolean-true</xsl:message>
      <xsl:variable name="impl:expected" select="false()"/>
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
   <xsl:template name="x:d6e86">
      <xsl:message>Check a invalid isAttributeTypeValidForObjectProperty</xsl:message>
      <x:scenario>
         <x:label>Check a invalid isAttributeTypeValidForObjectProperty</x:label>
         <x:call>
            <xsl:attribute name="function">f:isAttributeTypeValidForObjectProperty</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">attributeElement</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[220]/attributes[1]/attribute[4]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="attributeElement-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="attributeElement-doc"
                          as="document-node()"
                          select="doc($attributeElement-doc-uri)"/>
            <xsl:variable name="attributeElement" as="item()*">
               <xsl:for-each select="$attributeElement-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[220]/attributes[1]/attribute[4]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isAttributeTypeValidForObjectProperty($attributeElement)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e89">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e89">
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
   <xsl:template name="x:d6e90">
      <xsl:message>Check if a data-type is valid - isAttributeTypeValidForDatatypeProperty</xsl:message>
      <x:scenario>
         <x:label>Check if a data-type is valid - isAttributeTypeValidForDatatypeProperty </x:label>
         <x:call>
            <xsl:attribute name="function">f:isAttributeTypeValidForDatatypeProperty</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">attributeElement</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[283]/attributes[1]/attribute[1]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="attributeElement-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="attributeElement-doc"
                          as="document-node()"
                          select="doc($attributeElement-doc-uri)"/>
            <xsl:variable name="attributeElement" as="item()*">
               <xsl:for-each select="$attributeElement-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[283]/attributes[1]/attribute[1]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isAttributeTypeValidForDatatypeProperty($attributeElement)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e93">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e93">
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
   <xsl:template name="x:d6e94">
      <xsl:message>Check if a data-type is valid when passing a UML data-type - isAttributeTypeValidForDatatypeProperty</xsl:message>
      <x:scenario>
         <x:label>Check if a data-type is valid when passing a UML data-type - isAttributeTypeValidForDatatypeProperty</x:label>
         <x:call>
            <xsl:attribute name="function">f:isAttributeTypeValidForDatatypeProperty</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">attributeElement</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[35]/attributes[1]/attribute[8]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="attributeElement-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="attributeElement-doc"
                          as="document-node()"
                          select="doc($attributeElement-doc-uri)"/>
            <xsl:variable name="attributeElement" as="item()*">
               <xsl:for-each select="$attributeElement-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[35]/attributes[1]/attribute[8]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isAttributeTypeValidForDatatypeProperty($attributeElement)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e97">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e97">
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
   <xsl:template name="x:d6e98">
      <xsl:message>Check a invalid data-type - isAttributeTypeValidForDatatypeProperty</xsl:message>
      <x:scenario>
         <x:label>Check a invalid data-type - isAttributeTypeValidForDatatypeProperty</x:label>
         <x:call>
            <xsl:attribute name="function">f:isAttributeTypeValidForDatatypeProperty</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">attributeElement</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[35]/attributes[1]/attribute[9]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="attributeElement-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="attributeElement-doc"
                          as="document-node()"
                          select="doc($attributeElement-doc-uri)"/>
            <xsl:variable name="attributeElement" as="item()*">
               <xsl:for-each select="$attributeElement-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[35]/attributes[1]/attribute[9]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isAttributeTypeValidForDatatypeProperty($attributeElement)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e101">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e101">
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
   <xsl:template name="x:d6e102">
      <xsl:message>Check isAttributeStereotypeValid - invalid stereotype</xsl:message>
      <x:scenario>
         <x:label>Check isAttributeStereotypeValid - invalid stereotype</x:label>
         <x:call>
            <xsl:attribute name="function">f:isAttributeStereotypeValid</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[37]/attributes[1]/attribute[9]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[37]/attributes[1]/attribute[9]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isAttributeStereotypeValid($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e105">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e105">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>result</xsl:message>
      <xsl:variable name="impl:expected" select="false()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>result</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e107">
      <xsl:message>Check isAttributeStereotypeValid - not stereotype</xsl:message>
      <x:scenario>
         <x:label>Check isAttributeStereotypeValid - not stereotype</x:label>
         <x:call>
            <xsl:attribute name="function">f:isAttributeStereotypeValid</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[35]/attributes[1]/attribute[3]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[35]/attributes[1]/attribute[3]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isAttributeStereotypeValid($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e110">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e110">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>result</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>result</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e111">
      <xsl:message>Check isElementStereotypeValid - valid stereotype 1</xsl:message>
      <x:scenario>
         <x:label>Check isElementStereotypeValid - valid stereotype 1</x:label>
         <x:call>
            <xsl:attribute name="function">f:isElementStereotypeValid</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[155]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[155]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isElementStereotypeValid($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e114">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e114">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>result</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>result</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e115">
      <xsl:message>Check isElementStereotypeValid - valid stereotype 2</xsl:message>
      <x:scenario>
         <x:label>Check isElementStereotypeValid - valid stereotype 2</x:label>
         <x:call>
            <xsl:attribute name="function">f:isElementStereotypeValid</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[163]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[163]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isElementStereotypeValid($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e118">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e118">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>result</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>result</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e119">
      <xsl:message>Check isElementStereotypeValid - valid stereotype 2</xsl:message>
      <x:scenario>
         <x:label>Check isElementStereotypeValid - valid stereotype 2</x:label>
         <x:call>
            <xsl:attribute name="function">f:isElementStereotypeValid</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[36]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[36]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isElementStereotypeValid($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e122">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e122">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>result</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>result</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e123">
      <xsl:message>Check isElementStereotypeValid - invalid stereotype 1</xsl:message>
      <x:scenario>
         <x:label>Check isElementStereotypeValid - invalid stereotype 1</x:label>
         <x:call>
            <xsl:attribute name="function">f:isElementStereotypeValid</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[103]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[103]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isElementStereotypeValid($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e126">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e126">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>result</xsl:message>
      <xsl:variable name="impl:expected" select="false()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>result</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e127">
      <xsl:message>Check isConnectorStereotypeValid - invalid stereotype</xsl:message>
      <x:scenario>
         <x:label>Check isConnectorStereotypeValid - invalid stereotype</x:label>
         <x:call>
            <xsl:attribute name="function">f:isConnectorStereotypeValid</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[5]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[5]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isConnectorStereotypeValid($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e130">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e130">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>result</xsl:message>
      <xsl:variable name="impl:expected" select="false()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>result</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e131">
      <xsl:message>Check isConnectorStereotypeValid - valid stereotype</xsl:message>
      <x:scenario>
         <x:label>Check isConnectorStereotypeValid - valid stereotype</x:label>
         <x:call>
            <xsl:attribute name="function">f:isConnectorStereotypeValid</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[27]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[27]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isConnectorStereotypeValid($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e134">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e134">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>result</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>result</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e135">
      <xsl:message>Check isConnectorStereotypeValid - valid stereotype</xsl:message>
      <x:scenario>
         <x:label>Check isConnectorStereotypeValid - valid stereotype</x:label>
         <x:call>
            <xsl:attribute name="function">f:isConnectorStereotypeValid</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[453]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[453]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isConnectorStereotypeValid($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e138">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e138">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>result</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>result</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e139">
      <xsl:message>Check isConnectorStereotypeValid - invalid stereotype</xsl:message>
      <x:scenario>
         <x:label>Check isConnectorStereotypeValid - invalid stereotype</x:label>
         <x:call>
            <xsl:attribute name="function">f:isConnectorStereotypeValid</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[41]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/connectors[1]/connector[41]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isConnectorStereotypeValid($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e142">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e142">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>result</xsl:message>
      <xsl:variable name="impl:expected" select="false()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>result</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e144">
      <xsl:message>Check hasAttributeCorrespondingDependecy- no corresponding Dependency found</xsl:message>
      <x:scenario>
         <x:label>Check  hasAttributeCorrespondingDependecy- no corresponding Dependency found </x:label>
         <x:call>
            <xsl:attribute name="function">f:hasAttributeCorrespondingDependecy</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">attribute</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[38]/attributes[1]/attribute[3]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="attribute-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="attribute-doc"
                          as="document-node()"
                          select="doc($attribute-doc-uri)"/>
            <xsl:variable name="attribute" as="item()*">
               <xsl:for-each select="$attribute-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[38]/attributes[1]/attribute[3]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:hasAttributeCorrespondingDependecy($attribute)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e147">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e147">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>result</xsl:message>
      <xsl:variable name="impl:expected" select="false()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>result</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e149">
      <xsl:message>Check hasAttributeCorrespondingDependecy- attribute name = dependency target role name with 'has' prefix</xsl:message>
      <x:scenario>
         <x:label>Check  hasAttributeCorrespondingDependecy- attribute name = dependency target role name with 'has' prefix</x:label>
         <x:call>
            <xsl:attribute name="function">f:hasAttributeCorrespondingDependecy</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">attribute</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[38]/attributes[1]/attribute[4]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="attribute-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="attribute-doc"
                          as="document-node()"
                          select="doc($attribute-doc-uri)"/>
            <xsl:variable name="attribute" as="item()*">
               <xsl:for-each select="$attribute-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[38]/attributes[1]/attribute[4]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:hasAttributeCorrespondingDependecy($attribute)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e152">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e152">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>result</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>result</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e153">
      <xsl:message>Check hasAttributeCorrespondingDependecy- attribute name = dependency target role name</xsl:message>
      <x:scenario>
         <x:label>Check hasAttributeCorrespondingDependecy- attribute name = dependency target role name</x:label>
         <x:call>
            <xsl:attribute name="function">f:hasAttributeCorrespondingDependecy</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">attribute</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[38]/attributes[1]/attribute[2]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="attribute-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="attribute-doc"
                          as="document-node()"
                          select="doc($attribute-doc-uri)"/>
            <xsl:variable name="attribute" as="item()*">
               <xsl:for-each select="$attribute-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[38]/attributes[1]/attribute[2]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:hasAttributeCorrespondingDependecy($attribute)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e156">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e156">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>result</xsl:message>
      <xsl:variable name="impl:expected" select="true()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, '')"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>result</x:label>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:expect</xsl:with-param>
            <xsl:with-param name="test" as="attribute(test)?"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d6e157">
      <xsl:message>Check an element that is missing the name - no name value</xsl:message>
      <x:scenario>
         <x:label>Check an element that is missing the name - no name value</x:label>
         <x:call>
            <xsl:attribute name="function">f:isElementNameMissing</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[317]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[317]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isElementNameMissing($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e160">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e160">
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
   <xsl:template name="x:d6e161">
      <xsl:message>Check an element that is missing the name - no name attribute</xsl:message>
      <x:scenario>
         <x:label>Check an element that is missing the name - no name attribute</x:label>
         <x:call>
            <xsl:attribute name="function">f:isElementNameMissing</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[318]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[318]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isElementNameMissing($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e164">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e164">
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
   <xsl:template name="x:d6e165">
      <xsl:message>Check an element that is not missing the name</xsl:message>
      <x:scenario>
         <x:label>Check an element that is not missing the name</x:label>
         <x:call>
            <xsl:attribute name="function">f:isElementNameMissing</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[316]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[316]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isElementNameMissing($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e168">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e168">
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
   <xsl:template name="x:d6e169">
      <xsl:message>Check an element that has the name prefix missing</xsl:message>
      <x:scenario>
         <x:label>Check an element that has the name prefix missing</x:label>
         <x:call>
            <xsl:attribute name="function">f:isElementNamePrefixMissing</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[316]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[316]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isElementNamePrefixMissing($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e172">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e172">
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
   <xsl:template name="x:d6e173">
      <xsl:message>Check an element that is has the name prefix missing - has delimiter but it is empty</xsl:message>
      <x:scenario>
         <x:label>Check an element that is has the name prefix missing - has delimiter but it is empty</x:label>
         <x:call>
            <xsl:attribute name="function">f:isElementNamePrefixMissing</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[99]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[99]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isElementNamePrefixMissing($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e176">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e176">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>boolean-true</xsl:message>
      <xsl:variable name="impl:expected" select="false()"/>
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
   <xsl:template name="x:d6e177">
      <xsl:message>Check an element that has the name prefix</xsl:message>
      <x:scenario>
         <x:label>Check an element that has the name prefix</x:label>
         <x:call>
            <xsl:attribute name="function">f:isElementNamePrefixMissing</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[319]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[319]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isElementNamePrefixMissing($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e180">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e180">
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
   <xsl:template name="x:d6e181">
      <xsl:message>Check an element that has local segment</xsl:message>
      <x:scenario>
         <x:label>Check an element that has local segment</x:label>
         <x:call>
            <xsl:attribute name="function">f:isElementNameLocalSegmentMissing</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[319]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[319]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isElementNameLocalSegmentMissing($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e184">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e184">
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
   <xsl:template name="x:d6e185">
      <xsl:message>Check an element that has local segment - it is not a Qname</xsl:message>
      <x:scenario>
         <x:label>Check an element that has local segment - it is not a Qname</x:label>
         <x:call>
            <xsl:attribute name="function">f:isElementNameLocalSegmentMissing</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[36]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[36]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isElementNameLocalSegmentMissing($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e188">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e188">
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
   <xsl:template name="x:d6e189">
      <xsl:message>Check an element that has no local segment</xsl:message>
      <x:scenario>
         <x:label>Check an element that has no local segment</x:label>
         <x:call>
            <xsl:attribute name="function">f:isElementNameLocalSegmentMissing</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[73]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[73]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isElementNameLocalSegmentMissing($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e192">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e192">
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
   <xsl:template name="x:d6e194">
      <xsl:message>Check an element with valid prefix</xsl:message>
      <x:scenario>
         <x:label>Check an element with valid prefix</x:label>
         <x:call>
            <xsl:attribute name="function">f:isInvalidNamePrefix</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[319]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[319]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isInvalidNamePrefix($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e197">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e197">
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
   <xsl:template name="x:d6e198">
      <xsl:message>Check an element with invalid prefix</xsl:message>
      <x:scenario>
         <x:label>Check an element with invalid prefix</x:label>
         <x:call>
            <xsl:attribute name="function">f:isInvalidNamePrefix</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[73]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[73]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isInvalidNamePrefix($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e201">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e201">
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
   <xsl:template name="x:d6e202">
      <xsl:message>Check an element with valid local segment - not Qname</xsl:message>
      <x:scenario>
         <x:label>Check an element with valid local segment - not Qname</x:label>
         <x:call>
            <xsl:attribute name="function">f:isInvalidLocalSegmentName</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[36]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[36]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isInvalidLocalSegmentName($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e205">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e205">
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
   <xsl:template name="x:d6e206">
      <xsl:message>Check an element with valid local segment</xsl:message>
      <x:scenario>
         <x:label>Check an element with valid local segment</x:label>
         <x:call>
            <xsl:attribute name="function">f:isInvalidLocalSegmentName</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[319]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[319]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isInvalidLocalSegmentName($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e209">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e209">
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
   <xsl:template name="x:d6e210">
      <xsl:message>Check an element with invalid local segment</xsl:message>
      <x:scenario>
         <x:label>Check an element with invalid local segment</x:label>
         <x:call>
            <xsl:attribute name="function">f:isInvalidLocalSegmentName</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[95]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[95]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isInvalidLocalSegmentName($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e213">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e213">
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
   <xsl:template name="x:d6e214">
      <xsl:message>Check the local segment first character for an element which is valid</xsl:message>
      <x:scenario>
         <x:label>Check the local segment first character for an element which is valid</x:label>
         <x:call>
            <xsl:attribute name="function">f:isValidFirstCharacterInLocalSegment</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[319]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[319]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isValidFirstCharacterInLocalSegment($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e217">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e217">
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
   <xsl:template name="x:d6e218">
      <xsl:message>Check the local segment first character for an element which is invalid</xsl:message>
      <x:scenario>
         <x:label>Check the local segment first character for an element which is invalid</x:label>
         <x:call>
            <xsl:attribute name="function">f:isValidFirstCharacterInLocalSegment</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[36]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[36]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isValidFirstCharacterInLocalSegment($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e221">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e221">
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
   <xsl:template name="x:d6e222">
      <xsl:message>Check an element that has the local segment with delimiters</xsl:message>
      <x:scenario>
         <x:label>Check an element that has the local segment with delimiters</x:label>
         <x:call>
            <xsl:attribute name="function">f:isDelimitersInLocalSegment</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[101]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[101]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isDelimitersInLocalSegment($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e225">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e225">
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
   <xsl:template name="x:d6e226">
      <xsl:message>Check an element that has the local segment with no delimiters</xsl:message>
      <x:scenario>
         <x:label>Check an element that has the local segment with no delimiters</x:label>
         <x:call>
            <xsl:attribute name="function">f:isDelimitersInLocalSegment</xsl:attribute>
            <x:param>
               <xsl:attribute name="name">element</xsl:attribute>
               <xsl:attribute name="href">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:attribute>
               <xsl:attribute name="select">/xmi:XMI/xmi:Extension[1]/elements[1]/element[319]</xsl:attribute>
            </x:param>
         </x:call>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="element-doc-uri" as="xs:anyURI">file:/home/lps/work/workspace-charm/model2owl/deliverable-B/test/testData/ePO-CM-v2.0.1-2020-03-27_test.eap.xmi</xsl:variable>
            <xsl:variable name="element-doc"
                          as="document-node()"
                          select="doc($element-doc-uri)"/>
            <xsl:variable name="element" as="item()*">
               <xsl:for-each select="$element-doc">
                  <xsl:sequence select="/xmi:XMI/xmi:Extension[1]/elements[1]/element[319]"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="f:isDelimitersInLocalSegment($element)"/>
         </xsl:variable>
         <xsl:call-template name="test:report-sequence">
            <xsl:with-param name="sequence" select="$x:result"/>
            <xsl:with-param name="wrapper-name" as="xs:string">x:result</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="x:d6e229">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d6e229">
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
