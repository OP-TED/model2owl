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
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dct="http://purl.org/dc/terms/" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="http://https://github.com/costezki/model2owl#" version="3.0">
    <xsl:import href="../common/fetchers.xsl"/>


    <xsl:variable name="reportType"/>


    <xd:doc>
        <xd:desc>This function will generate a info message</xd:desc>
        <xd:param name="infoMessage"/>
        <xd:param name="pathChecked"/>
        <xd:param name="ruleIdentifier"/>
    </xd:doc>
    <xsl:function name="f:generateInfoMessage">
        <xsl:param name="infoMessage"/>
        <xsl:param name="pathChecked"/>
        <xsl:param name="ruleIdentifier"/>
        <xsl:sequence>
            <xsl:if test="$reportType = 'HTML'">
                <dd class="filter infos">
                    <i class="fa fa-info-circle info"/>
                    <xsl:value-of select="$infoMessage"/>
                </dd>
            </xsl:if>
            <xsl:if test="$reportType = 'SVRL'">

                <svrl:fired-rule id="{$ruleIdentifier}"/>
                <svrl:failed-assert location="{$pathChecked}" role="info" id="{$ruleIdentifier}">
                    <svrl:text>
                        <xsl:value-of select="$infoMessage"/>
                    </svrl:text>
                </svrl:failed-assert>

            </xsl:if>
        </xsl:sequence>
    </xsl:function>

    <xd:doc>
        <xd:desc>This function will generate a warning message</xd:desc>
        <xd:param name="warningMessage"/>
        <xd:param name="pathChecked"/>
        <xd:param name="ruleIdentifier"/>
    </xd:doc>
    <xsl:function name="f:generateWarningMessage">
        <xsl:param name="warningMessage"/>
        <xsl:param name="pathChecked"/>
        <xsl:param name="ruleIdentifier"/>

        <xsl:sequence>
            <xsl:if test="$reportType = 'HTML'">
                <dd class="filter warnings">
                    <i class="fa fa-exclamation-triangle warning"/>
                    <xsl:value-of select="$warningMessage"/>
                </dd>
            </xsl:if>
            <xsl:if test="$reportType = 'SVRL'">

                <svrl:fired-rule id="{$ruleIdentifier}"/>
                <svrl:failed-assert location="{$pathChecked}" role="warning" id="{$ruleIdentifier}">
                    <svrl:text>
                        <xsl:value-of select="$warningMessage"/>
                    </svrl:text>
                </svrl:failed-assert>
           

            </xsl:if>
        </xsl:sequence>
    </xsl:function>

    <xd:doc>
        <xd:desc>This function will generate an error message</xd:desc>
        <xd:param name="errorMessage"/>
        <xd:param name="pathChecked"/>
        <xd:param name="ruleIdentifier"/>
    </xd:doc>
    <xsl:function name="f:generateErrorMessage">
        <xsl:param name="errorMessage"/>
        <xsl:param name="pathChecked"/>
        <xsl:param name="ruleIdentifier"/>
        <xsl:sequence>
            <xsl:if test="$reportType = 'HTML'">
                <dd class="filter errors">
                    <i class="fa fa-times-circle error"/>
                    <xsl:value-of select="$errorMessage"/>
                </dd>
            </xsl:if>
            <xsl:if test="$reportType = 'SVRL'">
                <svrl:fired-rule id="{$ruleIdentifier}"/>
                    <svrl:failed-assert location="{$pathChecked}" role="error" id="{$ruleIdentifier}">
                        <svrl:text>
                            <xsl:value-of select="$errorMessage"/>
                        </svrl:text>
                    </svrl:failed-assert>
            </xsl:if>
        </xsl:sequence>
    </xsl:function>


    <xd:doc>
        <xd:desc>This function will generate a info message with a list </xd:desc>
        <xd:param name="infoMessage"/>
        <xd:param name="elementsList"/>
        <xd:param name="pathChecked"/>
        <xd:param name="ruleIdentifier"/>
    </xd:doc>
    <xsl:function name="f:generateFormattedInfoMessage">
        <xsl:param name="infoMessage"/>
        <xsl:param name="elementsList"/>
        <xsl:param name="pathChecked"/>
        <xsl:param name="ruleIdentifier"/>
        <xsl:sequence>
            <xsl:if test="$reportType = 'HTML'">
                <dd class="filter infos">
                    <i class="fa fa-info-circle info"/>
                    <xsl:value-of select="$infoMessage"/>
                    <ul>
                        <xsl:for-each select="$elementsList">
                            <li>
                                <xsl:value-of select="."/>
                            </li>
                        </xsl:for-each>
                    </ul>
                </dd>
            </xsl:if>
            <xsl:if test="$reportType = 'SVRL'">
                
                <svrl:fired-rule id="{$ruleIdentifier}"/>
                <svrl:failed-assert location="{$pathChecked}" role="info" id="{$ruleIdentifier}">
                    <svrl:text>
                        <xsl:value-of select="fn:concat($infoMessage, ' ')"/>
                        <xsl:for-each select="$elementsList">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:value-of select="', '"/>
                            </xsl:if>
                        </xsl:for-each>
                    </svrl:text>
                </svrl:failed-assert>

                
            </xsl:if>
        </xsl:sequence>
    </xsl:function>


    <xd:doc>
        <xd:desc>This function will generate a warning message with a list</xd:desc>
        <xd:param name="warningMessage"/>
        <xd:param name="elementsList"/>
        <xd:param name="pathChecked"/>
        <xd:param name="ruleIdentifier"/>
    </xd:doc>
    <xsl:function name="f:generateFormattedWarningMessage">
        <xsl:param name="warningMessage"/>
        <xsl:param name="elementsList"/>
        <xsl:param name="pathChecked"/>
        <xsl:param name="ruleIdentifier"/>
        <xsl:sequence>
            <xsl:if test="$reportType = 'HTML'">
                <dd class="filter warnings">
                    <i class="fa fa-exclamation-triangle warning"/>
                    <xsl:value-of select="$warningMessage"/>
                    <ul>
                        <xsl:for-each select="$elementsList">
                            <li>
                                <xsl:value-of select="."/>
                            </li>
                        </xsl:for-each>
                    </ul>
                </dd>
            </xsl:if>
            <xsl:if test="$reportType = 'SVRL'">
                
                <svrl:fired-rule id="{$ruleIdentifier}"/>
                <svrl:failed-assert location="{$pathChecked}" role="warning" id="{$ruleIdentifier}">
                    <svrl:text>
                        <xsl:value-of select="fn:concat($warningMessage, ' ')"/>
                        
                        <xsl:for-each select="$elementsList">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:value-of select="', '"/>
                            </xsl:if>
                        </xsl:for-each>
                    </svrl:text>
                </svrl:failed-assert>   
            </xsl:if>
        </xsl:sequence>
    </xsl:function>


    <xd:doc>
        <xd:desc>This function will generate a error message with a list </xd:desc>
        <xd:param name="errorMessage"/>
        <xd:param name="elementsList"/>
        <xd:param name="pathChecked"/>
        <xd:param name="ruleIdentifier"/>
    </xd:doc>
    <xsl:function name="f:generateFormattedErrorMessage">
        <xsl:param name="errorMessage"/>
        <xsl:param name="elementsList"/>
        <xsl:param name="pathChecked"/>
        <xsl:param name="ruleIdentifier"/>
        <xsl:sequence>
            <xsl:if test="$reportType = 'HTML'">
                <dd class="filter errors">
                    <i class="fa fa-times-circle error"/>
                    <xsl:value-of select="$errorMessage"/>
                    <ul>
                        <xsl:for-each select="$elementsList">
                            <li>
                                <xsl:value-of select="."/>
                            </li>
                        </xsl:for-each>
                    </ul>
                </dd>
            </xsl:if>
            <xsl:if test="$reportType = 'SVRL'">
                
                <svrl:fired-rule id="{$ruleIdentifier}"/>
                <svrl:failed-assert location="{$pathChecked}" role="error" id="{$ruleIdentifier}">
                    <svrl:text>
                        <xsl:value-of select="fn:concat($errorMessage, ' ')"/>
                        <xsl:for-each select="$elementsList">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:value-of select="', '"/>
                            </xsl:if>
                        </xsl:for-each>
                    </svrl:text>
                </svrl:failed-assert>    
            </xsl:if>
        </xsl:sequence>
    </xsl:function>


</xsl:stylesheet>