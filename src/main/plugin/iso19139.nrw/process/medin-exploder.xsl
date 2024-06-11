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
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd" version="2.0">

  <xsl:import href="process-utility.xsl"/>


  <!-- i18n information -->
  <xsl:variable name="keyword-semicolon-loc">
    <msg id="a" xml:lang="eng">MEDIN Keyword field contains ";" (ie.</msg>
    <msg id="b" xml:lang="eng">). Run this task to explode those keywords.</msg>
    <msg id="c" xml:lang="eng">and</msg>
  </xsl:variable>

  <xsl:template name="list-medin-exploder">
    <suggestion process="medin-exploder"/>
  </xsl:template>

  <!-- Analyze the metadata record and return available suggestion
    for that process -->
  <xsl:template name="analyze-medin-exploder">
    <xsl:param name="root"/>
    <xsl:variable name="keywordWithsemicolon"
      select="$root//gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/gmd:MD_Identifier/gmd:code[contains(gco:CharacterString, ';')]"/>
    <xsl:if test="$keywordWithsemicolon">
      <suggestion process="keywords-semicolon-exploder" id="{generate-id()}" category="keyword"
                  target="keyword">
        <name xml:lang="en">
          <xsl:value-of select="geonet:i18n($keyword-semicolon-loc, 'a', $guiLang)"/>
          <xsl:value-of
            select="string-join($keywordWithsemicolon, geonet:i18n($keyword-semicolon-loc, 'c', $guiLang))"/>
          <xsl:value-of select="geonet:i18n($keyword-semicolon-loc, 'b', $guiLang)"/>
        </name>
        <operational>true</operational>
        <form/>
      </suggestion>
    </xsl:if>
  </xsl:template>

  <!-- Do a copy of every node and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Always remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>

  <!-- Apply to all keywords having "," in it. -->
  <xsl:template match="gmd:EX_Extent" priority="2">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:for-each select="gmd:geographicElement">
        <xsl:call-template name="explode-keyword">
          <xsl:with-param name="value" select="gco:CharacterString"/>
          <xsl:with-param name="separator" select="';'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:copy-of select="gmd:type|gmd:thesaurusName"/>
    </xsl:copy>
  </xsl:template>


  <!-- Take each token separated by the separator
  and create as many elements as needed -->
  <xsl:template name="explode-keyword">
    <xsl:param name="value"/>
    <xsl:param name="separator"/>

    <gmd:keyword>
      <gco:CharacterString>
        <xsl:choose>
          <xsl:when test="contains($value, $separator)">
            <xsl:value-of select="normalize-space(substring-before($value, $separator))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$value"/>
          </xsl:otherwise>
        </xsl:choose>
      </gco:CharacterString>
      <xsl:copy-of select="gmd:PT_FreeText"/>
    </gmd:keyword>

    <xsl:if test="contains($value, $separator)">
      <xsl:call-template name="explode-keyword">
        <xsl:with-param name="value" select="substring-after($value, $separator)"/>
        <xsl:with-param name="separator" select="$separator"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>