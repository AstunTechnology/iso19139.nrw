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
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:xslutil="java:org.fao.geonet.util.XslUtil"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
                xmlns:java="java:org.fao.geonet.util.XslUtil"
                version="2.0"
                exclude-result-prefixes="#all">

  <!-- Custom rendering of keyword section
    * gmd:descriptiveKeywords is boxed element and the title
    of the fieldset is the thesaurus title
    * if the thesaurus is available in the catalog, display
    the advanced editor which provides easy selection of
    keywords.

  -->

  <xsl:function name="geonet:getThesaurusTitle">
    <xsl:param name="thesarusNameEl" />
    <xsl:param name="lang1" />

    <xsl:variable name="lang">
        <xsl:choose>
          <xsl:when test="lower-case($lang1) = 'fre'">
            <xsl:value-of select="'#fra'"/>
          </xsl:when>

          <xsl:otherwise>
            <xsl:value-of select="concat('#',lower-case($lang1))"/>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="thesaurusTitleSimple" select="$thesarusNameEl/gmd:CI_Citation/gmd:title/gco:CharacterString/normalize-space()" />
    <xsl:variable name="thesaurusTitleMultilingualNode"
                  select="$thesarusNameEl/gmd:CI_Citation/gmd:title/gmd:PT_FreeText/gmd:textGroup/gmd:LocalisedCharacterString[@locale = $lang]/normalize-space()"
    />


    <xsl:choose>
      <xsl:when test="$thesaurusTitleMultilingualNode">
        <xsl:value-of select="$thesaurusTitleMultilingualNode"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$thesaurusTitleSimple"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>


  <!-- Descriptive Keywords -->
  <xsl:template mode="mode-iso19139" priority="5000"
                match="gmd:descriptiveKeywords[$schema = 'iso19139.nrw']">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="overrideLabel" select="''" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="thesaurusTitleEl"
                  select="gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title"/>

    <xsl:variable name="thesaurusTitleMultiLingual" select="geonet:getThesaurusTitle(gmd:MD_Keywords/gmd:thesaurusName,$lang)"/>

    <!--Add all Thesaurus as first block of keywords-->
    <xsl:if test="name(preceding-sibling::*[1]) != name()">
      <xsl:call-template name="addAllThesaurus">
        <xsl:with-param name="ref" select="../gn:element/@ref"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:variable name="thesaurusTitle">
      <xsl:choose>
        <xsl:when test="normalize-space($thesaurusTitleMultiLingual) != ''">
          <xsl:value-of select="if ($overrideLabel != '')
              then $overrideLabel
              else concat(
                      $iso19139strings/keywordFrom,
                      normalize-space($thesaurusTitleMultiLingual))"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="gmd:MD_Keywords/gmd:thesaurusName/
                                  gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="attributes">
      <xsl:if test="$isEditing">
        <!-- Create form for all existing attribute (not in gn namespace)
        and all non existing attributes not already present. -->
        <xsl:apply-templates mode="render-for-field-for-attribute"
                             select="
          @*|
          gn:attribute[not(@name = parent::node()/@*/name())]">
          <xsl:with-param name="ref" select="gn:element/@ref"/>
          <xsl:with-param name="insertRef" select="gn:element/@ref"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="thesaurusIdentifier"
                  select="normalize-space($thesaurusTitle)"/>

    <!-- DJB: might be wrong-->
    <xsl:variable name="thesaurusConfig"
                  as="element()?"
                  select="if ($thesaurusList/thesaurus[@key=substring-after($thesaurusIdentifier, 'geonetwork.thesaurus.')])
                          then $thesaurusList/thesaurus[@key=substring-after($thesaurusIdentifier, 'geonetwork.thesaurus.')]
                          else if ($listOfThesaurus/thesaurus[title=$thesaurusTitle])
                          then $listOfThesaurus/thesaurus[title=$thesaurusTitle]
                          else $listOfThesaurus/thesaurus[./multilingualTitles/multilingualTitle/title=$thesaurusTitle]"/>


    <xsl:choose>
      <xsl:when test="$thesaurusConfig/@fieldset = 'false'">

        <xsl:apply-templates mode="mode-iso19139" select="*">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="labels" select="$labels"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="hideDelete" as="xs:boolean">
              <xsl:value-of select="false()" />
         </xsl:variable>

        <xsl:variable name="labelConfig" select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)"/>
        <xsl:variable name="requiredClass">
          <xsl:if test="$labelConfig/condition='mandatory'">
            <xsl:value-of select="'gn-required'" />
          </xsl:if>
        </xsl:variable>

        <xsl:call-template name="render-boxed-element">
          <xsl:with-param name="label"
                          select="if ($thesaurusTitle !='')
                    then $thesaurusTitle
                    else gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
          <xsl:with-param name="editInfo" select="gn:element"/>
          <xsl:with-param name="cls" select="concat(local-name(), ' ', $requiredClass)"/>
          <xsl:with-param name="xpath" select="$xpath"/>
          <xsl:with-param name="attributesSnippet" select="$attributes"/>
          <!--<xsl:with-param name="hideDelete" select="$hideDelete" />-->
          <xsl:with-param name="subTreeSnippet">
            <xsl:apply-templates mode="mode-iso19139" select="*">
              <xsl:with-param name="schema" select="$schema"/>
              <xsl:with-param name="labels" select="$labels"/>
            </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:function name="geonet:findThesaurus">
    <xsl:param name="title1" />
    <xsl:param name="title2" />

    <!--standard way to look for thesaurus-->
    <xsl:variable name="thesaurusConfig"
                  as="element()?"
                  select="if ($listOfThesaurus/thesaurus[@key=substring-after($title1, 'geonetwork.thesaurus.')])
                          then $listOfThesaurus/thesaurus[@key=substring-after($title1, 'geonetwork.thesaurus.')]
                          else if ($listOfThesaurus/thesaurus[title=$title1])
                          then $listOfThesaurus/thesaurus[title=$title1]
                          else if ($listOfThesaurus/thesaurus[title=$title2])
                          then $listOfThesaurus/thesaurus[title=$title2]
                          else $listOfThesaurus/thesaurus[key=$title2]"/>
    <!--handle multilingual case -->
    <xsl:variable name="thesaurusConfig2"
                  as="element()?"
                  select="$listOfThesaurus/thesaurus[./multilingualTitles/multilingualTitle/title=$title1]"/>
    <xsl:variable name="thesaurusConfig3"
                  as="element()?"
                  select="$listOfThesaurus/thesaurus[./multilingualTitles/multilingualTitle/title=$title2]"/>

    <xsl:choose>
        <xsl:when test="$thesaurusConfig">
           <xsl:copy-of  select="$thesaurusConfig"/>
        </xsl:when>
        <xsl:when test="$thesaurusConfig2">
          <xsl:copy-of  select="$thesaurusConfig2"/>
        </xsl:when>
        <xsl:when test="$thesaurusConfig3">
          <xsl:copy-of  select="$thesaurusConfig3"/>
        </xsl:when>
    </xsl:choose>
  </xsl:function>


  <xsl:template mode="mode-iso19139" match="gmd:MD_Keywords[$schema = 'iso19139.nrw']" priority="6000">

    <xsl:variable name="thesaurusIdentifier"
                  select="normalize-space(gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString)"/>


    <xsl:variable name="thesaurusTitle"
                  select="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString"/>

    <xsl:variable name="thesaurusTitle2">
          <xsl:value-of  select="normalize-space(gmd:thesaurusName/gmd:CI_Citation/gmd:title/gmd:PT_FreeText/gmd:textGroup/gmd:LocalisedCharacterString)"/>
    </xsl:variable>


    <xsl:variable name="thesaurusConfig"  as="element()?"  select="geonet:findThesaurus($thesaurusTitle,$thesaurusTitle2)" />


    <xsl:choose>
      <xsl:when test="$thesaurusConfig">

        <xsl:variable name="thesaurusIdentifier"
                      select="$thesaurusConfig/key"/>

        <!-- The thesaurus key may be contained in the MD_Identifier field or
          get it from the list of thesaurus based on its title.
          -->
        <xsl:variable name="thesaurusInternalKey"
                      select="if ($thesaurusIdentifier)
          then $thesaurusIdentifier
          else $thesaurusConfig/key"/>
        <xsl:variable name="thesaurusKey"
                      select="if (starts-with($thesaurusInternalKey, 'geonetwork.thesaurus.'))
                      then substring-after($thesaurusInternalKey, 'geonetwork.thesaurus.')
                      else $thesaurusInternalKey"/>

        <!-- if gui lang eng > #EN -->
        <xsl:variable name="guiLangId"
                      select="
                      if (count($metadata/gmd:locale/gmd:PT_Locale[gmd:languageCode/gmd:LanguageCode/@codeListValue = $lang]) = 1)
                        then $metadata/gmd:locale/gmd:PT_Locale[gmd:languageCode/gmd:LanguageCode/@codeListValue = $lang]/@id
                        else $metadata/gmd:locale/gmd:PT_Locale[gmd:languageCode/gmd:LanguageCode/@codeListValue = $metadataLanguage]/@id"/>

        <!--
        get keyword in gui lang
        in default language
        -->
        <xsl:variable name="keywords" select="string-join(
                  if ($guiLangId and gmd:keyword//*[@locale = concat('#', $guiLangId)]) then
                    gmd:keyword//*[@locale = concat('#', $guiLangId)]/replace(text(), ',', ',,')
                  else gmd:keyword/*[1]/replace(text(), ',', ',,'), ',')"/>

        <!-- Define the list of transformation mode available. -->
        <!--<xsl:variable name="transformations"
                      as="xs:string"
                      select="if ($thesaurusConfig/@transformations != '')
                              then $thesaurusConfig/@transformations
                              else 'to-iso19139-keyword,to-iso19139-keyword-with-anchor,to-iso19139-keyword-as-xlink'"/>-->
        <xsl:variable name="transformations" select="'to-iso19139.nrw-keyword,to-iso19139.nrw-keyword-with-anchor,to-iso19139.nrw-keyword-as-xlink'" />

        <!-- Get current transformation mode based on XML fragment analysis -->
        <xsl:variable name="transformation"
                      select="if (parent::node()/@xlink:href) then 'to-iso19139.nrw-keyword-as-xlink'
          else if (count(gmd:keyword/gmx:Anchor) > 0)
          then 'to-iso19139.nrw-keyword-with-anchor'
          else 'to-iso19139.nrw-keyword'"/>

        <xsl:variable name="parentName" select="name(..)"/>

        <!-- Create custom widget:
              * '' for item selector,
              * 'tagsinput' for tags
              * 'tagsinput' and maxTags = 1 for only one tag
              * 'multiplelist' for multiple selection list
        -->
        <xsl:variable name="widgetMode" select="'tagsinput'"/>
        <xsl:variable name="maxTags"
                      as="xs:string"
                      select="if ($thesaurusConfig/@maxtags)
                              then $thesaurusConfig/@maxtags
                              else ''"/>
        <!--
          Example: to restrict number of keyword to 1 for INSPIRE
          <xsl:variable name="maxTags"
          select="if ($thesaurusKey = 'external.theme.inspire-theme') then '1' else ''"/>
        -->
        <!-- Create a div with the directive configuration
            * elementRef: the element ref to edit
            * elementName: the element name
            * thesaurusName: the thesaurus title to use
            * thesaurusKey: the thesaurus identifier
            * keywords: list of keywords in the element
            * transformations: list of transformations
            * transformation: current transformation
          -->

        <xsl:variable name="allLanguages"
                      select="concat($metadataLanguage, ',', $metadataOtherLanguages)"></xsl:variable>

        <xsl:variable name="thesaurusTitleToDisplay">
          <xsl:choose>
            <xsl:when test="contains($thesaurusIdentifier, 'EC_')">
              <xsl:value-of select="/root/gui/schemas/iso19139.nrw/strings/*[name() = $thesaurusIdentifier]" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$thesaurusTitle" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>



        <xsl:variable name="isMandatory">
          <xsl:choose>
            <xsl:when test="contains($thesaurusIdentifier, 'EC_Information_Category') or
                            contains($thesaurusIdentifier, 'EC_Geographic_Scope') or
                            contains($thesaurusIdentifier, 'EC_Core_Subject')">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- $thesaurusIdentifier add label for keywords in Information Classification panel -->
        <div data-gn-keyword-selector="{$widgetMode}"
             data-metadata-id="{$metadataId}"
             data-element-ref="{concat('_X', ../gn:element/@ref, '_replace')}"
             data-parent-element-ref="{gmd:keyword[1]/gn:element/@ref}"
             data-thesaurus-title="{if ($thesaurusConfig/@fieldset = 'false' or contains($thesaurusIdentifier, 'EC_')) then $thesaurusTitleToDisplay else ''}"
             data-thesaurus-key="{$thesaurusKey}"
             data-mandatory="{$isMandatory}"
             data-keywords="{$keywords}"
             data-transformations="{$transformations}"
             data-current-transformation="{$transformation}"
             data-max-tags="{$maxTags}"
             data-lang="{$metadataOtherLanguagesAsJson}"
             data-textgroup-only="false">
        </div>

        <!-- TODO: To check for ECCC -->
        <!--<xsl:variable name="isTypePlace"
                      select="count(gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='place']) > 0"/>
        <xsl:if test="$isTypePlace">
          <xsl:call-template name="render-batch-process-button">
            <xsl:with-param name="process-name" select="'add-extent-from-geokeywords'"/>
            <xsl:with-param name="process-params">{"replace": true}</xsl:with-param>
          </xsl:call-template>
        </xsl:if>-->

        <div class="col-sm-offset-2 col-sm-9">
          <!--<xsl:call-template name="get-errors-2">
            <xsl:with-param name="refToUse" select="gmd:keyword[1]/gn:element/@ref" />
          </xsl:call-template>-->
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="mode-iso19139" select="*"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>