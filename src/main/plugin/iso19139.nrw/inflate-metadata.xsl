<?xml version="1.0" encoding="UTF-8"?>

<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:nrw="http://naturalresources.wales/nrw"
                version="2.0">


  <xsl:template match="/root">
    <xsl:apply-templates select="gmd:*"/>
  </xsl:template>

  <!-- datasets -->

  <xsl:template match="gmd:MD_DataIdentification">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <xsl:copy-of select="gmd:citation" />
      <xsl:copy-of select="gmd:abstract" />
      <xsl:copy-of select="gmd:purpose" />
      <xsl:copy-of select="gmd:credit" />
      <xsl:copy-of select="gmd:status" />
      <xsl:copy-of select="gmd:pointOfContact" />
      <xsl:copy-of select="gmd:resourceMaintenance" />
      <xsl:copy-of select="gmd:graphicOverview" />
      <xsl:copy-of select="gmd:resourceFormat" />
      <xsl:copy-of select="gmd:descriptiveKeywords" />
      <xsl:copy-of select="gmd:resourceSpecificUsage" />
      <xsl:copy-of select="gmd:resourceConstraints" />
      <xsl:copy-of select="gmd:aggregationInfo" />
      <xsl:copy-of select="gmd:spatialRepresentationType" />
      <!-- Add spatialrepresentationtype if missing -->
      <xsl:if test="not(gmd:spatialRepresentationType)">
        <gmd:spatialRepresentationType>
            <gmd:MD_SpatialRepresentationTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#MD_SpatialRepresentationTypeCode"
                                                  codeListValue="vector"/>
         </gmd:spatialRepresentationType>
       </xsl:if>
      <xsl:copy-of select="gmd:spatialResolution" />
      <xsl:copy-of select="gmd:language" />
      <xsl:copy-of select="gmd:characterSet" />
      <!-- Add characterSet if missing -->
      <xsl:if test="not(gmd:characterSet)">
        <gmd:characterSet>
          <gmd:MD_CharacterSetCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#MD_CharacterSetCode"
                                     codeListValue="utf8">UTF-8</gmd:MD_CharacterSetCode>
        </gmd:characterSet>
      </xsl:if>
      <xsl:copy-of select="gmd:topicCategory" />
      <!-- Add gmd:topicCategory if missing -->
      <xsl:if test="not(gmd:topicCategory)">
        <gmd:topicCategory>
          <gmd:MD_TopicCategoryCode></gmd:MD_TopicCategoryCode>
        </gmd:topicCategory>
      </xsl:if>
      <xsl:copy-of select="gmd:environmentDescription" />
      <xsl:copy-of select="gmd:extent" />
  

      <xsl:copy-of select="gmd:supplementalInformation" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gmd:MD_Distribution">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="gmd:distributionFormat" />

      <xsl:if test="not(gmd:distributionFormat)" >
        <gmd:distributionFormat>
            <gmd:MD_Format>
               <gmd:name>
                  <gco:CharacterString xmlns:gco="http://www.isotc211.org/2005/gco"></gco:CharacterString>
               </gmd:name>
               <gmd:version>
                  <gco:CharacterString xmlns:gco="http://www.isotc211.org/2005/gco"></gco:CharacterString>
               </gmd:version>
            </gmd:MD_Format>
         </gmd:distributionFormat>
      </xsl:if>
      <xsl:apply-templates select="gmd:transferOptions" />

    </xsl:copy>

  </xsl:template>

  <!-- services -->

    <xsl:template match="srv:SV_ServiceIdentification">
      <xsl:copy>
        <xsl:copy-of select="@*" />

        <xsl:copy-of select="gmd:citation" />
        <xsl:copy-of select="gmd:abstract" />
        <xsl:copy-of select="gmd:purpose" />
        <xsl:copy-of select="gmd:credit" />
        <xsl:copy-of select="gmd:status" />
        <xsl:copy-of select="gmd:pointOfContact" />
        <xsl:copy-of select="gmd:resourceMaintenance" />
        <xsl:copy-of select="gmd:graphicOverview" />
        <xsl:copy-of select="gmd:resourceFormat" />
        <xsl:copy-of select="gmd:descriptiveKeywords" />
        <xsl:copy-of select="gmd:resourceSpecificUsage" />
        <xsl:copy-of select="gmd:resourceConstraints" />
        <xsl:copy-of select="srv:serviceType" />
        <!-- Add srv:serviceType if missing -->
        <xsl:if test="not(srv:serviceType)">
          <srv:serviceType>
            <gco:LocalName xmlns:gco="http://www.isotc211.org/2005/gco" codeSpace="INSPIRE">view</gco:LocalName>
         </srv:serviceType>
         </xsl:if>
        <xsl:copy-of select="srv:extent" />
        <xsl:copy-of select="srv:couplingType"/>
        <xsl:copy-of select="srv:containsOperations"/>
        <xsl:copy-of select="srv:operatesOn"/>
        <!-- Add srv:operatesOn if missing -->
        <xsl:if test="not(srv:operatesOn)">
          <srv:operatesOn xlink:href=""/>
         </xsl:if>
      </xsl:copy>
    </xsl:template>


  <!-- Add gco:Boolean to gmd:pass with nilReason to work nicely in the editor,
    update-fixed-info.xsl should removed if empty to avoid xsd errors  -->
  <xsl:template match="gmd:pass[@gco:nilReason and not(gco:Boolean)]" priority="102">
    <!-- <xsl:message>=== Expanded empty Boolean with nilReason===</xsl:message> -->
      <xsl:copy>
      <xsl:copy-of select="@*" />
      <gco:Boolean></gco:Boolean>
    </xsl:copy>
  </xsl:template>

    <!-- Add gco:CharacterString child nodes to elements with gco:nilReason attributes so they display
    in the editor, then use update-fixed-info.xsl to get rid of them if not required, keep also gco:nilReason attribute -->
    <xsl:template match="//*[(@gco:nilReason='inapplicable' or @gco:nilReason='unknown' or @gco:nilReason='missing') and not(gco:CharacterString) and name() != 'gmd:verticalElement' and name() != 'gmd:hierarchyLevelName' and name() != 'gmd:linkage']" priority="101">
      <!-- <xsl:message>=== Expanded empty CharacterString with nilReason===</xsl:message> -->
      <xsl:copy>
        <xsl:apply-templates select="@*|*"/>
        <xsl:element name="gco:CharacterString"/>
      </xsl:copy>
    </xsl:template>

    <!-- Add gmd:URL child nodes to gmd:linkage elements with gco:nilReason attributes so they display
    in the editor, then use update-fixed-info.xsl to get rid of them if not required, keep also gco:nilReason attribute -->
    <xsl:template match="//*[(@gco:nilReason='inapplicable' or @gco:nilReason='unknown' or @gco:nilReason='missing') and not(gmd:URL) and name() = 'gmd:linkage']" priority="100">
      <!-- <xsl:message>=== Expanded empty URL with nilReason===</xsl:message> -->
      <xsl:copy>
        <xsl:apply-templates select="@*|*"/>
        <xsl:element name="gmd:URL"/>
      </xsl:copy>
    </xsl:template>

  <!-- copy everything else -->

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
