<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:func="http://exslt.org/functions"
    xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/xhtml"
    extension-element-prefixes="exsl func"
    xmlns:htmlbook="https://github.com/oreillymedia/HTMLBook"
    exclude-result-prefixes="exsl func h">
  <xsl:output method="xml"
              encoding="UTF-8"/>
  <xsl:preserve-space elements="*"/>

<!-- Do add border div for figure images in cookbook series -->
<xsl:param name="figure.border.div" select="1"/>


<!-- Generate separate footnote-call markers, so that we don't
       need to rely on AH counters to do footnote numbering -->
<xsl:param name="process.footnote.callouts.only" select="1"/>


  <!-- Logic for processing sect2 headings with labels (including section numbers) -->
  <xsl:template match="h:section[@data-type='sect2']/h:h2" mode="process-heading">
    <xsl:param name="autogenerate.labels" select="$autogenerate.labels"/>
    <!-- Labeled element is typically the parent element of the heading (e.g., <section> or <figure>) -->
    <xsl:param name="labeled-element" select="(parent::h:header/parent::*|parent::*[not(self::h:header)])[1]"/>
    <!-- Labeled element semantic name is typically the parent element of the heading's @data-type -->
    <xsl:param name="labeled-element-semantic-name" select="(parent::h:header/parent::*|parent::*[not(self::h:header)])[1]/@data-type"/>
    <!-- Name for output heading element; same as current node name by default -->
    <xsl:param name="output-element-name" select="local-name(.)"/>
    <xsl:element name="{$output-element-name}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="@*"/>

    </xsl:element>
  </xsl:template>

  <!-- Creating the sect1 labels (read: creating the X.X section numbering) -->
  <xsl:template match="h:section[@data-type='sect1']" mode="label.markup">
    <xsl:variable name="current-node" select="."/>
    
  </xsl:template>
  
  <!-- Creating the sect2 labels (read: creating the X.X.X section numbering) -->
  <xsl:template match="h:section[@data-type='sect2']" mode="label.markup">
    <!-- END OVERRIDE -->
    <xsl:variable name="current-node" select="."/>
    
  </xsl:template>
  <!-- Utility template -->
  <xsl:template name="check.chap.for.intro">
    <xsl:param name="chapter" select="."/>
    <xsl:choose>
      <xsl:when test="$chapter/h:section[@data-type='sect1'][1]/h:h1 = 'Introduction'">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="check.sect1.for.intro">
    <xsl:param name="sect1" select="."/>
    <xsl:choose>
      <xsl:when test="$sect1/h:section[@data-type='sect2'][1]/h:h2 = 'Introduction'">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ***************** Custom xref handling ************  -->
  <!-- Overrides xrefgen.xsl -->

  <!-- Custom xrefs to numbered sections -->
  <xsl:template match="h:section[@data-type='sect1']" mode="xref-to">
    <xsl:param name="referrer"/>
    <xsl:param name="xrefstyle"/>
    <xsl:param name="verbose" select="1"/>
    <xsl:choose>
      <xsl:when test="h:h1">
        <xsl:apply-templates select="." mode="object.xref.markup">
          <xsl:with-param name="purpose" select="'xref'"/>
          <!-- BEGIN OVERRIDE -->
          <xsl:with-param name="xrefstyle" select="'template: Section %n, &#x201c;%t,&#x201d;'"/>
          <!-- END OVERRIDE -->
          <xsl:with-param name="referrer" select="$referrer"/>
          <xsl:with-param name="verbose" select="$verbose"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <!-- Otherwise, throw warning, and print out ??? -->
        <xsl:call-template name="log-message">
          <xsl:with-param name="type" select="'WARNING'"/>
          <xsl:with-param name="message">
            <xsl:text>Cannot output gentext for XREF to section (id:</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text>)</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:text>???</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="h:section[@data-type='sect2']" mode="xref-to">
    <xsl:param name="referrer"/>
    <xsl:param name="xrefstyle"/>
    <xsl:param name="verbose" select="1"/>
    <xsl:choose>
      <xsl:when test="h:h2">
        <xsl:apply-templates select="." mode="object.xref.markup">
          <xsl:with-param name="purpose" select="'xref'"/>
          <!-- BEGIN OVERRIDE -->
          <xsl:with-param name="xrefstyle" select="'template: Section %n, &#x201c;%t,&#x201d;'"/>
          <!-- END OVERRIDE -->
          <xsl:with-param name="referrer" select="$referrer"/>
          <xsl:with-param name="verbose" select="$verbose"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <!-- Otherwise, throw warning, and print out ??? -->
        <xsl:call-template name="log-message">
          <xsl:with-param name="type" select="'WARNING'"/>
          <xsl:with-param name="message">
            <xsl:text>Cannot output gentext for XREF to section (id:</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text>)</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:text>???</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- ***************** TOC HANDLING ***************** -->
<!-- ************* Overrides tocgen.xsl ************* -->

<xsl:template match="h:section[not(@data-type = 'dedication' or @data-type = 'titlepage' or @data-type = 'toc' or @data-type = 'colophon' or @data-type = 'copyright-page' or @data-type = 'halftitlepage')]|h:div[@data-type='part']" mode="tocgen">
    <xsl:param name="toc.section.depth" select="$toc.section.depth"/>
    <xsl:choose>
      <!-- Don't output entry for section elements at a level that is greater than specified $toc.section.depth -->
      <xsl:when test="self::h:section[contains(@data-type, 'sect') and htmlbook:section-depth(.) != '' and htmlbook:section-depth(.) &gt; $toc.section.depth]"/>
      <!-- Otherwise, go ahead -->
      <xsl:otherwise>
  <xsl:element name="li">
    <xsl:attribute name="data-type">
      <xsl:value-of select="@data-type"/>
    </xsl:attribute>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
    <xsl:with-param name="object" select="."/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="title.markup"/>
    </a>
    <!-- Make sure there are descendants that conform to $toc.section.depth restrictions before generating nested TOC <ol> -->
    <xsl:if test="descendant::h:section[not(contains(@data-type, 'sect')) or htmlbook:section-depth(.) &lt;= $toc.section.depth]|descendant::h:div[@data-type='part']">
      <ol>
        <xsl:apply-templates mode="tocgen">
          <xsl:with-param name="toc.section.depth" select="$toc.section.depth"/>
        </xsl:apply-templates>
      </ol>
    </xsl:if>
  </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="string-replace-all">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="by"/>
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)"/>
        <xsl:value-of select="$by"/>
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="substring-after($text,$replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="by" select="$by"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

