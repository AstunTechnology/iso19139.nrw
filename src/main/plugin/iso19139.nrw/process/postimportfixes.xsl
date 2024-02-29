<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
                xmlns:nrw="http://naturalresources.wales/nrw">
    
    <!-- Define a map of inspire theme values and their corresponding xlink:href attributes -->
    <xsl:variable name="valueToHrefMap">
        <map>
            <entry value="Addresses" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/ad"/>
            <entry value="Administrative units" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/au"/>
            <entry value="Agricultural and aquaculture facilities" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/af"/>
            <entry value="Area management/restriction/regulation zones and reporting units" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/am"/>
            <entry value="Atmospheric conditions" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/ac"/>
            <entry value="Bio-geographical regions" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/br"/>
            <entry value="Buildings" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/bu"/>
            <entry value="Cadastral parcels" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/cp"/>
            <entry value="Coordinate reference systems" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/rs"/>
            <entry value="Elevation" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/el"/>
            <entry value="Energy resources" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/er"/>
            <entry value="Environmental monitoring facilities" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/ef"/>
            <entry value="Geographical grid systems" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/gg"/>
            <entry value="Geographical names" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/gn"/>
            <entry value="Geology" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/ge"/>
            <entry value="Habitats and biotopes" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/hb"/>
            <entry value="Human health and safety" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/hh"/>
            <entry value="Hydrography" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/hy"/>
            <entry value="Land cover" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/lc"/>
            <entry value="Land use" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/lu"/>
            <entry value="Meteorological geographical features" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/mf"/>
            <entry value="Mineral resources" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/mr"/>
            <entry value="Natural risk zones" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/nz"/>
            <entry value="Oceanographic geographical features" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/of"/>
            <entry value="Orthoimagery" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/oi"/>
            <entry value="Population distribution - demography" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/pd"/>
            <entry value="Production and industrial facilities" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/pf"/>
            <entry value="Protected sites" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/ps"/>
            <entry value="Sea regions" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/sr"/>
            <entry value="Soil" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/so"/>
            <entry value="Species distribution" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/sd"/>
            <entry value="Statistical units" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/su"/>
            <entry value="Transport networks" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/tn"/>
            <entry value="Utility and government services" href="https://www.eionet.europa.eu/gemet/en/inspire-theme/us"/>
        </map>
    </xsl:variable>

    <!-- Identity transform for all nodes and attributes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Remove gco:nilReason attribute from the root element -->
    <xsl:template match="/gmd:MD_Metadata/@gco:nilReason"/>
    
    <!-- Convert INSPIRE keyword from gco:CharacterString to gmx:Anchor -->
    <xsl:template match="/gmd:MD_Metadata
        /gmd:identificationInfo
        /gmd:MD_DataIdentification
        /gmd:descriptiveKeywords
        /gmd:MD_Keywords
        /gmd:keyword[../gmd:thesaurusName
        /gmd:CI_Citation
        /gmd:title
        /gmx:Anchor='GEMET - INSPIRE themes, version 1.0']">
        
        <gmx:Anchor xlink:href="{$valueToHrefMap/map/entry[@value=current()]/@href}">
            <xsl:value-of select="gco:CharacterString"/>
        </gmx:Anchor>
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
</xsl:stylesheet>
