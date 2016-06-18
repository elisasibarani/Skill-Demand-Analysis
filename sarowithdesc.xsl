<?xml version="1.0" encoding="UTF-8"?>


<!DOCTYPE stylesheet [
    <!ENTITY xml "http://example.org/xml#">
	<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	<!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
	<!ENTITY so "http://schema.org/">
	<!ENTITY saro "http://www.semanticweb.org/elisasibarani/ontologies/2016/0/untitled-ontology-51#">
	<!ENTITY xsd "http://www.w3.org/2001/XMLSchema#">
]>

<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
	xmlns:krextor="http://kwarc.info/projects/krextor"
    xmlns:krextor-genuri="http://kwarc.info/projects/krextor/genuri"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    exclude-result-prefixes="#all"
    version="2.0">

    <xd:doc type="stylesheet">
	<xd:short>Extraction module for GATE annotation result which is stored in XML</xd:short>
	<xd:author>Elisa Margareth Sibarani</xd:author>
	</xd:doc>
    
    <!-- Note that this is not the global default; actually the 
         concrete way of URI generation is decided on element level -->
    <!--
    <param name="autogenerate-fragment-uris" select="'pseudo-xpath', 'generate-id'"/>
    -->
    <param name="autogenerate-fragment-uris" select="'saro'"/>

    <!--<strip-space elements="*"/>
	-->
	
	<template match="krextor-genuri:saro" as="xs:anyURI?">
		<param name="node"/>
		<param name="base-uri"/>

		<apply-templates select="$node" mode="krextor-genuri:saro">
			<!-- <with-param name="saro-base-uri" select="$base-uri"/> -->
		</apply-templates>
	  
	</template>
	
	<!--Fail to generate a XLIFF compliant URI for all elements for which none is specified, i.e. all elements except //GateDocumentFeatures/Feature/Value  and //Annotation/Feature/Value 
    <template match="*" mode="krextor-genuri:saro" as="xs:anyURI?"/> -->
    
    <!--We enforce an empty base URI, so that really just the //Annotation/Feature/Value URI shows up in the RDF, without any “URI resolution magic”
    <template match="." mode="krextor:main">
      <apply-imports>
        <with-param
          name="krextor:base-uri"
          select="xs:anyURI('')"
          as="xs:anyURI"
          tunnel="yes"/>
      </apply-imports>
    </template>-->
	
	
<!--		
    <template match="//GateDocumentFeatures/Feature/Value" mode="krextor:main">

        <call-template name="krextor:create-resource">
            <with-param name="type" select="'&saro;JobPosting'"/>
			<with-param name="properties">
                <for-each select="//Annotation">
					<choose>
						<when test="@Type='title'">
							<variable name="startrole" select="@StartNode"/>
							<krextor:property uri="&saro;describes" value="{//Node[@id=$startrole]/following-sibling::text()[1]}"/>
						</when>
						<when test="@Type='jobLocation'">
							<variable name="start" select="@StartNode"/>
							<krextor:property uri="&so;jobLocation" value="{//Node[@id=$start]/following-sibling::text()[1]}"/>
						</when>
						<when test="@Type='datePosted'">
							<variable name="start" select="@StartNode"/>
							<krextor:property uri="&so;datePosted" value="{//Node[@id=$start]/following-sibling::text()[1]}"/>
						</when>
						<when test="@Type='hiringOrganization'">
							<variable name="start" select="@StartNode"/>
							<krextor:property uri="&so;hiringOrganization" value="{//Node[@id=$start]/following-sibling::text()[1]}"/>
						</when>
					</choose>
				</for-each>
			</with-param>
        </call-template>
    </template>


-->
	<template match="//AnnotationSet/@Name" mode="krextor:main">
		<call-template name="krextor:create-resource">
            <with-param name="type" select="'&saro;jobPosting'"/>
		</call-template>	
	</template>


	<variable name="startloc" select="//AnnotationSet/Annotation[@Type='Location']/@StartNode"/>
	<template match="text()[preceding-sibling::Node[@id=$startloc]][1]" mode="krextor:main">
		<call-template name="krextor:add-uri-property">
			<with-param name="property" select="'&so;jobLocation'"/>
		</call-template>
	</template>

	<variable name="startorg" select="//AnnotationSet/Annotation[@Type='Organization']/@StartNode"/>
	<template match="text()[preceding-sibling::Node[@id=$startorg]][1]" mode="krextor:main">
		<call-template name="krextor:add-uri-property">
			<with-param name="property" select="'&so;hiringOrganization'"/>
		</call-template>
	</template>

	<variable name="startdate" select="//AnnotationSet/Annotation[@Type='datePosted']/@StartNode"/>
	<template match="text()[preceding-sibling::Node[@id=$startdate]][1]" mode="krextor:main">
		<call-template name="krextor:add-literal-property">
			<with-param name="property" select="'&so;datePosted'"/>
			<with-param name="datatype" select="'&xsd;dateTime'"/>
		</call-template>
	</template>
	
	<variable name="startrole1" select="//AnnotationSet/Annotation[@Type='jobRole']/@StartNode"/>
		

	<template match="text()[preceding-sibling::Node[@id=$startrole1]][1]" mode="krextor:main">
		<call-template name="krextor:create-resource">
			<with-param name="type" select="'&saro;JobRole'"/>
		</call-template>
		
		<call-template name="krextor:add-uri-property">
			<with-param name="property" select="'&saro;describes'"/>
		</call-template>
	</template>



