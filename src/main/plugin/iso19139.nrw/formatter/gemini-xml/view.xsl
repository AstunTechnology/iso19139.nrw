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

<!-- for downloading xml in Gemini endpoint -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:geonet="http://www.fao.org/geonetwork">

  <!-- Import base formatter from xsl-view -->
  <xsl:import href="../base-xml/view.xsl"/>


  <!-- Gemini-specific transformations -->
  <xsl:template match="gmd:metadataStandardName">
    <gmd:metadataStandardName>
      <gmx:Anchor xlink:type="simple" xlink:href="http://vocab.nerc.ac.uk/collection/M25/current/MEDIN/">Gemini</gmx:Anchor>
    </gmd:metadataStandardName>
  </xsl:template>

  <xsl:template match="gmd:metadataStandardVersion">
    <gmd:metadataStandardVersion>
      <gco:CharacterString>2.3</gco:CharacterString>
    </gmd:metadataStandardVersion>
  </xsl:template>

  <!-- Limit gmd:dateStamp to full seconds only, stripping out milliseconds and timezone -->
  <xsl:template match="gmd:dateStamp">
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

</xsl:stylesheet>
