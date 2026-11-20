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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gss="http://www.isotc211.org/2005/gss"
                xmlns:nrw="http://naturalresources.wales/nrw"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:tr="java:org.fao.geonet.api.records.formatters.SchemaLocalizations"
                xmlns:java="java:org.fao.geonet.util.XslUtil"
                version="2.0" exclude-result-prefixes="#all">

    <!-- Define a map of medin keywords values and their corresponding xlink:href attributes -->
    <xsl:variable name="medinValueToHrefMap">
        <map>
            <entry value="littoral" href="http://vocab.nerc.ac.uk/collection/L13/current/LI/"/>
            <entry value="thermosphere" href="http://vocab.nerc.ac.uk/collection/L13/current/TS/"/>
            <entry value="epipelagic water column" href="http://vocab.nerc.ac.uk/collection/L13/current/U2/"/>
            <entry value="abyssobenthic" href="http://vocab.nerc.ac.uk/collection/L13/current/AY/"/>
            <entry value="upper epipelagic water column" href="http://vocab.nerc.ac.uk/collection/L13/current/U1/"/>
            <entry value="tropopause" href="http://vocab.nerc.ac.uk/collection/L13/current/TP/"/>
            <entry value="deep circalittoral" href="http://vocab.nerc.ac.uk/collection/L13/current/DC/"/>
            <entry value="bathybenthic" href="http://vocab.nerc.ac.uk/collection/L13/current/BB/"/>
            <entry value="troposphere" href="http://vocab.nerc.ac.uk/collection/L13/current/TH/"/>
            <entry value="core" href="http://vocab.nerc.ac.uk/collection/L13/current/CO/"/>
            <entry value="circalittoral" href="http://vocab.nerc.ac.uk/collection/L13/current/CL/"/>
            <entry value="benthic boundary layer" href="http://vocab.nerc.ac.uk/collection/L13/current/NB/"/>
            <entry value="mesosphere" href="http://vocab.nerc.ac.uk/collection/L13/current/MS/"/>
            <entry value="atmosphere" href="http://vocab.nerc.ac.uk/collection/L13/current/AT/"/>
            <entry value="crust" href="http://vocab.nerc.ac.uk/collection/L13/current/CR/"/>
            <entry value="mesopelagic water column" href="http://vocab.nerc.ac.uk/collection/L13/current/MW/"/>
            <entry value="exosphere" href="http://vocab.nerc.ac.uk/collection/L13/current/ES/"/>
            <entry value="abyssopelagic water column" href="http://vocab.nerc.ac.uk/collection/L13/current/AP/"/>
            <entry value="mesopause" href="http://vocab.nerc.ac.uk/collection/L13/current/MP/"/>
            <entry value="stratopause" href="http://vocab.nerc.ac.uk/collection/L13/current/SP/"/>
            <entry value="stratosphere" href="http://vocab.nerc.ac.uk/collection/L13/current/SS/"/>
            <entry value="infralittoral" href="http://vocab.nerc.ac.uk/collection/L13/current/IL/"/>
            <entry value="upper slope" href="http://vocab.nerc.ac.uk/collection/L13/current/US/"/>
            <entry value="water column skin" href="http://vocab.nerc.ac.uk/collection/L13/current/WS/"/>
            <entry value="atmospheric boundary layer" href="http://vocab.nerc.ac.uk/collection/L13/current/AB/"/>
            <entry value="inapplicable" href="http://vocab.nerc.ac.uk/collection/L13/current/IA/"/>
            <entry value="unknown" href="http://vocab.nerc.ac.uk/collection/L13/current/UK/"/>
            <entry value="soil and sediment" href="http://vocab.nerc.ac.uk/collection/L13/current/SD/"/>
            <entry value="hadopelagic water column" href="http://vocab.nerc.ac.uk/collection/L13/current/HW/"/>
            <entry value="heterosphere" href="http://vocab.nerc.ac.uk/collection/L13/current/HX/"/>
            <entry value="mantle" href="http://vocab.nerc.ac.uk/collection/L13/current/MA/"/>
            <entry value="soil and sediment boundary layer" href="http://vocab.nerc.ac.uk/collection/L13/current/SB/"/>
            <entry value="water column" href="http://vocab.nerc.ac.uk/collection/L13/current/WC/"/>
            <entry value="homopause" href="http://vocab.nerc.ac.uk/collection/L13/current/HP/"/>
            <entry value="water column boundary layer" href="http://vocab.nerc.ac.uk/collection/L13/current/NS/"/>
            <entry value="homosphere" href="http://vocab.nerc.ac.uk/collection/L13/current/HS/"/>
            <entry value="thermopause" href="http://vocab.nerc.ac.uk/collection/L13/current/TZ/"/>
            <entry value="bathypelagic water column" href="http://vocab.nerc.ac.uk/collection/L13/current/BP/"/>
        </map>
    </xsl:variable>


    <!-- Identity transform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Match gmd:geographicElement containing gco:CharacterString with semicolons -->
    <xsl:template match="gmd:geographicElement[gmd:EX_GeographicDescription/gmd:geographicIdentifier/gmd:MD_Identifier/gmd:code/gco:CharacterString[contains(text(), ';')]]">
        <xsl:variable name="authority">
            <xsl:apply-templates select="gmd:EX_GeographicDescription/gmd:geographicIdentifier/gmd:MD_Identifier/gmd:authority" mode="deep-copy"/>
        </xsl:variable>
        <xsl:variable name="text" select="normalize-space(gmd:EX_GeographicDescription/gmd:geographicIdentifier/gmd:MD_Identifier/gmd:code/gco:CharacterString)"/>
        <xsl:variable name="href" select="$medinValueToHrefMap/map/entry[@value=$text]/@href"/>

        <xsl:for-each select="tokenize($text, ';')">
            <xsl:variable name="item" select="normalize-space(.)"/>
            <xsl:variable name="href" select="$medinValueToHrefMap/map/entry[@value=$item]/@href"/>
            <gmd:geographicElement>
                <gmd:EX_GeographicDescription>
                    <gmd:geographicIdentifier>
                        <gmd:MD_Identifier>
                            <xsl:copy-of select="$authority"/>
                            <gmd:code xsi:type="gmd:PT_FreeText_PropertyType">
                                <gmx:Anchor xlink:href="{$href}">
                                    <xsl:value-of select="$item"/>
                                </gmx:Anchor>
                                <gmd:PT_FreeText>
                                    <gmd:textGroup>
                                        <gmd:LocalisedCharacterString locale="#EN">
                                            <xsl:value-of select="$item"/>
                                        </gmd:LocalisedCharacterString>
                                    </gmd:textGroup>
                                </gmd:PT_FreeText>
                            </gmd:code>
                        </gmd:MD_Identifier>
                    </gmd:geographicIdentifier>
                </gmd:EX_GeographicDescription>
            </gmd:geographicElement>
        </xsl:for-each>
    </xsl:template>

    <!-- Deep copy template for authority element -->
    <xsl:template match="*" mode="deep-copy">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <xsl:apply-templates select="@* | node()" mode="deep-copy"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*" mode="deep-copy">
        <xsl:attribute name="{name()}" namespace="{namespace-uri()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

</xsl:stylesheet>