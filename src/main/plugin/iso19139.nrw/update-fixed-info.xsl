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
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:gml320="http://www.opengis.net/gml"
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

  <xsl:include href="../iso19139/convert/functions.xsl"/>
  <xsl:include href="update-fixed-info-keywords.xsl"/>
  <xsl:include href="../iso19139/layout/utility-fn.xsl"/>

  <xsl:variable name="serviceUrl" select="/root/env/siteURL"/>
  <xsl:variable name="node" select="/root/env/node"/>

  <xsl:variable name="schemaLocationFor2007"
                select="'http://www.isotc211.org/2005/gmd http://schemas.opengis.net/csw/2.0.2/profiles/apiso/1.0.0/apiso.xsd'"/>

  <!-- Try to determine if using the 2005 or 2007 version
  of ISO19139. Based on this GML 3.2.0 or 3.2.1 is used.
  Default is 2007 with GML 3.2.1.

  You can force usage of a schema by setting:
  * ISO19139:2007
  <xsl:variable name="isUsing2005Schema" select="false()"/>
  * ISO19139:2005 (not recommended)
  <xsl:variable name="isUsing2005Schema" select="true()"/>
  -->
  <xsl:variable name="isUsing2005Schema"
                select="(/root/gmd:MD_Metadata/@xsi:schemaLocation
                          and /root/gmd:MD_Metadata/@xsi:schemaLocation != $schemaLocationFor2007)
                        or
                        count(//gml320:*) > 0"/>

  <!-- This variable is used to migrate from 2005 to 2007 version.
  By setting the schema location in a record, on next save, the record
  will use GML3.2.1.-->
  <xsl:variable name="isUsing2007Schema"
                select="/root/gmd:MD_Metadata/@xsi:schemaLocation
                          and /root/gmd:MD_Metadata/@xsi:schemaLocation = $schemaLocationFor2007"/>

  <!-- variables for doing hex-encoding -->
  <!-- the next line is all on one line and the before the ! is a space -->
  <xsl:variable name="ascii"> !"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~</xsl:variable>
  <xsl:variable name="hex" >0123456789ABCDEF</xsl:variable>

  <!-- The default language is also added as gmd:locale
  for multilingual metadata records. -->
  <xsl:variable name="mainLanguage">
    <xsl:call-template name="langId_from_gmdlanguage19139">
      <xsl:with-param name="gmdlanguage" select="/root/*/gmd:language"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="isMultilingual"
                select="count(/root/*/gmd:locale[*/gmd:languageCode/*/@codeListValue != $mainLanguage]) > 0"/>

  <xsl:variable name="mainLanguageId"
                select="upper-case(java:twoCharLangCode($mainLanguage))"/>

  <xsl:variable name="locales"
                select="/root/*/gmd:locale/gmd:PT_Locale"/>

  <xsl:variable name="defaultEncoding"
                select="'utf8'"/>

  <xsl:variable name="editorConfig"
                select="document('layout/config-editor.xml')"/>

  <xsl:variable name="nonMultilingualFields"
                select="$editorConfig/editor/multilingualFields/exclude"/>



  <xsl:template match="/root">
    <xsl:apply-templates select="*:MD_Metadata"/>
  </xsl:template>

  <!-- Override template to add gss namespace, to avoid being added to the elements inline.
       Used in templates and not defined in the template from iso19139
  -->
  <xsl:template name="add-namespaces">
    <xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
    <xsl:namespace name="gco" select="'http://www.isotc211.org/2005/gco'"/>
    <xsl:namespace name="gmd" select="'http://www.isotc211.org/2005/gmd'"/>
    <xsl:namespace name="srv" select="'http://www.isotc211.org/2005/srv'"/>
    <xsl:namespace name="gmx" select="'http://www.isotc211.org/2005/gmx'"/>
    <xsl:namespace name="gts" select="'http://www.isotc211.org/2005/gts'"/>
    <xsl:namespace name="gsr" select="'http://www.isotc211.org/2005/gsr'"/>
    <xsl:namespace name="gmi" select="'http://www.isotc211.org/2005/gmi'"/>
    <xsl:namespace name="gss" select="'http://www.isotc211.org/2005/gss'"/>
    <xsl:namespace name="nrw" select="'http://naturalresources.wales/nrw'"/>
    <xsl:choose>
      <xsl:when test="$isUsing2005Schema and not($isUsing2007Schema)">
        <xsl:namespace name="gml" select="'http://www.opengis.net/gml'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:namespace name="gml" select="'http://www.opengis.net/gml/3.2'"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
  </xsl:template>

  <!-- Remove gco:nilReason attribute from the root element -->
    <xsl:template match="/gmd:MD_Metadata/@gco:nilReason"/>


<!-- encode file identifier as a UUID hex encoding of the numeric component of the resource identifier. Prefix with the hex encoding of OLIB-CCWd-ds -->
   <xsl:template match="gmd:fileIdentifier" priority="100">
        <xsl:variable name="nrw-uuid" select="/root/env/uuid"/>
        <xsl:variable name="prefix">4f4c4942-4343-5764-6473-</xsl:variable>
        <gmd:fileIdentifier>
            <gco:CharacterString>
                <xsl:variable name="numericValue">
                    <xsl:call-template name="extractNumeric">
                        <xsl:with-param name="input" select="$nrw-uuid"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($prefix, $numericValue)"/>
            </gco:CharacterString>
        </gmd:fileIdentifier>
    </xsl:template>

    <xsl:template name="extractNumeric">
        <xsl:param name="input" />
        <xsl:variable name="numeric" select="translate($input, translate($input, '1234567890', ''), '')" />
        <xsl:call-template name="recurse-over-string">
            <xsl:with-param name="str" select="$numeric"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="recurse-over-string">
        <xsl:param name="str"/>
        <xsl:if test="$str">
            <xsl:variable name="first-char" select="substring($str,1,1)"/>
            <xsl:variable name="ascii-value" select="string-length(substring-before($ascii,$first-char)) + 32"/>
            <xsl:variable name="hex-digit1" select="substring($hex,floor($ascii-value div 16) + 1,1)"/>
            <xsl:variable name="hex-digit2" select="substring($hex,$ascii-value mod 16 + 1,1)"/>
            <xsl:value-of select="concat($hex-digit1,$hex-digit2)"/>
            <xsl:if test="string-length($str) &gt; 1">
                <xsl:call-template name="recurse-over-string">
                    <xsl:with-param name="str" select="substring($str,2)"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>


  <!-- Override ISO19139 template for gmd:MD_Metadata to stop it messing with the file identifier -->
  <xsl:template match="gmd:MD_Metadata" priority="100">
    <xsl:copy copy-namespaces="no">
      <xsl:call-template name="add-namespaces"/>

      <xsl:apply-templates select="@*"/>

      <!-- <gmd:fileIdentifier>
        <gco:CharacterString>
          <xsl:value-of select="/root/env/uuid"/>
        </gco:CharacterString>
      </gmd:fileIdentifier> -->

      <xsl:apply-templates select="gmd:fileIdentifier"/>
      <xsl:apply-templates select="gmd:language"/>
      <xsl:apply-templates select="gmd:characterSet"/>

      <xsl:choose>
        <xsl:when test="/root/env/parentUuid!=''">
          <gmd:parentIdentifier>
            <gco:CharacterString>
              <xsl:value-of select="/root/env/parentUuid"/>
            </gco:CharacterString>
          </gmd:parentIdentifier>
        </xsl:when>
        <xsl:when test="gmd:parentIdentifier">
          <xsl:apply-templates select="gmd:parentIdentifier"/>
        </xsl:when>
      </xsl:choose>

      <xsl:apply-templates select="
        gmd:hierarchyLevel|
        gmd:hierarchyLevelName|
        gmd:contact|
        gmd:dateStamp|
        gmd:metadataStandardName|
        gmd:metadataStandardVersion|
        gmd:dataSetURI"/>

      <!-- Copy existing locales and create an extra one for the default metadata language. -->
      <xsl:if test="$isMultilingual">
        <xsl:apply-templates select="gmd:locale[*/gmd:languageCode/*/@codeListValue != $mainLanguage]"/>
        <gmd:locale>
          <gmd:PT_Locale id="{$mainLanguageId}">
            <gmd:languageCode>
              <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/"
                                codeListValue="{$mainLanguage}"/>
            </gmd:languageCode>
            <gmd:characterEncoding>
              <gmd:MD_CharacterSetCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_CharacterSetCode"
                                       codeListValue="{$defaultEncoding}"/>
            </gmd:characterEncoding>
            <!-- Apply country if it exists.  -->
            <xsl:apply-templates select="gmd:locale/gmd:PT_Locale[gmd:languageCode/*/@codeListValue = $mainLanguage]/gmd:country"/>
          </gmd:PT_Locale>
        </gmd:locale>
      </xsl:if>

      <xsl:apply-templates select="
        gmd:spatialRepresentationInfo|
        gmd:referenceSystemInfo|
        gmd:metadataExtensionInfo|
        gmd:identificationInfo|
        gmd:contentInfo|
        gmd:distributionInfo|
        gmd:dataQualityInfo|
        gmd:portrayalCatalogueInfo|
        gmd:metadataConstraints|
        gmd:applicationSchemaInfo|
        gmd:metadataMaintenance|
        gmd:series|
        gmd:describes|
        gmd:propertyType|
        gmd:featureType|
        gmd:featureAttribute"/>

      <!-- Handle ISO profiles extensions. -->
      <xsl:apply-templates select="
        *[namespace-uri()!='http://www.isotc211.org/2005/gmd' and
          namespace-uri()!='http://www.isotc211.org/2005/srv']"/>
    </xsl:copy>
  </xsl:template>

  <!-- remove empty gco:CharacterString child nodes that have been added by inflate-metadata -->

<xsl:template match="gmd:contentInfo" priority="10">
        <xsl:choose>
            <xsl:when test="not(*)">
                <xsl:message>=== Empty NRW ===</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- override template for updating datestamp to just use date -->
    <!-- now over-overridden to use dateTime again -->
    <xsl:template match="gmd:dateStamp">
    <xsl:choose>
      <xsl:when test="/root/env/changeDate">
        <xsl:copy>
          <gco:DateTime>
            <xsl:value-of select="/root/env/changeDate"/>
          </gco:DateTime>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- ========================================================================= -->

      <!-- Preserve existing gco:nilReason if empty, but if not defined add a default value unknown -->

  <!-- <xsl:template match="gmd:MD_Format/gmd:version[not(string(gco:CharacterString))]" priority="10">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(@gco:nilReason)">
        <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gmd:MD_Format/gmd:specification[not(string(gco:CharacterString))]" priority="10">
    <xsl:copy>

      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(@gco:nilReason)">
        <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

    <xsl:template match="gmd:MD_Format/gmd:version">
        <xsl:copy>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="gmd:MD_Format/gmd:specification">
        <xsl:copy>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

      <xsl:template match="gmd:hierarchyLevelName[not(string(gco:CharacterString))]" priority="10">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(@gco:nilReason)">
        <xsl:attribute name="gco:nilReason">inapplicable</xsl:attribute>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gmd:valueUnit[not(string(gco:CharacterString))]" priority="10">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(@gco:nilReason)">
        <xsl:attribute name="gco:nilReason">inapplicable</xsl:attribute>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gmd:DQ_ConformanceResult/gmd:explanation[not(string(gco:CharacterString))]" priority="10">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(@gco:nilReason)">
        <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
      </xsl:if>
    </xsl:copy>
  </xsl:template>


    <xsl:template match="gco:CharacterString">
        <xsl:element name="gco:CharacterString">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template> -->

<!-- ========================================================================= -->

<!--   <xsl:template match="gmd:geographicElement[gmd:EX_GeographicDescription/gmd:geographicIdentifier/gmd:MD_Identifier/gmd:authority/gmd:CI_Citation/gmd:title/gco:CharacterString ='SeaVoX Vertical Co-ordinate Coverages']">
    <xsl:choose>
      <xsl:when test="gmd:EX_GeographicDescription/gmd:geographicIdentifier/gmd:MD_Identifier/gmd:code[@gmd:nilReason='missing']">
        <xsl:message>=== Removing Medin vertical extent keyword ===</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> -->

<!-- ========================================================================= -->

<!--   <xsl:template match="gmd:LanguageCode[@codeListValue]" priority="10">

    <xsl:variable name="codelistTranslation"
                  select="tr:codelist-value-label(
                            tr:create('iso19139.nrw'),
                            local-name(), @codeListValue)"/>

    <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/">
      <xsl:apply-templates select="@*[name(.)!='codeList']"/>

      <xsl:value-of select="$codelistTranslation" />
    </gmd:LanguageCode>
  </xsl:template> -->

  <!-- ========================================================================= -->

  <!-- remove empty CharacterString elements with nilreasons of inapplicable, unknown or missing -->
