<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                exclude-result-prefixes="#all"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is
      the preferred method for meta-stylesheets to use where possible.
    -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <xsl:include xmlns:svrl="http://purl.oclc.org/dsdl/svrl" href="../../../xsl/utils-fn.xsl"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="lang"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="thesaurusDir"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="rule"/>
   <xsl:variable xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="loc"
                 select="document(concat('../loc/', $lang, '/', $rule, '.xml'))"/>

   <!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators
    -->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators
    -->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
            <xsl:variable name="p_1"
                          select="1+       count(preceding-sibling::*[name()=name(current())])"/>
            <xsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1"/>]</xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>']</xsl:text>
            <xsl:variable name="p_2"
                          select="1+     count(preceding-sibling::*[local-name()=local-name(current())])"/>
            <xsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2"/>]</xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@
              <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@
        <xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans
      (Top-level element has index)
    -->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@
        <xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH-->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2-->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="MEDIN Discovery Metadata Profile"
                              schemaVersion="3.1.2">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>
         
        <xsl:value-of select="$archiveNameParameter"/>
         
        <xsl:value-of select="$fileNameParameter"/>
         
        <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:text>
    This Schematron schema is based on MEDIN_Schema_Documentation3_1_2_full.pdf. The text describing
    each metadata element has been extracted from this document. Reference has also been made to
    the INSPIRE Metadata Implementing Rules: Technical Guidelines based on EN ISO 19115 and EN ISO 19139
    which is available at:
  </svrl:text>
         <svrl:text>
    http://inspire.jrc.ec.europa.eu/reports/ImplementingRules/metadata/MD_IR_and_ISO_20090218.pdf
  </svrl:text>
         <svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/gml/3.2" prefix="gml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gmd" prefix="gmd"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gco" prefix="gco"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gmx" prefix="gmx"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/srv" prefix="srv"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 1 - Resource Title (M)</xsl:attribute>
            <svrl:text>Mandatory element. Only one resource title allowed. Free text.</svrl:text>
            <svrl:text>
      The title is used to provide a brief and precise description of the dataset.
      The following format is recommended:
    </svrl:text>
            <svrl:text>
      'Date' 'Originating organization/programme' 'Location' 'Type of survey'.
      It is advised that acronyms and abbreviations are reproduced in full.
      Example: Centre for Environment, Fisheries and Aquaculture Science (Cefas).
    </svrl:text>
            <svrl:text>
      If acronyms cannot be reproduced in full in the Title element, they must be fully expanded in one 
      of the Resource Abstract or Alternative Resource Title elements.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/> 1992 Centre for Environment, Fisheries and Aquaculture Science (Cefas)
      North Sea 2m beam trawl survey.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/> 1980-2000 Marine Life Information Network UK
      (MarLIN) Sealife Survey records.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinResourceTitleGcoTypeTest</xsl:attribute>
            <xsl:attribute name="name">MedinResourceTitleGcoTypeTest</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 2 - Alternative Resource Title (O)</xsl:attribute>
            <svrl:text>
      Optional element.  Multiple alternative resource titles allowed.  Free text.
    </svrl:text>
            <svrl:text>
      The purpose of alternative title is to record any additional names by which the resource 
      (e.g. dataset) may be known and may include short name, other name, acronyms or alternative 
      language title e.g. Welsh language title of the same resource. If including acronyms in the 
      text, they should be expanded in full if the full term has not been stated in the Resource 
      title element. 
    </svrl:text>
            <svrl:text>Example</svrl:text>
            <svrl:text>
      1980-2000 MarLIN Volunteer Sighting records.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinAlternativeResourceTitleInnerText</xsl:attribute>
            <xsl:attribute name="name">MedinAlternativeResourceTitleInnerText</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 3 - Resource Abstract (M)</xsl:attribute>
            <svrl:text>Mandatory element.  Only one resource abstract allowed.  Free text.</svrl:text>
            <svrl:text>
      The abstract should provide a clear and brief statement of the content of the resource 
      (e.g. dataset).  It shall be a minimum of 100 characters in length and shall not be a 
      duplicate of the title. Metadata creators should include what has been recorded, what 
      form the data takes, what purpose it was collected for, and any limiting information, 
      i.e. limits or caveats on the use and interpretation of the data.  Background methodology 
      and quality information should be entered into the Lineage element (Element 17).  It is 
      recommended that acronyms and abbreviations are reproduced in full e.g. Centre for 
      Environment, Fisheries and Aquaculture Science (Cefas).
    </svrl:text>
            <svrl:text>
      Restrictions relating to spatial resolution for metadata for services shall be expressed in 
      Resource abstract if they exist, and not in Element 18 Spatial Resolution.
    </svrl:text>
            <svrl:text>Examples</svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/> Benthic marine species abundance data from an assessment of 
      the cumulative impacts of aggregate extraction on seabed macro-invertebrate communities. The 
      purpose of this study was to determine whether there was any evidence of a large-scale 
      cumulative impact on benthic macro-invertebrate communities as a result of the multiple sites 
      of aggregate extraction located off Great Yarmouth in the North Sea.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/> As part of the UK Department of Trade and Industry's (DTI's)
      ongoing sectorial Strategic Environmental Assessment (SEA) programme, a seabed survey
      programme (SEA2) was undertaken in May/June 2001 for areas in the central and southern
      North Sea UKCS.  This report summarizes the sediment total hydrocarbon and aromatic data
      generated from the analyses of selected samples from three main study areas:
    </svrl:text>
            <svrl:text>
      Area 1: the major sandbanks off the coast of Norfolk and Lincolnshire in the Southern North Sea (SNS);
    </svrl:text>
            <svrl:text>
      Area 2: the Dogger Bank in the SNS; and
    </svrl:text>
            <svrl:text>
      Area 3: the pockmarks in the Fladen Ground vicinity of the central North Sea (CNS).
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 3:<xsl:text/> The effects of a recent dumping of spoil in a licensed dumping 
      ground within the Salcombe and Kingsbridge Estuary were studied during September 15th - 19th, 
      1987. The area was mapped using a combination of echo soundings and observations by divers. Data 
      on species and biotope recorded and entered onto Marine Recorder. Species data and biotope data 
      mapped as points using MapInfo. Includes Salcombe1 electronic data in the form of a Word 
      document report.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 4:<xsl:text/> Conductivity, Temperature, Depth (CTD) grid survey in
      the Irish Sea undertaken in August 1981.  Only temperature profiles due to conductivity
      sensor malfunction.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">d562e3529TypeNotNillablePattern</xsl:attribute>
            <xsl:attribute name="name">d562e3529TypeNotNillablePattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Abstract free-text element check</xsl:attribute>
            <svrl:text>A human readable, non-empty description of the dataset, dataset series or service shall
      be provided</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Abstract length check</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Abstract is not the same as Title...</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 4 - Resource Type (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  One occurrence allowed.  Controlled vocabulary.
    </svrl:text>
            <svrl:text>
      Identify the type of resource using the controlled vocabulary, MD_ScopeCode from ISO 19115.  
      (See Annex C for code list).  The resource type shall be a dataset, a series (collection of 
      datasets with a common specification) or a service. In the vast majority of cases for MEDIN 
      the resource type will be a dataset or a series. Further information on the difference between 
      a dataset and a series and the definition of a service is available at 
      http://www.medin.org.uk/medin/data/faqs. 
    </svrl:text>
            <svrl:text>
      Example
    </svrl:text>
            <svrl:text>
      series
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 31 - Hierarchy Level Name (C)</xsl:attribute>
            <svrl:text>Conditional element (shall be completed when Resource type is not 'dataset').  
      Single occurrence allowed.  Free text. </svrl:text>
            <svrl:text>
      This is the name of the hierarchy level for which the metadata is provided. It should be used in 
      conjunction with Resource type to provide users with information on the hierarchy of data within 
      the resource.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/> series
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/> service
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">hierarchyLevelName-NotNillable</xsl:attribute>
            <xsl:attribute name="name">hierarchyLevelName-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 5 - Resource Locator (C)</xsl:attribute>
            <svrl:text>Conditional element (shall be completed when online access is available).  Multiple 
    resource locators are allowed.  Free text.</svrl:text>
            <svrl:text>
      Formerly named online resource. If the resource is available online you must provide a web 
      address (URL) that links to the resource. If there is no online access to the resource but 
      there is a publicly available online resource providing additional information about the 
      described resource, a link to this information resource should be provided instead. This 
      element should be used to provide the URL of any Digital Object Identifier (DOI) landing 
      page(s) for the data resource.
    </svrl:text>
            <svrl:text>
      Schematron note: The condition cannot be tested with Schematron.
    </svrl:text>
            <svrl:text>Element 5.1 - Resource locator URL (C)</svrl:text>
            <svrl:text>Conditional element (must be completed if known).  URL (web address).</svrl:text>
            <svrl:text>The URL (web address) including the http:// </svrl:text>
            <svrl:text>Element 5.2 - Resource locator name (O)</svrl:text>
            <svrl:text>Optional element.  Free text.</svrl:text>
            <svrl:text>The name of the web resource.</svrl:text>
            <svrl:text>Element 5.3 - Resource function (O)</svrl:text>
            <svrl:text>Optional element. Controlled vocabulary from ISO CI_OnlineFunctionCode. E.g. download, 
      information, offlineAccess, order or search</svrl:text>
            <svrl:text>Code for the function performed by the online resource. If the element is being populated 
      for a DOI, the code shall be ‘information’. </svrl:text>
            <svrl:text>Element 5.4 - Resource locator description (C)</svrl:text>
            <svrl:text>Conditional element.  Free text.</svrl:text>
            <svrl:text>A detailed text description of what the online resource is or does. This element shall 
      be populated for datasets and series metadata if ‘Resource locator name’ is unavailable. For 
      services, it shall be populated if the service is an invocable spatial data service. Otherwise, 
      population of this sub-element is optional.</svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/>
            </svrl:text>
            <svrl:text>
      Resource locator URL: </svrl:text>
            <svrl:text>
        http://www.defra.gov.uk/marine/science/monitoring/merman.htm </svrl:text>
            <svrl:text>
      Resource locator name: </svrl:text>
            <svrl:text>
        The Marine Environment National Monitoring and Assessment Database</svrl:text>
            <svrl:text>
      Resource locator function: </svrl:text>
            <svrl:text>
        download 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/>
            </svrl:text>
            <svrl:text>
      Resource locator URL: </svrl:text>
            <svrl:text>
        https://doi.org/10.5285/481720C2-35BD-6C10-E053-6C86ABC06BB3 </svrl:text>
            <svrl:text>
      Resource locator name: </svrl:text>
            <svrl:text>
        An improved database of coastal flooding in the United Kingdom from 1915 to 2016 </svrl:text>
            <svrl:text>
      Resource locator function: </svrl:text>
            <svrl:text>
        information 
    </svrl:text>
            <svrl:text>
      Resource locator description: </svrl:text>
            <svrl:text>
        URL accesses a landing page (at the British Oceanographic Data Centre) for the UK database 
        of coastal flooding from 1915 to 2016, allowing interested parties to download the data 
        anonymously.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinResouceLocatorName-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MedinResouceLocatorName-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinResouceLocatorDescription-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MedinResouceLocatorDescription-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinResouceLocatorFunction-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MedinResouceLocatorFunction-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 6 - Unique Resource Identifier (C)</xsl:attribute>
            <svrl:text>
      Mandatory element for datasets and series of datasets, not applicable to services. Multiple occurrences allowed.  
      Free text.
    </svrl:text>
            <svrl:text>
      A Unique Resource Identifier allows a resource to be identified by a code. This code is 
      generally assigned by the data owner and commonly consists of the organisation that manages 
      the dataset and a number or code which is used to uniquely identify it within the databases 
      of the organisation. If this code is unique then it is possible for an organisation to 
      identify a dataset that a 3rd party may be referring to and also to quickly identify where 
      dataset records may be duplicated in a portal.
    </svrl:text>
            <svrl:text>
      The two parts to the element can either be provided separately as a code + a codespace or combined 
      as 1 code. MEDIN recommends the use of code + a codespace as shown in example 1. Preferably the 
      www address of the organisation should be given rather than the organisation acronym or name. 
      The code and the codespace should not include any spaces. If you are unable to generate a Unique 
      Identifier Code please contact medin.metadata@mba.ac.uk  and we will generate a code for you or 
      endeavour to provide a tool to generate your own codes.
    </svrl:text>
            <svrl:text>
      Where present, a resource DOI should be recorded as a resource identifier, with the code 
      reflecting the DOI and codespace being 'doi'.
    </svrl:text>
            <svrl:text>Element 6.1 - Code (M)</svrl:text>
            <svrl:text>Mandatory sub-element (for datasets and series of datasets and also for services if 
      element population is desired).  One occurrence allowed.  Free text. </svrl:text>
            <svrl:text>A unique identification code for the resource. Where a DOI is being provided as a 
      resource identifier, this code should be the DOI string. For DOIs, the resource needs to be encoded 
      with an xlink anchor to the URL of the doi landing page.</svrl:text>
            <svrl:text>Element 6.2 - Code Space (O)</svrl:text>
            <svrl:text>Optional sub-element.  One occurrence allowed.  Free text. </svrl:text>
            <svrl:text>This sub element is the authority that guarantees that the Sub element 6.1. 'Code' given 
      is unique within its management system. For INSPIRE compliance, this should be the internet 
      domain of the data owner/provider. Where a DOI is being provided as a resource identifier, this 
      code space should be the text string 'doi'. </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/>
            </svrl:text>
            <svrl:text>
      Code: 5639287</svrl:text>
            <svrl:text>
      Codespace: http://www.bodc.ac.uk</svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/>
            </svrl:text>
            <svrl:text>
      Code: http://www.bodc.ac.uk/5639287</svrl:text>
            <svrl:text>
               <xsl:text/>Example 3:<xsl:text/>
            </svrl:text>
            <svrl:text>
      Code: doi:10.5285/481720c2-35bd-6c10-e053-6c86abc06bb3</svrl:text>
            <svrl:text>
      Codespace: doi</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">URI-Code-NotNillable</xsl:attribute>
            <xsl:attribute name="name">URI-Code-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">URI-CodeSpace-Nillable</xsl:attribute>
            <xsl:attribute name="name">URI-CodeSpace-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinUniqueResourceIdentifierGcoTypePattern</xsl:attribute>
            <xsl:attribute name="name">MedinUniqueResourceIdentifierGcoTypePattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinUniqueResourceIdentifierCodeSpaceGcoTypePattern</xsl:attribute>
            <xsl:attribute name="name">MedinUniqueResourceIdentifierCodeSpaceGcoTypePattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 7 - Coupled Resource (C)</xsl:attribute>
            <svrl:text>
      Conditional element. Not applicable to datasets or series. Mandatory for View and Download 
      services, optional for other service types.  Multiple occurrences allowed. Free text. 
    </svrl:text>
            <svrl:text>
      This identifies the data resource(s) on which the service operates. Each occurrence shall be 
      a URL that points to the metadata record of the data on which the service operates 
    </svrl:text>
            <svrl:text>Example</svrl:text>
            <svrl:text>http://portal.oceannet.org/portal/start.php#details?tpc=006_00806134608655879d57842c8 138b1ff</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 8 - Resource Language (C)</xsl:attribute>
            <svrl:text>
      Conditional element.  Mandatory for datasets and series, not applicable to services. 
      Multiple occurrences allowed. Controlled vocabulary, ISO 639-2. 
    </svrl:text>
            <svrl:text>
      Describes the language(s) of any textual information contained within the resource.  
    </svrl:text>
            <svrl:text>
      Select the relevant 3-letter code(s) from the ISO 639-2 code list of languages.  Additional 
      languages may be added to this list if required.  A full list of UK language codes is listed 
      in Annex D and a list of recognized languages available online 
      http://www.loc.gov/standards/iso639-2/php/code_list.php.
    </svrl:text>
            <svrl:text>
      For Welsh, ISO 639-2 allows either of ‘cym’ or ‘wel’, but MEDIN recommend that ‘cym’ is used 
      as this is the abbreviation of the language’s own name for itself. This follows guidance from 
      GEMINI. 
    </svrl:text>
            <svrl:text>
      If there is no textual information in the data resource, then the code value zxx from 
      ISO 639-2/B for ‘no linguistic content; not applicable’ shall be used.  
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/>
            </svrl:text>
            <svrl:text>
      eng (English)</svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/>
            </svrl:text>
            <svrl:text>
      cym (Welsh)</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinResourceLanguageLanguagePattern</xsl:attribute>
            <xsl:attribute name="name">MedinResourceLanguageLanguagePattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 9 - Topic Category (C)</xsl:attribute>
            <svrl:text>
      Conditional element.  Mandatory for datasets and series of datasets.  This element is not 
      required if a service is being described. Multiple occurrences allowed.    
      Controlled vocabulary. 
    </svrl:text>
            <svrl:text>
      This indicates the main theme(s) of the data resource. The purpose of this element is to 
      provide a basic classification for the data resource, for use in initial searches. The 
      relevant topic category/categories shall be selected from the ISO MD_TopicCategory list.  
      The full list can be found in Annex E or viewed in controlled vocabulary library P05 on the 
      NVS2 Vocabulary Server https://www.bodc.ac.uk/resources/vocabularies/vocabulary_search/P05/. 
    </svrl:text>
            <svrl:text>
      MEDIN have mapped the MEDIN keywords (see element 11) to the ISO Topic Categories, so it 
      is possible to generate the topic categories automatically once MEDIN keywords have been 
      selected from the SeaDataNet Parameter Discovery Vocabulary (P02) 
      https://www.bodc.ac.uk/data/codes_and_formats/vocabulary_search/P02/.    
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/>
            </svrl:text>
            <svrl:text>
      biota</svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/>
            </svrl:text>
            <svrl:text>
      oceans</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinTopicCategoryCodeInnerText</xsl:attribute>
            <xsl:attribute name="name">MedinTopicCategoryCodeInnerText</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 10 - Spatial Data Service Type (C)</xsl:attribute>
            <svrl:text>
      Conditional element.  Mandatory if the described resource is a service. Not applicable to 
      datasets or series. One occurrence allowed. Controlled vocabulary, INSPIRE Service type 
      code list 
    </svrl:text>
            <svrl:text>
      An element required by INSPIRE for metadata about data services e.g. web services.  If a
      service is being described (from Element 4) it must be assigned a service type from the
      INSPIRE Service type codelist.  See Annex 5 for list.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinSpatialDataServiceTypeGcoTypePattern</xsl:attribute>
            <xsl:attribute name="name">MedinSpatialDataServiceTypeGcoTypePattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 32 - Spatial Representation Type (C)</xsl:attribute>
            <svrl:text>
      Conditional element.  Mandatory for datasets and series of datasets.  This element is not 
      required if a service is being described. Multiple occurrences allowed.    
      Controlled vocabulary, subset of MD_SpatialRepresentationTypeCode from ISO 19115  
    </svrl:text>
            <svrl:text>
      This element describes the method used to spatially represent geographic information. The 
      type in which the spatial data is represented may be of importance when evaluating the fit 
      for purpose of the datasets. 
    </svrl:text>
            <svrl:text>
      This element is regarded by the INSPIRE metadata technical guidance as interoperability 
      metadata for datasets and series. The element shall be populated with one or more of a subset of codes from 
      MD_SpatialRepresentationTypeCode that most appropriately describe(s) the resource. 
      See Annex M for list.  
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example:<xsl:text/>
            </svrl:text>
            <svrl:text>
      grid</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 11 - Keywords (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  Multiple keywords allowed.  Controlled vocabularies.
    </svrl:text>
            <svrl:text>
      The purpose of this element is to indicate the general subject area(s) of the data resource 
      using key words. This enables searches to eliminate resources that are of no interest to users.
    </svrl:text>
            <svrl:text>
      Keywords should be chosen using the code list options given below. OAI harvesting keywords 
      should be linked to the data resource as described below if the metadata record is being 
      submitted to MEDIN and to data.gov.uk.
    </svrl:text>
            <svrl:text>
      In addition, if a spatial data service is being described, then a keyword defining the 
      category or subcategory of the service using its language neutral name as defined in Part D 4 
      of the Metadata Implementing Rules shall be given. 
    </svrl:text>
            <svrl:text>
      The entry shall consist of two sub-elements: the keywords and reference to the controlled 
      vocabulary used as shown in the sub elements below. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>INSPIRE Keywords (M)<xsl:text/>
            </svrl:text>
            <svrl:text>
      MEDIN require at least one INSPIRE theme keyword as this ensures INSPIRE compliance.  
    </svrl:text>
            <svrl:text>
      A list of the INSPIRE theme keywords is available in Annex J. This list is also available at  
      http://www.eionet.europa.eu/gemet/inspire_themes or library P22 in the NVS2 Vocabulary 
      Server https://www.bodc.ac.uk/data/codes_and_formats/vocabulary_search/P22/. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>MEDIN Keywords (C)<xsl:text/>
            </svrl:text>
            <svrl:text>
      The contents of the dataset shall be described using the SeadataNet Parameter Discovery 
      Vocabulary (P02), unless there are no applicable terms in the list. This improves the 
      discoverability of datasets by using terms related to the marine domain. 
    </svrl:text>
            <svrl:text>
      The P02 terms are available at https://www.bodc.ac.uk/data/codes_and_formats/vocabulary_search/P02/. 
      The parameter groups and codes that are used may also be searched hierarchically through a 
      user friendly interface which has been built as part of the European funded SeaDataNet 
      project at http://seadatanet.maris2.nl/v_bodc_vocab_v2/vocab_relations.asp?lib=P08. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Vertical Extent Keywords (C)<xsl:text/>
            </svrl:text>
            <svrl:text>
      Element 11: 'vertical extent keyword' shall be populated only if Element 14: 'Vertical 
      extent information' cannot be completed. 
    </svrl:text>
            <svrl:text>
      A vocabulary of keywords is available to describe the vertical extent of the resource (e.g. 
      dataset). The vocabulary is available as library L13 (Vertical Coordinate Coverages) at 
      https://www.bodc.ac.uk/data/codes_and_formats/vocabulary_search/L13/. It can also be seen 
      in Annex J.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Other Keywords (O)<xsl:text/>
            </svrl:text>
            <svrl:text>
      Keywords from other vocabularies may be used as required, as long as they follow the format 
      specified in 11.1 – 11.2.3. 
    </svrl:text>
            <svrl:text>
      Take care that selected keywords do not duplicate information that is used to populate other 
      Elements in the Profile e.g. selection of sea area keywords, which should go into 
      Element 13: 'Extent'. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Keywords For Services (O)<xsl:text/>
            </svrl:text>
            <svrl:text>
      If a service is being described, the category or subcategory of the service shall be described 
      using its language neutral name. This is defined in Part D 4 of the Metadata Implementing Rules 
      which can be found at  
      http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2008:326:0012:0030:EN:PDF and the 
      keyword vocabulary available at http://inspire.ec.europa.eu/registry/.  
    </svrl:text>
            <svrl:text>
               <xsl:text/>Making Metadata Available to the MEDIN portal and data.gov.uk via OAI, CSW and WAF<xsl:text/>
            </svrl:text>
            <svrl:text>
      If XML files are being collected using the MEDIN harvesting process, an additional keyword 
      is required to allow the discovery web service to distinguish MEDIN records. The required term 
      to use in the XML fragment is NDGO0001 (from the N01 controlled vocabulary at 
      https://www.bodc.ac.uk/data/codes_and_formats/vocabulary_search/N01/). If you wish your discovery 
      metadata records to also be made available to the UK Geoportal 'data.gov.uk' via MEDIN then you 
      should include the additional term NDGO0005 i.e. Include both NDGO0001 and NDGO0005 in keywords 
      to indicate a record will be published to both portals.   
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 11.1 - Keyword value (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory element.  Multiple occurrences allowed from each vocabulary.  Controlled vocabulary.</svrl:text>
            <svrl:text>
      Keyword from a formally registered controlled vocabulary/thesaurus or a similar authoritative source of 
      keywords. Multiple keywords can be specified.    
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 11.2 - Originating controlled vocabulary (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory element.  Multiple controlled vocabularies allowed.  Controlled vocabulary.</svrl:text>
            <svrl:text>
      The controlled vocabulary that is the store for the keywords in the discovery metadata record. 
      Multiple controlled vocabularies can be specified, to allow keywords to define the data resource 
      in different subject areas.    
    </svrl:text>
            <svrl:text>
      Originating controlled vocabulary shall be defined through the following properties:     
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 11.2.1 - Thesaurus name (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory element.  Multiple occurrences allowed. Free text.</svrl:text>
            <svrl:text>
      Name of the formally registered thesaurus or a similar authoritative source of keywords.   
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 11.2.2 - Date type (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory element.  Multiple occurrences allowed. Controlled vocabulary.</svrl:text>
            <svrl:text>
      Select one of the following three values: Creation, Revision or Publication.    
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 11.2.3 - Date (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory element. Multiple occurrences allowed. Date format, yyyy-mm-dd.</svrl:text>
            <svrl:text>
      Date of creation, revision or publication as defined in 11.2.2 Date type.   
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1<xsl:text/>
            </svrl:text>
            <svrl:text>keywordValue: Fish taxonomy-related counts</svrl:text>
            <svrl:text>keywordValue: Temperature of the water column</svrl:text>
            <svrl:text>thesaurusName: SeaDataNet Parameter Discovery Vocabulary</svrl:text>
            <svrl:text>dateType: revision</svrl:text>
            <svrl:text>date: 2009-10-13</svrl:text>
            <svrl:text>
               <xsl:text/>Example 2<xsl:text/>
            </svrl:text>
            <svrl:text>keywordValue: upper_epipelagic</svrl:text>
            <svrl:text>thesaurusName: SeaDataNet vertical coverage</svrl:text>
            <svrl:text>dateType: Creation</svrl:text>
            <svrl:text>date: 2006-11-15</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-Keyword-Nillable</xsl:attribute>
            <xsl:attribute name="name">MEDIN-Keyword-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-Thesaurus-Title-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MEDIN-Thesaurus-Title-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-Thesaurus-Date-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MEDIN-Thesaurus-Date-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-Thesaurus-DateType-CodeList</xsl:attribute>
            <xsl:attribute name="name">MEDIN-Thesaurus-DateType-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 12 - Geographical Bounding Box (C)</xsl:attribute>
            <svrl:text>
      Mandatory element for datasets and series, conditional for services on their being a defined 
      extent for the service.  Multiple occurrences of each sub-element allowed.  Numeric and 
      controlled vocabulary. 
    </svrl:text>
            <svrl:text>
      The purpose of this element is to record the geographic extent that is covered by the metadata 
      resource. This extent range is recorded as one or more bounding boxes that have positional 
      information expressed as decimal degrees longitude and latitude. A minimum of two decimal 
      places shall be provided for each coordinate. 
    </svrl:text>
            <svrl:text>
      Multiple bounding boxes are acceptable and can be used to describe resources that have a 
      disparate geographic coverage; each bounding box must only have one occurrence of the east, 
      west, north and south sub-elements.
    </svrl:text>
            <svrl:text>
      Latitudes between 0 and 90N, and longitudes between 0 and 180E should be expressed as 
      positive numbers, and latitudes between 0 and 90S, and longitudes between 0 and 180W 
      should be expressed as negative numbers. In the event that a single point is being described 
      the east bounding longitude should equal the west bounding longitude, and the north bounding 
      latitude and south bounding latitude should be equal. 
    </svrl:text>
            <svrl:text>
      The latitude and longitude of the bounding box(es) is implicitly in WGS84.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 12.1 - West bounding longitude (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory element.  One occurrence allowed per bounding box.  Numeric decimal 
    (minimum 2 decimal places). </svrl:text>
            <svrl:text>
      The western-most limit of the data resource.     
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 12.2 - East bounding longitude (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory element.  One occurrence allowed per bounding box.  Numeric decimal 
    (minimum 2 decimal places). </svrl:text>
            <svrl:text>
      The eastern-most limit of the data resource.     
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 12.3 - North bounding longitude (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory element.  One occurrence allowed per bounding box.  Numeric decimal 
    (minimum 2 decimal places). </svrl:text>
            <svrl:text>
      The northern-most limit of the data resource.     
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 12.4 - South bounding longitude (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory element.  One occurrence allowed per bounding box.  Numeric decimal 
    (minimum 2 decimal places). </svrl:text>
            <svrl:text>
      The southern-most limit of the data resource.     
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinGeographicBoundingBoxPattern</xsl:attribute>
            <xsl:attribute name="name">MedinGeographicBoundingBoxPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 13 - Extent (O)</xsl:attribute>
            <svrl:text>
      Optional element.  Multiple occurrences allowed.  Numeric and controlled vocabulary. 
    </svrl:text>
            <svrl:text>
      This element defines the geographic extent of coverage of the data resource relative to a 
      defined authority. Keywords should be selected from controlled vocabularies to describe the 
      spatial extent of the resource. MEDIN strongly recommends the use of the SeaVoX salt and 
      freshwater body gazetteer available as vocabulary C19 at 
      https://www.bodc.ac.uk/data/codes_and_formats/vocabulary_search/C19/, which is a managed 
      vocabulary and has a worldwide distribution.
    </svrl:text>
            <svrl:text>
      Other vocabularies available, including ICES areas and rectangles http://vocab.ices.dk/, 
      or Charting Progress 2 regions, may be used as long as they follow the format specified 
      in 13.1 – 13.2.3 (Charting Progress 2 regions are available as vocabulary C64 at 
      https://www.bodc.ac.uk/data/codes_and_formats/vocabulary_search/C64/). 
    </svrl:text>
            <svrl:text>
      If populating Extent, the element shall be defined through the following properties: 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 13.1 - Extent name (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory element.  Multiple occurrences allowed.  Controlled vocabulary.</svrl:text>
            <svrl:text>
      Keyword describing the geographic extent of the resource from a formally registered 
      thesaurus or a similar authoritative source of extents.  Choose from a controlled 
      vocabulary held on the MEDIN website http://www.medin.org.uk/data-standards/controlledvocabularies. 
      MEDIN recommends that this element be populated with the text description of the controlled 
      vocabulary term, and that, when encoding the XML, the full URL of the code be stored as an 
      XML xlink anchor (see example below).    
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 13.2 - Originating controlled vocabulary (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory sub-element.  Multiple occurrences allowed. Free text.</svrl:text>
            <svrl:text>
      Name of the formally registered thesaurus or a similar authoritative source of extents. 
    </svrl:text>
            <svrl:text>
      The controlled vocabulary for extent shall be defined through the following properties:  
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 13.2.1 - Thesaurus name (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. Multiple occurrences allowed. Free text.</svrl:text>
            <svrl:text>
      Title of vocabulary or thesaurus. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 13.2.2 - Date type (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. Multiple occurrences allowed. Controlled vocabulary. </svrl:text>
            <svrl:text>
      Select one of the following three values: Creation, Revision or Publication.    
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 13.2.3 - Date (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. Single instance per date type allowed. Date format, yyyy-mm-dd</svrl:text>
            <svrl:text>
      Date of creation, revision or publication as defined in 13.2.2 Date type.    
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example<xsl:text/>
            </svrl:text>
            <svrl:text>This example includes multiple extents from different vocabularies.</svrl:text>
            <svrl:text>extentName: Scotland</svrl:text>
            <svrl:text>vocabularyName: ISO3166 Countries</svrl:text>
            <svrl:text>dateType: Creation</svrl:text>
            <svrl:text>date: 2005-04-29</svrl:text>
            <svrl:text>extentName: ICES Area IVb </svrl:text>
            <svrl:text>vocabularyName: ICES Regions</svrl:text>
            <svrl:text>dateType: Revision </svrl:text>
            <svrl:text>date:  2006-01-01</svrl:text>
            <svrl:text>extentName: Northern North Sea</svrl:text>
            <svrl:text>vocabularyName: Charting Progress 2 regions.</svrl:text>
            <svrl:text>dateType: Revision </svrl:text>
            <svrl:text>date: 2008-09-01 </svrl:text>
            <svrl:text>extentName: North Sea</svrl:text>
            <svrl:text>vocabularyName: IHO Sea Areas 1952</svrl:text>
            <svrl:text>dateType: Creation</svrl:text>
            <svrl:text>date: 1952-01-01</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinExtentCodeGcoTypeTestPattern</xsl:attribute>
            <xsl:attribute name="name">MedinExtentCodeGcoTypeTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M52"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinExtentAuthorityGcoTypeTestPattern</xsl:attribute>
            <xsl:attribute name="name">MedinExtentAuthorityGcoTypeTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M53"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 14 - Vertical Extent Information (C)</xsl:attribute>
            <svrl:text>
      Conditional element.  This element shall be filled in if the vertical coordinate reference 
      system is known. Multiple occurrences allowed.  Numeric free text and controlled vocabulary. 
    </svrl:text>
            <svrl:text>
      This element shall be filled in if the vertical Coordinate Reference System (CRS) is 
      registered in the 'European Petroleum Survey Group' (EPSG) database. http://www.epsgregistry.org/. 
    </svrl:text>
            <svrl:text>
      If you do not have the defined CRS you shall complete the vertical extent vocabulary 
      defined in Element 11 – Keywords, to describe the vertical extent of the resource. 
    </svrl:text>
            <svrl:text>
      One of the elements '11: vertical extent keyword' or '14: vertical extent information' 
      must be completed.  
    </svrl:text>
            <svrl:text>
      The vertical extent element has three sub-elements; the minimum vertical extent value, the 
      maximum vertical extent value, and the coordinate reference system.  Depth below sea water 
      surface should be a negative number.  Depth taken in the intertidal zone above the sea 
      level should be positive.  If the dataset covers from the intertidal to the subtidal zone 
      then the sub element 14.1 should be used to record the highest intertidal point and 14.2 
      the deepest subtidal depth.  Although the element itself is optional its sub-elements are 
      mandatory if the field is filled. 
    </svrl:text>
            <svrl:text>
      For services, this element should be used to record the maximum vertical boundaries of all 
      resources covered by the service. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 14.1 - Minimum Value (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. One occurrence only. Numeric. </svrl:text>
            <svrl:text>
      Record as positive or negative decimal number.  The shallowest depth recorded if subtidal, 
      or, if intertidal, the lowest point recorded.    
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 14.2 - Maximum Value (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. One occurrence only. Numeric. </svrl:text>
            <svrl:text>
      Record as positive or negative decimal number.  The deepest depth recorded if subtidal, 
      or if intertidal, the highest point recorded.    
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 14.3 - Vertical coordinate reference system (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. One occurrence only. Controlled vocabulary. </svrl:text>
            <svrl:text>
      This sub-element defines the vertical coordinate reference system of the minimum and 
      maximum vertical extent values. The vertical coordinate reference system should be 
      included by reference to the EPSG register of geodetic parameters 
      (http://www.epsgregistry.org/).    
    </svrl:text>
            <svrl:text>
      In brief, to find a code click on the EPSG Geodetic Parameter Registry and if you know the 
      title (e.g. WGS84) then type this in the 'Name' field and click search. The name, code and 
      further information is displayed. If you are looking for a specific type of reference 
      system such as 'vertical' then click in the 'Type' box, hover over coordinate reference 
      system and click on vertical and then click the search button and all recorded vertical 
      reference systems are shown. If you want to search for a reference system in a particular 
      part of the world (e.g. Northern Ireland Grid) then you may do so by submitting a term to 
      the 'Area' box or fill out the latitudes and longitudes then click search. The website also 
      provides a database of the reference systems and web services to access the information. 
      If the vertical coordinate reference system is not known or explicitly defined in the EPSG 
      register then this element should not be completed and Element 11 should be filled out 
      instead.    
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example<xsl:text/>
            </svrl:text>
            <svrl:text>minimumValue: 42</svrl:text>
            <svrl:text>maximumValue: 94</svrl:text>
            <svrl:text>verticalCoordinateReferenceSystem: urn:ogc:def:crs:EPSG::5701</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M54"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinVerticalExtentInformationTypeNotNillablePattern</xsl:attribute>
            <xsl:attribute name="name">MedinVerticalExtentInformationTypeNotNillablePattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinVerticalExtentVerticalCRSTypeNotNillablePattern</xsl:attribute>
            <xsl:attribute name="name">MedinVerticalExtentVerticalCRSTypeNotNillablePattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 15 - Spatial Reference System (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  Multiple occurrences allowed.  Controlled vocabulary.
    </svrl:text>
            <svrl:text>
      Describes the system of spatial referencing (typically a coordinate reference system (CRS)) 
      used in the resource.  This should be derived from the EPSG register of geodetic parameters 
      (http://www.epsg-registry.org/).
    </svrl:text>
            <svrl:text>
      To find a code click on the EPSG link above and if you know the title (e.g. WGS84) then 
      type this in the 'Name' field and click search. The name, code and further information are 
      displayed. If you are looking for a specific type of reference system such as 'vertical' then 
      click in the 'Type' box, hover over coordinate reference system and click on vertical and then 
      click the search button and all recorded vertical reference systems are shown. If you want to 
      search for a reference system in a particular part of the world (e.g. Northern Ireland Grid) 
      the you may do so by submitting a term to the 'Area' box or fill out the latitude and 
      longitudes then click search. The website also provides a database of the reference systems 
      and web services to access the information.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 15.1 - Code (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory element.  Multiple occurrrences allowed.  Free text.</svrl:text>
            <svrl:text>
      Provide a code that is a full and unambiguous definition of the CRS used in the resource. 
      If referencing CRS definitions from the EPSG register, the full Uniform Resource Name (URN) 
      of the CRS shall be supplied.    
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 15.2 - Originating controlled vocabulary (O)<xsl:text/>
            </svrl:text>
            <svrl:text>Optional sub-element.  Multiple occurrences allowed. Free text.</svrl:text>
            <svrl:text>
      Name of the formally registered thesaurus or a similar authoritative source of extents.     
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 15.2.1 - Thesaurus name (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. Multiple occurrences allowed. Free text.</svrl:text>
            <svrl:text>
      Title of vocabulary or thesaurus.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 15.2.2 - Date type (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. Multiple date types allowed. Controlled vocabulary.</svrl:text>
            <svrl:text>
      Select one of the following three values: Creation, Revision or Publication.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 15.2.3 - Date (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. Single instance per date type allowed. Date format, yyyy-mm-dd</svrl:text>
            <svrl:text>
      Date of creation, revision or publication as defined in 13.2.2 Date type.  
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/> (for WGS84)
    </svrl:text>
            <svrl:text>Code: urn:ogc:def:crs:EPSG::4326</svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/> (for National Grid of Great Britain)
    </svrl:text>
            <svrl:text>Code: urn:ogc:def:crs:EPSG::4277</svrl:text>
            <svrl:text>Thesaurus name: EPSG Geodetic Parameter Registry</svrl:text>
            <svrl:text>Date type: revision</svrl:text>
            <svrl:text>Date: 2016-09-29</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-SRS-Code-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MEDIN-SRS-Code-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-SpatialReferenceSystem-Authority-Title-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MEDIN-SpatialReferenceSystem-Authority-Title-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-SpatialReferenceSystem-Authority-Date-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MEDIN-SpatialReferenceSystem-Authority-Date-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-SpatialReferenceSystem-Authority-DateType-CodeList</xsl:attribute>
            <xsl:attribute name="name">MEDIN-SpatialReferenceSystem-Authority-DateType-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M61"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 16 - Temporal Reference (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  Multiplicity as stated below.  Controlled vocabulary and Date/Time 
      format, yyyy-mm-dd or yyyy-mm-ddThh:mm:ss
    </svrl:text>
            <svrl:text>
      The date of publication (i.e. the date at which the resource was made publicly available) is 
      mandatory for datasets, series of datasets and services, and shall be provided. The temporal 
      extent of the resource (e.g. the time period over which data were collected) and the date of 
      publication (i.e. the date at which it was made publicly available) is mandatory for datasets 
      and series of datasets and shall be provided. Temporal extent should be provided for services 
      where a temporal extent is relevant to the service. The date of last revision or date of 
      creation for the resource may also be provided. One occurrence for each sub-element is allowed 
      except for sub element 16.4 (Temporal extent) where multiple temporal extents are allowed to 
      describe datasets and series which are temporally irregular.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M62"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinTemporalReferenceGcoTypeTestPattern</xsl:attribute>
            <xsl:attribute name="name">MedinTemporalReferenceGcoTypeTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M63"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 16.1 - Date of Publication (M)</xsl:attribute>
            <svrl:text>Mandatory. One occurrence allowed.  Controlled vocabulary and Date/Time format, 
      yyyy-mm-dd or yyyy-mm-ddThh:mm:ss</svrl:text>
            <svrl:text>
      This describes the publication date of the resource and shall be populated. If the 
      resource is previously unpublished please use the date that the resource was made 
      publicly available via the MEDIN network.  It is recommended that a full date including 
      year, month and day is added, but it is accepted that for some historical resources only 
      vague dates (year only, year and month only) are available. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 16.1.1 - Date type (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. One occurrence allowed. Controlled vocabulary </svrl:text>
            <svrl:text>
      Select an option from 'creation', 'publication' or 'revision'. For Date of publication, 
      select 'publication' from list.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 16.1.2 - Date (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. One occurrence allowed. Date/Time format, yyyy-mm-dd or 
      yyyy-mmddThh:mm:ss</svrl:text>
            <svrl:text>
      Populate with date or date and time of date type in element 16.1.1: yyyy-mm-dd or 
      yyyymm-ddThh:mm:ss     
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M64"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinCitationDate-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MedinCitationDate-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M65"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 16.2 - Date of Last Revision (C)</xsl:attribute>
            <svrl:text>Conditional.  Complete if known.  One occurrence allowed.  Controlled vocabulary 
      and Date/Time format, yyyy-mm-dd or yyyy-mm-ddThh:mm:ss </svrl:text>
            <svrl:text>
      This describes the most recent date that the resource was revised.  It is recommended 
      that a full date including year, month and day is added. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 16.2.1 - Date type (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. One occurrence allowed. Controlled vocabulary </svrl:text>
            <svrl:text>
      Select an option from 'creation', 'publication' or 'revision'. For Date of publication, 
      select 'revision' from list.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 16.2.2 - Date (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. One occurrence allowed. Date/Time format, yyyy-mm-dd or 
      yyyy-mmddThh:mm:ss</svrl:text>
            <svrl:text>
      Populate with date or date and time of date type in element 16.2.1: yyyy-mm-dd or 
      yyyymm-ddThh:mm:ss     
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M66"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 16.3 - Date of Creation (C)</xsl:attribute>
            <svrl:text>Conditional.  Complete if known.  One occurrence allowed. Controlled vocabulary 
      and Date/Time format, yyyy-mm-dd or yyyy-mm-ddThh:mm:ss</svrl:text>
            <svrl:text>
      This describes the most recent date that the resource was created.  It is recommended 
      that a full date including year, month and day is added. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 16.3.1 - Date type (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. One occurrence allowed. Controlled vocabulary </svrl:text>
            <svrl:text>
      Select an option from 'creation', 'publication' or 'revision'. For Date of publication, 
      select 'creation' from list.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 16.3.2 - Date (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. One occurrence allowed. Date/Time format, yyyy-mm-dd or 
      yyyy-mmddThh:mm:ss</svrl:text>
            <svrl:text>
      Populate with date or date and time of date type in element 16.3.1: yyyy-mm-dd or 
      yyyymm-ddThh:mm:ss     
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M67"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 16.4 - Temporal Extent (C)</xsl:attribute>
            <svrl:text>Mandatory for datasets and series; conditional for services where temporal extent 
      is relevant to the service.  Multiple occurrence(s) allowed for each of begin and end.  
      Date or Date/Time format, yyyy-mm-dd or yyyy-mm-ddThh:mm:ss</svrl:text>
            <svrl:text>
      This describes the start and end date(s) of the resource (e.g. dataset). The start date(s) 
      is mandatory and the end date (s) should be provided if known (conditional). It is 
      recommended that a full date including year, month and day is added, but it is accepted 
      that for some historical resources only vague dates (year only, year and month only) are 
      available. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 16.4.1 - Begin (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. Multiple occurrence(s) allowed. Date format, yyyy-mm-dd or 
      yyyy-mmddThh:mm:ss</svrl:text>
            <svrl:text>
      Start of temporal extent.    
    </svrl:text>
            <svrl:text>
      date or date and time: yyyy-mm-dd or yyyy-mm-ddThh:mm:ss   
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 16.4.2 - End (c)<xsl:text/>
            </svrl:text>
            <svrl:text>Conditional. Multiple occurrence(s) allowed. Date format, yyyy-mm-dd or 
      yyyy-mmddThh:mm:ss</svrl:text>
            <svrl:text>
      End of temporal extent. If the resource that you are describing is ongoing then use the 
      encoding as described in the relevant example below. End may be left blank to indicate 
      uncertainty. 
    </svrl:text>
            <svrl:text>
      date or date and time: yyyy-mm-dd or yyyy-mm-ddThh:mm:ss   
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M68"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-TemporalExtent-BeginPosition-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MEDIN-TemporalExtent-BeginPosition-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M69"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 17 - Lineage (C)</xsl:attribute>
            <svrl:text>
      Mandatory element for datasets or series of datasets.  This Element is not required if a 
      service is being described.  One occurrence allowed.  Free text. 
    </svrl:text>
            <svrl:text>
      The purpose of this element is to record information about the events or source data used 
      in the construction of the data resource. 
    </svrl:text>
            <svrl:text>
      Lineage includes the background information, history of the sources of data used and can 
      include data quality statements.  The lineage element should include information about: 
      source material; data collection methods used; data processing methods used; quality control 
      processes.  Please indicate any data collection standards used.  Apart from describing the 
      process history, the overall quality of the dataset or series should be included in the 
      Lineage metadata element. This statement should contain any quality information required 
      for interoperability and/or valuable for use and evaluation of the dataset or series. 
      Acronyms should be expanded to their full text the first time they are mentioned in the 
      Lineage element. The abbreviated version of the term can be used from then onwards. 
    </svrl:text>
            <svrl:text>
      Although not required for describing a service, MEDIN recommend that this element is 
      populated with information about the creation of the service and the data used to generate 
      the service. 
    </svrl:text>
            <svrl:text>
      Element 19. Additional information should be used to record relevant references to the 
      data e.g. reports, articles, website.  
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/> This dataset was collected by the Fisheries Research Services and
      provided to the British Oceanographic Data Centre for long term archive and management.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/> (no protocols or standards used)- Forty 0.1m2 Hamon grab samples 
      were collected from across the region, both within and beyond the extraction area, and analyzed 
      for macrofauna and sediment particle size distribution in order to produce a regional description 
      of the status of the seabed environment.  Samples were sieved over a 1mm mesh sieve.  In addition, 
      the data were analyzed in relation to the area of seabed impacted by dredging over the period 
      1993-1998.  Areas subject to 'direct' impacts were determined through reference to annual 
      electronic records of dredging activity and this information was then used to model the likely 
      extent of areas potentially subject to 'indirect' ecological and geophysical impact. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 3:<xsl:text/> (collected using protocols and standards) - Data was collected 
      using the National Marine Monitoring Programme (NMMP) data collection, processing and Quality 
      Assurance Standard Operating Procedures (SOPs) and complies with MEDIN data guidelines. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 4:<xsl:text/> Survey data from Marine Nature Conservation Review (MNCR) 
      lagoon surveys were used to create a GIS layer of the extent of saline lagoons in the UK that 
      was ground-truthed using 2006-2008 aerial coastal photography obtained from the Environment 
      Agency and site visits to selected locations.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 5:<xsl:text/> The Nutrients General Quality Assessment (GQA) described quality 
    in terms of two nutrients: nitrates (mg NO3 /l) and phosphates (mg P/l) and graded from 1 to 6. 
    Grades were allocated for both phosphate and nitrate; they were not combined into a single 
    nutrients grade. There were no set 'good' or 'bad' concentrations for nutrients in the way that 
    we describe chemical and biological quality. Locations in different parts of the country have 
    naturally different concentrations of nutrients. 'Very low' nutrient concentrations, for example, 
    are not necessarily good or bad; the classifications merely stated that concentrations in this 
    location were very low relative to other sampling areas. Classification for phosphate Grade 
    limit (mgP/l) Average Description: 0.02 to 0.06 Low &gt;0.06 to 0.1 Moderate &gt;0.1 to 0.2 High &gt;0.2 
    to 1.0 Very high &gt;1.0 Excessively high Classification for nitrate Grade limit (mg NO3/l) Average 
    Description: 5 to 10 Low &gt;10 to 20 Moderately low &gt;20 to30 Moderate &gt;30 to 40 High &gt;40 Very high. 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M70"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinLineageGcoTypeTestPattern</xsl:attribute>
            <xsl:attribute name="name">MedinLineageGcoTypeTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M71"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 18 - Spatial Resolution (C)</xsl:attribute>
            <svrl:text>
      Conditional for datasets and series where a resolution distance or scale can be specified,
      not applicable to services. Multiple occurrences allowed. Numeric (positive whole number). 
    </svrl:text>
            <svrl:text>
      Provides an indication of the spatial resolution of the data resource or the spatial 
      limitations of the service. This element should only be populated if the distance or 
      equivalent scale can be specified. 
    </svrl:text>
            <svrl:text>
      For services, spatial resolution cannot be encoded in the ISO 191939 XML Schema that this 
      MEDIN Standard adheres to. Therefore, spatial resolution of services shall be recorded in 
      the Abstract where necessary. Spatial resolution for services shall refer to the spatial 
      resolution of the datasets/series that the service operates on. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 18.1 - Distance (C)<xsl:text/>
            </svrl:text>
            <svrl:text>Conditional for datasets and series where a resolution distance can be specified. 
    Multiple occurrences allowed. Numeric (positive whole number). </svrl:text>
            <svrl:text>
      MEDIN requires that you shall provide the average distance (i.e. resolution) between 
      sampling locations in metres, where this is possible. For example, if a dataset was 
      composed of a grid of stations that have an average distance between stations of 2 km 
      then 2000 metres should be recorded. 
    </svrl:text>
            <svrl:text>
      In the case of a multi-beam survey, the distance in metres should be the average distance 
      between each sounding or 'ping' on the sea bed. For transect data such as an intertidal 
      beach survey or a single beam echo sounder survey the resolution should be taken as the 
      distance in metres between the transect lines.  
    </svrl:text>
            <svrl:text>
      For single samples and observational data MEDIN recommends using 'not applicable' which 
      may be encoded as shown in the last example below.  
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 18.2 - Equivalent scale (O)<xsl:text/>
            </svrl:text>
            <svrl:text>Optional.  Multiple occurrences allowed. Numeric (positive whole number).</svrl:text>
            <svrl:text>
      Where the data being described in the resource is captured from a map, the scale of that 
      map should be recorded. Spatial resolution should only be expressed by equivalent scale 
      where a distance cannot be determined. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1 (distance):<xsl:text/>
            </svrl:text>
            <svrl:text>distance:10</svrl:text>
            <svrl:text>units: metres</svrl:text>
            <svrl:text>
               <xsl:text/>Example 2 (equivalent scale):<xsl:text/>
            </svrl:text>
            <svrl:text>5000</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M72"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinEquivalentScaleGcoTypeTestPattern</xsl:attribute>
            <xsl:attribute name="name">MedinEquivalentScaleGcoTypeTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M73"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 19 - Additional Information (O)</xsl:attribute>
            <svrl:text>
      Optional element for datasets or series of datasets.  This Element is not required if a 
      service is being described  Single occurrence allowed.  Free text. 
    </svrl:text>
            <svrl:text>
      The purpose of this element is to record relevant information that does not clearly 
      belong in another element. This may be a reference to a web location that provides valuable 
      information, through a URL, a document reference or a Digital Object Identifier (DOI) that 
      points to a deferencing service or landing page for an information source. 
    </svrl:text>
            <svrl:text>
      Information about access to the resource should not be in this element, but should be 
      provided in Element 5 'Resource Locator' 
    </svrl:text>
            <svrl:text>
      Information about licencing or fees should be provided in Element 20 'Limitations on 
      public access'. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/>
            </svrl:text>
            <svrl:text>
      Malthus, T.J., Harries, D.B., Karpouzli, E., Moore, C.G., Lyndon, A.R., Mair, J.M.,
      Foster-Smith, B.,Sotheran, I. and Foster-Smith, D. (2006). Biotope mapping of the
      Sound of Harris, Scotland. Scottish Natural Heritage Commissioned Report No. 212
      (ROAME No. F01AC401/2).
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/>
            </svrl:text>
            <svrl:text>
      http://www.cefas.co.uk/publications/files/datarep42.pdf
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 3:<xsl:text/>
            </svrl:text>
            <svrl:text>
      doi:10.1111/jbi.12708
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M74"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinAdditionalInformationSourceGcoTypeTestPattern</xsl:attribute>
            <xsl:attribute name="name">MedinAdditionalInformationSourceGcoTypeTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M75"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 20 - Limitations on Public Access (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  Multiple occurrences allowed.  Controlled vocabulary and free text.
    </svrl:text>
            <svrl:text>
      This element describes any restrictions imposed on accessing the resource for security and 
      other reasons. Please provide information on any limitations to access of resource and the 
      reasons for them. If different parts of the resource have different access constraints, 
      generate occurrences for each.   
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 20.1 - Access Constraints (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. Multiple occurrences allowed. Controlled vocabulary.</svrl:text>
            <svrl:text>
      This shall be recorded as 'otherRestrictions' from ISO vocabulary RestrictionCode 
      (see Annex G). This is an INSPIRE/GEMINI requirement. ISO allow full use of RestrictionCode. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 20.2 - Other  Constraints (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. Multiple occurrences allowed. Free text.</svrl:text>
            <svrl:text>
      Record any limitations on access to the resource. If there are no limitations on public 
      access, this shall be indicated by ‘no limitations’.  The free text shall be encoded in a 
      gmx:Anchor element, with xlink:href pointing to the relevant kind of limitation from the 
      INSPIRE Metadata registry: http://inspire.ec.europa.eu/metadatacodelist/LimitationsOnPublicAccess. 
      If a part of the resource has a specific limitation, make this clear in the text. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/>
            </svrl:text>
            <svrl:text>accessConstraints: otherRestrictions</svrl:text>
            <svrl:text>otherConstraints: No restrictions to public access</svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/>
            </svrl:text>
            <svrl:text>accessConstraints: otherRestrictions</svrl:text>
            <svrl:text>otherConstraints: Restricted public access due to sensitive species, only available at 
      10km resolution. </svrl:text>
            <svrl:text>
               <xsl:text/>Example 3:<xsl:text/>
            </svrl:text>
            <svrl:text>accessConstraints: otherRestrictions</svrl:text>
            <svrl:text>otherConstraints: no limitations </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M76"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-OtherConstraints-Nillable</xsl:attribute>
            <xsl:attribute name="name">MEDIN-OtherConstraints-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M77"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-AccessConstraints-CodeList</xsl:attribute>
            <xsl:attribute name="name">MEDIN-AccessConstraints-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M78"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 21 - Conditions Applying for Access and Use (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  One occurrence allowed.  Controlled vocabulary and free text.
    </svrl:text>
            <svrl:text>
      This element provides information on any constraints on using the resource.  Any known constraints 
      such as licensing, fees, usage restrictions should be identified. If different parts of the resource 
      have different use constraints, generate occurrences for each.  
    </svrl:text>
            <svrl:text>
      Conditions for access and use are different from Limitations on public access which describe 
      limitations on access to the data. A data resource can have open access (e.g. to look at it), but 
      restricted use. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 21.1 - Use Constraints (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. One occurrence allowed.  Controlled vocabulary.</svrl:text>
            <svrl:text>
      This shall be recorded as ‘otherRestrictions’ from ISO vocabulary RestrictionCode (see Annex G). 
      This is an INSPIRE/GEMINI requirement. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 21.2 - Other Constraints (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. Multiple occurrences allowed. Free text.</svrl:text>
            <svrl:text>
      Record any constraints on use of the data described in the resource here. Multiple conditions 
      can be recorded for different parts of the data resource.  If no conditions apply, then 
      'no conditions apply' should be recorded. 
    </svrl:text>
            <svrl:text>
      If there is a formal licence title, that should be supplied along with, if available, a 
      licence URL. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/> Data is freely available for research or commercial use 
      providing that the originators are acknowledged in any publications produced. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/> Data is freely available for use in teaching and 
      conservation but permission must be sought for use if the data will be reproduced in full 
      or part or if used in any analyses. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 3:<xsl:text/> Not suitable for use in navigation.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M79"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-UseConstraints-CodeList</xsl:attribute>
            <xsl:attribute name="name">MEDIN-UseConstraints-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M80"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 22 - Responsible Party (M)</xsl:attribute>
            <svrl:text>
      Mandatory element. This shall include a minimum of organisation name and email address. 
      Multiple occurrences are allowed for some responsible party roles. Free text and controlled 
      vocabulary.
    </svrl:text>
            <svrl:text>
      Provides a description of an organisation or person who has a role for the resource. MEDIN 
      mandates that the roles of 'Originator', 'Custodian' (data holder), 'Distributor',  'Metadata 
      point of contact' and 'Owner' shall be entered. Other types of responsible party may be 
      specified from the controlled vocabulary (see Annex H, INSPIRE registry12 or ISO Codelist 
      CI_RoleCode13 for code list) if desired. 
    </svrl:text>
            <svrl:text>
      If the data has been lodged with a MEDIN approved Data Archive Centre (DAC) then the DAC 
      shall be specified as the Custodian. 
    </svrl:text>
            <svrl:text>
      The sub sub-elements for describing each responsible party entry are as follows:
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 22.0.1 - Job Position (O)<xsl:text/>
            </svrl:text>
            <svrl:text>One occurrence only per role in 22.0.8. Free text.</svrl:text>
            <svrl:text>
      The position of the person within the organisation who holds or held the Responsible Party 
      role being described. Do not identify an individual by name, as this is subject to change 
      without warning and the information is impossible to keep up-to-date. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 22.0.2 - Organisation name (M)<xsl:text/>
            </svrl:text>
            <svrl:text>One occurrence only per role in 22.0.8. Controlled vocabulary or free text.</svrl:text>
            <svrl:text>
      Where an organisation is given, this shall be taken from the European Directory of Marine 
      Organisations (http://seadatanet.maris2.nl/edmo/). In the event that an organisation name 
      is not in that directory then please contact enquiries@medin.org.uk who will add it.     
    </svrl:text>
            <svrl:text>
      Where possible an organisation should be cited and only when this is impossible should 
      Individual Name be used instead.     
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 22.0.3 - Postal address (O)<xsl:text/>
            </svrl:text>
            <svrl:text>One occurrence allowed per role in 22.0.8. Free text.</svrl:text>
            <svrl:text>
      The full formal postal address (as defined for example by Royal Mail) should be given, 
      including the postcode.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 22.0.4 - Telephone number (O)<xsl:text/>
            </svrl:text>
            <svrl:text>One occurrence allowed per role in 22.0.8. Numeric</svrl:text>
            <svrl:text>
      Where possible a generic rather than individual telephone number should be used e.g. the 
      organisational switchboard or a helpdesk number.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 22.0.5 - Email address (M)<xsl:text/>
            </svrl:text>
            <svrl:text>One occurrence allowed per role in 22.0.8. Free text.</svrl:text>
            <svrl:text>
      Where possible a generic rather than an individual email should be used e.g. the 
      organisation's enquiries email address.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 22.0.6 - Web address (O)<xsl:text/>
            </svrl:text>
            <svrl:text>One occurrence allowed per role in 22.0.8. Free text.</svrl:text>
            <svrl:text>
      Where possible a valid World Wide Web address for the organisation should be given.     
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 22.0.8 - Responsible party role (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Multiple occurrences allowed. Controlled vocabulary, ISO responsible party code 
      list CI_RoleCode.</svrl:text>
            <svrl:text>
      Populate for 'metadata point of contact', 'distributor', 'originator', 'custodian' and 
      'owner'. Other roles can be populated if desired using the codelist in Annex H.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example Distributor:<xsl:text/>
            </svrl:text>
            <svrl:text>JobPosition: DASSH Data officer</svrl:text>
            <svrl:text>OrganisationName: DASSH</svrl:text>
            <svrl:text>PostalAddress: The Laboratory, Citadel Hill, Plymouth PL4 8SR</svrl:text>
            <svrl:text>TelephoneNumber: 01752 633291</svrl:text>
            <svrl:text>EmailAddress: dassh.enquiries@mba.ac.uk</svrl:text>
            <svrl:text>WebAddress: http://www.dassh.ac.uk</svrl:text>
            <svrl:text>ResponsiblePartyRole: distributor</svrl:text>
            <svrl:text>
               <xsl:text/>Example Point Of Contact:<xsl:text/>
            </svrl:text>
            <svrl:text>JobPosition: Marine officer</svrl:text>
            <svrl:text>OrganisationName: Joint Nature Conservation Committee (JNCC)</svrl:text>
            <svrl:text>PostalAddress: City Road, Peterborough, PE1 1JY</svrl:text>
            <svrl:text>TelephoneNumber: 01733 562626</svrl:text>
            <svrl:text>FacsimileNumber: 01733 555948</svrl:text>
            <svrl:text>EmailAddress: marine.teamexample@jncc.gov.uk</svrl:text>
            <svrl:text>WebAddress: http://jncc.defra.gov.uk </svrl:text>
            <svrl:text>ResponsiblePartyRole: pointOfContact</svrl:text>
            <svrl:text>
               <xsl:text/>Example Originator:<xsl:text/>
            </svrl:text>
            <svrl:text>OrganisationName: SeaZone Solutions </svrl:text>
            <svrl:text>EmailAddress: info@seazone.com</svrl:text>
            <svrl:text>ResponsiblePartyRole:  Originator</svrl:text>
            <svrl:text>
               <xsl:text/>Example Metadata point of contact:<xsl:text/>
            </svrl:text>
            <svrl:text>JobPosition: BODC Enquiries Officer</svrl:text>
            <svrl:text>EmailAddress: enquiries@bodc.ac.uk</svrl:text>
            <svrl:text>TelephoneNumber: 01517954912</svrl:text>
            <svrl:text>ResponsiblePartyRole: pointOfContact</svrl:text>
            <svrl:text>
               <xsl:text/>Example Owner:<xsl:text/>
            </svrl:text>
            <svrl:text>JobPosition: Operations Director</svrl:text>
            <svrl:text>OrganisationName: Oceanwise Ltd</svrl:text>
            <svrl:text>TelephoneNumber: 01420768262</svrl:text>
            <svrl:text>EmailAddress: info@oceanwise.eu</svrl:text>
            <svrl:text>ResponsiblePartyRole: owner</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M81"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-Contacts-EmailAddress-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MEDIN-Contacts-EmailAddress-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M82"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-Contacts-OrganisationName-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MEDIN-Contacts-OrganisationName-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M83"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 22.1 - Originator (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  This shall include a minimum of person/organisation name and email 
      address. Multiple occurrences allowed. 
    </svrl:text>
            <svrl:text>
      Person(s) or organisation(s) who created the resource. This sub element should give details 
      for the person or organisation who collected or produced the data. For example, if MEConsulting 
      have been contracted to do an EIA of a wind farm site by 'Greeny Energy Ltd' then MEConsulting 
      are the Originator. It should not be used to record who 'owns' the data as that information is 
      recorded under Sub element 22.5. 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M84"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 22.2 - Custodian (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  This shall include a minimum of person/organisation name and email 
      address. Multiple occurrences allowed. 
    </svrl:text>
            <svrl:text>
      Person(s) or organisation(s) that accept responsibility for the resource and ensures 
      appropriate care and maintenance. If a dataset has been lodged with a Data Archive Centre 
      for maintenance then this organisation should be entered. If the organisation who owns the 
      data or service continues to accept responsibility for it then they should also be stated 
      here.
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M85"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 22.3 - Distributor (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  This shall include a minimum of person/organisation name and email 
      address. Multiple occurrences. 
    </svrl:text>
            <svrl:text>
      Person(s) or organisation(s) that distributes the resource. 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M86"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 22.4 - Metadata Point of Contact (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  This shall include a minimum of person/organisation name and email 
      address. One occurrence allowed. 
    </svrl:text>
            <svrl:text>
      Person or organisation with responsibility for the creation and maintenance of the metadata 
      for the resource. 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M87"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-MetadataPointofContact-EmailAddress-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MEDIN-MetadataPointofContact-EmailAddress-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M88"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MEDIN-MetadataPointofContact-OrganisationName-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MEDIN-MetadataPointofContact-OrganisationName-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M89"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 22.5 - Owner (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  This shall include a minimum of person/organisation name and email 
      address. Multiple occurrences allowed.
    </svrl:text>
            <svrl:text>
      Person or organisation that owns the resource. 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M90"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 23 - Data Format (C)</xsl:attribute>
            <svrl:text>
      Mandatory for datasets and series, not applicable to services.  Multiple occurrences are 
      allowed.  Controlled vocabulary.
    </svrl:text>
            <svrl:text>
      Indicate the formats in which digital data can be provided for transfer. MEDIN have defined 
      a controlled vocabulary which is M01 'MEDIN data format categories' and is available at 
      https://www.bodc.ac.uk/resources/vocabularies/vocabulary_search/M01/ or which can be seen 
      in Annex K. One or more terms from this controlled vocabulary shall be used for the sub 
      element 'name of format'. Sub element 'version' shall be populated with information about the 
      version of the resource format(s) if known, and 'unknown' if no information is available.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 23.1 - Name of format (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory element.  Single occurrence for each format type.  Controlled vocabulary.</svrl:text>
            <svrl:text>
      Give title of term from controlled vocabulary M01. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 23.2 - Version (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory element.  Single occurrence for each format type. Free Text.</svrl:text>
            <svrl:text>
      Populate with version information about the format of the resource. If no version 
      information is available, populate with 'Unknown'  
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/>
            </svrl:text>
            <svrl:text>name: Database</svrl:text>
            <svrl:text>version: Unknown</svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/>
            </svrl:text>
            <svrl:text>name: Network Common Data Form</svrl:text>
            <svrl:text>version: CF 1.6</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M91"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinDataFormatName-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MedinDataFormatName-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M92"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 33 - Character Encoding (C)</xsl:attribute>
            <svrl:text>
      Conditional for datasets and series of datasets, not applicable to services.  Multiple 
      occurrences are allowed.  Controlled vocabulary. 
    </svrl:text>
            <svrl:text>
      This describes the character encoding used in the dataset. It shall be populated if an 
      encoding is used that is not based on UTF-8, otherwise it is optional. 
    </svrl:text>
            <svrl:text>
      Select all applicable character encodings from ISO character set codelist (MD_CharacterSetCode).  
      The full code list is presented in Annex N, or can be found in library G09 on the NVS2 
      Vocabulary Server  https://www.bodc.ac.uk/data/codes_and_formats/vocabulary_search/G09/ 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/>
            </svrl:text>
            <svrl:text>8859part1</svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/>
            </svrl:text>
            <svrl:text>utf8</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M93"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Medin-Character-Encoding-CodeListValue-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Medin-Character-Encoding-CodeListValue-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M94"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 24 - Frequency of Update (C)</xsl:attribute>
            <svrl:text>
      Mandatory for datasets and series of datasets, Conditional for services where frequency 
      of update is relevant to the service.  One occurrence allowed.  Controlled vocabulary.
    </svrl:text>
            <svrl:text>
      This describes the frequency that the resource (dataset) is modified or updated and shall be 
      included if known.  For example if the dataset is from a monitoring programme which samples 
      once per year then the frequency is annually. Select one option from ISO frequency of update 
      codelist (MD_MaintenanceFrequencyCode codelist).  The full code list is presented in Annex I, 
      or can be found in library G17 on the NVS2 Vocabulary Server 
      https://www.bodc.ac.uk/data/codes_and_formats/vocabulary_search/G17/ 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/> monthly
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/> annually
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M95"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinFrequencyOfUpdateInnerTextPattern</xsl:attribute>
            <xsl:attribute name="name">MedinFrequencyOfUpdateInnerTextPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M96"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 25 - Conformity (M)</xsl:attribute>
            <svrl:text>
      Mandatory element. Multiple occurrences allowed. Free text, controlled vocabulary and date.
    </svrl:text>
            <svrl:text>
      This element specifies if the dataset or service being described is conformant with other 
      specifications such as the INSPIRE data specifications or MEDIN data guidelines. There are 
      3 sub-elements which give the title of the specification, the degree of conformity (if it 
      is or not conformant) and an explanation which gives further details of how conformant it 
      is or any other useful information for the user. Conformity can be assessed with respect to 
      more than one specification.
    </svrl:text>
            <svrl:text>
      Dataset, series and metadata for services shall always include one Conformity occurrence that 
      references an INSPIRE specification. This reference shall be present, even if it is to indicate 
      that the data resource is non-conformant to the quoted INSPIRE specification. 
    </svrl:text>
            <svrl:text>
      Other occurrences, referencing either INSPIRE or other specifications, can be populated as part 
      of the same metadata record. 
    </svrl:text>
            <svrl:text>
      The list of MEDIN data guidelines can be found in library C48 on the NVS2 Vocabulary Server 
      at https://www.bodc.ac.uk/data/codes_and_formats/vocabulary_search/C48/ 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M97"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 25.1 - INSPIRE Specification (M)</xsl:attribute>
            <svrl:text>
      Mandatory element. Single occurrence per specification. Free text, controlled vocabulary 
      and date.  
    </svrl:text>
            <svrl:text>
      Give the citation of the specification or user requirement against which data resource is 
      evaluated.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 25.1.1 - Title (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. One occurrence only. Free text.</svrl:text>
            <svrl:text>
      Title of specification that the data resource is being evaluated against.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 25.1.2 - Date type (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. One occurrence only. Controlled vocabulary.</svrl:text>
            <svrl:text>
      Type of date of the specification. Choose from 'publication', 'revision' or 'creation' to 
      reflect date of specification, revision date etc. MEDIN recommend use of 'publication' date 
      rather than revision or creation.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Element 25.1.3 - Date (M)<xsl:text/>
            </svrl:text>
            <svrl:text>Mandatory. One occurrence only. Date format, yyyy-mm-dd</svrl:text>
            <svrl:text>
      Date format for date type specified in element 25.1.2. yyyy-mm-dd
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M98"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Medin-Conformance-Explanation-NotNillable</xsl:attribute>
            <xsl:attribute name="name">Medin-Conformance-Explanation-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M99"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinSpecificationTitleGcoTypeTest</xsl:attribute>
            <xsl:attribute name="name">MedinSpecificationTitleGcoTypeTest</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M100"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinSpecificationDateGcoTypeTest</xsl:attribute>
            <xsl:attribute name="name">MedinSpecificationDateGcoTypeTest</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M101"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinSpecificationDateTypeInnerTextTest</xsl:attribute>
            <xsl:attribute name="name">MedinSpecificationDateTypeInnerTextTest</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M102"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M103"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M104"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <svrl:text>This test allows for the title to start with `COMMISSION REGULATION` but ss. it should be
      'Commission Regulation'</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M105"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M106"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M107"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M108"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 25.2 - Degree of Conformity (M)</xsl:attribute>
            <svrl:text>
      Mandatory element. Single occurrence per specification.  Controlled vocabulary
    </svrl:text>
            <svrl:text>
      This element indentifies the conformity of the data resource to a specification cited in 
      25.1.1.  The values shall be one of either: 
    </svrl:text>
            <svrl:text>
      True – select this to indicate that the resource conforms to the specification in 25.1.1  
    </svrl:text>
            <svrl:text>
      False – select this to indicate that the resource is not conformant to the specification in 
      25.1.1 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M109"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 25.3 - Explanation (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  Single occurrence per specification. Free Text. 
    </svrl:text>
            <svrl:text>
      This provides meaning of the conformance statement in 25.2 for this degree of conformance 
      result. It should include a statement about which (if any) aspects of the specification the 
      data resource conforms and any exceptions. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/>
            </svrl:text>
            <svrl:text>D2.8.I.5 INSPIRE Data Specification on Addresses – Guidelines, publication, 2010-04-26</svrl:text>
            <svrl:text>True</svrl:text>
            <svrl:text>Only mandatory items included </svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/>
            </svrl:text>
            <svrl:text>MEDIN Data Guideline for sediment sampling by grab or core for benthos, publication, 
      2009-07-29</svrl:text>
            <svrl:text>True</svrl:text>
            <svrl:text>All mandatory and conditional items were completed</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M110"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 26 - Date of Update of Metadata (M)</xsl:attribute>
            <svrl:text>Mandatory element.  One occurence allowed.  Date format.</svrl:text>
            <svrl:text>
      This describes the last date the metadata was updated on. If the metadata has not been 
      updated it shall give the date on which it was created. This shall be provided as a date 
      or date and time in the format:
    </svrl:text>
            <svrl:text>
      yyyy-mm-dd or yyyy-mm-ddThh:mm:ss 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1:<xsl:text/>
            </svrl:text>
            <svrl:text>2008-05-12</svrl:text>
            <svrl:text>
               <xsl:text/>Example 2:<xsl:text/>
            </svrl:text>
            <svrl:text>2008-05-12T09:09:09</svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M111"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinDateOfUpdateOfMetadata-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MedinDateOfUpdateOfMetadata-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M112"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinFileIdentifier-NotNillable</xsl:attribute>
            <xsl:attribute name="name">MedinFileIdentifier-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M113"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 27 - Metadata Standard Name (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  One occurence allowed. Free text.
    </svrl:text>
            <svrl:text>
      This element is to identify the metadata standard used to create the metadata. Select one option from NERC 
      Vocabulary Server code list M25 at https://www.bodc.ac.uk/data/codes_and_formats/vocabulary_search/M25/.
      For MEDIN discovery metadata profiles, it shall be populated with the text 'MEDIN'.
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example:<xsl:text/>
            </svrl:text>
            <svrl:text>
      MEDIN 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M114"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinMetadataStandardNameInnerText</xsl:attribute>
            <xsl:attribute name="name">MedinMetadataStandardNameInnerText</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M115"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 28 - Metadata Standard Version (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  One occurence allowed. Free text.
    </svrl:text>
            <svrl:text>
      This element shall be populated with the version of the MEDIN Discovery Metadata Standard 
      used to create the metadata record for the resource. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example:<xsl:text/>
            </svrl:text>
            <svrl:text>
      Version 3.0
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M116"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinMetadataStandardVersionInnerText</xsl:attribute>
            <xsl:attribute name="name">MedinMetadataStandardVersionInnerText</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M117"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 29 - Metadata Language (M)</xsl:attribute>
            <svrl:text>
      Mandatory element.  One occurrence allowed.  Controlled vocabulary. 
    </svrl:text>
            <svrl:text>
      Describes the language used in documenting the metadata. 
    </svrl:text>
            <svrl:text>
      This element should be used to indicate the main language used in populating the metadata 
      for the resource. If a second language is used in some elements e.g. Alternative title, the 
      main language should still be used to populate this element. 
    </svrl:text>
            <svrl:text>
      Select the relevant 3-letter code(s) from the ISO 639-2 code list of languages.  Additional 
      languages may be added to this list if required.  A full list of UK language codes is listed 
      in Annex D and a list of recognized languages is available online at 
      http://www.loc.gov/standards/iso639-2/php/code_list.php.  
    </svrl:text>
            <svrl:text>
      For Welsh, ISO 639-2 allows either of 'cym' or 'wel', but MEDIN recommend that 'cym' is used 
      as this is the abbreviation of the language's own name for itself. This follows guidance from 
      GEMINI.  
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 1: (English)<xsl:text/> eng
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example 2: (Welsh)<xsl:text/> cym
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M118"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinMetadataLanguageLanguagePattern</xsl:attribute>
            <xsl:attribute name="name">MedinMetadataLanguageLanguagePattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M119"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MedinMetadataLanguageGcoTypeTestPattern</xsl:attribute>
            <xsl:attribute name="name">MedinMetadataLanguageGcoTypeTestPattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M120"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Element 30 - Parent ID (O)</xsl:attribute>
            <svrl:text>
      Optional element. One occurence allowed. Free text. 
    </svrl:text>
            <svrl:text>
      This field holds the file identifier code of the series metadata record for which the dataset 
      which is being described is part of. Therefore, this element allows links to be made between 
      a dataset and a series (see http://www.medin.org.uk/data/faqs for MEDINs definition of these 
      terms). This will then allow the MEDIN portal to be able to find related metadata records. 
      For example, a large multidisciplinary project may be described as a ‘series’ and each of the 
      themes of work will be described as 'datasets'. Using this field allows the user when viewing 
      the series metadata to ask for the metadata records of all the datasets of each theme. 
      Alternatively, a user may ask for all related records when viewing a dataset. 
    </svrl:text>
            <svrl:text>
      For services, this element should only be populated if the service that the metadata record 
      is populated for consists of part of a larger set of services. 
    </svrl:text>
            <svrl:text>
               <xsl:text/>Example:<xsl:text/>
            </svrl:text>
            <svrl:text>
      79557726-b60a-4cf3-a8fd-9799c603d4dc 
    </svrl:text>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M121"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">MEDIN Discovery Metadata Profile</svrl:text>
   <xsl:param name="inspire1089"
              select="'Commission Regulation (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services'"/>
   <xsl:param name="inspire1089x"
              select="'COMMISSION REGULATION (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services'"/>
   <xsl:param name="inspire976"
              select="'Commission Regulation (EC) No 976/2009 of 19 October 2009 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards the Network Services'"/>
   <xsl:param name="defaultCRScodes"
              select="document('https://agi.org.uk/images/xslt/d4.xml')"/>

   <!--PATTERN
        Element 1 - Resource Title (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 1 - Resource Title (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo" priority="1000" mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:identificationInfo"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:citation/*/gmd:title) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:citation/*/gmd:title) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Resource Title is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>

   <!--PATTERN
        MedinResourceTitleGcoTypeTest-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:title" priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:title"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

   <!--PATTERN
        Element 2 - Alternative Resource Title (O)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 2 - Alternative Resource Title (O)</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>

   <!--PATTERN
        MedinAlternativeResourceTitleInnerText-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:citation/*//gmd:alternateTitle"
                 priority="1000"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:citation/*//gmd:alternateTitle"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                    (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                    @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>

   <!--PATTERN
        Element 3 - Resource Abstract (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 3 - Resource Abstract (M)</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>

   <!--PATTERN
        d562e3529TypeNotNillablePattern-->


  <!--RULE
      -->
<xsl:template match="$context" priority="1000" mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="$context"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>

   <!--PATTERN
        Abstract free-text element check-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Abstract free-text element check</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:abstract" priority="1000" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:abstract"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="normalize-space(.) and *"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="normalize-space(.) and *">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> A human readable, non-empty description of
        the dataset, dataset series, or service shall be provided </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>

   <!--PATTERN
        Abstract length check-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Abstract length check</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:abstract/*[1]" priority="1001" mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:abstract/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length() &gt; 99"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length() &gt; 99">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> Abstract is too short. MEDIN requires
        an abstract of at least 100 characters, but abstract "<xsl:text/>
                  <xsl:copy-of select="normalize-space(.)"/>
                  <xsl:text/>" has only <xsl:text/>
                  <xsl:copy-of select="string-length(.)"/>
                  <xsl:text/>
        characters </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*" priority="1000" mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(//gmd:abstract) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(//gmd:abstract) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
       Abstract is mandatory. One occurrence is allowed.
     </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>

   <!--PATTERN
        Abstract is not the same as Title...-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Abstract is not the same as Title...</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:abstract/*[1]" priority="1000" mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:abstract/*[1]"/>
      <xsl:variable name="resourceTitle"
                    select="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:title/*[1][normalize-space()]"/>
      <xsl:variable name="resourceAbstract" select="normalize-space(.)"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$resourceAbstract != $resourceTitle"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$resourceAbstract != $resourceTitle">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> Abstract "<xsl:text/>
                  <xsl:copy-of select="$resourceAbstract"/>
                  <xsl:text/>" must not be the same text as the title "<xsl:text/>
                  <xsl:copy-of select="$resourceTitle"/>
                  <xsl:text/>")). </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

   <!--PATTERN
        Element 4 - Resource Type (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 4 - Resource Type (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*" priority="1000" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:hierarchyLevel) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:hierarchyLevel) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Resource Type is mandatory. One occurrence is allowed.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or                    contains(gmd:hierarchyLevel/*/@codeListValue, 'series') or                    contains(gmd:hierarchyLevel/*/@codeListValue, 'service')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or contains(gmd:hierarchyLevel/*/@codeListValue, 'series') or contains(gmd:hierarchyLevel/*/@codeListValue, 'service')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Value of Resource Type must be dataset, series or service.
        Value of Resource Type is '<xsl:text/>
                  <xsl:copy-of select="gmd:hierarchyLevel/*/@codeListValue"/>
                  <xsl:text/>'
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>

   <!--PATTERN
        Element 31 - Hierarchy Level Name (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 31 - Hierarchy Level Name (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*" priority="1001" mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'service') or                    contains(gmd:hierarchyLevel/*/@codeListValue, 'series')) and                    count(gmd:hierarchyLevelName) = 1) or contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'service') or contains(gmd:hierarchyLevel/*/@codeListValue, 'series')) and count(gmd:hierarchyLevelName) = 1) or contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        If the Resource Type is service or series, Hierarchy Level Name must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:hierarchyLevelName/*[1]" priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:hierarchyLevelName/*[1]"/>
      <xsl:variable name="hierLevelcListVal"
                    select="preceding::gmd:hierarchyLevel/*/@codeListValue"/>
      <xsl:variable name="hierLevelNameText" select="descendant-or-self::text()"/>

      <!--REPORT
      -->
<xsl:if test="($hierLevelcListVal = 'service' and $hierLevelNameText != 'service')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="($hierLevelcListVal = 'service' and $hierLevelNameText != 'service')">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
       Hierarchy level name for services must have value "service" </svrl:text>
         </svrl:successful-report>
      </xsl:if>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="."/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test=".">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> Hierarchy level name for services must have value "service" </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>

   <!--PATTERN
        hierarchyLevelName-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:hierarchyLevelName" priority="1000" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:hierarchyLevelName"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

   <!--PATTERN
        Element 5 - Resource Locator (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 5 - Resource Locator (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:distributionInfo/*[1]/gmd:transferOptions/*[1]/gmd:onLine/*[1]"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:distributionInfo/*[1]/gmd:transferOptions/*[1]/gmd:onLine/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="         count(gmd:linkage) = 0 or         (starts-with(normalize-space(gmd:linkage/*[1]), 'http://') or         starts-with(normalize-space(gmd:linkage/*[1]), 'https://') or         starts-with(normalize-space(gmd:linkage/*[1]), 'ftp://'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:linkage) = 0 or (starts-with(normalize-space(gmd:linkage/*[1]), 'http://') or starts-with(normalize-space(gmd:linkage/*[1]), 'https://') or starts-with(normalize-space(gmd:linkage/*[1]), 'ftp://'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> The value of resource locator does not appear to be a valid URL. It has a value of
        '<xsl:text/>
                  <xsl:copy-of select="gmd:linkage/*[1]"/>
                  <xsl:text/>'. The URL must start with either http://,
        https:// or ftp://. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>

   <!--PATTERN
        MedinResouceLocatorName-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:distributionInfo/*/gmd:transferOptions/*/gmd:onLine/*/gmd:name"
                 priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:distributionInfo/*/gmd:transferOptions/*/gmd:onLine/*/gmd:name"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

   <!--PATTERN
        MedinResouceLocatorDescription-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:distributionInfo/*/gmd:transferOptions/*/gmd:onLine/*/gmd:description"
                 priority="1000"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:distributionInfo/*/gmd:transferOptions/*/gmd:onLine/*/gmd:description"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>

   <!--PATTERN
        MedinResouceLocatorFunction-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:distributionInfo/*/gmd:transferOptions/*/gmd:onLine/*/gmd:function"
                 priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:distributionInfo/*/gmd:transferOptions/*/gmd:onLine/*/gmd:function"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>

   <!--PATTERN
        Element 6 - Unique Resource Identifier (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 6 - Unique Resource Identifier (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]"
                 priority="1001"
                 mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="         ((../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or         ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and         count(gmd:identifier) &gt;= 1) or         (../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and         ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or         count(../../../../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and count(gmd:identifier) &gt;= 1) or (../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or count(../../../../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> Unique Resource Identifier is mandatory for datasets and series. One or more
        shall be provided. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]"
                 priority="1000"
                 mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="         ((../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or         ../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and         count(gmd:code) &gt;= 1) or         (../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and         ../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or         count(../../../../../../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or ../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and count(gmd:code) &gt;= 1) or (../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and ../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or count(../../../../../../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> Unique Resource Identifier is mandatory for datasets and series. One or more
        shall be provided. code tag is missing.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="         ((../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or         ../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and         count(gmd:codeSpace) &gt;= 1) or         (../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and         ../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or         count(../../../../../../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or ../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and count(gmd:codeSpace) &gt;= 1) or (../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and ../../../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or count(../../../../../../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> Unique Resource Identifier is mandatory for datasets and series. One or more
        shall be provided. codeSpace tag is missing.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>

   <!--PATTERN
        URI-Code-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:code"
                 priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:code"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>

   <!--PATTERN
        URI-CodeSpace-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:codeSpace"
                 priority="1000"
                 mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:codeSpace"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="         (string-length(normalize-space(.)) &gt; 0) or         (@gco:nilReason = 'inapplicable' or         @gco:nilReason = 'missing' or         @gco:nilReason = 'template' or         @gco:nilReason = 'unknown' or         @gco:nilReason = 'withheld' or         starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the 
        following Metadata Items: Alternative Title, (Unique) Resource Identifier,
        Spatial Data Service Type, Conformity, Specification, and Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>

   <!--PATTERN
        MedinUniqueResourceIdentifierGcoTypePattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:identifier/*/gmd:code"
                 priority="1000"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:identifier/*/gmd:code"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                    (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                    @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>

   <!--PATTERN
        MedinUniqueResourceIdentifierCodeSpaceGcoTypePattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:identifier/*/gmd:codeSpace"
                 priority="1000"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:identifier/*/gmd:codeSpace"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                    (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                    @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>

   <!--PATTERN
        Element 7 - Coupled Resource (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 7 - Coupled Resource (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:operatesOn"
                 priority="1001"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/srv:operatesOn"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(@xlink:href) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(@xlink:href) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> Coupled resource shall be implemented by
        reference using the xlink:href attribute. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*" priority="1000" mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'service')) and          (contains(/*/gmd:identificationInfo/*/srv:serviceType/*, 'view') or          contains(/*/gmd:identificationInfo/*/srv:serviceType/*, 'download')) and          count(/*/gmd:identificationInfo/*/srv:operatesOn) &gt; 0) or          (contains(/*/gmd:identificationInfo/*/srv:serviceType/*, 'discovery') or         contains(/*/gmd:identificationInfo/*/srv:serviceType/*, 'transformation') or          contains(/*/gmd:identificationInfo/*/srv:serviceType/*, 'invoke') or          contains(/*/gmd:identificationInfo/*/srv:serviceType/*, 'other') or         contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or          contains(gmd:hierarchyLevel/*/@codeListValue, 'series'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'service')) and (contains(/*/gmd:identificationInfo/*/srv:serviceType/*, 'view') or contains(/*/gmd:identificationInfo/*/srv:serviceType/*, 'download')) and count(/*/gmd:identificationInfo/*/srv:operatesOn) &gt; 0) or (contains(/*/gmd:identificationInfo/*/srv:serviceType/*, 'discovery') or contains(/*/gmd:identificationInfo/*/srv:serviceType/*, 'transformation') or contains(/*/gmd:identificationInfo/*/srv:serviceType/*, 'invoke') or contains(/*/gmd:identificationInfo/*/srv:serviceType/*, 'other') or contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or contains(gmd:hierarchyLevel/*/@codeListValue, 'series'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        If the Resource Type is 'service' and Service Type is 'discovery' or 'view', at least one srv:operatesOn must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>

   <!--PATTERN
        Element 8 - Resource Language (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 8 - Resource Language (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*" priority="1000" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or                    contains(gmd:hierarchyLevel/*/@codeListValue, 'series')) and                    count(/*/gmd:identificationInfo/*/gmd:language) &gt;= 1) or                    (contains(gmd:hierarchyLevel/*/@codeListValue, 'service'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or contains(gmd:hierarchyLevel/*/@codeListValue, 'series')) and count(/*/gmd:identificationInfo/*/gmd:language) &gt;= 1) or (contains(gmd:hierarchyLevel/*/@codeListValue, 'service'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        If the Resource Type is dataset or series, Resource Language must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>

   <!--PATTERN
        MedinResourceLanguageLanguagePattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:language" priority="1000" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:language"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(./gco:CharacterString = 'eng' or ./gco:CharacterString = 'cym' or ./gco:CharacterString = 'gle' or ./gco:CharacterString = 'gla' or ./gco:CharacterString = 'cor') or          (./gmd:LanguageCode/@codeListValue='eng' or ./gmd:LanguageCode/@codeListValue='cym' or ./gmd:LanguageCode/@codeListValue='gle' or ./gmd:LanguageCode/@codeListValue='gla' or ./gmd:LanguageCode/@codeListValue='cor' or ./gmd:LanguageCode/@codeListValue='zxx')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(./gco:CharacterString = 'eng' or ./gco:CharacterString = 'cym' or ./gco:CharacterString = 'gle' or ./gco:CharacterString = 'gla' or ./gco:CharacterString = 'cor') or (./gmd:LanguageCode/@codeListValue='eng' or ./gmd:LanguageCode/@codeListValue='cym' or ./gmd:LanguageCode/@codeListValue='gle' or ./gmd:LanguageCode/@codeListValue='gla' or ./gmd:LanguageCode/@codeListValue='cor' or ./gmd:LanguageCode/@codeListValue='zxx')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> must be one of eng, cym, gle, gla, cor or zxx (for no linguistic context).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>

   <!--PATTERN
        Element 9 - Topic Category (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 9 - Topic Category (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*" priority="1000" mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or                    contains(gmd:hierarchyLevel/*/@codeListValue, 'series')) and                    count(/*/gmd:identificationInfo/*/gmd:topicCategory) &gt;= 1) or                    (contains(gmd:hierarchyLevel/*/@codeListValue, 'service'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or contains(gmd:hierarchyLevel/*/@codeListValue, 'series')) and count(/*/gmd:identificationInfo/*/gmd:topicCategory) &gt;= 1) or (contains(gmd:hierarchyLevel/*/@codeListValue, 'service'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        If the Resource Type is dataset or series, one or more Topic Categories must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>

   <!--PATTERN
        MedinTopicCategoryCodeInnerText-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:topicCategory" priority="1000"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:topicCategory"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(gmd:MD_TopicCategoryCode) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(gmd:MD_TopicCategoryCode) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element should have a value.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>

   <!--PATTERN
        Element 10 - Spatial Data Service Type (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 10 - Spatial Data Service Type (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*" priority="1000" mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'service')) and                    count(/*/gmd:identificationInfo/*/srv:serviceType) = 1) or                    (contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or                    contains(gmd:hierarchyLevel/*/@codeListValue, 'series'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'service')) and count(/*/gmd:identificationInfo/*/srv:serviceType) = 1) or (contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or contains(gmd:hierarchyLevel/*/@codeListValue, 'series'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        If the Resource Type is service, one Spatial Data Service Type must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>

   <!--PATTERN
        MedinSpatialDataServiceTypeGcoTypePattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/srv:serviceType" priority="1000" mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/srv:serviceType"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                    (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                    @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/srv:serviceType" priority="1000" mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/srv:serviceType"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="gco:LocalName[text() = 'discovery'] or         gco:LocalName[text() = 'view'] or         gco:LocalName[text() = 'download'] or         gco:LocalName[text() = 'transformation'] or         gco:LocalName[text() = 'invoke'] or         gco:LocalName[text() = 'other']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gco:LocalName[text() = 'discovery'] or gco:LocalName[text() = 'view'] or gco:LocalName[text() = 'download'] or gco:LocalName[text() = 'transformation'] or gco:LocalName[text() = 'invoke'] or gco:LocalName[text() = 'other']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Service type must be one of 'discovery', 'view', 'download', 'transformation', 'invoke'
        or 'other' following INSPIRE generic names.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>

   <!--PATTERN
        Element 32 - Spatial Representation Type (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 32 - Spatial Representation Type (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*" priority="1000" mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or                          contains(gmd:hierarchyLevel/*/@codeListValue, 'series')) and                          count(/*/gmd:identificationInfo/*/gmd:spatialRepresentationType) &gt;= 1) or                          (contains(gmd:hierarchyLevel/*/@codeListValue, 'service'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or contains(gmd:hierarchyLevel/*/@codeListValue, 'series')) and count(/*/gmd:identificationInfo/*/gmd:spatialRepresentationType) &gt;= 1) or (contains(gmd:hierarchyLevel/*/@codeListValue, 'service'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        If the Resource Type is dataset or series, one or more Spatial Representation Types must 
        be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:spatialRepresentationType"
                 priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:spatialRepresentationType"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="contains(*/@codeListValue, 'vector') or         contains(*/@codeListValue, 'grid') or         contains(*/@codeListValue, 'textTable') or         contains(*/@codeListValue, 'tin')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="contains(*/@codeListValue, 'vector') or contains(*/@codeListValue, 'grid') or contains(*/@codeListValue, 'textTable') or contains(*/@codeListValue, 'tin')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Spatial representation type must be one of 'vector', 'grid', 'textTable', or 'tin' following ISO19115 generic names.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>

   <!--PATTERN
        Element 11 - Keywords (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 11 - Keywords (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo" priority="1004" mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:identificationInfo"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:descriptiveKeywords) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:descriptiveKeywords) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Keywords are mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:descriptiveKeywords/*/gmd:keyword) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:descriptiveKeywords/*/gmd:keyword) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        keyword tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:descriptiveKeywords/*/gmd:thesaurusName) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:descriptiveKeywords/*/gmd:thesaurusName) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Thesaurus Name is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(*/@xlink:href, 'http://vocab.nerc.ac.uk/collection/P22/')]) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(*/@xlink:href, 'http://vocab.nerc.ac.uk/collection/P22/')]) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        At least one INSPIRE keyword from http://vocab.nerc.ac.uk/collection/P22/ must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(contains(../gmd:hierarchyLevel/*/@codeListValue, 'dataset') or          contains(../gmd:hierarchyLevel/*/@codeListValue, 'series')) or         (contains(../gmd:hierarchyLevel/*/@codeListValue, 'service') and          count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(*/@xlink:href, 'http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/')]) &gt;= 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(contains(../gmd:hierarchyLevel/*/@codeListValue, 'dataset') or contains(../gmd:hierarchyLevel/*/@codeListValue, 'series')) or (contains(../gmd:hierarchyLevel/*/@codeListValue, 'service') and count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(*/@xlink:href, 'http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/')]) &gt;= 1)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        INSPIRE: Part D 4 of the Metadata Implementing Rules - For a service at least one keyword must come from http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(*/@xlink:href, 'P02')]) = count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(gmx:Anchor/@xlink:href, 'http://vocab.nerc.ac.uk/collection/P02/')])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(*/@xlink:href, 'P02')]) = count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(gmx:Anchor/@xlink:href, 'http://vocab.nerc.ac.uk/collection/P02/')])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Keyword: When referring to the P02 vocabulary the gmx:Anchor xlink:href must contain 'http://vocab.nerc.ac.uk/collection/P02/current'
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(*/@xlink:href, 'N01')]) = count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(gmx:Anchor/@xlink:href, 'http://vocab.nerc.ac.uk/collection/N01/')])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(*/@xlink:href, 'N01')]) = count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(gmx:Anchor/@xlink:href, 'http://vocab.nerc.ac.uk/collection/N01/')])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Keyword: When referring to the N01 vocabulary the gmx:Anchor xlink:href must contain 'http://vocab.nerc.ac.uk/collection/N01/current'
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(*/@xlink:href, 'L13')]) = count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(gmx:Anchor/@xlink:href, 'http://vocab.nerc.ac.uk/collection/L13/')])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(*/@xlink:href, 'L13')]) = count(*/gmd:descriptiveKeywords/*/gmd:keyword[contains(gmx:Anchor/@xlink:href, 'http://vocab.nerc.ac.uk/collection/L13/')])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Keyword: When referring to the L13 vocabulary the gmx:Anchor xlink:href must contain 'http://vocab.nerc.ac.uk/collection/L13/current'
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords" priority="1003"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:keyword) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:keyword) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Keyword: keyword tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:thesaurusName) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:thesaurusName) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Keyword: thesaurusName tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:thesaurusName"
                 priority="1002"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:thesaurusName"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:title) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:title) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Keyword: ThesaurusName: title tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:date) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:date) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Keyword: ThesaurusName: date tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:thesaurusName/*/gmd:date"
                 priority="1001"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:thesaurusName/*/gmd:date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:date) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:date) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Keyword: ThesaurusName: date: date tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:dateType) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:dateType) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Keyword: ThesaurusName: date: dateType tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:dateType/gmd:CI_DateTypeCode) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:dateType/gmd:CI_DateTypeCode) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Keyword: ThesaurusName: date: dateType: CI_DateTypeCode tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:thesaurusName/*/gmd:date/*/gmd:dateType/gmd:CI_DateTypeCode"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:thesaurusName/*/gmd:date/*/gmd:dateType/gmd:CI_DateTypeCode"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeList) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeList) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Keyword: ThesaurusName: date: dateType: codeList must have a value.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="@codeListValue = 'creation' or @codeListValue = 'revision' or @codeListValue = 'publication'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="@codeListValue = 'creation' or @codeListValue = 'revision' or @codeListValue = 'publication'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Keyword: ThesaurusName: date: dateType: codeListValue must have a creation, revision or publication.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-Keyword-Nillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:keyword"
                 priority="1000"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:keyword"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="         (string-length(normalize-space(.)) &gt; 0) or         (@gco:nilReason = 'inapplicable' or         @gco:nilReason = 'missing' or         @gco:nilReason = 'template' or         @gco:nilReason = 'unknown' or         @gco:nilReason = 'withheld' or         starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(normalize-space(.)) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element shall have a value or a valid Nil Reason. This test may be called by the 
        following Metadata Items: Alternative Title, (Unique) Resource Identifier,
        Spatial Data Service Type, Conformity, Specification, and Equivalent
        scale </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-Thesaurus-Title-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:thesaurusName/*/gmd:title"
                 priority="1000"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:thesaurusName/*/gmd:title"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-Thesaurus-Date-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:thesaurusName/*/gmd:date/*/gmd:date/*"
                 priority="1000"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:thesaurusName/*/gmd:date/*/gmd:date/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-Thesaurus-DateType-CodeList-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:thesaurusName/*/gmd:date/*/gmd:dateType/*"
                 priority="1000"
                 mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:descriptiveKeywords/*/gmd:thesaurusName/*/gmd:date/*/gmd:dateType/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: Keyword,
        Dataset Reference Date, Responsible Organisation, Frequency of Update,
        Limitations on Public Access, Use Constraints, Resource Type,
        Specification, Spatial representation type, and Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>

   <!--PATTERN
        Element 12 - Geographical Bounding Box (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 12 - Geographical Bounding Box (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo" priority="1000" mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:identificationInfo"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((contains(../gmd:hierarchyLevel/*/@codeListValue, 'dataset') or                    contains(../gmd:hierarchyLevel/*/@codeListValue, 'series')) and                    count(*/gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox) &gt;= 1) or                   contains(../gmd:hierarchyLevel/*/@codeListValue, 'service')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((contains(../gmd:hierarchyLevel/*/@codeListValue, 'dataset') or contains(../gmd:hierarchyLevel/*/@codeListValue, 'series')) and count(*/gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox) &gt;= 1) or contains(../gmd:hierarchyLevel/*/@codeListValue, 'service')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Geographic bounding box is mandatory. One or more shall be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>

   <!--PATTERN
        MedinGeographicBoundingBoxPattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox |                /*/gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'] |                /*/gmd:identificationInfo/*/srv:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox |                /*/gmd:identificationInfo/*/srv:extent/*/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox']"
                 priority="1000"
                 mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox |                /*/gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'] |                /*/gmd:identificationInfo/*/srv:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox |                /*/gmd:identificationInfo/*/srv:extent/*/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="gmd:westBoundLongitude &gt;= -180.0 and gmd:westBoundLongitude &lt;= 180.0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:westBoundLongitude &gt;= -180.0 and gmd:westBoundLongitude &lt;= 180.0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        westBoundLongitude has a value of <xsl:text/>
                  <xsl:copy-of select="gmd:westBoundLongitude"/>
                  <xsl:text/> which is outside bounds.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="gmd:eastBoundLongitude &gt;= -180.0 and gmd:eastBoundLongitude &lt;= 180.0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:eastBoundLongitude &gt;= -180.0 and gmd:eastBoundLongitude &lt;= 180.0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        eastBoundLongitude has a value of <xsl:text/>
                  <xsl:copy-of select="gmd:eastBoundLongitude"/>
                  <xsl:text/> which is outside bounds.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="gmd:southBoundLatitude &gt;= -90.0 and gmd:southBoundLatitude &lt;= gmd:northBoundLatitude"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:southBoundLatitude &gt;= -90.0 and gmd:southBoundLatitude &lt;= gmd:northBoundLatitude">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        southBoundLatitude has a value of <xsl:text/>
                  <xsl:copy-of select="gmd:southBoundLatitude"/>
                  <xsl:text/> which is outside bounds.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="gmd:northBoundLatitude &lt;= 90.0 and gmd:northBoundLatitude &gt;= gmd:southBoundLatitude"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:northBoundLatitude &lt;= 90.0 and gmd:northBoundLatitude &gt;= gmd:southBoundLatitude">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        northBoundLatitude has a value of <xsl:text/>
                  <xsl:copy-of select="gmd:northBoundLatitude"/>
                  <xsl:text/> which is outside bounds.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(substring-after(string(gmd:westBoundLongitude/gco:Decimal), '.'))) &gt; 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(substring-after(string(gmd:westBoundLongitude/gco:Decimal), '.'))) &gt; 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>westBoundLongitude is mandatory and must have 2 or more decimal places
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(substring-after(gmd:eastBoundLongitude, '.'))) &gt; 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(substring-after(gmd:eastBoundLongitude, '.'))) &gt; 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>eastBoundLongitude is mandatory and must have 2 or more decimal places
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(substring-after(gmd:southBoundLatitude, '.'))) &gt; 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(substring-after(gmd:southBoundLatitude, '.'))) &gt; 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>southBoundLongitude is mandatory and must have 2 or more decimal places
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(substring-after(gmd:northBoundLatitude, '.'))) &gt; 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(substring-after(gmd:northBoundLatitude, '.'))) &gt; 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>northBoundLongitude is mandatory and must have 2 or more decimal places
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>

   <!--PATTERN
        Element 13 - Extent (O)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 13 - Extent (O)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/*/gmd:geographicIdentifier"
                 priority="1000"
                 mode="M51">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement/*/gmd:geographicIdentifier"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(contains(*/gmd:code/*/@xlink:href, 'C19') and            contains(*/gmd:code/*/@xlink:href, 'http://vocab.nerc.ac.uk/collection/C19/current')) or           not(contains(*/gmd:code/*/@xlink:href, 'C19'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(contains(*/gmd:code/*/@xlink:href, 'C19') and contains(*/gmd:code/*/@xlink:href, 'http://vocab.nerc.ac.uk/collection/C19/current')) or not(contains(*/gmd:code/*/@xlink:href, 'C19'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
          Extent: When referring to the C19 vocabulary the xlink:href must contain 'http://vocab.nerc.ac.uk/collection/C19/current'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(contains(*/gmd:code/*/@xlink:href, 'C64') and          contains(*/gmd:code/*/@xlink:href, 'http://vocab.nerc.ac.uk/collection/C64/current')) or         not(contains(*/gmd:code/*/@xlink:href, 'C64'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(contains(*/gmd:code/*/@xlink:href, 'C64') and contains(*/gmd:code/*/@xlink:href, 'http://vocab.nerc.ac.uk/collection/C64/current')) or not(contains(*/gmd:code/*/@xlink:href, 'C64'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
          Extent: When referring to the C64 vocabulary the xlink:href must contain 'http://vocab.nerc.ac.uk/collection/C64/current'
        </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>

   <!--PATTERN
        MedinExtentCodeGcoTypeTestPattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/*/*/gmd:geographicElement/*/gmd:geographicIdentifier/*/gmd:code"
                 priority="1000"
                 mode="M52">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/*/*/gmd:geographicElement/*/gmd:geographicIdentifier/*/gmd:code"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                    (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                    @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>

   <!--PATTERN
        MedinExtentAuthorityGcoTypeTestPattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/*/*/gmd:geographicElement/*/gmd:geographicIdentifier/*/gmd:authority/*/gmd:title"
                 priority="1000"
                 mode="M53">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/*/*/gmd:geographicElement/*/gmd:geographicIdentifier/*/gmd:authority/*/gmd:title"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                    (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                    @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>

   <!--PATTERN
        Element 14 - Vertical Extent Information (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 14 - Vertical Extent Information (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:extent/*/gmd:verticalElement"
                 priority="1000"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:extent/*/gmd:verticalElement"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:minimumValue) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:minimumValue) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Vertical Extent: minimumValue tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:maximumValue) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:maximumValue) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Vertical Extent: maximumValue tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:verticalCRS) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:verticalCRS) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Vertical Extent: verticalCRS tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>

   <!--PATTERN
        MedinVerticalExtentInformationTypeNotNillablePattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:extent/*/gmd:verticalElement/*/gmd:minimumValue |       /*/gmd:identificationInfo/*/gmd:extent/*/gmd:verticalElement/*/gmd:maximumValue"
                 priority="1000"
                 mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:extent/*/gmd:verticalElement/*/gmd:minimumValue |       /*/gmd:identificationInfo/*/gmd:extent/*/gmd:verticalElement/*/gmd:maximumValue"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>

   <!--PATTERN
        MedinVerticalExtentVerticalCRSTypeNotNillablePattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:extent/*/gmd:verticalElement/*/gmd:verticalCRS/@xlink:href"
                 priority="1000"
                 mode="M56">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:extent/*/gmd:verticalElement/*/gmd:verticalCRS/@xlink:href"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>

   <!--PATTERN
        Element 15 - Spatial Reference System (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 15 - Spatial Reference System (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*" priority="1007" mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:referenceSystemInfo) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:referenceSystemInfo) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Coordinate reference system information must be supplied.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:referenceSystemInfo" priority="1006" mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:referenceSystemInfo"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:referenceSystemIdentifier) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:referenceSystemIdentifier) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        gmd:referenceSystemInfo: must contain gmd:referenceSystemIdentifier.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier"
                 priority="1005"
                 mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:code) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:code) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        gmd:referenceSystemIdentifier: must contain gmd:code.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/*[1]/gmd:code"
                 priority="1004"
                 mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/*[1]/gmd:code"/>

      <!--REPORT
      -->
<xsl:if test="count(gmx:Anchor) = 0">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="count(gmx:Anchor) = 0">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
        Spatial Reference System: code: must contain an anchor link
      </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/*[1]"
                 priority="1003"
                 mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:code) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:code) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Spatial Reference System: code is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier/*/gmd:authority"
                 priority="1002"
                 mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier/*/gmd:authority"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:title) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:title) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Spatial Reference System: Authority: title tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:date) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:date) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Spatial Reference System: Authority: date tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier/*/gmd:authority/*/gmd:date"
                 priority="1001"
                 mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier/*/gmd:authority/*/gmd:date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:date) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:date) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Spatial Reference System: Authority: date: date tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:dateType) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:dateType) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Spatial Reference System: Authority: date: dateType tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:dateType/gmd:CI_DateTypeCode) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:dateType/gmd:CI_DateTypeCode) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Spatial Reference System: Authority: date: dateType: CI_DateTypeCode tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier/*/gmd:authority/*/gmd:date/*/gmd:dateType/gmd:CI_DateTypeCode"
                 priority="1000"
                 mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier/*/gmd:authority/*/gmd:date/*/gmd:dateType/gmd:CI_DateTypeCode"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeList) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeList) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Spatial Reference System: Authority: date: dateType: codeList must have a value.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="@codeListValue = 'creation' or @codeListValue = 'revision' or @codeListValue = 'publication'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="@codeListValue = 'creation' or @codeListValue = 'revision' or @codeListValue = 'publication'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Spatial Reference System: Authority: date: dateType: codeListValue must have a creation, revision or publication.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-SRS-Code-NotNillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/*[1]/gmd:code"
                 priority="1000"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/*[1]/gmd:code"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-SpatialReferenceSystem-Authority-Title-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier/*/gmd:authority/*/gmd:title"
                 priority="1000"
                 mode="M59">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier/*/gmd:authority/*/gmd:title"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-SpatialReferenceSystem-Authority-Date-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier/*/gmd:authority/*/gmd:date/*/gmd:date/*"
                 priority="1000"
                 mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier/*/gmd:authority/*/gmd:date/*/gmd:date/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-SpatialReferenceSystem-Authority-DateType-CodeList-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier/*/gmd:authority/*/gmd:date/*/gmd:dateType/*"
                 priority="1000"
                 mode="M61">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:referenceSystemInfo/*/gmd:referenceSystemIdentifier/*/gmd:authority/*/gmd:date/*/gmd:dateType/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: Keyword,
        Dataset Reference Date, Responsible Organisation, Frequency of Update,
        Limitations on Public Access, Use Constraints, Resource Type,
        Specification, Spatial representation type, and Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M61"/>
   <xsl:template match="@*|node()" priority="-2" mode="M61">
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>

   <!--PATTERN
        Element 16 - Temporal Reference (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 16 - Temporal Reference (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo" priority="1000" mode="M62">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:identificationInfo"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:citation/*/gmd:date/*/gmd:dateType/*[@codeListValue='revision']) &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:citation/*/gmd:date/*/gmd:dateType/*[@codeListValue='revision']) &lt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        One revision date must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:citation/*/gmd:date/*/gmd:dateType/*[@codeListValue='creation']) &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:citation/*/gmd:date/*/gmd:dateType/*[@codeListValue='creation']) &lt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Only one creation date allowed.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M62"/>
   <xsl:template match="@*|node()" priority="-2" mode="M62">
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>

   <!--PATTERN
        MedinTemporalReferenceGcoTypeTestPattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:date/*/gmd:date"
                 priority="1000"
                 mode="M63">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:date/*/gmd:date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                    (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                    @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M63"/>
   <xsl:template match="@*|node()" priority="-2" mode="M63">
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>

   <!--PATTERN
        Element 16.1 - Date of Publication (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 16.1 - Date of Publication (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo" priority="1002" mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:identificationInfo"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:citation/*/gmd:date/*/gmd:dateType[*/@codeListValue='publication']) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:citation/*/gmd:date/*/gmd:dateType[*/@codeListValue='publication']) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Publication date is mandatory. One must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:date" priority="1001"
                 mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:date) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:date) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Citation: date: date tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:dateType) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:dateType) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Citation: date: dateType tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:dateType/gmd:CI_DateTypeCode) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:dateType/gmd:CI_DateTypeCode) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Citation: date: dateType: CI_DateTypeCode tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:date/*/gmd:dateType/gmd:CI_DateTypeCode"
                 priority="1000"
                 mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:date/*/gmd:dateType/gmd:CI_DateTypeCode"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeList) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeList) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Citation: date: dateType: codeList must have a value.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="@codeListValue = 'creation' or @codeListValue = 'revision' or @codeListValue = 'publication'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="@codeListValue = 'creation' or @codeListValue = 'revision' or @codeListValue = 'publication'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Citation: date: dateType: codeListValue must have a creation, revision or publication.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M64"/>
   <xsl:template match="@*|node()" priority="-2" mode="M64">
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>

   <!--PATTERN
        MedinCitationDate-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:date/*/gmd:date"
                 priority="1000"
                 mode="M65">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:citation/*/gmd:date/*/gmd:date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M65"/>
   <xsl:template match="@*|node()" priority="-2" mode="M65">
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>

   <!--PATTERN
        Element 16.2 - Date of Last Revision (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 16.2 - Date of Last Revision (C)</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M66"/>
   <xsl:template match="@*|node()" priority="-2" mode="M66">
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>

   <!--PATTERN
        Element 16.3 - Date of Creation (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 16.3 - Date of Creation (C)</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M67"/>
   <xsl:template match="@*|node()" priority="-2" mode="M67">
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>

   <!--PATTERN
        Element 16.4 - Temporal Extent (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 16.4 - Temporal Extent (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo" priority="1002" mode="M68">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:identificationInfo"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((contains(../gmd:hierarchyLevel/*/@codeListValue, 'dataset') or          contains(../gmd:hierarchyLevel/*/@codeListValue, 'series')) and          count(*/gmd:extent/*/gmd:temporalElement) &gt;= 1) or         contains(../gmd:hierarchyLevel/*/@codeListValue, 'service')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((contains(../gmd:hierarchyLevel/*/@codeListValue, 'dataset') or contains(../gmd:hierarchyLevel/*/@codeListValue, 'series')) and count(*/gmd:extent/*/gmd:temporalElement) &gt;= 1) or contains(../gmd:hierarchyLevel/*/@codeListValue, 'service')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Temporal extent is mandatory for datasets and series. One must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/*/*/gmd:temporalElement/*/gmd:extent"
                 priority="1001"
                 mode="M68">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/*/*/gmd:temporalElement/*/gmd:extent"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gml:beginPosition) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gml:beginPosition) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Temporal extent: beginPosition is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/*/*/gmd:temporalElement/*/gmd:extent/gml:TimePeriod"
                 priority="1000"
                 mode="M68">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/*/*/gmd:temporalElement/*/gmd:extent/gml:TimePeriod"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@gml:id) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@gml:id) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Temporal Extent: TimePeriod: gml:id must have a value.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M68"/>
   <xsl:template match="@*|node()" priority="-2" mode="M68">
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-TemporalExtent-BeginPosition-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:extent/*/gmd:temporalElement/*/gmd:extent/*/gml:beginPosition"
                 priority="1000"
                 mode="M69">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:extent/*/gmd:temporalElement/*/gmd:extent/*/gml:beginPosition"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M69"/>
   <xsl:template match="@*|node()" priority="-2" mode="M69">
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>

   <!--PATTERN
        Element 17 - Lineage (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 17 - Lineage (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*" priority="1000" mode="M70">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or                    contains(gmd:hierarchyLevel/*/@codeListValue, 'series')) and                    count(gmd:dataQualityInfo/*/gmd:lineage/*/gmd:statement) = 1) or                    (contains(gmd:hierarchyLevel/*/@codeListValue, 'service'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((contains(gmd:hierarchyLevel/*/@codeListValue, 'dataset') or contains(gmd:hierarchyLevel/*/@codeListValue, 'series')) and count(gmd:dataQualityInfo/*/gmd:lineage/*/gmd:statement) = 1) or (contains(gmd:hierarchyLevel/*/@codeListValue, 'service'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Lineage is mandatory for datasets and series of datasets.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M70"/>
   <xsl:template match="@*|node()" priority="-2" mode="M70">
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>

   <!--PATTERN
        MedinLineageGcoTypeTestPattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:dataQualityInfo/*/gmd:lineage/*/gmd:statement" priority="1000"
                 mode="M71">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:dataQualityInfo/*/gmd:lineage/*/gmd:statement"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M71"/>
   <xsl:template match="@*|node()" priority="-2" mode="M71">
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>

   <!--PATTERN
        Element 18 - Spatial Resolution (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 18 - Spatial Resolution (C)</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M72"/>
   <xsl:template match="@*|node()" priority="-2" mode="M72">
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>

   <!--PATTERN
        MedinEquivalentScaleGcoTypeTestPattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:spatialResolution/*/gmd:equivalentScale/*/gmd:denominator"
                 priority="1000"
                 mode="M73">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:spatialResolution/*/gmd:equivalentScale/*/gmd:denominator"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                    (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                    @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M73"/>
   <xsl:template match="@*|node()" priority="-2" mode="M73">
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>

   <!--PATTERN
        Element 19 - Additional Information (O)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 19 - Additional Information (O)</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M74"/>
   <xsl:template match="@*|node()" priority="-2" mode="M74">
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>

   <!--PATTERN
        MedinAdditionalInformationSourceGcoTypeTestPattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:supplementalInformation" priority="1000"
                 mode="M75">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:supplementalInformation"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                    (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                    @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M75"/>
   <xsl:template match="@*|node()" priority="-2" mode="M75">
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>

   <!--PATTERN
        Element 20 - Limitations on Public Access (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 20 - Limitations on Public Access (M)</svrl:text>
   <xsl:variable name="LoPAurl"
                 select="'http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/'"/>
   <xsl:variable name="LoPAurlNum"
                 select="count(//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gmx:Anchor/@xlink:href[contains(.,$LoPAurl)])"/>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo" priority="1003" mode="M76">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:identificationInfo"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:resourceConstraints/*/gmd:accessConstraints) +                   count(*/gmd:resourceConstraints/*/gmd:otherConstraints) +                   count(*/gmd:classification/*/gmd:resourceConstraints/*/gmd:classification) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:resourceConstraints/*/gmd:accessConstraints) + count(*/gmd:resourceConstraints/*/gmd:otherConstraints) + count(*/gmd:classification/*/gmd:resourceConstraints/*/gmd:classification) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Limitations on Public Access is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:resourceConstraints/*/gmd:accessConstraints) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:resourceConstraints/*/gmd:accessConstraints) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Limitations on Public Access: must contain one accessConstraints tag. There are <xsl:text/>
                  <xsl:copy-of select="count(*/gmd:resourceConstraints/*/gmd:accessConstraints)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:resourceConstraints/*/gmd:accessConstraints"
                 priority="1002"
                 mode="M76">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:resourceConstraints/*/gmd:accessConstraints"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:MD_RestrictionCode) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:MD_RestrictionCode) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Limitations on Public Access: each access constraint must contain gmd:MD_RestrictionCode tag.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:resourceConstraints" priority="1001"
                 mode="M76">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:resourceConstraints"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:otherConstraints) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:otherConstraints) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Limitations on Public Access and Conditions Applying for Access and Use: each constraint must contain at least one otherConstraints tag.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(count(*/gmd:accessConstraints) &gt;=1 and count(*/gmd:otherConstraints[contains(*/@xlink:href,'LimitationsOnPublicAccess')]) &gt;= 1) or count(*/gmd:accessConstraints) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(count(*/gmd:accessConstraints) &gt;=1 and count(*/gmd:otherConstraints[contains(*/@xlink:href,'LimitationsOnPublicAccess')]) &gt;= 1) or count(*/gmd:accessConstraints) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Limitations on Public Access and Conditions Applying for Access and Use: At least one instance of gmd:otherConstraints shall point to the INSPIRE codelist Limitations on Public Access.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:resourceConstraints/*/gmd:accessConstraints/gmd:MD_RestrictionCode"
                 priority="1000"
                 mode="M76">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:resourceConstraints/*/gmd:accessConstraints/gmd:MD_RestrictionCode"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="@codeListValue = 'otherRestrictions'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="@codeListValue = 'otherRestrictions'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_RestrictionCode: codeListValue must be 'otherRestrictions'
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M76"/>
   <xsl:template match="@*|node()" priority="-2" mode="M76">
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-OtherConstraints-Nillable-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:otherConstraints"
                 priority="1000"
                 mode="M77">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:otherConstraints"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M77"/>
   <xsl:template match="@*|node()" priority="-2" mode="M77">
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-AccessConstraints-CodeList-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:accessConstraints/*[1]"
                 priority="1000"
                 mode="M78">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:accessConstraints/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: Keyword,
        Dataset Reference Date, Responsible Organisation, Frequency of Update,
        Limitations on Public Access, Use Constraints, Resource Type,
        Specification, Spatial representation type, and Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M78"/>
   <xsl:template match="@*|node()" priority="-2" mode="M78">
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>

   <!--PATTERN
        Element 21 - Conditions Applying for Access and Use (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 21 - Conditions Applying for Access and Use (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:resourceConstraints/*/gmd:useConstraints/gmd:MD_RestrictionCode"
                 priority="1003"
                 mode="M79">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:resourceConstraints/*/gmd:useConstraints/gmd:MD_RestrictionCode"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="@codeListValue = 'otherRestrictions'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="@codeListValue = 'otherRestrictions'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_RestrictionCode: codeListValue must be 'otherRestrictions'
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo" priority="1002" mode="M79">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:identificationInfo"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:resourceConstraints/*/gmd:useConstraints) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:resourceConstraints/*/gmd:useConstraints) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Conditions Applying for Access and Use: must contain one useConstraints tag.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:resourceConstraints/*/gmd:useConstraints"
                 priority="1001"
                 mode="M79">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:resourceConstraints/*/gmd:useConstraints"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:MD_RestrictionCode) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:MD_RestrictionCode) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Conditions Applying for Access and Use: each use constraint must contain gmd:MD_RestrictionCode tag.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:resourceConstraints/*/gmd:useConstraints/gmd:MD_RestrictionCode"
                 priority="1000"
                 mode="M79">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:resourceConstraints/*/gmd:useConstraints/gmd:MD_RestrictionCode"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="@codeListValue = 'otherRestrictions'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="@codeListValue = 'otherRestrictions'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        MD_RestrictionCode: codeListValue must be 'otherRestrictions'
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M79"/>
   <xsl:template match="@*|node()" priority="-2" mode="M79">
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-UseConstraints-CodeList-->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:useConstraints/*[1]"
                 priority="1000"
                 mode="M80">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:useConstraints/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> The codeListValue attribute
        does not have a value. This test may be called by the following Metadata Items: Keyword,
        Dataset Reference Date, Responsible Organisation, Frequency of Update,
        Limitations on Public Access, Use Constraints, Resource Type,
        Specification, Spatial representation type, and Character encoding </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M80"/>
   <xsl:template match="@*|node()" priority="-2" mode="M80">
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>

   <!--PATTERN
        Element 22 - Responsible Party (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 22 - Responsible Party (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]" priority="1003"
                 mode="M81">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:pointOfContact) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:pointOfContact) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> Responsible organisation is
        mandatory. At least one shall be provided. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact"
                 priority="1002"
                 mode="M81">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value of responsible organisation
        shall not be null. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]" priority="1001" mode="M81">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:contact/*/gmd:role[*/@codeListValue = 'pointOfContact']) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:contact/*/gmd:role[*/@codeListValue = 'pointOfContact']) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Point of contact is a mandatory element. Only one must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo" priority="1000" mode="M81">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:identificationInfo"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:pointOfContact/*/gmd:role[*/@codeListValue = 'originator']) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:pointOfContact/*/gmd:role[*/@codeListValue = 'originator']) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Originator point of contact is a mandatory element. At least one must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:pointOfContact/*/gmd:role[*/@codeListValue = 'custodian']) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:pointOfContact/*/gmd:role[*/@codeListValue = 'custodian']) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Custodian point of contact is a mandatory element. At least one must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:pointOfContact/*/gmd:role[*/@codeListValue = 'distributor']) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:pointOfContact/*/gmd:role[*/@codeListValue = 'distributor']) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Distributor point of contact is a mandatory element. At least one must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:pointOfContact/*/gmd:role[*/@codeListValue = 'owner']) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:pointOfContact/*/gmd:role[*/@codeListValue = 'owner']) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Owner point of contact is a mandatory element. At least one must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M81"/>
   <xsl:template match="@*|node()" priority="-2" mode="M81">
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-Contacts-EmailAddress-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:pointOfContact/*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress"
                 priority="1000"
                 mode="M82">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:pointOfContact/*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M82"/>
   <xsl:template match="@*|node()" priority="-2" mode="M82">
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-Contacts-OrganisationName-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:pointOfContact/*/gmd:organisationName"
                 priority="1000"
                 mode="M83">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:pointOfContact/*/gmd:organisationName"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M83"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M83"/>
   <xsl:template match="@*|node()" priority="-2" mode="M83">
      <xsl:apply-templates select="*" mode="M83"/>
   </xsl:template>

   <!--PATTERN
        Element 22.1 - Originator (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 22.1 - Originator (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:pointOfContact[*/gmd:role/*/@codeListValue = 'originator']"
                 priority="1000"
                 mode="M84">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:pointOfContact[*/gmd:role/*/@codeListValue = 'originator']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Originator email address must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:organisationName) + count(*/gmd:individualName) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:organisationName) + count(*/gmd:individualName) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Originator organisation name or individual name must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M84"/>
   <xsl:template match="@*|node()" priority="-2" mode="M84">
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>

   <!--PATTERN
        Element 22.2 - Custodian (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 22.2 - Custodian (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:pointOfContact[*/gmd:role/*/@codeListValue = 'custodian']"
                 priority="1000"
                 mode="M85">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:pointOfContact[*/gmd:role/*/@codeListValue = 'custodian']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Custodian email address must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:organisationName) + count(*/gmd:individualName) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:organisationName) + count(*/gmd:individualName) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Custodian organisation name or individual name must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M85"/>
   <xsl:template match="@*|node()" priority="-2" mode="M85">
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>

   <!--PATTERN
        Element 22.3 - Distributor (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 22.3 - Distributor (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:pointOfContact[*/gmd:role/*/@codeListValue = 'distributor']"
                 priority="1000"
                 mode="M86">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:pointOfContact[*/gmd:role/*/@codeListValue = 'distributor']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Distributor email address must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:organisationName) + count(*/gmd:individualName) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:organisationName) + count(*/gmd:individualName) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Distributor organisation name or individual name must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M86"/>
   <xsl:template match="@*|node()" priority="-2" mode="M86">
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>

   <!--PATTERN
        Element 22.4 - Metadata Point of Contact (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 22.4 - Metadata Point of Contact (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:contact" priority="1000" mode="M87">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:contact"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Metadata Point of Contact email address must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:organisationName) + count(*/gmd:individualName) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:organisationName) + count(*/gmd:individualName) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Metadata Point of Contact organisation name or individual name must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M87"/>
   <xsl:template match="@*|node()" priority="-2" mode="M87">
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-MetadataPointofContact-EmailAddress-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:contact/*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress"
                 priority="1000"
                 mode="M88">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:contact/*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M88"/>
   <xsl:template match="@*|node()" priority="-2" mode="M88">
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>

   <!--PATTERN
        MEDIN-MetadataPointofContact-OrganisationName-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:contact/*/gmd:organisationName" priority="1000" mode="M89">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:contact/*/gmd:organisationName"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M89"/>
   <xsl:template match="@*|node()" priority="-2" mode="M89">
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>

   <!--PATTERN
        Element 22.5 - Owner (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 22.5 - Owner (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:pointOfContact[*/gmd:role/*/@codeListValue = 'owner']"
                 priority="1000"
                 mode="M90">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:pointOfContact[*/gmd:role/*/@codeListValue = 'owner']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:contactInfo/*/gmd:address/*/gmd:electronicMailAddress) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Owner email address must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:organisationName) + count(*/gmd:individualName) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:organisationName) + count(*/gmd:individualName) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Owner organisation name or individual name must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M90"/>
   <xsl:template match="@*|node()" priority="-2" mode="M90">
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>

   <!--PATTERN
        Element 23 - Data Format (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 23 - Data Format (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo" priority="1002" mode="M91">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:identificationInfo"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((contains(../gmd:hierarchyLevel/*/@codeListValue, 'dataset') or          contains(../gmd:hierarchyLevel/*/@codeListValue, 'series')) and          count(/*/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format) &gt; 0) or          (contains(../gmd:hierarchyLevel/*/@codeListValue, 'service'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((contains(../gmd:hierarchyLevel/*/@codeListValue, 'dataset') or contains(../gmd:hierarchyLevel/*/@codeListValue, 'series')) and count(/*/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format) &gt; 0) or (contains(../gmd:hierarchyLevel/*/@codeListValue, 'service'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Format is mandatory for datasets and series. At least one must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format"
                 priority="1001"
                 mode="M91">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:name) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:name) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Format: gmd:name tag missing
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:version) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:version) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Format: gmd:version tag missing
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name"
                 priority="1000"
                 mode="M91">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="contains(*/@xlink:href , 'http://vocab.nerc.ac.uk/collection/M01/current/') or (../gmd:name/gco:CharacterString = 'Unknown' and ../gmd:version/@gco:nilReason='inapplicable')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="contains(*/@xlink:href , 'http://vocab.nerc.ac.uk/collection/M01/current/') or (../gmd:name/gco:CharacterString = 'Unknown' and ../gmd:version/@gco:nilReason='inapplicable')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Format: xlink:href must contain 'http://vocab.nerc.ac.uk/collection/M01/current/' or gmd:version gco:nilReason must be 'inapplicable' and gmd:name/gco:CharacterString must be 'Unknown'.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M91"/>
   <xsl:template match="@*|node()" priority="-2" mode="M91">
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>

   <!--PATTERN
        MedinDataFormatName-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:distributionInfo/*/gmd:distributionFormat/*/gmd:name"
                 priority="1000"
                 mode="M92">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:distributionInfo/*/gmd:distributionFormat/*/gmd:name"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M92"/>
   <xsl:template match="@*|node()" priority="-2" mode="M92">
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>

   <!--PATTERN
        Element 33 - Character Encoding (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 33 - Character Encoding (C)</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M93"/>
   <xsl:template match="@*|node()" priority="-2" mode="M93">
      <xsl:apply-templates select="*" mode="M93"/>
   </xsl:template>

   <!--PATTERN
        Medin-Character-Encoding-CodeListValue-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue"
                 priority="1000"
                 mode="M94">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M94"/>
   <xsl:template match="@*|node()" priority="-2" mode="M94">
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>

   <!--PATTERN
        Element 24 - Frequency of Update (C)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 24 - Frequency of Update (C)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo" priority="1000" mode="M95">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:identificationInfo"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="((contains(../gmd:hierarchyLevel/*/@codeListValue, 'dataset') or          contains(../gmd:hierarchyLevel/*/@codeListValue, 'series')) and          count(*/gmd:resourceMaintenance/*/gmd:maintenanceAndUpdateFrequency) = 1) or          (contains(../gmd:hierarchyLevel/*/@codeListValue, 'service'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((contains(../gmd:hierarchyLevel/*/@codeListValue, 'dataset') or contains(../gmd:hierarchyLevel/*/@codeListValue, 'series')) and count(*/gmd:resourceMaintenance/*/gmd:maintenanceAndUpdateFrequency) = 1) or (contains(../gmd:hierarchyLevel/*/@codeListValue, 'service'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Frequency of update is mandatory for datasets and series. One must be provided.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M95"/>
   <xsl:template match="@*|node()" priority="-2" mode="M95">
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>

   <!--PATTERN
        MedinFrequencyOfUpdateInnerTextPattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:identificationInfo/*/gmd:resourceMaintenance/*/gmd:maintenanceAndUpdateFrequency"
                 priority="1000"
                 mode="M96">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:identificationInfo/*/gmd:resourceMaintenance/*/gmd:maintenanceAndUpdateFrequency"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(*/@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(*/@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element should have a value.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M96"/>
   <xsl:template match="@*|node()" priority="-2" mode="M96">
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>

   <!--PATTERN
        Element 25 - Conformity (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 25 - Conformity (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*" priority="1000" mode="M97">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Conformity information must be supplied.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M97"/>
   <xsl:template match="@*|node()" priority="-2" mode="M97">
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>

   <!--PATTERN
        Element 25.1 - INSPIRE Specification (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 25.1 - INSPIRE Specification (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result" priority="1005"
                 mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:specification) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:specification) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Quality: report: result: specification tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:specification"
                 priority="1004"
                 mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:specification"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:title) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:title) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Quality: report: result: specification: title tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:date) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:date) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Quality: report: result: specification: date tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:specification/*/gmd:date"
                 priority="1003"
                 mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:specification/*/gmd:date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:date) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:date) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Quality: report: result: specification: date: date tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:dateType) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:dateType) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Quality: report: result: specification: date: dateType tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(*/gmd:dateType/gmd:CI_DateTypeCode) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:dateType/gmd:CI_DateTypeCode) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Quality: report: result: specification: date: dateType: CI_DateTypeCode tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:specification/*/gmd:date/*/gmd:dateType/gmd:CI_DateTypeCode"
                 priority="1002"
                 mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:specification/*/gmd:date/*/gmd:dateType/gmd:CI_DateTypeCode"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(@codeList) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeList) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Quality: report: result: specification: date: dateType: codeList must have a value.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="@codeListValue = 'creation' or @codeListValue = 'revision' or @codeListValue = 'publication'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="@codeListValue = 'creation' or @codeListValue = 'revision' or @codeListValue = 'publication'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Quality: report: result: specification: date: dateType: codeListValue must have a creation, revision or publication.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:pass"
                 priority="1001"
                 mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:pass"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="gco:Boolean = 'true' or gco:Boolean = 'false'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gco:Boolean = 'true' or gco:Boolean = 'false'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Quality: report: result: pass: must be true or false.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*" priority="1000"
                 mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:explanation) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:explanation) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Quality: report: result: explanation tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:pass) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:pass) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Data Quality: report: result: pass tag is mandatory.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M98"/>
   <xsl:template match="@*|node()" priority="-2" mode="M98">
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>

   <!--PATTERN
        Medin-Conformance-Explanation-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:explanation"
                 priority="1000"
                 mode="M99">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:explanation"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M99"/>
   <xsl:template match="@*|node()" priority="-2" mode="M99">
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>

   <!--PATTERN
        MedinSpecificationTitleGcoTypeTest-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:specification/*/gmd:title"
                 priority="1000"
                 mode="M100">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:specification/*/gmd:title"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M100"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M100"/>
   <xsl:template match="@*|node()" priority="-2" mode="M100">
      <xsl:apply-templates select="*" mode="M100"/>
   </xsl:template>

   <!--PATTERN
        MedinSpecificationDateGcoTypeTest-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:specification/*/gmd:date/*/gmd:date"
                 priority="1000"
                 mode="M101">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:specification/*/gmd:date/*/gmd:date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M101"/>
   <xsl:template match="@*|node()" priority="-2" mode="M101">
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>

   <!--PATTERN
        MedinSpecificationDateTypeInnerTextTest-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:specification/*/gmd:date/*/gmd:dateType"
                 priority="1000"
                 mode="M102">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:specification/*/gmd:date/*/gmd:dateType"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(*/@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(*/@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element should have a value.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M102"/>
   <xsl:template match="@*|node()" priority="-2" mode="M102">
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]" priority="1000" mode="M103">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata[1]"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> Conformity: There must be at least one gmd:DQ_ConformanceResult </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M103"/>
   <xsl:template match="@*|node()" priority="-2" mode="M103">
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][text() = 'Commission Regulation (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services']"
                 priority="1000"
                 mode="M104">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][text() = 'Commission Regulation (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services']"/>
      <xsl:variable name="localPassPath"
                    select="parent::gmd:title/parent::gmd:CI_Citation/parent::gmd:specification/following-sibling::gmd:pass"/>
      <xsl:variable name="localDatePath"
                    select="parent::gmd:title/following-sibling::gmd:date/gmd:CI_Date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localPassPath/gco:Boolean"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localPassPath/gco:Boolean">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Conformity: The pass value shall be true or false/&gt;
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localDatePath/gmd:date/gco:Date[normalize-space(text()) = '2010-12-08']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localDatePath/gmd:date/gco:Date[normalize-space(text()) = '2010-12-08']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Conformity: The date reported shall be 2010-12-08 (date of publication), in a conformance
        statement for <xsl:text/>
                  <xsl:copy-of select="$inspire1089"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localDatePath/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localDatePath/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Conformity: The dateTypeCode reported shall be publication, in a conformance statement for
        <xsl:text/>
                  <xsl:copy-of select="$inspire1089"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M104"/>
   <xsl:template match="@*|node()" priority="-2" mode="M104">
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][text() = 'COMMISSION REGULATION (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services']"
                 priority="1000"
                 mode="M105">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][text() = 'COMMISSION REGULATION (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services']"/>
      <xsl:variable name="localPassPath"
                    select="parent::gmd:title/parent::gmd:CI_Citation/parent::gmd:specification/following-sibling::gmd:pass"/>
      <xsl:variable name="localDatePath"
                    select="parent::gmd:title/following-sibling::gmd:date/gmd:CI_Date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localPassPath/gco:Boolean"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localPassPath/gco:Boolean">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        (Conformity): The pass value shall be true or false"/&gt;
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localDatePath/gmd:date/gco:Date[normalize-space(text()) = '2010-12-08']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localDatePath/gmd:date/gco:Date[normalize-space(text()) = '2010-12-08']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        (Conformity): The date reported shall be 2010-12-08 (date of publication), in a conformance
        statement for <xsl:text/>
                  <xsl:copy-of select="$inspire1089"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localDatePath/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localDatePath/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        (Conformity): The DateTypeCode reported shall be publication, in a conformance statement for
        <xsl:text/>
                  <xsl:copy-of select="$inspire1089"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M105"/>
   <xsl:template match="@*|node()" priority="-2" mode="M105">
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][text() = 'Commission Regulation (EC) No 976/2009 of 19 October 2009 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards the Network Services']"
                 priority="1000"
                 mode="M106">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][text() = 'Commission Regulation (EC) No 976/2009 of 19 October 2009 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards the Network Services']"/>
      <xsl:variable name="localPassPath"
                    select="parent::gmd:title/parent::gmd:CI_Citation/parent::gmd:specification/following-sibling::gmd:pass"/>
      <xsl:variable name="localDatePath"
                    select="parent::gmd:title/following-sibling::gmd:date/gmd:CI_Date"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localPassPath/gco:Boolean"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localPassPath/gco:Boolean">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        (Conformity): The pass value shall be true or false/&gt;
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localDatePath/gmd:date/gco:Date[normalize-space(text()) = '2010-12-08']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localDatePath/gmd:date/gco:Date[normalize-space(text()) = '2010-12-08']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        (Conformity): The date reported shall be 2010-12-08 (date of publication), in a conformance
        statement for <xsl:text/>
                  <xsl:copy-of select="$inspire976"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$localDatePath/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$localDatePath/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue = 'publication']">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        (Conformity): The dateTypeCode reported shall be publication, in a conformance statement for
        <xsl:text/>
                  <xsl:copy-of select="$inspire976"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M106"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M106"/>
   <xsl:template match="@*|node()" priority="-2" mode="M106">
      <xsl:apply-templates select="*" mode="M106"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'service']"
                 priority="1000"
                 mode="M107">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'service']"/>
      <xsl:variable name="count1089"
                    select="count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089])"/>
      <xsl:variable name="count1089x"
                    select="count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089x])"/>
      <xsl:variable name="count976"
                    select="count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire976])"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$count1089 &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$count1089 &lt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> (Conformity): A service record should have no more than one
        Conformance report to [1089/2010] (counted <xsl:text/>
                  <xsl:copy-of select="$count1089"/>
                  <xsl:text/>) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$count1089x &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$count1089x &lt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> (Conformity): A service record should have no more than one
        Conformance report to [1089/2010] (counted <xsl:text/>
                  <xsl:copy-of select="$count1089"/>
                  <xsl:text/>) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$count976 &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$count976 &lt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> (Conformity): A service record should have no more than one
        Conformance report to [976/2009] (counted <xsl:text/>
                  <xsl:copy-of select="$count976"/>
                  <xsl:text/>) </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="         not(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089]) and         not(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089x]) and         not(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire976])">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="not(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089]) and not(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire1089x]) and not(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[1][normalize-space(text()) = $inspire976])">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text> (Conformity): A service record should have a Conformance report to [976/2009] or [1089/2010]
      </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M107"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M107"/>
   <xsl:template match="@*|node()" priority="-2" mode="M107">
      <xsl:apply-templates select="*" mode="M107"/>
   </xsl:template>

   <!--PATTERN
        -->


  <!--RULE
      -->
