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

  <xsl:import href="../iso19139/update-fixed-info.xsl"/>
  <xsl:include href="../convert/thesaurus-transformation.xsl"/>

  <!-- variables for doing hex-encoding -->
  <!-- the next line is all on one line and the before the ! is a space -->
  <xsl:variable name="ascii"> !"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~</xsl:variable>
  <xsl:variable name="hex" >0123456789ABCDEF</xsl:variable>


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


<!-- encode file identifier as a UUID hex encoding of the numeric component of the resource identifier. Prefix with the hex encoding of OLIB-CCWd-ds -->
   <xsl:template match="gmd:fileIdentifier">
        <xsl:variable name="foo" select="/root/env/uuid"/>
        <xsl:variable name="prefix">4f4c4942-4343-5764-6473-</xsl:variable>
        <gmd:fileIdentifier>
            <gco:CharacterString>
                <xsl:variable name="numericValue">
                    <xsl:call-template name="extractNumeric">
                        <xsl:with-param name="input" select="$foo"/>
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



  <xsl:template match="gmd:MD_Format/gmd:version[not(string(gco:CharacterString))]" priority="10">
    <xsl:copy>
      <!-- Preserve existing gco:nilReason if empty, but if not defined add a default value unknown -->
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(gco:nilReason)">
        <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
      </xsl:if>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="gmd:hierarchyLevelName[not(string(gco:CharacterString))]" priority="10">
    <xsl:copy>
      <!-- Preserve existing gco:nilReason if empty, but if not defined add a default value inapplicable -->
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(@gco:nilReason)">
        <xsl:attribute name="gco:nilReason">inapplicable</xsl:attribute>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gmd:valueUnit[not(string(gco:CharacterString))]" priority="10">
    <xsl:copy>
      <!-- Preserve existing gco:nilReason if empty, but if not defined add a default value inapplicable -->
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(@gco:nilReason)">
        <xsl:attribute name="gco:nilReason">inapplicable</xsl:attribute>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gmd:DQ_ConformanceResult/gmd:explanation[not(string(gco:CharacterString))]" priority="10">
    <xsl:copy>
      <!-- Preserve existing gco:nilReason if empty, but if not defined add a default value unknown -->
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(@gco:nilReason)">
        <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gmd:LanguageCode[@codeListValue]" priority="10">

    <!-- Retrieve the translation for the codeListValue attribute -->
    <xsl:variable name="codelistTranslation"
                  select="tr:codelist-value-label(
                            tr:create('iso19139.nrw'),
                            local-name(), @codeListValue)"/>

    <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/">
      <xsl:apply-templates select="@*[name(.)!='codeList']"/>

      <xsl:value-of select="$codelistTranslation" />
    </gmd:LanguageCode>
  </xsl:template>

  <!-- remove empty CharacterString elements with nilreasons of inapplicable, unknown or missing -->
  <xsl:template match="//*[(@gco:nilReason='inapplicable' or @gco:nilReason='unknown')]/gco:CharacterString" priority="10">
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
  </xsl:template>

  <!-- remove URL elements with nilreasons of inapplicable, unknown or missing -->
  <xsl:template match="//*[(@gco:nilReason='inapplicable' or @gco:nilReason='unknown')]/gmd:URL" priority="10">
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
  </xsl:template>

      <!--  Delete empty keyword elements  -->
  <xsl:template match="gmd:descriptiveKeywords" priority="100">
    <xsl:choose>
      <xsl:when test="gmd:MD_Keywords/gmd:keyword/@gco:nilReason='missing'">
        <xsl:message>=== Removing empty Keyword Element ===</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- remove empty parent identifier -->
  <xsl:template match="gmd:parentIdentifier" priority="10">
    <xsl:choose>
      <xsl:when test="not(text())">
        <xsl:message>=== Removing empty Parent Identifier ===</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- remove empty alt title -->
  <xsl:template match="gmd:alternateTitle" priority="100">
    <xsl:choose>
      <xsl:when test="not(gco:CharacterString/text())">
        <xsl:message>=== Removing empty Alternate Title ===</xsl:message>
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

  <!-- remove whole vertical element if both min and max values are empty or not present -->
  <!-- <xsl:template match="gmd:verticalElement">
    <xsl:variable name="hasMinimumValue" select="string(gmd:EX_VerticalExtent/gmd:minimumValue/gco:Real)" />
    <xsl:variable name="hasMaximumValue" select="string(gmd:EX_VerticalExtent/gmd:maximumValue/gco:Real)" />
    <xsl:variable name="hasVerticalCRSContent" select="string(gmd:EX_VerticalExtent/gmd:verticalCRS/@xlink:href) or count(gmd:EX_VerticalExtent/gmd:verticalCRS/*) > 0" />

    <xsl:choose>
      <xsl:when test="$hasMinimumValue or $hasMaximumValue or $hasVerticalCRSContent">
         <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <gmd:verticalElement gco:nilReason="inapplicable" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> -->


    <!-- Prefill resource identifier with uuid -->

    <xsl:template match="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation" >

        <xsl:copy>
            <xsl:apply-templates select="gmd:title|gmd:alternateTitle|gmd:date|gmd:date|gmd:edition|gmd:editionDate"/>

            <!-- <xsl:choose>
                <xsl:when test="not(gmd:identifier) or gmd:identifier ='' ">
                    <xsl:message>==== Add missing resource identifier ====</xsl:message>
                    <gmd:identifier>
                        <gmd:MD_Identifier>
                            <gmd:code>
                                <gco:CharacterString><xsl:value-of select="/root/env/uuid"/></gco:CharacterString>
                            </gmd:code>
                        </gmd:MD_Identifier>
                    </gmd:identifier>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="gmd:identifier"/>
                </xsl:otherwise>
            </xsl:choose> -->

            <gmd:identifier>
                        <gmd:MD_Identifier>
                            <gmd:code>
                                <gco:CharacterString><xsl:value-of select="/root/env/uuid"/></gco:CharacterString>
                            </gmd:code>
                            <gmd:codeSpace>
                              <gco:CharacterString>http://naturalresources.wales/</gco:CharacterString>
                           </gmd:codeSpace>
                        </gmd:MD_Identifier>
                    </gmd:identifier>

            <xsl:apply-templates select="gmd:citedResponsibleParty|gmd:presentationForm|gmd:series|gmd:otherCitationDetails|gmd:collectiveTitle|gmd:ISBN|gmd:ISSN"/>

        </xsl:copy>
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

</xsl:stylesheet>