<!--   <xsl:template match="//*[(@gco:nilReason='inapplicable' or @gco:nilReason='unknown')]/gco:CharacterString" priority="10">
    <xsl:choose>
      <xsl:when test="not(text())">
        <xsl:message>=== Removing empty characterString element ===</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> -->

  <!-- remove URL elements with nilreasons of inapplicable, unknown or missing -->
 <!--  <xsl:template match="//*[(@gco:nilReason='inapplicable' or @gco:nilReason='unknown')]/gmd:URL" priority="10">
    <xsl:choose>
      <xsl:when test="not(text())">
        <xsl:message>=== Removing empty URL element ===</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> -->


  <!-- remove empty parent identifier -->
  <xsl:template match="gmd:parentIdentifier" priority="10">
    <xsl:choose>
      <xsl:when test="not(gco:CharacterString/text())">
        <xsl:message>=== Removing empty Parent Identifier ===</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- remove empty uuidref attributes -->
  <xsl:template match="//*[@uuidref[not(string())]]" priority="10">
    <xsl:message>=== Removing empty uuidref ===</xsl:message>
              <xsl:apply-templates select="node()"/>
         </xsl:template>

<!-- ========================================================================= -->

<xsl:template match="*[gco:CharacterString|gmx:Anchor|gmd:PT_FreeText]">
    <xsl:copy>
      <xsl:apply-templates select="@*[not(name() = 'gco:nilReason') and not(name() = 'xsi:type')]"/>

      <!-- Add nileason if text is empty -->
      <xsl:variable name="excluded"
                    select="gn-fn-iso19139:isNotMultilingualField(., $editorConfig)"/>


      <xsl:variable name="valueInPtFreeTextForMainLanguage"
                    select="normalize-space(gmd:PT_FreeText/*/gmd:LocalisedCharacterString[
                                            @locale = concat('#', $mainLanguageId)])"/>

      <!-- Add nileason if text is empty -->
      <xsl:variable name="isMainLanguageEmpty"
                    select="if ($isMultilingual and not($excluded))
                            then ($valueInPtFreeTextForMainLanguage = '' and normalize-space(gco:CharacterString|gmx:Anchor) = '')
                            else if ($valueInPtFreeTextForMainLanguage != '')
                            then $valueInPtFreeTextForMainLanguage = ''
                            else normalize-space(gco:CharacterString|gmx:Anchor) = ''"/>

      <!-- TODO ? Removes @nilReason from parents of gmx:Anchor if anchor has @xlink:href attribute filled. -->
      <xsl:variable name="isEmptyAnchor"
                    select="normalize-space(gmx:Anchor/@xlink:href) = ''" />


      <xsl:choose>
        <xsl:when test="$isMainLanguageEmpty">
          <xsl:attribute name="gco:nilReason">
            <xsl:choose>
              <xsl:when test="@gco:nilReason">
                <xsl:value-of select="@gco:nilReason"/>
              </xsl:when>
              <xsl:otherwise>missing</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@gco:nilReason != 'missing' and not($isMainLanguageEmpty)">
          <xsl:copy-of select="@gco:nilReason"/>
        </xsl:when>
      </xsl:choose>


      <!-- For multilingual records, for multilingual fields,
       create a gco:CharacterString or gmx:Anchor containing
       the same value as the default language PT_FreeText.
      -->
      <xsl:variable name="element" select="name()"/>


      <xsl:choose>
        <!-- Check record does not contains multilingual elements
          matching the main language. This may happen if the main
          language is declared in locales and only PT_FreeText are set.
          It should not be possible in GeoNetwork, but record user can
          import may use this encoding. -->
        <xsl:when test="not($isMultilingual) and
                        $valueInPtFreeTextForMainLanguage != '' and
                        normalize-space(gco:CharacterString|gmx:Anchor) = ''">
          <xsl:element name="{if (gmx:Anchor) then 'gmx:Anchor' else 'gco:CharacterString'}">
            <xsl:copy-of select="gmx:Anchor/@*"/>
            <xsl:value-of select="$valueInPtFreeTextForMainLanguage"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="not($isMultilingual) or
                        $excluded">
          <!-- Copy gco:CharacterString only. PT_FreeText are removed if not multilingual. -->
          <xsl:apply-templates select="gco:CharacterString|gmx:Anchor"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Add xsi:type for multilingual element. -->
          <xsl:attribute name="xsi:type" select="'gmd:PT_FreeText_PropertyType'"/>

          <!-- Is the default language value set in a PT_FreeText ? -->
          <xsl:variable name="isInPTFreeText"
                        select="count(gmd:PT_FreeText/*/gmd:LocalisedCharacterString[
                                            @locale = concat('#', $mainLanguageId)]) = 1"/>


          <xsl:choose>
            <xsl:when test="$isInPTFreeText">
              <!-- Update gco:CharacterString to contains
                   the default language value from the PT_FreeText.
                   PT_FreeText takes priority. -->
              <xsl:element name="{if (gmx:Anchor) then 'gmx:Anchor' else 'gco:CharacterString'}">
                <xsl:copy-of select="gmx:Anchor/@*"/>
                <xsl:value-of select="gmd:PT_FreeText/*/gmd:LocalisedCharacterString[
                                            @locale = concat('#', $mainLanguageId)]/text()"/>
              </xsl:element>

              <xsl:if test="gmd:PT_FreeText[normalize-space(.) != '']">
                <gmd:PT_FreeText>
                  <xsl:call-template name="populate-free-text"/>
                </gmd:PT_FreeText>
              </xsl:if>

            </xsl:when>
            <xsl:otherwise>

              <!-- Populate PT_FreeText for default language if not existing and it is not null. -->
              <xsl:apply-templates select="gco:CharacterString|gmx:Anchor"/>
              <!-- only put this in if there's stuff to put in, otherwise we get a <gmd:PT_FreeText/> in output -->
              <xsl:if test="(normalize-space(gco:CharacterString|gmx:Anchor) != '') or gmd:PT_FreeText">
                <gmd:PT_FreeText>
                  <xsl:if test="normalize-space(gco:CharacterString|gmx:Anchor) != ''"> <!-- default lang-->
                    <gmd:textGroup>
                      <gmd:LocalisedCharacterString locale="#{$mainLanguageId}">
                        <xsl:value-of select="gco:CharacterString|gmx:Anchor"/>
                      </gmd:LocalisedCharacterString>
                    </gmd:textGroup>
                  </xsl:if>
                  <xsl:call-template name="populate-free-text"/> <!-- other langs -->
                </gmd:PT_FreeText>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>

      <!-- Apply other elements that we are not handling in this template -->
      <xsl:apply-templates select="node()[not(self::gco:CharacterString|self::gmx:Anchor|self::gmd:PT_FreeText)]"/>

    </xsl:copy>
  </xsl:template>


  <xsl:template name="populate-free-text">
    <xsl:variable name="freeText"
                  select="gmd:PT_FreeText/gmd:textGroup"/>

    <!-- Loop on locales in order to preserve order.
        Keep main language on top.
        Translations having no locale are ignored. eg. when removing a lang. -->
    <xsl:apply-templates select="$freeText[*/@locale = concat('#', $mainLanguageId)]"/>

    <xsl:for-each select="$locales[@id != $mainLanguageId]">
      <xsl:variable name="localId"
                    select="@id"/>

      <xsl:variable name="element"
                    select="$freeText[*/@locale = concat('#', $localId)]"/>

      <xsl:apply-templates select="$element"/>
    </xsl:for-each>
  </xsl:template>

