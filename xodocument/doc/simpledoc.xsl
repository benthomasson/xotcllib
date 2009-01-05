<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="document">
<html>
<head>
<LINK REL="StyleSheet" HREF="style.css" TYPE="text/css" />
<title><xsl:value-of select="title" /></title>
</head>
<body>
<h2><xsl:value-of select="title"/></h2>
<p>
<xsl:value-of select="synopsis" />
</p>
<b>Sections:</b>
<ul>
<xsl:for-each select="section|docSection">
<li> <xsl:element name="a">
    <xsl:attribute name="href">#<xsl:value-of select="title" /></xsl:attribute>
<xsl:value-of select="title" />
</xsl:element> </li>
</xsl:for-each>
</ul>
<xsl:apply-templates/>
</body>
</html>
</xsl:template>

<xsl:template match="section">
<div>
<hr />
<xsl:element name="a">
    <xsl:attribute name="name"><xsl:value-of select="title" /></xsl:attribute>
</xsl:element>
<h3><xsl:value-of select="title" /></h3>
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="text">
<p><xsl:value-of select="body" /></p>
</xsl:template>

<xsl:template match="example">
<h3><xsl:value-of select="title"/></h3>
<pre><xsl:value-of select="body" /></pre>
</xsl:template>

<xsl:template match="title">
</xsl:template>

</xsl:stylesheet>

