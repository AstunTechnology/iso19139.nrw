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
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:geonet="http://www.fao.org/geonetwork"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:param name="displayInfo"/>

  <!-- Convert ISO profile elements to their base type -->
  <xsl:template match="*[@gco:isoType]" priority="99">
    <xsl:element name="{@gco:isoType}">
      <xsl:apply-templates select="@*[name() != 'gco:isoType']|*"/>
    </xsl:element>
  </xsl:template>


  <xsl:template match="@*|node()[name(.)!='geonet:info']">
    <xsl:variable name="info" select="geonet:info"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()[name(.)!='geonet:info']"/>
      <!-- GeoNetwork elements added when resultType is equal to results_with_summary -->
      <xsl:if test="$displayInfo = 'true'">
        <xsl:copy-of select="$info"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- Switch identifiers -->
  <xsl:variable name="originalFileIdentifier" select="//gmd:fileIdentifier/gco:CharacterString"/>
  <xsl:variable name="originalNrwIdentifier" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString"/>

  <xsl:template match="gmd:fileIdentifier/gco:CharacterString">
    <xsl:copy>
      <xsl:value-of select="$originalNrwIdentifier"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gmd:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString">
    <xsl:copy>
      <xsl:value-of select="$originalFileIdentifier"/>
    </xsl:copy>
  </xsl:template>

  <!-- Fixes for MEDIN harvest: -->
  
   <!-- Transform empty codelist elements to include a value -->
  <xsl:template match="//gmd:CI_RoleCode|//gmd:CI_DateTypeCode|//gmd:MD_MaintenanceFrequencyCode|//gmd:MD_KeywordTypeCode|//gmd:MD_RestrictionCode|//gmd:MD_SpatialRepresentationTypeCode|//gmd:CI_OnLineFunctionCode|//gmd:MD_ScopeCode|//gmd:MD_CharacterSetCode|//gmd:LanguageCode">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="@codeListValue"/>
    </xsl:copy>
  </xsl:template>

  <!-- Limit gmd:dateStamp to full seconds only, stripping out milliseconds and timezone -->
  <xsl:template match="//gmd:dateStamp">
    <xsl:variable name="datestamp" select="./gco:DateTime"/>

    <xsl:choose>
      <!-- Check if the date is in the wrong YYYY-MM-DDTHH:MM:SS.sssZ format -->
      <xsl:when test="contains($datestamp, '.') and substring($datestamp, string-length($datestamp), 1) = 'Z'">
        <xsl:message>==== Changing the date format to YYYY-MM-DDTHH:MM:SS ====</xsl:message>
        <gmd:dateStamp>
          <gco:DateTime>
            <xsl:value-of select="concat(substring($datestamp, 1, 10), 'T', substring($datestamp, 12, 8))"/>
          </gco:DateTime>
        </gmd:dateStamp>
      </xsl:when>

      <!-- If the date does not match the problematic format, output the original value -->
      <xsl:otherwise>
        <xsl:message>==== Preserving date format ====</xsl:message>
        <gmd:dateStamp>
          <gco:DateTime>
            <xsl:value-of select="$datestamp"/>
          </gco:DateTime>
        </gmd:dateStamp>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Add orphan geographic extents to NRW thesaurus-->
  <xsl:template match="//gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/gmd:MD_Identifier[not(gmd:authority)]">
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

  <xsl:template match="//gmd:CI_Citation">
    <xsl:for-each select="gmd:title">
	<gmd:title>
            <xsl:copy-of select="."/>
        </gmd:title>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="//gmd:CI_Citation">
    <xsl:for-each select="gmd:date">
	<gmd:date>
            <xsl:copy-of select="."/>
        </gmd:date>
    </xsl:for-each>
  </xsl:template>


</xsl:stylesheet>