<!-- ========================================================================= -->


    <!-- Prefill resource identifier with uuid -->

    <xsl:template match="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation" >

        <xsl:copy>
            <xsl:apply-templates select="gmd:title|gmd:alternateTitle|gmd:date|gmd:date|gmd:edition|gmd:editionDate"/>


                <gmd:identifier>
                    <gmd:MD_Identifier>
                        <gmd:code>
                            <gco:CharacterString><xsl:value-of select="/root/env/uuid"/></gco:CharacterString>
                        </gmd:code>
                    </gmd:MD_Identifier>
                </gmd:identifier>


            <xsl:apply-templates select="gmd:citedResponsibleParty|gmd:presentationForm|gmd:series|gmd:otherCitationDetails|gmd:collectiveTitle|gmd:ISBN|gmd:ISSN"/>

        </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->
  <!-- Set local identifier to the first 2 letters of iso code. Locale ids
        are used for multilingual charcterString using #iso2code for referencing.
    -->
  <xsl:template match="gmd:PT_Locale">
    <xsl:element name="gmd:{local-name()}">
      <xsl:variable name="id"
                    select="upper-case(java:twoCharLangCode(gmd:languageCode/gmd:LanguageCode/@codeListValue, ''))"/>

      <xsl:apply-templates select="@*"/>
      <xsl:if test="normalize-space(@id)='' or normalize-space(@id)!=$id">
        <xsl:attribute name="id">
          <xsl:value-of select="$id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

    <!-- ================================================================= -->
    <!-- Insert character encoding as utf8 if it does not exist -->

    <xsl:template match="gmd:identificationInfo/*/gmd:characterSet" >
      <xsl:copy>
      <xsl:choose>
        <xsl:when test="not(gmd:MD_CharacterSetCode/@codeListValue='utf8')">
        <xsl:message>==== Add missing encoding ====</xsl:message>
            <gmd:MD_CharacterSetCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_CharacterSetCode"
                                     codeListValue="utf8"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="gmd:MD_CharacterSetCode"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->
    <!-- Insert dataset lanaguage as English if it does not exist -->

    <xsl:template match="gmd:identificationInfo/*/gmd:language" >
      <xsl:copy>
      <xsl:choose>
        <xsl:when test="not(gmd:LanguageCode/text())">
        <xsl:message>==== Add missing dataset language ====</xsl:message>
            <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/php/code_list.php"
                                     codeListValue="eng">English</gmd:LanguageCode>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="gmd:LanguageCode"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:copy>
    </xsl:template>

    <!-- =============================================================== -->
    <!-- Match gmd:CI_DateTypeCode elements with an empty codeList attribute -->
    <xsl:template match="gmd:CI_DateTypeCode[@codeList='']">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <xsl:attribute name="codeList">http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_DateTypeCode</xsl:attribute>
        </xsl:copy>
    </xsl:template>

    <!-- =============================================================== -->
    <!-- Overwrite ISO19139 template for dealing with uuidref in srv:OperationsOn -->
    <xsl:template match="srv:operatesOn" priority="10">
        <xsl:copy>
          <xsl:copy-of select="@uuidref"/>
          <xsl:choose>

            <!-- Do not expand operatesOn sub-elements when using uuidref
                 to link service metadata to datasets or datasets to iso19110.
             -->
            <xsl:when test="@uuidref">
              <xsl:choose>
                <xsl:when test="not(string(@xlink:href)) or starts-with(@xlink:href, $serviceUrl)">
                  <xsl:attribute name="xlink:href">
                    <xsl:value-of
                      select="concat($serviceUrl,'csw?service=CSW&amp;request=GetRecordById&amp;version=2.0.2&amp;outputSchema=http://www.isotc211.org/2005/gmd&amp;elementSetName=full&amp;id=',@uuidref)"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="@xlink:href"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>

            <xsl:otherwise>
              <xsl:apply-templates select="@*|node()" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:copy>
      </xsl:template>

    <!-- =============================================================== -->

       <!--  Delete empty srv:operateson elements  -->
  <xsl:template match="srv:operatesOn" priority="100">
        <xsl:choose>
            <xsl:when test="not(string(@xlink:href)) or not(string(@uuidref))">
                <xsl:message>=== Removing Empty Coupled Resource ===</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- =============================================================== -->