<!--
	<variable name="startrole2" select="//Annotation[@Type='title']/@StartNode"/>

	<template match="text()[preceding-sibling::Node[@id=$startrole2]][1]" mode="krextor:main" >
		<call-template name="krextor:create-resource">
			<with-param name="type" select="'&saro;JobRole'"/>
			<with-param name="properties">
				<for-each select="//Annotation">
					<choose>
						<when test="@Type='SkillProduct' or @Type='SkillTopic' or @Type='SkillTool'">
							<variable name="start" select="@StartNode"/>
							<krextor:property uri="&saro;requiresSkill" value="{//Node[@id=$start]/following-sibling::text()[1]}"/>
						</when>
					</choose>
				</for-each>
			</with-param>
		</call-template>
	</template>
-->



	<template match="//Annotation[@Type='SkillProduct']/Feature[Name='string']/Value" mode="krextor:main">

		<variable name="id" select="ancestor::Annotation[1]/@Id"/>
		<!--<variable name="id" select="//Annotation[@Type='SkillTool']/@Id"/>
		<variable name="freq" select="//Annotation[@Id=$id]/Feature[Name='frequencyOfMention']/Value"/>-->
		<variable name="freq" select="ancestor::Annotation/Feature[Name='frequencyOfMention']/Value"/>

			<!--<call-template name="create-skill-resource">
				<with-param name="id1" select="$id" tunnel="yes"/>
				<with-param name="freq1" select="$freq" tunnel="yes"/>
			</call-template>-->

		<call-template name="krextor:create-resource">
			<with-param name="type" select="'&saro;Product'"/>
                        <with-param name="related-via-properties" select="'&saro;requiresSkill'" tunnel="yes"/>
			<with-param name="properties">
				<krextor:property uri="&saro;frequencyOfMention" value="{$freq}" datatype="&xsd;integer"/>
			</with-param>
		</call-template>
	</template>

	<template name="create-skill-resource">
		<param name="id1" tunnel="yes"/>
		<param name="freq1" tunnel="yes"/>

		<call-template name="krextor:create-resource">
			<with-param name="type" select="'&saro;Product'"/>
			<with-param name="properties">
				<krextor:property uri="&saro;frequencyOfMention" value="{$freq1}" datatype="&xsd;integer"/>
			</with-param>
		</call-template>
	</template>




	<template match="//Annotation[@Type='SkillTool']/Feature[Name='string']/Value" mode="krextor:main">
		<variable name="id" select="ancestor::Annotation[1]/@Id"/>
		<variable name="freq" select="ancestor::Annotation/Feature[Name='frequencyOfMention']/Value"/>
		<call-template name="krextor:create-resource">
			<with-param name="type" select="'&saro;Tool'"/>
                        <with-param name="related-via-properties" select="'&saro;requiresSkill'" tunnel="yes"/>
			<with-param name="properties">
				<krextor:property uri="&saro;frequencyOfMention" value="{$freq}" datatype="&xsd;integer"/>
			</with-param>
		</call-template>
	</template>

		<template match="//Annotation[@Type='SkillTopic']/Feature[Name='string']/Value" mode="krextor:main">
		<variable name="id" select="ancestor::Annotation[1]/@Id"/>
		<variable name="freq" select="ancestor::Annotation/Feature[Name='frequencyOfMention']/Value"/>
		<call-template name="krextor:create-resource">
			<with-param name="type" select="'&saro;Topic'"/>
                        <with-param name="related-via-properties" select="'&saro;requiresSkill'" tunnel="yes"/>
			<with-param name="properties">
				<krextor:property uri="&saro;frequencyOfMention" value="{$freq}" datatype="&xsd;integer"/>
			</with-param>
		</call-template>
	</template>
		
	
		
</stylesheet>





