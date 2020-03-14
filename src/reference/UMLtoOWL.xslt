<?xml version="1.0" encoding="UTF-8"?>
<!--
    File:    OUPtoOWL-Poseidon.xslt
    Purpose: An XSLT for producing an OWL XML serialization from  
    			a GOOD OLD AI's proposal for Ontology UML Profile. This 
    			version is accomodated for use with Poseidon for UML.
    Version: 0.3, 11 February 2006

    Copyright (C) 2006, Dragan Gasevic, Simon Fraser University, Surrey, Canada
    (http://www.sfu.ca/~dgasevic).
    

    
    History:
     
    November 24, 2006:
    
    The old OWL style of defining enumerations has been changes (see templated enumeration).
    
    11 February 2006:
    The template associationDomainRange and attributeDomainRangehave been changed. They now generate a property's range as a 
    union of all classes defined as its range in OUP models. This change has been made in order to support compatibilty of the generated OWL 
    ontologies and the OWL specification where defalt relation between multiple classes belonging to the same property's range is intersection, 
    while that meaning is union in OUP.
    
  	The enumeration template has been changed in order to have ful compatibility with Protege. These new OWL elements have been added just after the first 
  	named owl:Class elements: <xsl:element name="owl:equivalentClass"> and <xsl:element name="owl:Class">.
  	
  	The collectionInverse template has been changed in order to generate reference to individuals in an enumeration using the owl:Thing element instead of
  	the names of the corresponding classes they are instances of.
  	
  	The generalization template has been changed in order to distinguish between  subproperties and subclasses - the classOrPropery parameter has been added
  	that causes that super classes are referenced using the rdf:ID attribute, while super properties are still referenced using the rdf:resource property.
   	
    09 November 2003:
    
    extended support for collection template (i.e. Intersection and Union). Now this template provides 
    nesting one Intersection within onother one. 

      The above work was done by Dragan Gasevic
      (dgasevic@sfu.ca), postdoctoral fellow
      Laboratory for Ontological Engineering
      School of Interactive Arts and Technology
      Simon Fraser University Surrey
      13450 102 Ave.
      Surrey, BC V3T 5X3
      Canada
      
      Phone: +1 604 268.7520
      Fax: +1 604 268.7488
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:UML="org.omg.xmi.namespace.UML" xmlns:UML2 = 'org.omg.xmi.namespace.UML2' xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="UML" xmlns="http://owl.protege.stanford.edu#">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="owlPrefix">
		<xsl:text>http://www.w3.org/2002/07/owl#</xsl:text>
	</xsl:variable>
	<xsl:variable name="xsdPrefix">
		<xsl:text>http://www.w3.org/2001/XMLSchema#</xsl:text>
	</xsl:variable>
	<xsl:key name="stereotypeID" match="UML:Stereotype" use="@xmi.id"/>
	<xsl:key name="stereotypeName" match="UML:Stereotype" use="@name"/>
	<xsl:key name="classID" match="UML:Class" use="@xmi.id"/>
	<xsl:key name="classStereotypeID" match="UML:Class" use="UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
	<xsl:key name="linkEndID" match="UML:LinkEnd" use="@xmi.id"/>
	<xsl:key name="linkLinkEndID" match="UML:Link" use="UML:Link.connection/UML:LinkEnd/@xmi.id"/>
	<xsl:key name="linkID" match="UML:Link" use="@xmi.id"/>
	<xsl:key name="objectID" match="UML:Object" use="@xmi.id"/>
	<xsl:key name="tagDefinitionID" match="UML:TagDefinition" use="@xmi.id"/>
	<xsl:key name="dataTypeID" match="UML:DataType" use="@xmi.id"/>
	<xsl:key name="dependencyID" match="UML:Dependency" use="@xmi.id"/>
	<xsl:key name="dependencyClientID" match="UML:Dependency" use="UML:Dependency.client/UML:Class/@xmi.idref"/>
	<xsl:key name="dependencySupplierID" match="UML:Dependency" use="UML:Dependency.supplier/UML:Class/@xmi.idref"/>
	<xsl:key name="association" match="UML:Association" use="."/>
	<xsl:key name="generalizationID" match="UML:Generalization" use="@xmi.id"/>
	<xsl:key name="associationStereotypeID" match="UML:Association" use="UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
	<xsl:key name="associationEnd1" match="UML:Association" use="UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
	<xsl:key name="associationEnd2" match="UML:Association" use="UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
	<xsl:template match="/">
		<xsl:apply-templates select="XMI"/>
	</xsl:template>
	<xsl:template match="XMI">
		<xsl:apply-templates select="XMI.content/UML:Model"/>
	</xsl:template>
	<xsl:template match="XMI.content/UML:Model">
		<xsl:apply-templates select="UML:Namespace.ownedElement"/>
	</xsl:template>
	<xsl:template match="UML:Namespace.ownedElement">
		<rdf:RDF>
			<xsl:attribute name = "xml:base">http://owl.protege.stanford.edu</xsl:attribute>
			<xsl:apply-templates select="UML:Package/UML:Namespace.ownedElement"/>
		</rdf:RDF>
	</xsl:template>
	<xsl:template match="UML:Package/UML:Namespace.ownedElement">
		<xsl:if test="(key('stereotypeID', ../UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref)/@name = 'ontology') and
					(key('stereotypeID', ../UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref)/UML:Stereotype.baseClass = 'Package')">
			<xsl:apply-templates select="UML:Class"/>
			<xsl:apply-templates select="UML:Object"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="UML:Object">
		<xsl:variable name="objectStereotype" select="./UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
		<xsl:if test="key('stereotypeID', ./UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref)/@name = 'OntClass' 
		and key('stereotypeID', ./UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref)/UML:Stereotype.baseClass = 'Object'">
			<xsl:variable name="class">
				<xsl:value-of select="./UML:Instance.classifier/UML:Class/@xmi.idref"/>
			</xsl:variable>
			<xsl:element name="{key('classID', $class)/@name}">
				<xsl:attribute name="rdf:ID"><xsl:value-of select="./@name"/></xsl:attribute>
				<!--Poziv template-a za sameAs stereotip -->
				<xsl:call-template name="objectDepedencyStereotype">
					<xsl:with-param name="stereotype">
						<xsl:text>sameAs</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<!--Poziv template-a za sameAs stereotip -->
				<xsl:call-template name="objectDepedencyStereotype">
					<xsl:with-param name="stereotype">
						<xsl:text>differentFrom</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="Link"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Link">
		<!--Varaible that contains ID of the current Object-->
		<xsl:variable name="objectID" select="./@xmi.id"/>
		<!--For each LinkEnd that the current Object has -->
		<xsl:for-each select="./UML:Instance.linkEnd/UML:LinkEnd">
			<!--Variable that contains ID of current LinkEnd-->
			<xsl:variable name="linkEndID" select="./@xmi.idref"/>
			<!--A Link that contain current LinkEnd -->
			<xsl:variable name="linkID">
				<xsl:value-of select="key('linkLinkEndID', $linkEndID)/@xmi.id"/>
			</xsl:variable>
			<!--The opposite LinkEnd of the current Link -->
			<xsl:variable name="oppositeLinkEnd">
				<xsl:if test="key('linkID', $linkID)/UML:Link.connection/UML:LinkEnd[1]/@xmi.id =  $linkEndID">
					<xsl:value-of select="key('linkID', $linkID)/UML:Link.connection/UML:LinkEnd[2]/@xmi.id"/>
				</xsl:if>
				<xsl:if test="key('linkID', $linkID)/UML:Link.connection/UML:LinkEnd[2]/@xmi.id =  $linkEndID">
					<xsl:value-of select="key('linkID', $linkID)/UML:Link.connection/UML:LinkEnd[1]/@xmi.id"/>
				</xsl:if>
			</xsl:variable>
			<!--Variable that contains ID of the stereotype of the current Link -->
			<xsl:variable name="linkStereotype">
				<xsl:value-of select="key('linkLinkEndID', $linkEndID)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
			</xsl:variable>
			<!--Variable that contains ID of opposite (second) LinkEnd (Object) -->
			<xsl:variable name="objectIDRef">
				<xsl:value-of select="key('linkEndID',  $oppositeLinkEnd)/UML:LinkEnd.instance/UML:Object/@xmi.idref"/>
			</xsl:variable>
			<!--Type (Class) of opposite LinkEnd (Object)-->
			<xsl:variable name="linkEndTypeID">
				<xsl:value-of select="key('objectID', $objectIDRef)/UML:Instance.classifier/UML:Class/@xmi.idref"/>
			</xsl:variable>
			<!--If current Link is subject stereotype-->
			<xsl:if test="key('stereotypeID', $linkStereotype)/@name = 'subject'">
				<xsl:element name="{key('classID', $linkEndTypeID)/@name}">
					<xsl:for-each select="key('objectID', $objectIDRef)/UML:Instance.linkEnd/UML:LinkEnd">
						<!--Variable that contains ID of opposite Object of current Link end - now it is current LinkEnd-->
						<xsl:variable name="properyLinkEnd" select="./@xmi.idref"/>
						<!--ID of Link containing current LinkEnd-->
						<xsl:variable name="propertyLinkID">
							<xsl:value-of select="key('linkLinkEndID', $properyLinkEnd)/@xmi.id"/>
						</xsl:variable>
						<!--ID of current Link Stereotype-->
						<xsl:variable name="propertyLinkStereotype">
							<xsl:value-of select="key('linkLinkEndID', $properyLinkEnd)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
						</xsl:variable>
						<!--If Current link stereotype is <<object>>-->
						<xsl:if test="key('stereotypeID', $propertyLinkStereotype)/@name = 'object'">
							<!--Opposite LinkEnd of current LinkEnd (relation Object)-->
							<xsl:variable name="propertyOppositeLinkEnd">
								<xsl:if test="key('linkID', $propertyLinkID)/UML:Link.connection/UML:LinkEnd[1]/@xmi.id = $properyLinkEnd">
									<xsl:value-of select="key('linkID', $propertyLinkID)/UML:Link.connection/UML:LinkEnd[2]/@xmi.id"/>
								</xsl:if>
								<xsl:if test="key('linkID', $propertyLinkID)/UML:Link.connection/UML:LinkEnd[2]/@xmi.id = $properyLinkEnd">
									<xsl:value-of select="key('linkID', $propertyLinkID)/UML:Link.connection/UML:LinkEnd[1]/@xmi.id"/>
								</xsl:if>
							</xsl:variable>
							<!--Object that is equval to opposite LinkEnd -->
							<xsl:variable name="propertyObjectIDRef">
								<xsl:value-of select="key('linkEndID', $propertyOppositeLinkEnd)/UML:LinkEnd.instance/UML:Object/@xmi.idref"/>
							</xsl:variable>
							<!--Type (Class) of Opposite LinkEnd (Object)-->
							<xsl:variable name="propertyLinkEndTypeID">
								<xsl:value-of select="key('objectID', $propertyObjectIDRef)/UML:Instance.classifier/UML:Class/@xmi.idref"/>
							</xsl:variable>
							<xsl:variable name="propertyObjectStereotype">
								<xsl:value-of select="key('objectID', $objectIDRef)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
							</xsl:variable>
							<xsl:if test="key('stereotypeID', $propertyObjectStereotype)/@name = 'ObjectProperty'">
								<xsl:attribute name="rdf:resource"><xsl:text>#</xsl:text><xsl:value-of select="key('objectID', $propertyObjectIDRef)/@name"/></xsl:attribute>
							</xsl:if>
							<xsl:if test="key('stereotypeID', $propertyObjectStereotype)/@name = 'DatatypeProperty'">
								<xsl:value-of select="key('objectID', $propertyObjectIDRef)/@name"/>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="UML:Class">
		<xsl:variable name="stereotype">
			<xsl:value-of select="./UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
		</xsl:variable>
		<xsl:variable name="id">
			<xsl:value-of select="./@xmi.id"/>
		</xsl:variable>
		<xsl:variable name="classSterotype">
			<xsl:value-of select="key('stereotypeID', $stereotype)/@name"/>
		</xsl:variable>
		
		<!--Cases when we should convert an OWL Class or some OWL class constraint-->
		<xsl:if test="$classSterotype = 'ObjectProperty'">
			<xsl:call-template name="ObjectProperty"/>
		</xsl:if>
		<xsl:if test="$classSterotype = 'DatatypeProperty'">
			<xsl:call-template name="DatatypeProperty"/>
		</xsl:if>
		
		<xsl:if test="($classSterotype = 'OntClass') or ($classSterotype = 'Union') or ($classSterotype = 'Intersection') or ($classSterotype = 'Enumeration' or ($classSterotype = 'allDifferent'))">
			<xsl:call-template name="Class"/>
		</xsl:if>
		
	</xsl:template>
	
	
	
	<xsl:template name="Class">
		<xsl:param name="anon">
			<xsl:text>no</xsl:text>
		</xsl:param>
		<xsl:variable name="anonymousID">
			<xsl:if test="./UML:ModelElement.taggedValue">
				<xsl:value-of select="./UML:ModelElement.taggedValue/UML:TaggedValue/UML:TaggedValue.type/UML:TagDefinition/@xmi.idref"/>
			</xsl:if>
			<xsl:if test="not(./UML:ModelElement.taggedValue)">
				<xsl:text>noTaggedValue</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="taggedValue">
			<xsl:value-of select="./UML:ModelElement.taggedValue/UML:TaggedValue/UML:TaggedValue.dataValue"/>
		</xsl:variable>
		<xsl:if test="((key('tagDefinitionID', $anonymousID)/@name = 'odm.anonymous') and ($taggedValue ='true') and ($anon = 'yes')) or  ( not ((key('tagDefinitionID', $anonymousID)/@name = 'odm.anonymous') and ($taggedValue ='true')) and ($anon = 'no'))">
			<xsl:variable name="stereotype">
				<xsl:value-of select="./UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
			</xsl:variable>
			<xsl:variable name="id">
				<xsl:value-of select="./@xmi.id"/>
			</xsl:variable>
			<xsl:variable name="classSterotype">
				<xsl:value-of select="key( 'stereotypeID' , $stereotype)/@name"/>
			</xsl:variable>
			<xsl:variable name = "classOrAllDifferent">
				<xsl:choose>
					<xsl:when test="($classSterotype = 'allDifferent')">
						<xsl:text>owl:AllDifferent</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>owl:Class</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:element name="{$classOrAllDifferent}">
				<xsl:if test="($classSterotype != 'allDifferent') and ($anon ='no')">
					<xsl:attribute name="rdf:ID"><xsl:value-of select="./@name"/></xsl:attribute>
				</xsl:if>
				<!--This template invocation performs cration of subClassOf or subPropertyOf consturcts-->
				<xsl:call-template name="generalization">
					<xsl:with-param name="generalizationKind">
						<xsl:text>rdfs:subClassOf</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="classOrProperty">
						<xsl:text>class</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<!--This template invocation  is responsible to detect all class <<domain>> associations
				and to generate 	necessary cardinality constrains in OWL-->
				<!--This temeplate invocation is is responsibe to detect all associations with <<Restriction>> 
			stereotypes and to make subClassOf restriction on current Class using: hasValue-->
				<xsl:call-template name="classRestrictionProperty">
					<xsl:with-param name="restrictionKind">
						<xsl:text>hasValue</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<!--This temeplate invocation is is responsibe to detect all associations with <<Restriction>> 
			stereotypes and to make subClassOf restriction on current Class using: allValuesFrom -->
				<xsl:call-template name="classRestrictionProperty">
					<xsl:with-param name="restrictionKind">
						<xsl:text>allValuesFrom</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<!--This temeplate invocation is is responsibe to detect all associations with <<Restriction>> 
			stereotypes and to make subClassOf restriction on current Class using: someValuesFrom -->
				<xsl:call-template name="classRestrictionProperty">
					<xsl:with-param name="restrictionKind">
						<xsl:text>someValuesFrom</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="classRestrictionCardinalityProperty"/>
				<xsl:call-template name="classDomainAssociationMulitiplicity"/>
				<xsl:call-template name="classDomainAttributeMulitiplicity"/>
				<!--Poziv template-a za equivalentClass stereotip -->
				<xsl:call-template name="classDepedencyStereotype">
					<xsl:with-param name="stereotype">
						<xsl:text>equivalentClass</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<!--./UML:ModelElement.taggedValue/UML:TaggedValue/UML:TaggedValue.type/UML:TagDefinition/@xmi.idref-->
				<!--Poziv template-a za complementOf stereotip -->
				<xsl:call-template name="classDepedencyStereotype">
					<xsl:with-param name="stereotype">
						<xsl:text>complementOf</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<!--Poziv template-a za disjointWith stereotip -->
				<xsl:call-template name="classDepedencyStereotype">
					<xsl:with-param name="stereotype">
						<xsl:text>disjointWith</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<!--Poziv template-a za sameAs stereotip -->
				<xsl:call-template name="classDepedencyStereotype">
					<xsl:with-param name="stereotype">
						<xsl:text>sameAs</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<!--Poziv template-a za Union stereotip -->
				<xsl:if test="$classSterotype = 'Union' ">
					<xsl:call-template name="unionOf"/>
				</xsl:if>
				<!--Poziv template-a za Intersection stereotip -->
				<xsl:if test="$classSterotype = 'Intersection' ">
					<xsl:call-template name="intersectionOf"/>
				</xsl:if>
				<!--Poziv template-a za Enumeration stereotip -->
				<xsl:if test="$classSterotype = 'Enumeration' ">
					<xsl:call-template name="enumeration"/>
				</xsl:if>
				<!--Poziv template-a za allDifferent stereotip -->
				<xsl:if test="$classSterotype = 'allDifferent' ">
					<xsl:call-template name="allDifferent"/>
				</xsl:if>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="ObjectProperty">
		<xsl:variable name="range">
			<xsl:text>Class</xsl:text>
		</xsl:variable>
		<xsl:variable name="classID" select="./@xmi.id"/>
		<xsl:element name="owl:ObjectProperty">
			<xsl:attribute name="rdf:ID"><xsl:value-of select="./@name"/></xsl:attribute>
			<xsl:call-template name="classDepedencyStereotype">
				<xsl:with-param name="stereotype">
					<xsl:text>equivalentProperty</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="taggedValues"/>
			<xsl:call-template name="generalization">
				<xsl:with-param name="generalizationKind">
					<xsl:text>rdfs:subPropertyOf</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<!--Poziv template-a za complementOf stereotip -->
			<xsl:call-template name="classDepedencyStereotype">
				<xsl:with-param name="stereotype">
					<xsl:text>inverseOf</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="attributeDomainRange"/>
			<xsl:call-template name="associationDomainRange">
				<xsl:with-param name="range" select="$range"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template name="attributeDomainRange">
	
		<xsl:if test="./UML:Classifier.feature/UML:Attribute">
			<xsl:if test = "count(./UML:Classifier.feature/UML:Attribute/UML:ModelElement.stereotype/UML:Stereotype[@xmi.idref = key( 'stereotypeName', 'domain')/@xmi.id]) > 0">
				<xsl:element name="rdfs:domain">
				<xsl:element name="owl:Class">
				<xsl:element name="owl:unionOf">
					<xsl:attribute name="rdf:parseType">
						<xsl:text>Collection</xsl:text>
					</xsl:attribute>
					<xsl:for-each select="./UML:Classifier.feature/UML:Attribute">
					
						<xsl:variable name="type" select="./UML:StructuralFeature.type/UML:Class/@xmi.idref"/>
						<xsl:variable name="attrStereotype" select="./UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
						
						<xsl:if test="key( 'stereotypeID' , $attrStereotype)/@name = 'domain' ">
							<xsl:element name="owl:Class">
								<xsl:attribute name="rdf:about"><xsl:text>#</xsl:text><xsl:value-of select="key( 'classID', $type)/@name"/></xsl:attribute>
							</xsl:element>
						</xsl:if>
						
					<!--	<xsl:if test="key( 'stereotypeID' , $attrStereotype)/@name = 'range' ">
							<xsl:variable name="attributeType">
								<xsl:value-of select="key( 'dataTypeID', $type)/@name"/>
								<xsl:value-of select="key( 'classID', $type)/@name"/>
							</xsl:variable>
							<xsl:variable name="xsdType">
								<xsl:call-template name="xsdType">
									<xsl:with-param name="type" select="$attributeType"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:element name="rdfs:range">
								<xsl:attribute name="rdf:resource"><xsl:value-of select="$xsdType"/></xsl:attribute>
							</xsl:element>
						</xsl:if>-->
						
					</xsl:for-each>
			</xsl:element>
			</xsl:element>
			</xsl:element>
			</xsl:if>
			
			<xsl:if test = "count(./UML:Classifier.feature/UML:Attribute/UML:ModelElement.stereotype/UML:Stereotype[@xmi.idref = key( 'stereotypeName', 'range')/@xmi.id]) > 0">
				<xsl:for-each select="./UML:Classifier.feature/UML:Attribute">
						
					<xsl:variable name="type" select="./UML:StructuralFeature.type/UML:Class/@xmi.idref"/>
					<xsl:variable name="attrStereotype" select="./UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
							
					<xsl:if test="key( 'stereotypeID' , $attrStereotype)/@name = 'domain' ">
						<xsl:element name="owl:Class">
							<xsl:attribute name="rdf:about"><xsl:text>#</xsl:text><xsl:value-of select="key( 'classID', $type)/@name"/></xsl:attribute>
						</xsl:element>
					</xsl:if>
							
					<xsl:if test="key( 'stereotypeID' , $attrStereotype)/@name = 'range' ">
						<xsl:variable name="attributeType">
							<xsl:value-of select="key( 'dataTypeID', $type)/@name"/>
							<xsl:value-of select="key( 'classID', $type)/@name"/>
						</xsl:variable>
						<xsl:variable name="xsdType">
							<xsl:call-template name="xsdType">
								<xsl:with-param name="type" select="$attributeType"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:element name="rdfs:range">
							<xsl:attribute name="rdf:resource"><xsl:value-of select="$xsdType"/></xsl:attribute>
						</xsl:element>
					</xsl:if>
							
				</xsl:for-each>
			</xsl:if>

		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template name="DatatypeProperty">
		<xsl:variable name="range">
			<xsl:text>DataType</xsl:text>
		</xsl:variable>
		<xsl:element name="owl:DatatypeProperty">
			<xsl:attribute name="rdf:ID"><xsl:value-of select="./@name"/></xsl:attribute>
			<xsl:call-template name="classDepedencyStereotype">
				<xsl:with-param name="stereotype">
					<xsl:text>equivalentProperty</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="taggedValues"/>
			<xsl:call-template name="generalization">
				<xsl:with-param name="generalizationKind">
					<xsl:text>rdfs:subPropertyOf</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="attributeDomainRange"/>
			<xsl:call-template name="associationDomainRange">
				<xsl:with-param name="range" select="$range"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template name="xsdType">
		<xsl:param name="type"/>
		<xsl:variable name="return">
			<xsl:choose>
				<xsl:when test= "$type = 'String' ">
					<xsl:text>http://www.w3.org/2001/XMLSchema#string</xsl:text>
				</xsl:when>
				<xsl:when test="$type = 'Integer' ">
					<xsl:text>http://www.w3.org/2001/XMLSchema#int</xsl:text>
				</xsl:when>
				<xsl:when test="$type = 'Double'">
					<xsl:text>http://www.w3.org/2001/XMLSchema#double</xsl:text>
				</xsl:when>
				<xsl:when test="$type = 'Long'">
					<xsl:text>http://www.w3.org/2001/XMLSchema#long</xsl:text>
				</xsl:when>
				<xsl:when test="$type = 'anyURI'">
					<xsl:text>http://www.w3.org/2001/XMLSchema#anyURI</xsl:text>
				</xsl:when>
				<xsl:when test="$type = 'duration'">
					<xsl:text>http://www.w3.org/2001/XMLSchema#duration</xsl:text>
				</xsl:when>
				<xsl:when test="$type = 'decimal'">
					<xsl:text>http://www.w3.org/2001/XMLSchema#decimal</xsl:text>
				</xsl:when>
				<!--extend here for other datatypes -->
				<xsl:otherwise>
					<xsl:text>#</xsl:text>
					<xsl:value-of select="$type"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$return"/>
	</xsl:template>
	
	
	<xsl:template name="unionOf">
		<xsl:element name="owl:unionOf">
			<xsl:attribute name="rdf:parseType">Collection</xsl:attribute>
			<xsl:call-template name="collection">
				<xsl:with-param name="stereotype">
					<xsl:text>unionOf</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template name="allDifferent">
		<xsl:element name="owl:distinctMembers">
			<xsl:attribute name="rdf:parseType">Collection</xsl:attribute>
			<xsl:call-template name="distinctMembers">
				<xsl:with-param name="stereotype">
					<xsl:text>distinctMembers</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<!--Odavde nastaviti-->
	<xsl:template name="distinctMembers">
		<xsl:param name="stereotype"/>
		<xsl:variable name="client" select="./@xmi.id"/>
		<xsl:variable name="dependencyStereotype">
			<xsl:value-of select="key('stereotypeName', $stereotype)/@xmi.id"/>
		</xsl:variable>
		<xsl:for-each select="key( 'dependencyClientID', $client)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $dependencyStereotype]">
			<xsl:variable name="id">
				<xsl:value-of select="./UML:Dependency.supplier/UML:Object/@xmi.idref"/>
			</xsl:variable>
			<xsl:variable name="classID" select="key( 'objectID', $id)/UML:Instance.classifier/UML:Class/@xmi.idref"/>
			<xsl:element name="{key('classID', $classID)/@name}">
				<xsl:attribute name="rdf:about"><xsl:text>#</xsl:text><xsl:value-of select="key( 'objectID', $id)/@name"/></xsl:attribute>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="intersectionOf">
		<xsl:element name="owl:intersectionOf">
			<xsl:attribute name="rdf:parseType">Collection</xsl:attribute>
			<xsl:call-template name="collection">
				<xsl:with-param name="stereotype">
					<xsl:text>intersectionOf</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template name="collection">
		<xsl:param name="stereotype"/>
		
		<xsl:variable name="client" select="./@xmi.id"/>
		<xsl:variable name="dependencyStereotype">
			<xsl:value-of select="key('stereotypeName', $stereotype)/@xmi.id"/>
		</xsl:variable>
		<xsl:for-each select="key( 'dependencyClientID', $client)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $dependencyStereotype]">
			<xsl:variable name="id">
				<xsl:value-of select="./UML:Dependency.supplier/UML:Class/@xmi.idref"/>
			</xsl:variable>
			
			<xsl:variable name="supplierStereotype" select="key('stereotypeID', key('classID', $id)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref)/@name"/>
			<xsl:variable name="taggedValueAnonymousID">
				<xsl:choose>
					<xsl:when test="key( 'classID', $id)/UML:ModelElement.taggedValue">
						<xsl:value-of select="key( 'classID', $id)/UML:ModelElement.taggedValue/UML:TaggedValue/UML:TaggedValue.type/UML:TagDefinition/@xmi.idref"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>no</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$taggedValueAnonymousID != 'no' and key( 'tagDefinitionID', $taggedValueAnonymousID)/@name = 'odm.anonymous'">
					<xsl:if test="$supplierStereotype = 'Intersection' or $supplierStereotype = 'Union' ">
						
						<xsl:for-each select="key( 'classID', $id)">
							<xsl:variable name="collectionKind">
								<xsl:choose>
									<xsl:when test="$supplierStereotype = 'Intersection' ">intersectionOf</xsl:when>
									<xsl:when test="$supplierStereotype = 'Union' ">unionOf</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="owl:Class">
								<xsl:variable name="prefixedCollectionKind">
									<xsl:text>owl:</xsl:text>
									<xsl:value-of select="$collectionKind"/>
								</xsl:variable>
								<xsl:element name="{$prefixedCollectionKind}">
									<xsl:attribute name="rdf:parseType">Collection</xsl:attribute>
									<xsl:call-template name="collection">
										<xsl:with-param name="stereotype">
											<xsl:value-of select="$collectionKind"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:element>
							</xsl:element>
						</xsl:for-each>
						
					</xsl:if>
					<!--	<stereotype><xsl:value-of select="$supplierStereotype"/></stereotype>

					This loop is necessary only to make dependency Supplier as a current context for template Class
							This loop iterates only ones-->
				<xsl:for-each select="key( 'classID', $id)">
				<!--			<xsl:call-template name="Class">
							<xsl:with-param name="anon">
								<xsl:text>yes</xsl:text>
							</xsl:with-param>
						</xsl:call-template>-->
						<!-- This strange code I forgot to delete, and this template wasn't work welll. When I deleted it this 
						template was good.-->


							<xsl:call-template name="classRestrictionProperty">
								<xsl:with-param name="restrictionKind">
									<xsl:text>hasValue</xsl:text>
								</xsl:with-param>
								<xsl:with-param name="writeSubClass">
									<xsl:text>no</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
							
							<xsl:call-template name="classRestrictionProperty">
								<xsl:with-param name="restrictionKind">
									<xsl:text>allValuesFrom</xsl:text>
								</xsl:with-param>
								<xsl:with-param name="writeSubClass">
									<xsl:text>no</xsl:text>
								</xsl:with-param>
							</xsl:call-template>

							<xsl:call-template name="classRestrictionProperty">
								<xsl:with-param name="restrictionKind">
									<xsl:text>someValuesFrom</xsl:text>
								</xsl:with-param>
								<xsl:with-param name="writeSubClass">
									<xsl:text>no</xsl:text>
								</xsl:with-param>
							</xsl:call-template>

				</xsl:for-each>		
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="owl:Class">
						<xsl:attribute name="rdf:about"><xsl:text>#</xsl:text><xsl:value-of select="key( 'classID', $id)/@name"/></xsl:attribute>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			<!--			
			<xsl:element name="owl:Class">
				<xsl:attribute name="rdf:about">
					<xsl:text>#</xsl:text>
					<xsl:value-of select="key( 'classID', $id)/@name"/>
				</xsl:attribute>
			</xsl:element>-->
		</xsl:for-each>
	</xsl:template>
	
	
	

	<xsl:template name="collectionInverse">
		<xsl:param name="stereotype"/>
		<xsl:variable name="supplier" select="./@xmi.id"/>
		<xsl:variable name="dependencyStereotype">
			<xsl:value-of select="key('stereotypeName', $stereotype)/@xmi.id"/>
		</xsl:variable>
		<xsl:for-each select="key('dependencySupplierID',  $supplier)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $dependencyStereotype]">
			<xsl:variable name="id">
				<xsl:value-of select="./UML:Dependency.client/UML:Object/@xmi.idref"/>
			</xsl:variable>
			<xsl:variable name="classID" select="key( 'objectID', $id)/UML:Instance.classifier/UML:Class/@xmi.idref"/>
			<xsl:variable name="className">
				<xsl:value-of select="key( 'classID', $classID)/@name"/>
			</xsl:variable>
			<xsl:if test="key( 'classID', $classID)">
				<xsl:element name = "owl:Thing">
			<!--<xsl:element name="{$className}">-->
					<xsl:attribute name="rdf:about"><xsl:text>#</xsl:text><xsl:value-of select="key('objectID', $id)/@name"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	
	
	
	<xsl:template name="classDepedencyStereotype">
		<xsl:param name="stereotype"/>
		<!--Variable koji sluze da provere da li je jedna od zavisnosti koja je povezuje trenutnu Class sterotip-->
		<xsl:variable name="depedencyStereotypeID">
			<xsl:value-of select="key( 'stereotypeName', $stereotype)/@xmi.id"/>
		</xsl:variable>
		<xsl:for-each select="./UML:ModelElement.clientDependency/UML:Dependency">
			<xsl:variable name="classDependency">
				<xsl:value-of select="./@xmi.idref"/>
			</xsl:variable>
			<xsl:variable name="dependencyStereotype">
				<xsl:value-of select="key('dependencyID', $classDependency)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
			</xsl:variable>
			<xsl:variable name="dependencySupplier">
				<xsl:value-of select="key('dependencyID', $classDependency)/UML:Dependency.supplier/UML:Class/@xmi.idref"/>
			</xsl:variable>
			<!--Ovde je potrebeno proberiti da li je dependency supplier odm.anonymous = true. Ako je se onda je potrebno pozvati Class template, ali u njemu se sada ne dodaje naziv klase.  Ovaj postojeci deo se samo radi u slucaju da ovo sto sam rekao nije tacno. Uslov bi bio sledeci:-->
			<xsl:variable name="taggedValueAnonymousID">
				<xsl:choose>
					<xsl:when test="key( 'classID', $dependencySupplier)/UML:ModelElement.taggedValue">
						<xsl:value-of select="key( 'classID', $dependencySupplier)/UML:ModelElement.taggedValue/UML:TaggedValue/UML:TaggedValue.type/UML:TagDefinition/@xmi.idref"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>no</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$depedencyStereotypeID=$dependencyStereotype">
				<xsl:variable name="statementName">
					<xsl:text>owl:</xsl:text>
					<xsl:value-of select="$stereotype"/>
				</xsl:variable>
				<xsl:element name="{$statementName}">
					<xsl:choose>
						<xsl:when test="$taggedValueAnonymousID != 'no' and key( 'tagDefinitionID', $taggedValueAnonymousID)/@name = 'odm.anonymous'">
							<!--This loop is necessary only to make dependency Supplier as a current context for template Class
							This loop iterates only ones-->
							<xsl:for-each select="key( 'classID', $dependencySupplier)">
								<xsl:call-template name="Class">
									<xsl:with-param name="anon">
										<xsl:text>yes</xsl:text>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="owl:Class">
								<xsl:attribute name="rdf:about"><xsl:text>#</xsl:text><xsl:value-of select="key( 'classID', $dependencySupplier)/@name"/></xsl:attribute>
							</xsl:element>
							<!--<xsl:attribute name="rdf:resource"><xsl:text>#</xsl:text><xsl:value-of select="key( 'classID', $dependencySupplier)/@name"/></xsl:attribute>-->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	
	
	
	<xsl:template name="objectDepedencyStereotype">
		<xsl:param name="stereotype"/>
		<!--Variable koji sluze da provere da li je jedna od zavisnosti koja je povezuje trenutnu Object sterotip-->
		<xsl:variable name="depedencyStereotypeID">
			<xsl:value-of select="key('stereotypeName', $stereotype)/@xmi.id"/>
		</xsl:variable>
		<xsl:for-each select="./UML:ModelElement.clientDependency/UML:Dependency">
			<xsl:variable name="objectDependency">
				<xsl:value-of select="./@xmi.idref"/>
			</xsl:variable>
			<xsl:variable name="dependencyStereotype">
				<xsl:value-of select="key( 'dependencyID', $objectDependency)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
			</xsl:variable>
			<xsl:variable name="dependencySupplier">
				<xsl:value-of select="key( 'dependencyID', $objectDependency)/UML:Dependency.supplier/UML:Object/@xmi.idref"/>
			</xsl:variable>
			<xsl:if test="$depedencyStereotypeID=$dependencyStereotype">
				<xsl:variable name="statementName">
					<xsl:text>owl:</xsl:text>
					<xsl:value-of select="$stereotype"/>
				</xsl:variable>
				<xsl:element name="{$statementName}">
					<xsl:attribute name="rdf:resource"><xsl:text>#</xsl:text><xsl:value-of select="key( 'objectID', $dependencySupplier)/@name"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	
	
	
	<xsl:template name="associationDomainRange">
		<xsl:param name="range"/>
		<xsl:variable name="DomainStereotype" select="key( 'stereotypeName', 'domain')[UML:Stereotype.baseClass = 'Association']/@xmi.id"/>
		<xsl:variable name="RangeStereotype" select="key( 'stereotypeName', 'range')[UML:Stereotype.baseClass = 'Association']/@xmi.id"/>
		<xsl:variable name="id" select="./@xmi.id"/>
		
		
		<xsl:if test = "key( 'associationStereotypeID',  $RangeStereotype) and $range = 'Class' and (key( 'associationEnd1',  $id) or key( 'associationEnd2',  $id))">
			<xsl:element name="rdfs:range">
			<xsl:element name="owl:Class">
			<xsl:element name="owl:unionOf">
				<xsl:attribute name="rdf:parseType">
					<xsl:text>Collection</xsl:text>
				</xsl:attribute>
				<xsl:for-each select="key( 'associationStereotypeID',  $RangeStereotype)">
					<xsl:variable name="type1" select="./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
					<xsl:variable name="type2" select="./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
					<xsl:variable name = "stereotype1" select = "key('stereotypeID', key('classID', $type1)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref)/@name"/>
					<xsl:variable name = "stereotype2" select = "key('stereotypeID', key('classID', $type2)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref)/@name"/>
					<xsl:if test = "not(($stereotype1 = 'DataRange') or ($stereotype2 = 'DataRange'))">
						<xsl:variable name="associationStereotype">
							<xsl:value-of select="./UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
						</xsl:variable>
						<xsl:variable name="associationType">
							<xsl:choose>
								<xsl:when test="$type1 = $id">
									<xsl:value-of select="key( 'dataTypeID', $type2)/@name"/>
									<xsl:value-of select="key( 'classID', $type2)/@name"/>
								</xsl:when>
								<xsl:when test="$type2 = $id">
									<xsl:value-of select="key( 'dataTypeID', $type1)/@name"/>
									<xsl:value-of select="key( 'classID', $type1)/@name"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="key( 'stereotypeID',  $associationStereotype)/@name =  'range' ">
							<xsl:if test="($type1 = $id) or ($type2 = $id)">
								<xsl:element name ="owl:Class">
									<xsl:attribute name="rdf:about">
										<xsl:text>#</xsl:text>
											<xsl:value-of select="$associationType"/>
									</xsl:attribute>
								</xsl:element>
							</xsl:if>
						</xsl:if>
					</xsl:if>	
				</xsl:for-each>
			</xsl:element>
			</xsl:element>
			</xsl:element>
		</xsl:if>
		
		<xsl:if test = "key( 'associationStereotypeID',  $RangeStereotype) and $range = 'DataType' and (key( 'associationEnd1',  $id) or key( 'associationEnd2',  $id))">
			<xsl:element name="rdfs:range">
				<xsl:for-each select="key( 'associationStereotypeID',  $RangeStereotype)">
					<xsl:variable name="type1" select="./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
					<xsl:variable name="type2" select="./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
					<xsl:variable name="associationStereotype">
						<xsl:value-of select="./UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
					</xsl:variable>
					
					<xsl:variable name = "stereotype1" select = "key('stereotypeID', key('classID', $type1)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref)/@name"/>
					<xsl:variable name = "stereotype2" select = "key('stereotypeID', key('classID', $type2)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref)/@name"/>

					<xsl:variable name="associationType">
						<xsl:choose>
							<xsl:when test="$type1 = $id">
								<xsl:value-of select="key( 'dataTypeID', $type2)/@name"/>
								<xsl:value-of select="key( 'classID', $type2)/@name"/>
							</xsl:when>
							<xsl:when test="$type2 = $id">
								<xsl:value-of select="key( 'dataTypeID', $type1)/@name"/>
								<xsl:value-of select="key( 'classID', $type1)/@name"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="key( 'stereotypeID',  $associationStereotype)/@name =  'range' ">
						<xsl:if test="($type1 = $id) or ($type2 = $id)">
						<xsl:choose>
							<xsl:when test = "not(($stereotype1 = 'DataRange') or ($stereotype2 = 'DataRange'))">
								<xsl:attribute name="rdf:resource">
									<xsl:variable name="xsdType">
										<xsl:call-template name="xsdType">
											<xsl:with-param name="type" select="$associationType"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="$xsdType"/>	
								</xsl:attribute>		
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="dataRange">
									<xsl:with-param name = "classID">
										<xsl:if test = "$stereotype1 = 'DataRange'">
											<xsl:value-of select = "$type1"/>
										</xsl:if>
										<xsl:if test = "$stereotype2 = 'DataRange'">
											<xsl:value-of select = "$type2"/>
										</xsl:if>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
							
						</xsl:if>
					</xsl:if>
				</xsl:for-each>

			</xsl:element>
		</xsl:if>
		
		
		
		<xsl:if test = "key( 'associationStereotypeID',  $DomainStereotype) and (key( 'associationEnd1',  $id) or key( 'associationEnd2',  $id))">
			<xsl:element name="rdfs:domain">
			<xsl:element name="owl:Class">
			<xsl:element name="owl:unionOf">
				<xsl:attribute name="rdf:parseType">
					<xsl:text>Collection</xsl:text>
				</xsl:attribute>
		<xsl:for-each select="key( 'associationStereotypeID',  $DomainStereotype)">
			<xsl:variable name="type1" select="./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
			<xsl:variable name="type2" select="./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
			<xsl:variable name="associationStereotype">
				<xsl:value-of select="./UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
			</xsl:variable>
			<xsl:if test="key( 'stereotypeID',  $associationStereotype)/@name = 'domain' ">
				<xsl:if test="($type1 = $id)">
					<xsl:element name="owl:Class">
						<xsl:attribute name="rdf:about">
							<xsl:text>#</xsl:text>
							<xsl:value-of select="key( 'classID', $type2)/@name"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:if test="($type2 = $id)">
					<xsl:element name="owl:Class">
						<xsl:attribute name="rdf:about">
							<xsl:text>#</xsl:text>
							<xsl:value-of select="key( 'classID', $type1)/@name"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
			</xsl:element>
			</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="enumeration">
		<!--<xsl:element name="owl:equivalentClass">
	    <xsl:element name="owl:Class">-->
		<xsl:element name="owl:oneOf">
			<xsl:attribute name="rdf:parseType">Collection</xsl:attribute>
			<xsl:call-template name="collectionInverse">
				<xsl:with-param name="stereotype">
					<xsl:text>instanceOf</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:element>
		<!--</xsl:element>
		</xsl:element>-->
	</xsl:template>
	
	
	
	<xsl:template name="generalization">
		<xsl:param name="generalizationKind"/>
		<xsl:param name="classOrProperty">
			<xsl:text>property</xsl:text>
		</xsl:param>
		<xsl:if test="./UML:GeneralizableElement.generalization/UML:Generalization">
			<xsl:for-each select="./UML:GeneralizableElement.generalization/UML:Generalization">
				<xsl:element name="{$generalizationKind}">
					<xsl:variable name="generalization">
						<xsl:value-of select="./@xmi.idref"/>
					</xsl:variable>
					<xsl:variable name="parent">
						<xsl:value-of select="key( 'generalizationID', $generalization)/UML:Generalization.parent/UML:Class/@xmi.idref"/>
					</xsl:variable>
					<xsl:variable name="taggedValueAnonymousID">
						<xsl:choose>
							<xsl:when test="key( 'classID', $parent)/UML:ModelElement.taggedValue">
								<xsl:value-of select="key( 'classID',$parent)/UML:ModelElement.taggedValue/UML:TaggedValue/UML:TaggedValue.type/UML:TagDefinition/@xmi.idref"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>no</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$taggedValueAnonymousID != 'no' and key( 'tagDefinitionID', $taggedValueAnonymousID)/@name = 'odm.anonymous'">
							<!--			This loop is necessary only to make dependency Supplier as a current context for template Class
							This loop iterates only ones-->
							<xsl:for-each select="key( 'classID', $parent)">
								<xsl:call-template name="Class">
									<xsl:with-param name="anon">
										<xsl:text>yes</xsl:text>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$classOrProperty = 'class'">
							<xsl:element name="owl:Class">
								<xsl:attribute name="rdf:about"><xsl:text>#</xsl:text><xsl:value-of select="key( 'classID', $parent)/@name"/></xsl:attribute>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="rdf:resource"><xsl:text>#</xsl:text><xsl:value-of select="key( 'classID', $parent)/@name"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<!--				<xsl:attribute name="rdf:resource"><xsl:text>#</xsl:text><xsl:variable name="parent"><xsl:value-of select="key( 'generalizationID', $generalization)/UML:Generalization.parent/UML:Class/@xmi.idref"/></xsl:variable><xsl:value-of select="key( 'classID', $parent)/@name"/></xsl:attribute>-->
				</xsl:element>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
	
	
	<xsl:template name="taggedValues">
		<xsl:if test="./UML:ModelElement.taggedValue">
			<xsl:for-each select="./UML:ModelElement.taggedValue/UML:TaggedValue">
				<xsl:variable name="taggedValueDefinitionID">
					<xsl:value-of select="./UML:TaggedValue.type/UML:TagDefinition/@xmi.idref"/>
				</xsl:variable>
				<xsl:variable name="taggedValueName" select="key( 'tagDefinitionID',  $taggedValueDefinitionID)/@name"/>
				<xsl:if test="./UML:TaggedValue.dataValue = 'true'">
					<xsl:if test="$taggedValueName = 'symmetric' or $taggedValueName = 'functional' or $taggedValueName = 'transitive' or $taggedValueName = 'inverseFunctional'">
						<xsl:variable name="propertyType">
							<xsl:value-of select="$owlPrefix"/>
							<xsl:choose>
								<xsl:when test="$taggedValueName = 'symmetric'">
									<xsl:text>SymmetricProperty</xsl:text>
								</xsl:when>
								<xsl:when test="$taggedValueName = 'transitive'">
									<xsl:text>TransitiveProperty</xsl:text>
								</xsl:when>
								<xsl:when test="$taggedValueName = 'functional'">
									<xsl:text>FunctionalProperty</xsl:text>
								</xsl:when>
								<xsl:when test="$taggedValueName = 'inverseFunctional'">
									<xsl:text>InverseFunctionalProperty</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:element name="rdf:type">
							<xsl:attribute name="rdf:resource"><xsl:value-of select="$propertyType"/></xsl:attribute>
						</xsl:element>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
	
	
	
	<xsl:template name="classRestrictionCardinalityProperty">
		<xsl:variable name="cardinalityStereotype" select="key( 'stereotypeName', 'cardinality' )[UML:Stereotype.baseClass = 'Association']/@xmi.id"/>
		<xsl:variable name="onPropertyStereotype" select="key( 'stereotypeName', 'onProperty')[UML:Stereotype.baseClass = 'Dependency']/@xmi.id"/>
		<xsl:variable name="id" select="./@xmi.id"/>
		<xsl:for-each select="key( 'associationStereotypeID',  $cardinalityStereotype)[./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref] | key( 'associationStereotypeID',  $cardinalityStereotype)[./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref]">
			<xsl:variable name="type1" select="./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
			<xsl:variable name="type2" select="./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
			<xsl:variable name="associationStereotype">
				<xsl:value-of select="./UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
			</xsl:variable>
			<xsl:variable name="type">
				<xsl:choose>
					<xsl:when test="$type1 = $id">
						<xsl:value-of select="$type2"/>
					</xsl:when>
					<xsl:when test="$type2 = $id">
						<xsl:value-of select="$type1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>none</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="position">
				<xsl:choose>
					<xsl:when test="$type1 = $id">
						<xsl:text>2</xsl:text>
					</xsl:when>
					<xsl:when test="$type2 = $id">
						<xsl:text>1</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>none</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$type != 'none'">
				<xsl:variable name="restrictionClassStereotype" select="key( 'classID', $type)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
				<xsl:if test="key( 'stereotypeID', $restrictionClassStereotype)/@name = 'Restriction' and key( 'stereotypeID', $restrictionClassStereotype)/UML:Stereotype.baseClass = 'Class' ">
					<xsl:if test="key( 'dependencyClientID', $type) and key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $onPropertyStereotype]">
						<xsl:variable name="onPropertySupplier">
							<xsl:value-of select="key( 'dependencyClientID', $type)/UML:Dependency.supplier/UML:Class/@xmi.idref"/>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="./UML:Association.connection/UML:AssociationEnd[$position]/UML:AssociationEnd.multiplicity/UML:Multiplicity/UML:Multiplicity.range">
								<xsl:call-template name="mulitiplicityRestriction">
									<xsl:with-param name="lower" select="./UML:Association.connection/UML:AssociationEnd[$position]/UML:AssociationEnd.multiplicity/UML:Multiplicity/UML:Multiplicity.range/UML:MultiplicityRange/@lower"/>
									<xsl:with-param name="upper" select="./UML:Association.connection/UML:AssociationEnd[$position]/UML:AssociationEnd.multiplicity/UML:Multiplicity/UML:Multiplicity.range/UML:MultiplicityRange/@upper"/>
									<xsl:with-param name="propertyName">
										<xsl:value-of select="key( 'classID', $onPropertySupplier)/@name"/>
									</xsl:with-param>
									
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="mulitiplicityRestriction">
									<xsl:with-param name="lower">
										<xsl:text>1</xsl:text>
									</xsl:with-param>
									<xsl:with-param name="upper">
										<xsl:text>1</xsl:text>
									</xsl:with-param>
									<xsl:with-param name="propertyName">
										<xsl:value-of select="key( 'classID', $onPropertySupplier)/@name"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	
	
	<xsl:template name="classRestrictionProperty">
		<xsl:param name="restrictionKind"/>
		<xsl:param name="writeSubClass">
			<xsl:text>yes</xsl:text>
		</xsl:param>
		<xsl:variable name="hasValueStereotype" select="key( 'stereotypeName', $restrictionKind)[UML:Stereotype.baseClass = 'Association']/@xmi.id"/>
		<xsl:variable name="onPropertyStereotype" select="key( 'stereotypeName', 'onProperty')[UML:Stereotype.baseClass = 'Dependency']/@xmi.id"/>
		<xsl:variable name="hasValueDependecyStereotype" select="key( 'stereotypeName', $restrictionKind)[UML:Stereotype.baseClass = 'Dependency']/@xmi.id"/>
		<xsl:variable name="id" select="./@xmi.id"/>
		<xsl:for-each select="key( 'associationStereotypeID',  $hasValueStereotype)">
			<xsl:variable name="navigation1" select="./UML:Association.connection/UML:AssociationEnd[1]/@isNavigable"/>
			<xsl:variable name="navigation2" select="./UML:Association.connection/UML:AssociationEnd[2]/@isNavigable"/>
			<xsl:if test="($navigation1 = 'true' and not($navigation1 = $navigation2)) or ($navigation2 = 'true' and not($navigation1 = $navigation2))">
							
				<xsl:variable name="type">
					<xsl:choose>
						<xsl:when test="$navigation1 = 'true'">
							<xsl:value-of select="./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
						</xsl:when>
						<xsl:when test="$navigation2 = 'true'">
							<xsl:value-of select="./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="type1" select="./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
				<xsl:variable name="type2" select="./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
				<xsl:variable name="associationStereotype">
					<xsl:value-of select="./UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
				</xsl:variable>
				<!--ako je jedan od asocijacionih karajeva jednak trenutnoj klasi -->
				<xsl:if test="$type1 = $id or $type2 = $id">
					<xsl:variable name="restrictionClassStereotype" select="key( 'classID', $type)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
					<!--Provera da li je asociacioni kraj kod koga je @isNavigable='true' stereotype Restriction-->
					<xsl:if test="key( 'stereotypeID', $restrictionClassStereotype)/@name = 'Restriction' and key( 'stereotypeID', $restrictionClassStereotype)/UML:Stereotype.baseClass = 'Class' ">

						<!--Provera da li za <<Restriction>> postoji definisan i <<onProperty>> i <<hasValue>> -->
						<xsl:if test="key( 'dependencyClientID', $type) and key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $onPropertyStereotype]  and key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]">

							<xsl:if test="$writeSubClass = 'yes'">
								<xsl:element name="rdfs:subClassOf">
									<xsl:element name="owl:Restriction">
										<!--Ispisivanje elementa owl:onProperty -->
										<xsl:element name="owl:onProperty">
											<xsl:element name="owl:ObjectProperty">
													<xsl:attribute name="rdf:about"><xsl:variable name="onPropertySupplier"><xsl:value-of select="key( 'dependencyClientID',  $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $onPropertyStereotype]/UML:Dependency.supplier/UML:Class/@xmi.idref"/></xsl:variable><xsl:text>#</xsl:text><xsl:value-of select="key( 'classID', $onPropertySupplier)/@name"/></xsl:attribute>
											</xsl:element>
										</xsl:element>
										<xsl:variable name="elementName">
											<xsl:text>owl:</xsl:text>
											<xsl:value-of select="$restrictionKind"/>
										</xsl:variable>
										<xsl:variable name="hasValueSupplier">
											<!--Izbor da li je dependency Supplier UML:Class ili UML:Object-->
											<xsl:choose>
												<xsl:when test="key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Object">
													<xsl:value-of select="key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Object/@xmi.idref"/>
												</xsl:when>
												<xsl:when test="key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Class">
													<xsl:value-of select="key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Class/@xmi.idref"/>
												</xsl:when>
											</xsl:choose>
										</xsl:variable>
										<xsl:variable name="taggedValueAnonymousID">
											<xsl:choose>
												<xsl:when test="(key( 'classID', $hasValueSupplier)/UML:ModelElement.taggedValue) and key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Class">
													<xsl:value-of select="key( 'classID', $hasValueSupplier)/UML:ModelElement.taggedValue/UML:TaggedValue/UML:TaggedValue.type/UML:TagDefinition/@xmi.idref"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>no</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:element name="{$elementName}">
											<xsl:choose>
												<xsl:when test="$taggedValueAnonymousID != 'no' and key( 'tagDefinitionID', $taggedValueAnonymousID)/@name = 'odm.anonymous'">
													<!--This loop is necessary only to make dependency Supplier as a current context for template Class
							This loop iterates only ones-->
													<xsl:for-each select="key( 'classID', $hasValueSupplier)">
														<xsl:call-template name="Class">
															<xsl:with-param name="anon">
																<xsl:text>yes</xsl:text>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Object">
															<xsl:element name="owl:Thing">
																<xsl:attribute name="rdf:about">
																	<xsl:text>#</xsl:text>
																	<xsl:value-of select="key('objectID', $hasValueSupplier)/@name"/>
																	
																</xsl:attribute>
															</xsl:element>
														</xsl:when>
														<xsl:when test="key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Class">
															<xsl:attribute name="rdf:resource"><xsl:text>#</xsl:text><xsl:value-of select="key( 'classID', $hasValueSupplier)/@name"/></xsl:attribute>
														</xsl:when>
													</xsl:choose>
													
												</xsl:otherwise>
											</xsl:choose>
										</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:if>
							<xsl:if test="$writeSubClass = 'no' ">
								<xsl:element name="owl:Restriction">
									<!--Ispisivanje elementa owl:onProperty -->
									<xsl:element name="owl:onProperty">
										<xsl:variable name = "propertyStereotype" select="key('stereotypeID', key( 'classID', key( 'dependencyClientID',  $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $onPropertyStereotype]/UML:Dependency.supplier/UML:Class/@xmi.idref)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref)/@name"/>
										<xsl:element name="{concat('owl:', $propertyStereotype, '')}">
											<xsl:attribute name="rdf:about"><xsl:variable name="onPropertySupplier"><xsl:value-of select="key( 'dependencyClientID',  $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $onPropertyStereotype]/UML:Dependency.supplier/UML:Class/@xmi.idref"/></xsl:variable><xsl:text>#</xsl:text><xsl:value-of select="key( 'classID', $onPropertySupplier)/@name"/></xsl:attribute>
										</xsl:element>
									</xsl:element>
									<xsl:variable name="elementName">
										<xsl:text>owl:</xsl:text>
										<xsl:value-of select="$restrictionKind"/>
									</xsl:variable>
									<xsl:variable name="hasValueSupplier">
										<!--Izbor da li je dependency Supplier UML:Class ili UML:Object-->
										<xsl:choose>
											<xsl:when test="key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Object">
												<xsl:value-of select="key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Object/@xmi.idref"/>
											</xsl:when>
											<xsl:when test="key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Class">
												<xsl:value-of select="key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Class/@xmi.idref"/>
											</xsl:when>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="taggedValueAnonymousID">
										<xsl:choose>
											<xsl:when test="(key( 'classID', $hasValueSupplier)/UML:ModelElement.taggedValue) and key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Class">
												<xsl:value-of select="key( 'classID', $hasValueSupplier)/UML:ModelElement.taggedValue/UML:TaggedValue/UML:TaggedValue.type/UML:TagDefinition/@xmi.idref"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>no</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:element name="{$elementName}">
										<xsl:choose>
											<xsl:when test="$taggedValueAnonymousID != 'no' and key( 'tagDefinitionID', $taggedValueAnonymousID)/@name = 'odm.anonymous'">
												<!--This loop is necessary only to make dependency Supplier as a current context for template Class
							This loop iterates only ones-->
												<xsl:for-each select="key( 'classID', $hasValueSupplier)">
													<xsl:call-template name="Class">
														<xsl:with-param name="anon">
															<xsl:text>yes</xsl:text>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:for-each>
											</xsl:when>
											<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Object">
															<xsl:element name="owl:Thing">
																<xsl:attribute name="rdf:about">
																	<xsl:text>#</xsl:text>
																	<xsl:value-of select="key('objectID', $hasValueSupplier)/@name"/>
																	
																</xsl:attribute>
															</xsl:element>
														</xsl:when>
														<xsl:when test="key( 'dependencyClientID', $type)[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $hasValueDependecyStereotype]/UML:Dependency.supplier/UML:Class">
															<xsl:attribute name="rdf:resource"><xsl:text>#</xsl:text><xsl:value-of select="key( 'classID', $hasValueSupplier)/@name"/></xsl:attribute>
														</xsl:when>
													</xsl:choose>

											</xsl:otherwise>
										</xsl:choose>
									</xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	
	
	<xsl:template name="classDomainAssociationMulitiplicity">
		<xsl:variable name="id" select="./@xmi.id"/>
		<xsl:variable name="associationDomainStereotype" select="key( 'stereotypeName', 'domain')[UML:Stereotype.baseClass = 'Association']/@xmi.id"/>
		<xsl:for-each select="key( 'associationStereotypeID',  $associationDomainStereotype)">
			<xsl:variable name="type">
				<xsl:choose>
					<xsl:when test="$id = ./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref">
						<xsl:value-of select="./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
					</xsl:when>
					<xsl:when test="$id = ./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref">
						<xsl:value-of select="./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<!--ako je jedan od asocijacionih karajeva jednak trenutnoj klasi -->
			<xsl:if test="$type = $id">
				<xsl:variable name="type1" select="./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
				<xsl:variable name="type2" select="./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref"/>
				<xsl:if test="$id != ./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref">
					<xsl:choose>
						<xsl:when test="./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.multiplicity/UML:Multiplicity/UML:Multiplicity.range">
							<xsl:call-template name="mulitiplicityRestriction">
								<xsl:with-param name="lower" select="./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.multiplicity/UML:Multiplicity/UML:Multiplicity.range/UML:MultiplicityRange/@lower"/>
								<xsl:with-param name="upper" select="./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.multiplicity/UML:Multiplicity/UML:Multiplicity.range/UML:MultiplicityRange/@upper"/>
								<xsl:with-param name="propertyName">
									<xsl:value-of select="key( 'classID', $type1)/@name"/>
								</xsl:with-param>
								<xsl:with-param name="propertyType">
									<xsl:variable name = "typeProp" select="key('classID', ./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
									<xsl:text>owl:</xsl:text><xsl:value-of select ="key('stereotypeID', $typeProp)/@name"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="mulitiplicityRestriction">
								<xsl:with-param name="lower">
									<xsl:text>1</xsl:text>
								</xsl:with-param>
								<xsl:with-param name="upper">
									<xsl:text>1</xsl:text>
								</xsl:with-param>
								<xsl:with-param name="propertyName">
									<xsl:value-of select="key( 'classID', $type1)/@name"/>
								</xsl:with-param>
								<xsl:with-param name="propertyType">
									<xsl:variable name = "typeProp" select="key('classID', ./UML:Association.connection/UML:AssociationEnd[1]/UML:AssociationEnd.participant/UML:Class/@xmi.idref)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
									<xsl:text>owl:</xsl:text><xsl:value-of select ="key('stereotypeID', $typeProp)/@name"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$id != ./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref">
					<xsl:choose>
						<xsl:when test="./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.multiplicity/UML:Multiplicity/UML:Multiplicity.range">
							<xsl:call-template name="mulitiplicityRestriction">
								<xsl:with-param name="lower" select="./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.multiplicity/UML:Multiplicity/UML:Multiplicity.range/UML:MultiplicityRange/@lower"/>
								<xsl:with-param name="upper" select="./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.multiplicity/UML:Multiplicity/UML:Multiplicity.range/UML:MultiplicityRange/@upper"/>
								<xsl:with-param name="propertyName">
									<xsl:value-of select="key( 'classID', $type2)/@name"/>
								</xsl:with-param>
								<xsl:with-param name="propertyType">
									<xsl:variable name = "typeProp" select="key('classID', ./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
									<xsl:text>owl:</xsl:text><xsl:value-of select ="key('stereotypeID', $typeProp)/@name"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="mulitiplicityRestriction">
								<xsl:with-param name="lower">
									<xsl:text>1</xsl:text>
								</xsl:with-param>
								<xsl:with-param name="upper">
									<xsl:text>1</xsl:text>
								</xsl:with-param>
								<xsl:with-param name="propertyName">
									<xsl:value-of select="key( 'classID', $type2)/@name"/>
								</xsl:with-param>
								<xsl:with-param name="propertyType">
									<xsl:variable name = "typeProp" select="key('classID', ./UML:Association.connection/UML:AssociationEnd[2]/UML:AssociationEnd.participant/UML:Class/@xmi.idref)/UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref"/>
									<xsl:text>owl:</xsl:text><xsl:value-of select ="key('stereotypeID', $typeProp)/@name"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="classDomainAttributeMulitiplicity">
		<xsl:variable name="id" select="./@xmi.id"/>
		<xsl:variable name="attributeDomainStereotype" select="key( 'stereotypeName', 'domain')[UML:Stereotype.baseClass = 'Attribute']/@xmi.id"/>
		<xsl:variable name="datatypePropertyStereotype" select="key( 'stereotypeName', 'DatatypeProperty')[UML:Stereotype.baseClass = 'Class']/@xmi.id"/>
		<xsl:variable name="objectPropertyStereotype" select="key( 'stereotypeName', 'ObjectProperty')[UML:Stereotype.baseClass = 'Class']/@xmi.id"/>
		<xsl:for-each select="key( 'classStereotypeID', $datatypePropertyStereotype) | key( 'classStereotypeID', $objectPropertyStereotype) ">
			<xsl:variable name="className" select="./@name"/>
			<xsl:for-each select="./UML:Classifier.feature/UML:Attribute[UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref = $attributeDomainStereotype]">
				<xsl:if test="$id = ./UML:StructuralFeature.type/UML:Class/@xmi.idref">
					<xsl:choose>
						<xsl:when test="./UML:StructuralFeature.multiplicity">
							<xsl:call-template name="mulitiplicityRestriction">
								<xsl:with-param name="lower">
									<xsl:value-of select="./UML:StructuralFeature.multiplicity/UML:Multiplicity/UML:Multiplicity.range/UML:MultiplicityRange/@lower"/>
								</xsl:with-param>
								<xsl:with-param name="upper">
									<xsl:value-of select="./UML:StructuralFeature.multiplicity/UML:Multiplicity/UML:Multiplicity.range/UML:MultiplicityRange/@upper"/>
								</xsl:with-param>
								<xsl:with-param name="propertyName">
									<xsl:value-of select="$className"/>
								</xsl:with-param>
								<xsl:with-param name = "propertyType">
									<xsl:text>owl:</xsl:text><xsl:value-of select="key('stereotypeID', ../../UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref)/@name"/>
								</xsl:with-param>

							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="mulitiplicityRestriction">
								<xsl:with-param name="lower">
									<xsl:text>1</xsl:text>
								</xsl:with-param>
								<xsl:with-param name="upper">
									<xsl:text>1</xsl:text>
								</xsl:with-param>
								<xsl:with-param name="propertyName">
									<xsl:value-of select="$className"/>
								</xsl:with-param>
								<xsl:with-param name = "propertyType">
									<xsl:text>owl:</xsl:text><xsl:value-of select="key('stereotypeID', ../../UML:ModelElement.stereotype/UML:Stereotype/@xmi.idref)/@name"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="mulitiplicityRestriction">
		<xsl:param name="lower"/>
		<xsl:param name="upper"/>
		<xsl:param name="propertyName"/>
		<xsl:param name="propertyType">
			<xsl:text>owl:ObjectProperty</xsl:text>
		</xsl:param>	
		
		<xsl:if test="not ($lower = 0 and $upper = -1)">
			<xsl:element name="rdfs:subClassOf">
				<xsl:element name="owl:Restriction">
					<xsl:element name="owl:onProperty">
						<xsl:element name="{$propertyType}">
						<xsl:attribute name="rdf:about"><xsl:text>#</xsl:text><xsl:value-of select="$propertyName"/></xsl:attribute>
						</xsl:element>
					</xsl:element>
					<xsl:choose>
						<xsl:when test="($lower=1 and $upper=1) or (($lower = $upper) and ($lower != -1))">
							<xsl:element name="owl:cardinality">
								<xsl:attribute name="rdf:datatype"><xsl:value-of select="$xsdPrefix"/><xsl:text>nonNegativeInteger</xsl:text></xsl:attribute>
								<xsl:value-of select="$lower"/>
							</xsl:element>
						</xsl:when>
						<xsl:when test="($upper = -1) and ($lower >= 0)">
							<xsl:element name="owl:minCardinality">
								<xsl:attribute name="rdf:datatype"><xsl:value-of select="$xsdPrefix"/><xsl:text>nonNegativeInteger</xsl:text></xsl:attribute>
								<xsl:value-of select="$lower"/>
							</xsl:element>
						</xsl:when>
						<xsl:when test="($upper > 0 ) and ($lower = 0)">
							<xsl:element name="owl:maxCardinality">
								<xsl:attribute name="rdf:datatype"><xsl:value-of select="$xsdPrefix"/><xsl:text>nonNegativeInteger</xsl:text></xsl:attribute>
								<xsl:value-of select="$upper"/>
							</xsl:element>
						</xsl:when>
						<xsl:when test="($upper != -1) and ($lower >= 0)">
							<xsl:element name="owl:minCardinality">
								<xsl:attribute name="rdf:datatype"><xsl:value-of select="$xsdPrefix"/><xsl:text>nonNegativeInteger</xsl:text></xsl:attribute>
								<xsl:value-of select="$lower"/>
							</xsl:element>
							<xsl:element name="owl:maxCardinality">
								<xsl:attribute name="rdf:datatype"><xsl:value-of select="$xsdPrefix"/><xsl:text>nonNegativeInteger</xsl:text></xsl:attribute>
								<xsl:value-of select="$upper"/>
							</xsl:element>
						</xsl:when>
					</xsl:choose>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="dataRange">
		<xsl:param name = "classID"/>
		<xsl:element name="owl:DataRange">
			<xsl:element name="owl:oneOf">
				<xsl:call-template name="dataRangeAttributes">
					<xsl:with-param name="classID" select = "$classID"/>
				</xsl:call-template> 
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="dataRangeAttributes">
		<xsl:param name = "classID"/>
		<xsl:param name = "position">
			<xsl:text>1</xsl:text>
		</xsl:param>
		
		<xsl:if test = "key('classID', $classID)/UML:Classifier.feature/UML:Attribute[$position]">
			<xsl:element name ="rdf:List">
				<xsl:element name = "rdf:first">
					<xsl:attribute name = "rdf:datatype">
						<xsl:call-template name="xsdType">
							<xsl:with-param name="type" select="key('classID', key('classID', $classID)/UML:Classifier.feature/UML:Attribute[$position]/UML2:TypedElement.type/UML:Class/@xmi.idref)/@name"/>
						</xsl:call-template>
					</xsl:attribute>
					<xsl:value-of select = "key('classID', $classID)/UML:Classifier.feature/UML:Attribute[$position]/@name"/>
				</xsl:element>
				<xsl:element name = "rdf:rest">
					<xsl:choose>
						<xsl:when test = "key('classID', $classID)/UML:Classifier.feature/UML:Attribute[$position+1]">
							<xsl:call-template name="dataRangeAttributes">
								<xsl:with-param name = "position" select = "$position+1"/>
								<xsl:with-param name="classID" select="$classID"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name = "rdf:resource">
								<xsl:text>http://www.w3.org/1999/02/22-rdf-syntax-ns#nil</xsl:text>
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:element>	
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
