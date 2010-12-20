<?xml version="1.0"?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    xmlns:georss="http://www.georss.org/georss" xmlns:twitter="http://api.twitter.com">
<xsl:output omit-xml-declaration="yes"/>

<!-- NB: if you do a full 'xpath-expr FROM xmlfile AS xslfile',
       replace this xsl:template with the stuff in that section -->

<xsl:template match="/">
<xsl:apply-templates select="//item"/>
</xsl:template>

<xsl:template match="item">
    <xsl:apply-templates select="link/text()" />
    <xsl:text> | </xsl:text>
    <xsl:apply-templates select="guid/text()" />
    <xsl:text> | </xsl:text>
    <xsl:apply-templates select="pubDate/text()" />
    <xsl:text> | </xsl:text>
    <xsl:value-of select="translate(title/text(),'&#10;&#13;',' ')" /><xsl:text>
</xsl:text>
</xsl:template>


<!-- identity starts here -->
<xsl:template match="*">
               <xsl:copy>
               <xsl:apply-templates select="*|@*|text()"/>
               </xsl:copy>
</xsl:template>

<xsl:template match="@*|text()">
               <xsl:copy/>
</xsl:template>
</xsl:stylesheet>
