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
  
  <!-- Remove empty locale elements -->
  <xsl:template match="gmd:locale[not(normalize-space())]">
    <xsl:message>=== Removing empty gmd:locale element ===</xsl:message>
  </xsl:template>
  
  <!-- Shift location of Parent Identifier -->
  <xsl:template match="/gmd:MD_Metadata">
    <xsl:choose>
      <!-- Check if gmd:parentIdentifier is present -->
      <xsl:when test="gmd:parentIdentifier">
        <xsl:copy>
          <!-- Copy everything up to gmd:hierarchyLevel as is -->
          <xsl:copy-of select="@*|node()[not(self::gmd:parentIdentifier)][following-sibling::gmd:hierarchyLevel]"/>
          <!-- Copy gmd:hierarchyLevel -->
          <xsl:copy-of select="gmd:hierarchyLevel"/>
          <!-- Insert gmd:parentIdentifier after gmd:hierarchyLevel if it exists -->
          <xsl:copy-of select="gmd:parentIdentifier"/>
          <!-- Copy remaining elements -->
          <xsl:copy-of select="gmd:parentIdentifier/following-sibling::*[not(self::gmd:hierarchyLevel)]"/>
        </xsl:copy>
      </xsl:when>
      <!-- If there is no gmd:parentIdentifier, copy everything as-is -->
      <xsl:otherwise>
        <xsl:message>=== No parentIdentifier present ===</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Only remove the original gmd:parentIdentifier if it exists -->
  <xsl:template match="gmd:parentIdentifier"/>
  
  <!-- Transform empty codelist elements to include a value -->
  <xsl:template match="gmd:MD_ScopeCode|gmd:CI_RoleCode|gmd:CI_DateTypeCode|gmd:MD_MaintenanceFrequencyCode|gmd:MD_KeywordTypeCode|gmd:MD_RestrictionCode|gmd:MD_SpatialRepresentationTypeCode|gmd:CI_OnLineFunctionCode">
    <xsl:copy>
      <!-- Copy all attributes -->
      <xsl:copy-of select="@*"/>
      <!-- Add the text content based on codeListValue attribute -->
      <xsl:value-of select="@codeListValue"/>
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

</xsl:stylesheet>
