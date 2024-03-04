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



    


    <!-- POINT OF CONTACT -->

    <!-- <sch:pattern>
        <sch:title>$loc/strings/EAMP300</sch:title>
    </sch:pattern>

    <sch:pattern>
        <sch:title>EAMP-mi3-GeneralContact</sch:title>
        <sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty">
            <sch:assert test="count(./gmd:individualName)=1">$loc/strings/EAMP300.alert.name</sch:assert>
            <sch:assert test="count(./gmd:organisationName)=1">$loc/strings/EAMP300.alert.org</sch:assert>
            <sch:assert test="count(./gmd:positionName)=1">$loc/strings/EAMP300.alert.position</sch:assert>
            <sch:assert test="count(./gmd:role)=1">$loc/strings/EAMP300.alert.role</sch:assert>
     </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:title>EAMP-mi4-Custodian</sch:title>
        <sch:rule context="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification">
            <sch:assert test="count(//gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='custodian'])=2">$loc/strings/EAMP300.alert.custodian</sch:assert>
            <sch:assert test="count(//gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='owner'])=1">$loc/strings/EAMP300.alert.owner</sch:assert>
            <sch:assert test="count(//gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='pointOfContact'])=1">$loc/strings/EAMP300.alert.poc</sch:assert>
         </sch:rule>
     </sch:pattern>

    <sch:pattern>
        <sch:title>EAMP-mi5-Resourcetype</sch:title>
        <sch:rule context="/*[1]">
            <sch:assert test="count(gmd:hierarchyLevel) = 1">Resource type is mandatory. One shall be provided.</sch:assert>
            <sch:assert test="gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or
                gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series' or
                gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'nonGeographicDataset' or
                gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'service'">Value of resource type shall be 'dataset', 'series', 'nonGeographicDataset' or 'service'.</sch:assert>
        </sch:rule>
    </sch:pattern> -->

</sch:schema>
