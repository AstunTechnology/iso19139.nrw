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





</xsl:stylesheet>
