<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:parse="http://cdlib.org/xtf/parse"
   xmlns:xtf="http://cdlib.org/xtf"
   exclude-result-prefixes="#all">
   
   <!--
      Copyright (c) 2012, Regents of the University of California
      All rights reserved.
      
      Redistribution and use in source and binary forms, with or without 
      modification, are permitted provided that the following conditions are 
      met:
      
      - Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
      - Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution.
      - Neither the name of the University of California nor the names of its
      contributors may be used to endorse or promote products derived from 
      this software without specific prior written permission.
      
      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
      AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
      IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
      ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
      LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
      CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
      SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
      INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
      CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
      ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
      POSSIBILITY OF SUCH DAMAGE.
   -->



   <!-- ====================================================================== -->
   <!-- Import Common Templates and Functions                                  -->
   <!-- ====================================================================== -->
   
   <xsl:import href="../common/preFilterCommon.xsl"/>
   
   <!-- ====================================================================== -->
   <!-- Import OAC EAD templates and functions                                 -->
   <!-- ====================================================================== -->
   
   <xsl:import href="./supplied-headings.xsl"/>
   <!-- xmlns:oac="http://oac.cdlib.org" oac:supply-heading -->
   <xsl:import href="./at2oac.xsl"/>


   <!-- ====================================================================== -->
   <!-- Import UVA/VIVA additions -->
   <!-- ====================================================================== -->
   
   <xsl:include href="ent2href.xsl"/>



   <!-- ====================================================================== -->
   <!-- Output parameters                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:output method="xml" 
      indent="yes" 
      encoding="UTF-8"/>

   <!-- ====================================================================== -->
   <!-- normalize the file to the EAD 2002 DTD                                 -->
   <!-- ====================================================================== -->

   <xsl:variable name="dtdVersion">
        <xsl:apply-templates mode="at2oac"/>
   </xsl:variable>
   
   <!-- ====================================================================== -->
   <!-- Default: identity transformation                                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="@*|node()">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="/*">
         <xsl:apply-templates select="$dtdVersion" mode="root"/>
   </xsl:template>

   <xsl:template match="ead" mode="root">
      <xsl:copy>
         <xsl:namespace name="xtf" select="'http://cdlib.org/xtf'"/>
         <xsl:copy-of select="@*"/>
         <xsl:call-template name="get-meta"/>
         <xsl:apply-templates mode="addChunkId"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Top-level transformation: add chunk.id to each element                 -->
   <!-- ====================================================================== -->
   
   <xsl:template match="node()" mode="addChunkId">
      <xsl:call-template name="ead-copy">
         <xsl:with-param name="node" select="."/>
         <xsl:with-param name="chunk.id" select="xs:string(position())"/>
      </xsl:call-template>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Rearrange the archdesc section to be in display order                  -->
   <!-- ====================================================================== -->
   
   <xsl:template match="archdesc" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>         
         
         <xsl:apply-templates mode="addChunkId" select="did"/>
         <xsl:apply-templates mode="addChunkId" select="bioghist"/>
         <xsl:apply-templates mode="addChunkId" select="scopecontent"/>
         <xsl:apply-templates mode="addChunkId" select="arrangement"/>

         <!-- archdesc-restrict -->
         <xsl:apply-templates mode="addChunkId" select="userestrict"/>
         <xsl:apply-templates mode="addChunkId" select="accessrestrict"/>

         <!-- archdesc-relatedmaterial -->
         <xsl:apply-templates mode="addChunkId" select="relatedmaterial"/>
         <xsl:apply-templates mode="addChunkId" select="separatedmaterial"/>
         
         <xsl:apply-templates mode="addChunkId" select="controlaccess"/>
         <xsl:apply-templates mode="addChunkId" select="odd"/>
         <xsl:apply-templates mode="addChunkId" select="originalsloc"/>
         <xsl:apply-templates mode="addChunkId" select="phystech"/>

         <!-- archdesc-admininfo -->
         <xsl:apply-templates mode="addChunkId" select="custodhist"/>
         <xsl:apply-templates mode="addChunkId" select="altformavail"/>
         <xsl:apply-templates mode="addChunkId" select="prefercite"/>
         <xsl:apply-templates mode="addChunkId" select="acqinfo"/>
         <xsl:apply-templates mode="addChunkId" select="processinfo"/>
         <xsl:apply-templates mode="addChunkId" select="appraisal"/>
         <xsl:apply-templates mode="addChunkId" select="accruals"/>

         <xsl:apply-templates mode="addChunkId" select="descgrp"/>
         <xsl:apply-templates mode="addChunkId" select="otherfindaid"/>
         <xsl:apply-templates mode="addChunkId" select="fileplan"/>
         <xsl:apply-templates mode="addChunkId" select="bibliography"/>
         <xsl:apply-templates mode="addChunkId" select="index"/>
         
         <!-- Lastly, the container list. -->
         <xsl:apply-templates mode="addChunkId" select="dsc"/>
      </xsl:copy>
   </xsl:template>

   <!-- Rearrange the <did> section to be in display order -->
   <xsl:template match="did" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>         
         
         <xsl:apply-templates select="repository"/>
         <xsl:apply-templates select="origination"/>
         <xsl:apply-templates select="unittitle"/>
         <xsl:apply-templates select="unitdate"/>
         <xsl:apply-templates select="physdesc"/>
         <xsl:apply-templates select="abstract"/>
         <xsl:apply-templates select="unitid"/>
         <xsl:apply-templates select="physloc"/>
         <xsl:apply-templates select="langmaterial"/>
         <xsl:apply-templates select="materialspec"/>
         <xsl:apply-templates select="note"/>
         <xsl:apply-templates select="dao|daogrp|daoset" />
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Add a unique id to each child of archdesc and each c01, c02, and       --> 
   <!-- archdesc section...                                                    -->
   <!-- We do this by recording the position of each of the node's ancestors   -->
   <!-- (and the node itself)                                                  -->
   <!-- ====================================================================== -->
   
   <xsl:template name="ead-copy">
      <xsl:param name="node"/>
      <xsl:param name="chunk.id"/>

      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:choose>
            <xsl:when test="self::c01 or self::c02 or (self::* and (parent::archdesc or parent::ead))">
               <xsl:if test="not(@id)">
                  <xsl:attribute name="id" select="concat(local-name(), '_', $chunk.id)"/>
               </xsl:if>
               <xsl:if test="not($node/head)">
                  <xsl:variable name="heading" select="oac:supply-heading($node)" xmlns:oac="http://oac.cdlib.org"/>
                  <xsl:if test="$heading!=''">
                     <head><xsl:value-of select="$heading"/></head>
                  </xsl:if>
               </xsl:if>
               <xsl:for-each select="node()">
                  <xsl:call-template name="ead-copy">
                     <xsl:with-param name="node" select="."/>
                     <xsl:with-param name="chunk.id" select="concat($chunk.id, xtf:posToChar(position()))"/>
                  </xsl:call-template>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:apply-templates select="node()"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:copy>
   </xsl:template>
   
   <!-- Used to generate compact IDs by encoding numbers 1..26 as letters instead -->
   <xsl:function name="xtf:posToChar">
      <xsl:param name="pos"/>
      <xsl:value-of select="
         if ($pos &lt; 27) then
            substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ', $pos, 1)
         else
            concat('.', $pos)"/>
   </xsl:function>
   
   <!-- ====================================================================== -->
   <!-- EAD Indexing                                                           -->
   <!-- ====================================================================== -->
   
   <!-- Ignored Elements -->
   <xsl:template match="eadheader" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:index" select="'no'"/>
         <xsl:apply-templates mode="addChunkId"/>
      </xsl:copy>
   </xsl:template>
   
   
   <!-- sectionType Indexing and Element Boosting -->
   <xsl:template match="unittitle[parent::did]">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="concat('head ', @type)"/>
         <xsl:attribute name="xtf:wordBoost" select="2.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="prefercite">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="'citation'"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="titleproper[parent::titlestmt]">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:wordBoost" select="100.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Metadata Indexing                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:template name="get-meta">
      <!-- Access Dublin Core Record (if present) -->
      <xsl:variable name="dcMeta">
         <xsl:call-template name="get-dc-meta"/>
      </xsl:variable>
      
      <!-- If no Dublin Core present, then extract meta-data from the EAD -->
      <xsl:variable name="meta">
         <xsl:choose>
            <xsl:when test="$dcMeta/*">
               <xsl:copy-of select="$dcMeta"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="get-ead-title"/>
               <xsl:call-template name="get-ead-creator"/>
               <xsl:call-template name="get-ead-subject"/>
               <xsl:call-template name="get-ead-description"/>
               <xsl:call-template name="get-ead-publisher"/>
               <xsl:call-template name="get-ead-contributor"/>
               <xsl:call-template name="get-ead-date"/>
               <xsl:call-template name="get-ead-type"/>
               <xsl:call-template name="get-ead-format"/>
               <xsl:call-template name="get-ead-identifier"/>
               <xsl:call-template name="get-ead-source"/>
               <xsl:call-template name="get-ead-language"/>
               <xsl:call-template name="get-ead-relation"/>
               <xsl:call-template name="get-ead-coverage"/>
               <xsl:call-template name="get-ead-rights"/>
               <!-- special values for OAI -->
               <xsl:call-template name="oai-datestamp"/>
               <xsl:call-template name="oai-set"/>
               <!-- UVA / VIVA additions sdm7g 
               <xsl:call-template name="get-ead-collection-number"/>		-->		
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- Add display and sort fields to the data, and output the result. -->
      <xsl:call-template name="add-fields">
         <xsl:with-param name="display" select="'dynaxml'"/>
         <xsl:with-param name="meta" select="$meta"/>
      </xsl:call-template>    
   </xsl:template>

   <!-- collection number -->
   <xsl:template name="get-ead-collection-number">
 

   </xsl:template>

   <!-- VIVA version of title: trying to copy original app behavior here sdm7g -->
   <xsl:template name="get-ead-title">
      <xsl:variable name="titlestmt"
         select="$dtdVersion/ead/eadheader/filedesc/titlestmt" />
      <xsl:variable name="title" 
         select="replace(string-join($titlestmt/titleproper[not(@type='filing')]//text(), ', '), ',\s*,', ','  )" />
      <xsl:variable name="subtitle" 
         select="$titlestmt/subtitle" />
      <xsl:variable name="stype">
         <xsl:if test="$subtitle/@id" ><xsl:value-of select="concat(' [',$subtitle/@id, ']')"/></xsl:if>
      </xsl:variable>
      <xsl:variable name="numbers" 
         select="for $x in ($dtdVersion/ead/(eadheader//titlestmt|frontmatter/titlepage)//num, 
         $dtdVersion/ead/archdesc/did/unitid[1]) return xtf:normalize($x)" />
      <xsl:variable name="num" select="normalize-space(($titlestmt//num)[1])"/>
      <xsl:variable name="unitid" select="normalize-space($dtdVersion/archdesc/did/unitid[1])"/>
      <xsl:if test="$num"><num xtf:meta="true"><xsl:value-of select="$num"/></num></xsl:if>
      <xsl:if test="$unitid"><unitid xtf:meta="true"><xsl:value-of select="$unitid"/></unitid></xsl:if>
      <title xtf:meta="true" >
         <xsl:value-of select="xtf:normalize($title)"/>
         <xsl:choose>
            <xsl:when test="$num and not(contains($title,$num))"><xsl:value-of select="concat(' #',$num)"/></xsl:when>
            <xsl:when test="$unitid and not(contains($title,$unitid))"><xsl:value-of select="concat(' #',$unitid)"/></xsl:when>
            <xsl:otherwise></xsl:otherwise>
         </xsl:choose>
      </title>
      <subtitle xtf:meta="true" ><xsl:value-of select="concat(xtf:normalize( string-join( $subtitle//text(), ', ')),$stype)"/></subtitle>

      <sort-number xtf:meta="true" xtf:tokenize="no" >
         <xsl:value-of select="distinct-values($numbers)"/>
      </sort-number>
      <collection-number xtf:meta="true" xtf:tokenize="yes" >
         <xsl:value-of select="distinct-values($numbers)"/>
      </collection-number>
   </xsl:template>

   <!-- creator -->
   <xsl:template name="get-ead-creator">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/did/origination[starts-with(@label, 'Creator')]">
            <creator xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/archdesc/did/origination[@label, 'Creator'][1])"/>
            </creator>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/(eadheader|control)/filedesc/titlestmt/author">
            <creator xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/(eadheader|control)/filedesc/titlestmt/author[1])"/>
            </creator>
         </xsl:when>
         <xsl:otherwise>
            <creator xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </creator>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- subject --> 
   <!-- Note: we use for-each-group below to remove duplicate entries. -->
   <xsl:template name="get-ead-subject">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/subject">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/subject" group-by="string()">
               <subject xtf:meta="true">
                  <xsl:value-of select="."/>
               </subject>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/(eadheader|control)/filedesc/notestmt/subject">
            <xsl:for-each-group select="($dtdVersion)/ead/(eadheader|control)/filedesc/notestmt/subject" group-by="string()">
               <subject xtf:meta="true">
                  <xsl:value-of select="."/>
               </subject>
            </xsl:for-each-group>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <!-- description --> 
   <xsl:template name="get-ead-description">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/did/abstract">
            <description xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/archdesc/did/abstract[1])"/>
            </description>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/(eadheader|control)/filedesc/notestmt/note">
            <description xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/(eadheader|control)/filedesc/notestmt/note[1])"/>
            </description>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!-- this seems to have to be top level for document-uri to work correctly.
        Maybe it ought to be declared up at the top with other params, but I 
        want to keep it near the template in which it's used for now, to localize
        the source diffs.  (sdm7g) -->
   <xsl:param name="me"  select="document-uri(/)"/>

   <!-- publisher -->
   <xsl:template name="get-ead-publisher">            
         <xsl:if test="($dtdVersion)/ead/archdesc/did/repository">
            <publisher xtf:meta="true">
               <xsl:value-of select="xtf:normalize(($dtdVersion)/ead/archdesc/did/repository[1])"/>
            </publisher>
         </xsl:if>
         <xsl:if test="($dtdVersion)/ead/(eadheader|control)/filedesc/publicationstmt/publisher">
            <publisher xtf:meta="true">
               <xsl:value-of select="xtf:normalize(($dtdVersion)/ead/(eadheader|control)/filedesc/publicationstmt/publisher[1])"/>
            </publisher>
         </xsl:if>      

      <!-- publisher - VIVA additions: add sort-publisher and facet-publisher; 
        use VHP/VIVA institution from agency code to normalize -->

      <xsl:variable name="fromoai" select="matches($me,'/oai/[^/]+/repositories/\d+/resources/')"/>
   
   
      <xsl:variable name="directory"  >
         <xsl:choose>
            <xsl:when test="$fromoai">
               <xsl:value-of select="tokenize($me,'/')[last()-4]"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="tokenize($me,'/')[last()-1]"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <directory xtf:meta="true" xtf:tokenize="no" ><xsl:value-of select="$directory" /></directory>
      <path xtf:meta="true" xtf:tokenize="no" ><xsl:value-of select="$me" /></path>
      <document xtf:meta="true" xtf:tokenize="no" ><xsl:value-of select="tokenize($me,'/')[last()]" /></document>


      <xsl:variable name="agencycode" select="$dtdVersion/ead/(eadheader|control)/eadid/@mainagencycode"/>
      <xsl:variable name="countrycode" select="$dtdVersion/ead/(eadheader|control)/eadid/@countrycode"/>
            
      <xsl:variable name="isilcode" select="xtf:isil($agencycode,$countrycode)"/>

      <xsl:variable name="agencycode">
         <xsl:choose>
            <xsl:when test="$isilcode">
               <xsl:value-of select="$isilcode"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="string(document('../../../brand/viva/add_con/ead-inst.xml')/list/inst[@dirname=$directory]/@prefix)"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <agencycode xtf:meta="true" xtf:tokenize="no" ><xsl:value-of select="$agencycode"/></agencycode>
      
      <xsl:variable name="pub-name" >
         <xsl:choose>
            <xsl:when test="document('../../../brand/viva/add_con/ead-inst.xml')/list/inst[@prefix=$agencycode]">
               <xsl:value-of select="document('../../../brand/viva/add_con/ead-inst.xml')/list/inst[@prefix=$agencycode]"/>
            </xsl:when>
            <xsl:when test="document('../../../brand/viva/add_con/ead-inst.xml')/list/inst[@oclc=upper-case($agencycode)]">
               <xsl:value-of select="document('../../../brand/viva/add_con/ead-inst.xml')/list/inst[@oclc=upper-case($agencycode)]"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$directory"/>
            </xsl:otherwise>
         </xsl:choose>
          
         
      </xsl:variable>

 
      <institution xtf:meta="true" >
         <xsl:value-of select="$pub-name" />
      </institution>

      <sort-publisher xtf:meta="true" xtf:tokenize="no">
         <xsl:value-of select="$pub-name" />
      </sort-publisher>

      <facet-publisher xtf:meta="true" xtf:tokenize="no">
         <xsl:value-of select="$pub-name" />
      </facet-publisher>

      <facet-publisher xtf:meta="true" xtf:tokenize="no">
         <!--  temporary, for debugging merge of VH, ASpace OAI resources -->
         <xsl:choose>
            <xsl:when test="$fromoai">ArchivesSpace</xsl:when>
            <xsl:otherwise>Virginia Heritage</xsl:otherwise>
         </xsl:choose>
      </facet-publisher>

   </xsl:template>
   
   <!-- contributor -->
   <xsl:template name="get-ead-contributor">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/(eadheader|control)/filedesc/titlestmt/author">
            <contributor xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/(eadheader|control)/filedesc/titlestmt/author[1])"/>
            </contributor>
         </xsl:when>
         <xsl:otherwise>
            <contributor xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </contributor>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- date --> 
   <xsl:template name="get-ead-date">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/(eadheader|control)/filedesc/publicationstmt/date">
            <date xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/(eadheader|control)/filedesc/publicationstmt/date[1])"/>
            </date>
         </xsl:when>
         <xsl:otherwise>
            <date xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </date>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- type -->
   <xsl:template name="get-ead-type">
      <type xtf:meta="true">ead</type>
   </xsl:template>
   
   <!-- format -->
   <xsl:template name="get-ead-format">
      <format xtf:meta="true">xml</format>
   </xsl:template>
    
  
 
   <!-- source -->
   <xsl:template name="get-ead-source">
      <source xtf:meta="true">unknown</source>
   </xsl:template>
   
   <!-- language -->
   <xsl:template name="get-ead-language">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/(eadheader|control)/profiledesc/langusage/language">
            <language xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/(eadheader|control)/profiledesc/langusage/language[1])"/>
            </language>
         </xsl:when>
         <xsl:otherwise>
            <language xtf:meta="true">
               <xsl:value-of select="'english'"/>
            </language>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- relation -->
   <xsl:template name="get-ead-relation">
      <relation xtf:meta="true">unknown</relation>
   </xsl:template>
   
   <!-- coverage -->
   <xsl:template name="get-ead-coverage">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/did//unitdate">
            <coverage xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/archdesc/did//unitdate[1])"/>
            </coverage>
         </xsl:when>
         <xsl:otherwise>
            <coverage xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </coverage>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- rights -->
   <xsl:template name="get-ead-rights">
      <rights xtf:meta="true">public</rights>
   </xsl:template>
   
   <!-- OAI dateStamp -->
   <xsl:template name="oai-datestamp" xmlns:FileUtils="java:org.cdlib.xtf.xslt.FileUtils">
      <xsl:variable name="filePath" select="saxon:system-id()" xmlns:saxon="http://saxon.sf.net/"/>
      <xsl:if test="$filePath">
      <dateStamp xtf:meta="true" xtf:tokenize="no">
         <xsl:value-of use-when="function-available('FileUtils:lastModified')" select="FileUtils:lastModified($filePath, 'yyyy-MM-dd')"/>
      </dateStamp>
      </xsl:if>
   </xsl:template>
   
   <!-- OAI sets -->
   <xsl:template name="oai-set">
      <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/subject" group-by="string()">
         <set xtf:meta="true">
            <xsl:value-of select="."/>
         </set>
      </xsl:for-each-group>
      <xsl:for-each-group select="($dtdVersion)/ead/(eadheader|control)/filedesc/notestmt/subject" group-by="string()">
         <set xtf:meta="true">
            <xsl:value-of select="."/>
         </set>
      </xsl:for-each-group>
      <set xtf:meta="true">
         <xsl:value-of select="'public'"/>
      </set>
   </xsl:template>


   <!-- UVA VIVA additions sdm7g -->
   

   
   <!-- identifier VIVA mod sdm7g -->
   <xsl:template name="get-ead-identifier">
      <xsl:variable name="eadid">
         <xsl:choose>
            <xsl:when test="$dtdVersion/ead/@id">
               <xsl:value-of select="normalize-space(($dtdVersion)/ead/@id)"/>
            </xsl:when>
            <xsl:when test="$dtdVersion/ead/eadheader/eadid/@identifier">
               <xsl:value-of select="$dtdVersion/ead/eadheader/eadid/@identifier"/>
            </xsl:when>
