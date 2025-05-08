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

<!-- for downloading xml in medin endpoint -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:geonet="http://www.fao.org/geonetwork">

  <!-- Import base formatter from xsl-view -->
  <xsl:import href="../base-xml/view.xsl"/>

  <!-- Medin-specific transformations -->
  <xsl:template match="gmd:metadataStandardName">
    <gmd:metadataStandardName>
    <gmx:Anchor xlink:type="simple" xlink:href="http://vocab.nerc.ac.uk/collection/M25/current/MEDIN/">MEDIN</gmx:Anchor>
    </gmd:metadataStandardName>
  </xsl:template>

  <xsl:template match="gmd:metadataStandardVersion">
    <gmd:metadataStandardVersion>
    <gco:CharacterString>3.1.2</gco:CharacterString>
    </gmd:metadataStandardVersion>
  </xsl:template>

  <!-- Transform empty codelist elements to include a value -->
  <xsl:template match="gmd:MD_ScopeCode|gmd:CI_RoleCode|gmd:CI_DateTypeCode|gmd:MD_MaintenanceFrequencyCode|gmd:MD_KeywordTypeCode|gmd:MD_RestrictionCode|gmd:MD_SpatialRepresentationTypeCode|gmd:CI_OnLineFunctionCode|gmd:MD_ScopeCode|gmd:MD_CharacterSetCode|gmd:LanguageCode" priority="100">
    <xsl:copy>
      <!-- Copy all attributes -->
      <xsl:copy-of select="@*"/>
      <!-- Add the text content based on codeListValue attribute -->
      <xsl:value-of select="@codeListValue"/>
    </xsl:copy>
  </xsl:template>


  <!-- Shift location of Parent Identifier -->
  <xsl:template match="/gmd:MD_Metadata">
    <!-- Copy everything apart from gmd:parentIdentifier-->
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()[not(self::gmd:parentIdentifier)]"/>
      <xsl:apply-templates select="gmd:parentIdentifier"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gmd:hierarchyLevel">
    <!-- Add gmd:parentIdentifier after gmd:hierarcyLevel-->
    <xsl:copy-of select="."/>
    <xsl:if test="../gmd:parentIdentifier">
      <xsl:copy-of select="../gmd:parentIdentifier"/>
    </xsl:if>
  </xsl:template>

  <!-- Remove previous gmd:parentIdentifier to avoid duplication-->
  <xsl:template match="gmd:parentIdentifier">
    </xsl:template>

  <xsl:template match="@* | node()">
    <!-- Copy everything else as-is -->
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Add characterSetCode value if missing -->
  <xsl:template match="gmd:MD_CharacterSetCode">
    <xsl:copy>
      <!-- Copy all attributes -->
      <xsl:copy-of select="@*"/>
      <!-- Check if codeListValue is 'utf8' and set content accordingly -->
      <xsl:choose>
        <xsl:when test="@codeListValue = 'utf8'">
          <xsl:text>UTF-8</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- Set the content to the value of the codeListValue attribute -->
          <xsl:value-of select="@codeListValue"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <!-- Add orphan geographic extents to NRW thesaurus-->
  <xsl:template match="gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/gmd:MD_Identifier[not(gmd:authority)]">
    <gmd:MD_Identifier>
      <!-- Add authority data for MEDIN validity -->
      <gmd:authority>
        <gmd:CI_Citation>
          <gmd:title>
            <gco:CharacterString>NRW Geographic Identifiers Collection</gco:CharacterString>
          </gmd:title>
          <gmd:date>
            <gmd:CI_Date>
              <gmd:date>
                <gco:Date>2024-01-01</gco:Date>
              </gmd:date>
              <gmd:dateType>
                <gmd:CI_DateTypeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_DateTypeCode"
                                      codeListValue="publication">publication</gmd:CI_DateTypeCode>
              </gmd:dateType>
            </gmd:CI_Date>
          </gmd:date>
        </gmd:CI_Citation>
      </gmd:authority>
      <!-- Preserve code value -->
      <xsl:copy-of select="gmd:code"/>
    </gmd:MD_Identifier>
  </xsl:template>

  <!-- Remove gmd:description elements which have a nilReason attribute -->
  <xsl:template match="gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:description[@gco:nilReason]" />


  <!-- Remove NRW-specific elements -->
  <xsl:template match="gmd:contentInfo" />
  <xsl:template match="gmd:locale" />


</xsl:stylesheet>