<xsl:template match="       //gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'dataset'] |       //gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'series']"
                 priority="1001"
                 mode="M108">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="       //gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'dataset'] |       //gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'series']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="         count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title[contains(*[1], $inspire1089)]) = 1 or         count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title[contains(*[1], $inspire1089x)]) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title[contains(*[1], $inspire1089)]) = 1 or count(parent::gmd:level/parent::gmd:DQ_Scope/parent::gmd:scope/following-sibling::gmd:report/gmd:DQ_DomainConsistency/*/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title[contains(*[1], $inspire1089x)]) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> (Conformity): Datasets and series must provide one (and only one) conformance report to [1089/2010]. The INSPIRE
        rule tells us this must be the EXACT title of the regulation, which is: Commission Regulation (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M108"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'service']"
                 priority="1000"
                 mode="M108">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:MD_Metadata[1]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue = 'service']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(following::gmd:levelDescription) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(following::gmd:levelDescription) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> (Quality Scope): gmd:levelDescription is
        missing ~ the level shall be named using element
        gmd:scope/gmd:DQ_Scope/gmd:levelDescription/gmd:MD_ScopeDescription/gmd:other element with a
        Non-empty Free Text Element containing the term "service" </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="         following::gmd:levelDescription/gmd:MD_ScopeDescription/gmd:other/gco:CharacterString/text() != 'service' or         following::gmd:levelDescription/gmd:MD_ScopeDescription/gmd:other/gmx:Anchor/text() != 'service'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="following::gmd:levelDescription/gmd:MD_ScopeDescription/gmd:other/gco:CharacterString/text() != 'service' or following::gmd:levelDescription/gmd:MD_ScopeDescription/gmd:other/gmx:Anchor/text() != 'service'">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text> (Quality Scope): Value (gmd:MD_ScopeDescription/gmd:other) should be "service" </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M108"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M108"/>
   <xsl:template match="@*|node()" priority="-2" mode="M108">
      <xsl:apply-templates select="*" mode="M108"/>
   </xsl:template>

   <!--PATTERN
        Element 25.2 - Degree of Conformity (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 25.2 - Degree of Conformity (M)</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M109"/>
   <xsl:template match="@*|node()" priority="-2" mode="M109">
      <xsl:apply-templates select="*" mode="M109"/>
   </xsl:template>

   <!--PATTERN
        Element 25.3 - Explanation (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 25.3 - Explanation (M)</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M110"/>
   <xsl:template match="@*|node()" priority="-2" mode="M110">
      <xsl:apply-templates select="*" mode="M110"/>
   </xsl:template>

   <!--PATTERN
        Element 26 - Date of Update of Metadata (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 26 - Date of Update of Metadata (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*" priority="1001" mode="M111">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(/*/gmd:fileIdentifier) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(/*/gmd:fileIdentifier) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        File Identifier must be supplied.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M111"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="/" priority="1000" mode="M111">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(/*/gmd:dateStamp) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(/*/gmd:dateStamp) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Metadata Date must be supplied.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M111"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M111"/>
   <xsl:template match="@*|node()" priority="-2" mode="M111">
      <xsl:apply-templates select="*" mode="M111"/>
   </xsl:template>

   <!--PATTERN
        MedinDateOfUpdateOfMetadata-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:dateStamp" priority="1000" mode="M112">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:dateStamp"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M112"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M112"/>
   <xsl:template match="@*|node()" priority="-2" mode="M112">
      <xsl:apply-templates select="*" mode="M112"/>
   </xsl:template>

   <!--PATTERN
        MedinFileIdentifier-NotNillable-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:fileIdentifier" priority="1000" mode="M113">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:fileIdentifier"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(normalize-space(.)) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> MEDIN: The
        <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element is not nillable and shall have a value. This test may be called by the following 
        Metadata Items: Title, Abstract, Keyword, Geographic Bounding
        Box, Spatial Reference System, Responsible Organisation, Metadata Date,
        Metadata Point of Contact, (Unique) Resource Identifier, Specification, and in the
        Ancillary test Metadata file identifier </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M113"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M113"/>
   <xsl:template match="@*|node()" priority="-2" mode="M113">
      <xsl:apply-templates select="*" mode="M113"/>
   </xsl:template>

   <!--PATTERN
        Element 27 - Metadata Standard Name (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 27 - Metadata Standard Name (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*" priority="1000" mode="M114">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:metadataStandardName) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:metadataStandardName) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Metadata standard name is mandatory and only one occurence allowed.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(contains(gmd:metadataStandardName/*/@xlink:href, 'http://vocab.nerc.ac.uk/collection/M25/current/MEDIN/'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(contains(gmd:metadataStandardName/*/@xlink:href, 'http://vocab.nerc.ac.uk/collection/M25/current/MEDIN/'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Metadata standard name: the xlink:href must contain 'http://vocab.nerc.ac.uk/collection/M25/current/MEDIN/'
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M114"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M114"/>
   <xsl:template match="@*|node()" priority="-2" mode="M114">
      <xsl:apply-templates select="*" mode="M114"/>
   </xsl:template>

   <!--PATTERN
        MedinMetadataStandardNameInnerText-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:metadataStandardName" priority="1000" mode="M115">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:metadataStandardName"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(gmx:Anchor) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(gmx:Anchor) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element should have a value.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M115"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M115"/>
   <xsl:template match="@*|node()" priority="-2" mode="M115">
      <xsl:apply-templates select="*" mode="M115"/>
   </xsl:template>

   <!--PATTERN
        Element 28 - Metadata Standard Version (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 28 - Metadata Standard Version (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*" priority="1000" mode="M116">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:metadataStandardVersion) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:metadataStandardVersion) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Metadata standard version is mandatory and only one occurence allowed.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M116"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M116"/>
   <xsl:template match="@*|node()" priority="-2" mode="M116">
      <xsl:apply-templates select="*" mode="M116"/>
   </xsl:template>

   <!--PATTERN
        MedinMetadataStandardVersionInnerText-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:metadataStandardVersion" priority="1000" mode="M117">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*/gmd:metadataStandardVersion"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="string-length(gco:CharacterString) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(gco:CharacterString) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element should have a value.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M117"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M117"/>
   <xsl:template match="@*|node()" priority="-2" mode="M117">
      <xsl:apply-templates select="*" mode="M117"/>
   </xsl:template>

   <!--PATTERN
        Element 29 - Metadata Language (M)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 29 - Metadata Language (M)</svrl:text>

  <!--RULE
      -->
<xsl:template match="/*" priority="1000" mode="M118">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(gmd:language) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:language) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Metadata Language is mandatory and one occurrence allowed.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M118"/>
   <xsl:template match="@*|node()" priority="-2" mode="M118">
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>

   <!--PATTERN
        MedinMetadataLanguageLanguagePattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:language" priority="1000" mode="M119">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:language"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(./gco:CharacterString = 'eng' or ./gco:CharacterString = 'cym' or ./gco:CharacterString = 'gle' or ./gco:CharacterString = 'gla' or ./gco:CharacterString = 'cor') or          (./gmd:LanguageCode/@codeListValue='eng' or ./gmd:LanguageCode/@codeListValue='cym' or ./gmd:LanguageCode/@codeListValue='gle' or ./gmd:LanguageCode/@codeListValue='gla' or ./gmd:LanguageCode/@codeListValue='cor' or ./gmd:LanguageCode/@codeListValue='zxx')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(./gco:CharacterString = 'eng' or ./gco:CharacterString = 'cym' or ./gco:CharacterString = 'gle' or ./gco:CharacterString = 'gla' or ./gco:CharacterString = 'cor') or (./gmd:LanguageCode/@codeListValue='eng' or ./gmd:LanguageCode/@codeListValue='cym' or ./gmd:LanguageCode/@codeListValue='gle' or ./gmd:LanguageCode/@codeListValue='gla' or ./gmd:LanguageCode/@codeListValue='cor' or ./gmd:LanguageCode/@codeListValue='zxx')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> must be one of eng, cym, gle, gla, cor or zxx (for no linguistic context).
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M119"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M119"/>
   <xsl:template match="@*|node()" priority="-2" mode="M119">
      <xsl:apply-templates select="*" mode="M119"/>
   </xsl:template>

   <!--PATTERN
        MedinMetadataLanguageGcoTypeTestPattern-->


  <!--RULE
      -->
<xsl:template match="/*/gmd:language" priority="1000" mode="M120">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/gmd:language"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                    (@gco:nilReason = 'inapplicable' or                   @gco:nilReason = 'missing' or                    @gco:nilReason = 'template' or                   @gco:nilReason = 'unknown' or                   @gco:nilReason = 'withheld')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        The <xsl:text/>
                  <xsl:value-of select="name(.)"/>
                  <xsl:text/> element must have a value or a Nil Reason.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M120"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M120"/>
   <xsl:template match="@*|node()" priority="-2" mode="M120">
      <xsl:apply-templates select="*" mode="M120"/>
   </xsl:template>

   <!--PATTERN
        Element 30 - Parent ID (O)-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element 30 - Parent ID (O)</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M121"/>
   <xsl:template match="@*|node()" priority="-2" mode="M121">
      <xsl:apply-templates select="*" mode="M121"/>
   </xsl:template>
</xsl:stylesheet>