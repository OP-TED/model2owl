<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 2, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> lps</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template name="head">
        <head>            
            <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
            <meta charset="utf-8"/>
            <meta name="description" content="UML Comformance Report"/>
            <meta name="author" content="Publications Office of the European Union"/>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
            
            <link rel="stylesheet" href="static/css/jquery-ui.min.css"/>  
            <link rel="stylesheet" href="static/css/bootstrap.min.css"/>
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css"/>
            <link rel="stylesheet" href="static/css/pubcss-acm-sig.css"/>
            <link rel="stylesheet" media="screen" href="static/css/screen.css"/>
            <link rel="stylesheet" media="print" href="static/css/print.css"/>
            <link rel="stylesheet" href="static/css/toc_adjustments.css"/>
            
            <link rel="shortcut icon" href=""/>
            <title>UML Comformance Report</title>
        </head>
    </xsl:template>
    
</xsl:stylesheet>