<!-- Remove empty boolean  and set gco:nilReason='unknown' -->
  <!-- <xsl:template match="*[gco:Boolean and not(string(gco:Boolean))]" priority="1000">
    <xsl:message>=== Remove empty Boolean and set nilReason===</xsl:message>
    <xsl:copy>
      <xsl:copy-of select="@*[name() != 'gco:nilReason']" />
      <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
    </xsl:copy>
  </xsl:template> -->

  <!-- =============================================================== -->


<!-- Remove empty boolean  and set gco:nilReason='unknown' -->
  <xsl:template match="//gmd:pass[not(node()) and not(@*)]" priority="2000">
    <!-- <xsl:message>=== If no gco:Boolean, add nilReason unknown ===</xsl:message> -->
    <xsl:copy>
      <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
    </xsl:copy>
  </xsl:template>

      <!-- =============================================================== -->

  <!-- Remove gco:nilReason if not empty boolean -->
  <xsl:template match="*[string(gco:Boolean)]">
   <!--  <xsl:message>=== Remove empty nilReason in gco:Boolean ===</xsl:message> -->
    <xsl:copy>
      <xsl:copy-of select="@*[name() != 'gco:nilReason']" />
      <xsl:apply-templates select="*" />
    </xsl:copy>
  </xsl:template>

  <!-- ================================================================= -->

  <xsl:template name="correct_ns_prefix">
    <xsl:param name="element"/>
    <xsl:param name="prefix"/>
    <xsl:choose>
      <xsl:when test="local-name($element)=name($element) and $prefix != '' ">
        <xsl:element name="{$prefix}:{local-name($element)}">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="correct_ns_prefix_with_namespace">
    <xsl:param name="element"/>
    <xsl:param name="prefix"/>
    <xsl:param name="namespace"/>

    <xsl:choose>
      <xsl:when test="local-name($element)=name($element) and $prefix != '' ">
        <xsl:element name="{$prefix}:{local-name($element)}" namespace="{$namespace}">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="gmd:*">
    <xsl:call-template name="correct_ns_prefix">
      <xsl:with-param name="element" select="."/>
      <xsl:with-param name="prefix" select="'gmd'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="gco:*">
    <xsl:call-template name="correct_ns_prefix">
      <xsl:with-param name="element" select="."/>
      <xsl:with-param name="prefix" select="'gco'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Move to GML 3.2.1 when using 2007 version. -->
  <xsl:template match="gml320:*[$isUsing2007Schema]">
    <xsl:element name="gml:{local-name()}" namespace="http://www.opengis.net/gml/3.2">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="@gml320:*[$isUsing2007Schema]">
    <xsl:attribute name="gml:{local-name()}" namespace="http://www.opengis.net/gml/3.2" select="."/>
  </xsl:template>

  <xsl:template match="gml:*|gml320:*">
    <xsl:call-template name="correct_ns_prefix_with_namespace">
      <xsl:with-param name="element" select="."/>
      <xsl:with-param name="prefix"
                      select="'gml'"/>
      <xsl:with-param name="namespace"
                      select="if($isUsing2005Schema) then 'http://www.opengis.net/gml' else 'http://www.opengis.net/gml/3.2'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ================================================================= -->
  <!-- copy everything else as is -->

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@xsi:schemaLocation">
    <xsl:if test="java:getSettingValue('system/metadata/validation/removeSchemaLocation') = 'false'">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
