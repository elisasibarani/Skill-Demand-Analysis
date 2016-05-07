<?xml version="1.0" encoding="UTF-8"?>


<!DOCTYPE stylesheet [
    <!ENTITY xml "http://example.org/xml#">
	<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	<!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
	<!ENTITY so "http://schema.org/#">
	<!ENTITY saro "http://www.semanticweb.org/elisasibarani/ontologies/2016/0/untitled-ontology-51#">
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
    <param name="autogenerate-fragment-uris" select="'generate-id'"/>

    <!--<strip-space elements="*"/>
	-->
	
	<template match="krextor-genuri:saro-uri" as="xs:anyURI?">
      <param name="node"/>
      <param name="base-uri"/>
      <apply-templates select="$node" mode="krextor-genuri:saro-uri">
        <with-param name="saro-base-uri" select="$base-uri"/>
      </apply-templates>
    </template>

    <template match="Value" mode="krextor-genuri:saro-uri" as="xs:anyURI?">
      <param name="saro-base-uri"/>
      <sequence select="$saro-base-uri"/>
    </template>

    <template match="Value" mode="krextor-genuri:saro-uri" as="xs:anyURI?">
      <param name="saro-base-uri"/>
      <sequence select="xs:anyURI(
                            concat(
                            $saro-base-uri,
                            @id))"/>
    </template>
	
			
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

	
	<variable name="startrole" select="//Annotation[@Type='title']/@StartNode"/>
	
	<!--<template match="text()[preceding-sibling::Node[@id=$startrole] and following-sibling::Node[@id=$endrole]]" mode="krextor:main" >-->
	
	<template match="text()[preceding-sibling::Node[@id=$startrole]][1]" mode="krextor:main" >
		<call-template name="krextor:create-resource">
			<with-param name="type" select="'&saro;JobRole'"/>
			<with-param name="properties">
				<for-each select="//Annotation">
					<choose>
						<when test="@Type='SkillProduct' or @Type='SkillTopic' or @Type='SkillTool'">
							<variable name="start" select="@StartNode"/>
							<krextor:property uri="&saro;requiresSkill" value="{//Node[@id=$start]/following-sibling::text()[1]}"/>
							<!--<variable name="content" select="//Feature/Value/following-sibling::text()='string'"/>
							<krextor:property uri="&saro;requiresSkill" value="{//Feature/Value[preceding-sibling::Feature[Name='string']]}"/>-->
						</when>
					</choose>
				</for-each>
			</with-param>
		</call-template>
	</template>	
	
	
	
	<!--<template match="//Annotation[@Type='SkillProduct']/Feature/Value" mode="krextor:main">-->
	<template match="//Annotation[@Type='SkillProduct']/Feature[Name='string']/Value" mode="krextor:main">
		<call-template name="krextor:create-resource">
			<with-param name="type" select="'&saro;Product'"/>
			<with-param name="properties">
				<variable name="id" select="//Annotation[@Type='SkillProduct']/@Id"/>
				<krextor:property uri="&saro;frequencyOfMention" value="{//Annotation[@Id=$id]/Feature[Name='frequencyOfMention']/Value}"/>
			</with-param>
		</call-template>
	</template>
	
	
		
	<template match="//Annotation[@Type='SkillTool']/Feature[Name='string']/Value" mode="krextor:main">
		<call-template name="krextor:create-resource">
			<with-param name="type" select="'&saro;Tool'"/>
			<with-param name="properties">
				<variable name="id" select="//Annotation[@Type='SkillTool']/@Id"/>
				<krextor:property uri="&saro;frequencyOfMention" value="{//Annotation[@Id=$id]/Feature[Name='frequencyOfMention']/Value}"/>
			</with-param>
		</call-template>
	</template>
		
</stylesheet>





