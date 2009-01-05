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
<ul>
<xsl:for-each select="section">
<li> <xsl:element name="a">
    <xsl:attribute name="href">#<xsl:value-of select="title" /></xsl:attribute>
<xsl:value-of select="number" /><xsl:value-of select="title" />
</xsl:element> </li>
</xsl:for-each>
</ul>
<xsl:apply-templates/>
</body>
</html>
</xsl:template>

<xsl:template match="section">
<div>
<hr/>
<xsl:element name="a">
    <xsl:attribute name="name"><xsl:value-of select="title" /></xsl:attribute>
</xsl:element>
<h3><xsl:value-of select="number"/><xsl:value-of select="title" /></h3>
<ul>
<xsl:for-each select="section">
<li> <xsl:element name="a">
    <xsl:attribute name="href">#<xsl:value-of select="title" /></xsl:attribute>
<xsl:value-of select="number" /><xsl:value-of select="title" />
</xsl:element> </li>
</xsl:for-each>
</ul>
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="text">
<p>
<xsl:apply-templates/>
</p>
</xsl:template>

<xsl:template match="code">
<b>
<xsl:apply-templates/>
</b>
</xsl:template>

<xsl:template match="example">
<h4>Example:  <xsl:value-of select="title"/></h4>
<pre class="code">
<xsl:value-of select="body" />
<span/>
</pre>
</xsl:template>

<xsl:template match="title">
</xsl:template>

<xsl:template match="number">
</xsl:template>

<xsl:template match="unorderedList">
<ul>
<xsl:for-each select="item">
<li><xsl:apply-templates/></li>
</xsl:for-each>
</ul>
</xsl:template>

<xsl:template match="orderedList">
<ol>
<xsl:for-each select="item">
<li> <xsl:value-of select="." /></li>
</xsl:for-each>
</ol>
</xsl:template>

<xsl:template match="parameter">
<div>
<hr />
<p>
<xsl:element name="a">
    <xsl:attribute name="name"><xsl:value-of select="name" /></xsl:attribute>
</xsl:element>
<h3><xsl:value-of select="name" /></h3>
<b>Description:</b><br/>
    <pre>
    <xsl:value-of select="description" />
    </pre><br/>
</p>
</div>
</xsl:template>

<xsl:template match="command">
<div>
<hr />
<p>
<xsl:element name="a">
    <xsl:attribute name="name"><xsl:value-of select="name" /></xsl:attribute>
</xsl:element>
<h3><xsl:value-of select="name" /></h3>
<b>Synopsis:</b><br/>
    <b><xsl:value-of select="name" /></b>
    <xsl:for-each select="argument">
    &lt;<xsl:value-of select="name" />&gt;
    </xsl:for-each><br/>
<br />
<b>Description:</b><br/>
    <pre>
    <xsl:value-of select="description" />
    </pre><br/>
<b>Arguments:</b>
<ul>
<xsl:for-each select="positionalArgument">
    <li><b><xsl:value-of select="name" /></b>: (<xsl:value-of select="type" />) <xsl:value-of select="explanation" /></li>
</xsl:for-each>
<xsl:for-each select="argument">
    <li><b><xsl:value-of select="name" /></b>: <xsl:value-of select="explanation" /></li>
</xsl:for-each>
<span/>
</ul>
<b>Returns:</b><br/>
<ul>
<xsl:for-each select="return">
    <li><xsl:value-of select="." /></li>
</xsl:for-each>
</ul>
<br/>
<b>Example:</b><br/>
<pre class="code">
<xsl:value-of select="example" />
</pre>
</p>
</div>
</xsl:template>

<xsl:template match="parameterList">
<h3>Parameters:</h3>
<ul>
<xsl:for-each select="../parameter">
<li> <xsl:element name="a">
    <xsl:attribute name="href">#<xsl:value-of select="name" /></xsl:attribute>
<xsl:value-of select="name" />
</xsl:element> </li>
</xsl:for-each>
</ul>
</xsl:template>

<xsl:template match="commandList">
<h3>Commands:</h3>
<ul>
<xsl:for-each select="../command">
<li> <xsl:element name="a">
    <xsl:attribute name="href">#<xsl:value-of select="name" /></xsl:attribute>
<xsl:value-of select="name" />
</xsl:element> </li>
</xsl:for-each>
</ul>
</xsl:template>

<xsl:template match="link">
<xsl:element name="a">
    <xsl:attribute name="href"><xsl:value-of select="href" /></xsl:attribute>
<xsl:value-of select="text" />
</xsl:element> 
</xsl:template>

</xsl:stylesheet>

