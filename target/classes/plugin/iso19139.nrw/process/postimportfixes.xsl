<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gss="http://www.isotc211.org/2005/gss"
                xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:gsr="http://www.isotc211.org/2005/gsr"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gmi="http://www.isotc211.org/2005/gmi"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:nrw="http://naturalresources.wales/nrw">
    
    <!-- Define a map of inspire theme values and their corresponding xlink:href attributes -->
    <xsl:variable name="inspireValueToHrefMap">
        <map>
            <entry value="Addresses" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/ad"/>
            <entry value="Administrative units" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/au"/>
            <entry value="Agricultural and aquaculture facilities" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/af"/>
            <entry value="Area management/restriction/regulation zones and reporting units" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/am"/>
            <entry value="Atmospheric conditions" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/ac"/>
            <entry value="Bio-geographical regions" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/br"/>
            <entry value="Buildings" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/bu"/>
            <entry value="Cadastral parcels" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/cp"/>
            <entry value="Coordinate reference systems" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/rs"/>
            <entry value="Elevation" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/el"/>
            <entry value="Energy resources" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/er"/>
            <entry value="Environmental monitoring facilities" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/ef"/>
            <entry value="Geographical grid systems" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/gg"/>
            <entry value="Geographical names" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/gn"/>
            <entry value="Geology" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/ge"/>
            <entry value="Habitats and biotopes" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/hb"/>
            <entry value="Human health and safety" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/hh"/>
            <entry value="Hydrography" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/hy"/>
            <entry value="Land cover" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/lc"/>
            <entry value="Land use" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/lu"/>
            <entry value="Meteorological geographical features" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/mf"/>
            <entry value="Mineral resources" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/mr"/>
            <entry value="Natural risk zones" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/nz"/>
            <entry value="Oceanographic geographical features" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/of"/>
            <entry value="Orthoimagery" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/oi"/>
            <entry value="Population distribution - demography" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/pd"/>
            <entry value="Production and industrial facilities" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/pf"/>
            <entry value="Protected sites" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/ps"/>
            <entry value="Sea regions" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/sr"/>
            <entry value="Soil" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/so"/>
            <entry value="Species distribution" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/sd"/>
            <entry value="Statistical units" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/su"/>
            <entry value="Transport networks" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/tn"/>
            <entry value="Utility and government services" href="http://www.eionet.europa.eu/gemet/en/inspire-theme/us"/>
        </map>
    </xsl:variable>

      <!-- Define a map of medin format names and their corresponding xlink:href attributes -->
    <xsl:variable name="formatNameToHrefMap">
        <map>
            <entry value="Binary" href="http://vocab.nerc.ac.uk/collection/M01/current/BIN"/>
            <entry value="Database" href="http://vocab.nerc.ac.uk/collection/M01/current/DB"/>
            <entry value="Delimited" href="http://vocab.nerc.ac.uk/collection/M01/current/DEL"/>
            <entry value="Documents" href="http://vocab.nerc.ac.uk/collection/M01/current/DOC"/>
            <entry value="Geographic Information System" href="http://vocab.nerc.ac.uk/collection/M01/current/GIS"/>
            <entry value="Image" href="http://vocab.nerc.ac.uk/collection/M01/current/IMG"/>
            <entry value="Movie" href="http://vocab.nerc.ac.uk/collection/M01/current/MOV"/>
            <entry value="Text or Plaintext" href="http://vocab.nerc.ac.uk/collection/M01/current/TXT"/>
        </map>
    </xsl:variable>
   
    <!-- Define a map of language values and their corresponding codeListValues -->
    <xsl:variable name="languageToCodeListMap">
        <map>
            <entry value="Welsh" codeListValue="cym"/>
            <entry value="English" codeListValue="eng"/>
        </map>
    </xsl:variable>

    <!-- Identity transform for all nodes and attributes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>


    <!-- Remove errant gco:nilReason attribute from the root element -->
    <xsl:template match="/gmd:MD_Metadata/@gco:nilReason"/> 

    <!-- Remove errant gco:CharacterString element from the root element -->
    <xsl:template match="/gmd:MD_Metadata/gco:CharacterString"/>
    
    <!-- Add a locale element if there isn't one already -->
    <xsl:template match="/gmd:MD_Metadata[not(gmd:locale)]">
        <gmd:MD_Metadata>
            <xsl:message>=== adding a locale ===</xsl:message>
            <gmd:locale xmlns:geonet="http://www.fao.org/geonetwork">
                <gmd:PT_Locale id="CY">
                    <gmd:languageCode>
                        <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="wel">wel</gmd:LanguageCode>
                    </gmd:languageCode>
                    <gmd:characterEncoding/>
                </gmd:PT_Locale>
            </gmd:locale>
            <gmd:locale>
                <gmd:PT_Locale id="EN">
                    <gmd:languageCode>
                        <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="eng"/>
                    </gmd:languageCode>
                    <gmd:characterEncoding>
                        <gmd:MD_CharacterSetCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_CharacterSetCode" codeListValue="utf8"/>
                    </gmd:characterEncoding>
                </gmd:PT_Locale>
            </gmd:locale>
            <xsl:apply-templates/>
        </gmd:MD_Metadata>
    </xsl:template>
    
    <!-- Fix codelist URL for metadata language element -->
   
    <xsl:template match="gmd:identificationInfo/*/gmd:language" >
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="not(gmd:LanguageCode/text())">
                    <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/"
                        codeListValue="eng">English</gmd:LanguageCode>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="gmd:LanguageCode"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <!-- remove codespace from identifier -->
    <xsl:template match="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier">
        <xsl:copy>
            <xsl:apply-templates select="gmd:code"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- If dataset language contains a semi-colon, split it into two language blocks -->
    <xsl:template match="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language">
        <xsl:choose>
            <xsl:when test="contains(gmd:LanguageCode, ';')">
                <!-- Split the value and create two separate language variables -->
                <xsl:variable name="lang1" select="substring-before(gmd:LanguageCode, ';')"/>
                <xsl:variable name="lang2" select="substring-after(gmd:LanguageCode, '; ')"/>
                <gmd:language>
                    <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="{$languageToCodeListMap/map/entry[@value=$lang1]/@codeListValue}">
                        <xsl:value-of select="$lang1"/>
                    </gmd:LanguageCode>
                </gmd:language>
                <gmd:language>
                    <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="{$languageToCodeListMap/map/entry[@value=$lang2]/@codeListValue}">
                        <xsl:value-of select="$lang2"/>
                    </gmd:LanguageCode>
                </gmd:language>
            </xsl:when>
            <xsl:otherwise>
                <!-- Keep the original language element -->
                <gmd:language>
                    <xsl:variable name="lang" select="gmd:LanguageCode"/>
                    <xsl:variable name="langcodevalue" select="$languageToCodeListMap/map/entry[@value=$lang]/@codeListValue"/>
                    <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/"  codeListValue="{$langcodevalue}">
                        <xsl:value-of select="$lang"/>
                    </gmd:LanguageCode>
                </gmd:language>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Convert INSPIRE keyword from gco:CharacterString to gmx:Anchor if it's not one already -->
    <!-- TODO not working- possibly because title is a character string rather than an anchor -->
    <xsl:template match="/gmd:MD_Metadata
        /gmd:identificationInfo
        /gmd:MD_DataIdentification
        /gmd:descriptiveKeywords
        /gmd:MD_Keywords
        /gmd:keyword[../gmd:thesaurusName
        /gmd:CI_Citation
        /gmd:title
        /*/text()='GEMET - INSPIRE themes, version 1.0']">
        <xsl:message>=== Match INSPIRE template ===</xsl:message>
                    <xsl:if test="not(gmx:Anchor)">
                        <xsl:variable name="keywordValue" select="normalize-space(./gco:CharacterString)"/>
                        <xsl:variable name="href" select="$inspireValueToHrefMap/map/entry[@value=$keywordValue]/@href"/>
                        <gmd:keyword>
                        <gmx:Anchor xlink:href="{$href}">
                            <xsl:value-of select="$keywordValue"/>
                        </gmx:Anchor>
                        </gmd:keyword>
                </xsl:if>
    </xsl:template>
    
<!--    <xsl:template match="gmd:keyword[gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString='GEMET - INSPIRE themes, version 1.0']/gco:CharacterString">
        <xsl:variable name="keywordValue" select="normalize-space(.)"/>
        <xsl:variable name="href" select="$inspireValueToHrefMap/map/entry[@value=$keywordValue]/@href"/>
        
        <gmx:Anchor xlink:href="{$href}">
            <xsl:value-of select="$keywordValue"/>
        </gmx:Anchor>
    </xsl:template>-->

    <!-- Insert correct citation identifier for keyword -->
    <!-- TODO: For NRW SMNR title needs changing from ... Vocabulary to ... Keywords -->
    <xsl:template match="/gmd:MD_Metadata
        /gmd:identificationInfo
        /gmd:MD_DataIdentification
        /gmd:descriptiveKeywords
        /gmd:MD_Keywords
        /gmd:thesaurusName
        /gmd:CI_Citation">
        <xsl:copy>
          <xsl:choose>
            <xsl:when test="gmd:title/*/text() = 'GEMET - INSPIRE themes, version 1.0'">
                <xsl:choose>
                    <xsl:when test="count(gmd:identifier) = 0">
                    <xsl:apply-templates select="@*|node() except gmd:identifier"/>
                    <xsl:message>=== INSPIRE ===</xsl:message>
                        <gmd:identifier>
                            <gmd:MD_Identifier>
                                <gmd:code>
                                    <gmx:Anchor xlink:href="http://localhost/geonetwork/srv/api/registries/vocabularies/external.theme.httpinspireeceuropaeutheme-theme">geonetwork.thesaurus.external.theme.httpinspireeceuropaeutheme-theme</gmx:Anchor>
                                </gmd:code>
                            </gmd:MD_Identifier>
                        </gmd:identifier>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="@*|node()"/>
                    </xsl:otherwise>
                </xsl:choose>
             </xsl:when>
            <xsl:when test="gmd:title/*/text() = 'NRW Thesaurus'">
                <xsl:apply-templates select="@*|node() except gmd:identifier"/>
                <xsl:message>=== NRW Keywords ===</xsl:message>
                <gmd:identifier>
                        <gmd:MD_Identifier>
                           <gmd:code>
                              <gmx:Anchor xlink:href="http://localhost/geonetwork/srv/api/registries/vocabularies/local.theme.converted_nrw-keywords">geonetwork.thesaurus.local.theme.converted_nrw-keywords</gmx:Anchor>
                           </gmd:code>
                        </gmd:MD_Identifier>
                     </gmd:identifier>
            </xsl:when>
            <xsl:when test="starts-with(gmd:title/*/text(),'NRW SMNR')">
                <xsl:apply-templates select="@*|node() except gmd:identifier"/>
                <xsl:message>=== NRW SMNR Keywords ===</xsl:message>
                <gmd:identifier>
                        <gmd:MD_Identifier>
                           <gmd:code>
                              <gmx:Anchor xlink:href="http://localhost/geonetwork/srv/api/registries/vocabularies/local.theme.converted_nrw-smnr-keywords">geonetwork.thesaurus.local.theme.converted_nrw-smnr-keywords</gmx:Anchor>
                           </gmd:code>
                        </gmd:MD_Identifier>
                     </gmd:identifier>
            </xsl:when>
            <xsl:when test="gmd:title/*/text() = 'Integrated Public Sector Vocabulary'">
                <xsl:apply-templates select="@*|node() except gmd:identifier"/>
                <xsl:message>=== IPSV Subjects List ===</xsl:message>
                <gmd:identifier>
                        <gmd:MD_Identifier>
                           <gmd:code>
                              <gmx:Anchor xlink:href="http://localhost/geonetwork/srv/api/registries/vocabularies/external.theme.subjects">geonetwork.thesaurus.external.theme.subjects</gmx:Anchor>
                           </gmd:code>
                        </gmd:MD_Identifier>
                     </gmd:identifier>
            </xsl:when>
            <xsl:when test="gmd:title/*/text() = 'SeaDataNet Parameter Discovery Vocabulary'">
                <xsl:apply-templates select="@*|node() except gmd:identifier"/>
                <xsl:message>=== SeaDataNet Parameter Discovery Vocabulary ===</xsl:message>
                <gmd:identifier>
                        <gmd:MD_Identifier>
                           <gmd:code>
                              <gmx:Anchor xlink:href="http://localhost/geonetwork/srv/api/registries/vocabularies/external.theme.rdf+xml">geonetwork.thesaurus.external.theme.rdf+xml</gmx:Anchor>
                           </gmd:code>
                        </gmd:MD_Identifier>
                     </gmd:identifier>
            </xsl:when>
        </xsl:choose>
        </xsl:copy>
        </xsl:template>
    

    <xsl:template match="/gmd:MD_Metadata
        /gmd:identificationInfo
        /gmd:MD_DataIdentification
        /gmd:resourceConstraints
        /gmd:MD_LegalConstraints
        [gmd:accessConstraints]
        ">
        <xsl:choose>
            <xsl:when test="count(./gmd:otherConstraints/gmx:Anchor) = 0">
                <xsl:message>=== Adding an inspire nolimitations element ===</xsl:message>
                <gmd:MD_LegalConstraints>
                    <xsl:apply-templates select="@*|node()"/>
                    <gmd:otherConstraints>
                        <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/noLimitations">no limitations</gmx:Anchor>
                    </gmd:otherConstraints>
                </gmd:MD_LegalConstraints>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>=== No need to add an inspire nolimitations element ===</xsl:message>
                <gmd:MD_LegalConstraints>
                <xsl:apply-templates select="@*|node()"/>
                </gmd:MD_LegalConstraints>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Update limitations on public access codelistvalue to "otherRestrictions" -->
    <xsl:template match="/gmd:MD_Metadata
        /gmd:identificationInfo
        /gmd:MD_DataIdentification
        /gmd:resourceConstraints
        /gmd:MD_LegalConstraints
        /gmd:accessConstraints
        /gmd:MD_RestrictionCode/@codeListValue">
        <xsl:attribute name="codeListValue">otherRestrictions</xsl:attribute>
    </xsl:template>

      <!-- remove empty alt title -->
    <xsl:template match="gmd:alternateTitle" priority="100">
        <xsl:choose>
          <xsl:when test="not(gco:CharacterString/text())">
            <!-- <xsl:message>=== Removing empty Alternate Title ===</xsl:message> -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- remove empty denominator -->
    <xsl:template match="gmd:spatialResolution[gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator]" priority="100">
        <xsl:choose>
            <xsl:when test="not(./gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer/text())">
                <xsl:message>=== Removing empty Denominator ===</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>
    
    <!-- remove empty distance -->
    <xsl:template match="gmd:spatialResolution[gmd:MD_Resolution/gmd:distance/gco:Distance]" priority="100">
        <xsl:choose>
            <xsl:when test="not(./gmd:MD_Resolution/gmd:distance/gco:Distance/text())">
                <xsl:message>=== Removing empty Distance ===</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- remove empty distance only when min AND max are empty-->
    <xsl:template match="gmd:verticalElement[gmd:EX_VerticalExtent/gmd:maximumValue]" priority="100">
        <xsl:choose>
            <xsl:when test="not(./gmd:EX_VerticalExtent/gmd:maximumValue/gco:Real/text()) and not(./gmd:EX_VerticalExtent/gmd:minimumValue/gco:Real/text())">
                <xsl:message>=== Removing empty vertical extent ===</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- convert missing conformity pass element to false -->
    <xsl:template match="gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult" priority="100">
        <xsl:choose>
            <xsl:when test="gmd:pass[@gco:nilReason='unknown']">
                <xsl:message>=== Converting empty conformity pass to false ===</xsl:message>
                <xsl:copy>
                <xsl:apply-templates select="@*|node() except gmd:pass"/>
                <gmd:pass>
                    <gco:Boolean>false</gco:Boolean>
                </gmd:pass>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
   

    <!-- rearrange transfer options-->
    <xsl:template match="gmd:onLine/gmd:CI_OnlineResource">
        <xsl:copy>
            <xsl:apply-templates select="gmd:linkage"/>
            <xsl:apply-templates select="gmd:protocol"/>  
            <xsl:apply-templates select="@*|node() except (gmd:protocol|gmd:linkage)"/>  
        </xsl:copy>
    </xsl:template>


    
    <!-- remove empty transfer options -->
    <xsl:template match="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions" priority="100">
        <xsl:choose>
            <xsl:when test="not(gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:name/gco:CharacterString/text())">
<!--                 <xsl:message>=== Removing empty Transfer Options ===</xsl:message> -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- switch data format gmd:name and gmd:specification -->
    <xsl:template match="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format">
        <!-- <xsl:message>=== match data format switch template ===</xsl:message> -->
        <xsl:variable name="formatname" select="./gmd:name"/>
        <xsl:variable name="formatspecification" select="./gmd:specification"/>
        <xsl:variable name="formatversion" select="./gmd:version"/>
<!--          <xsl:message>=== <xsl:value-of select="$formatspecification"/> ===</xsl:message> -->
        <gmd:MD_Format>
            <gmd:name>
                <gmx:Anchor xlink:href="{$formatNameToHrefMap/map/entry[@value=$formatspecification/gco:CharacterString]/@href}">
                    <xsl:value-of select="$formatspecification"/>
                </gmx:Anchor>
            </gmd:name>
            <gmd:version>
                <gco:CharacterString>
                    <xsl:value-of select="$formatversion"/>
                </gco:CharacterString>
            </gmd:version>
            <gmd:specification>
                <gco:CharacterString>
                    <xsl:value-of select="$formatname"/>
                </gco:CharacterString>
            </gmd:specification>
        </gmd:MD_Format>
    </xsl:template>

    <!-- Split gmd:topicCategory element into multiple blocks -->
    <xsl:template match="gmd:topicCategory">
        <xsl:apply-templates select="gmd:MD_TopicCategoryCode"/>
    </xsl:template>
    
    <!-- Match MD_TopicCategoryCode elements and copy them unchanged within the same gmd:topicCategory block -->
    <xsl:template match="gmd:MD_TopicCategoryCode">
        <gmd:topicCategory>
            <xsl:copy-of select="."/>
        </gmd:topicCategory>
    </xsl:template>

    <!-- remove geonet -->
    <xsl:template match="geonet:info"/>

    

  
</xsl:stylesheet>