<!--            <xsl:when test="string-length($dtdVersion/ead/eadheader/eadid/@publicid) &lt; 16 ">
               <xsl:value-of select="normalize-space($dtdVersion/ead/eadheader/eadid/@publicid)"/>
            </xsl:when>  -->
            <xsl:otherwise>
               <xsl:value-of select="tokenize($me,'/')[last()]" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
  
      <identifier xtf:meta="true" xtf:tokenize="yes">
         <xsl:value-of select="normalize-space($eadid)"/>
      </identifier>
      
      <sort-identifier xtf:meta="true" xtf:tokenize="no">
         <xsl:value-of select="normalize-space($eadid)"/>
      </sort-identifier>
      
   </xsl:template>
   
   <xsl:function name="xtf:normalize" as="xs:string" >
      <xsl:param name="instring" />
      <xsl:value-of select="normalize-space(replace(string($instring),'\s+', ' ' ))"/>
   </xsl:function>

   <xsl:function name="xtf:isil" as="xs:string">
      <xsl:param name="agency" />
      <xsl:param name="country" />
      <xsl:variable name="cpat"
         select="concat( '^(', string-join(($country, 'us', 'oclc' ),'|' ) ,')-((' ,
                  string-join(($country, 'us', 'oclc' ),'|' ), ')-)?'  )" />
      <xsl:value-of select="lower-case(replace(replace(string($agency),$cpat,'', 'i'),'-',''))"/>
   </xsl:function>

</xsl:stylesheet>
