<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- EAMP v1.1 SCHEMATRON-->

    <sch:title xmlns="http://www.w3.org/2001/XMLSchema">Schematron validation for Natural Resources Wales Metadata Profile v1</sch:title>

    <sch:ns prefix="gml" uri="http://www.opengis.net/gml"/>
    <sch:ns prefix="gmd" uri="http://www.isotc211.org/2005/gmd"/>
    <sch:ns prefix="srv" uri="http://www.isotc211.org/2005/srv"/>
    <sch:ns prefix="gco" uri="http://www.isotc211.org/2005/gco"/>
    <sch:ns prefix="nrw" uri="http://naturalresources.wales/nrw"/> 
    <sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
    <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>

    <!-- NRW additional elements -->
    
    <!--Internal Location is Mandatory-->
    <sch:pattern>
        <sch:title>$loc/strings/NRW100</sch:title>
        <sch:rule context="//gmd:contentInfo/nrw:MD_ContentInfo/nrw:internalInfo/nrw:MD_InternalInfo/nrw:internalLocationInfo">
            <sch:assert test="string-length(.)>0">$loc/strings/NRW100.alert.nolocation</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!--Internal Location is Mandatory-->
    <sch:pattern>
        <sch:title>$loc/strings/NRW101</sch:title>
        <sch:rule context="//gmd:contentInfo/nrw:MD_ContentInfo/nrw:internalInfo/nrw:MD_InternalInfo/nrw:internalContactInfo">
            <sch:assert test="string-length(.)>0">$loc/strings/NRW101.alert.nocontact</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- additional rules for standard elements -->

    <!-- Vertical Extent -->
    
    <!-- There should be only one -->
   <sch:pattern>
        <sch:title>$loc/strings/NRW200</sch:title>
        <sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent">
            <sch:assert test="count(./gmd:verticalElement)=1">$loc/strings/NRW200.alert</sch:assert>
     </sch:rule>
    </sch:pattern>

</sch:schema>
