<?xml version="1.0" encoding="UTF-8"?>
<!-- Chart parser using the Earley-algorithm. Input is provided in as input variable, grammar and lexicon as other variables. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:my="example.com/my" exclude-result-prefixes="my">
    <xsl:key name="checkLexicon" use="self::*" match="t"/>
    <xsl:output indent="yes" method="xml"/>
    <!-- Reading rules and lexicon  -->
    <xsl:variable name="grammarRules" select="$grammar/grammar/rule"/>
    <!-- Reading and tokenizing the input.  --> 
    <xsl:variable name="input">
        <xsl:for-each select="tokenize($inputItems/inputItems/inputString,'\s+')">
            <token>
                <xsl:value-of select="."/>
            </token>
        </xsl:for-each>
    </xsl:variable>
    <!-- Function for getting rid of double hypothesis, generated out of rules of the form a > $b c, where c can differ. Example: "VP > V $NP", vs "V > V $NP PP". >   -->

    <xsl:function name="my:deleteDoublets">
        <xsl:param name="hypotheses"/>
        <xsl:variable name="addedSignature">
            <xsl:for-each select="$hypotheses/hypothesis">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:attribute name="sig"
                        select="'i',i,'j',j,(struct/@nt | struct/@t),'&gt;',for $rhs in struct/* return (if(name($rhs)='current') then('$') else $rhs)"/>
                    <xsl:copy-of select="*"/>
                </xsl:copy>

            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="distinct-values($addedSignature/hypothesis/@sig)">
            <xsl:variable name="sig" select="."/>
            <xsl:copy-of select="$addedSignature/hypothesis[@sig=$sig][1]"/>
        </xsl:for-each>
    </xsl:function>
    <!-- The main template -->
    <xsl:template match="/" name="main">
        <!-- Creating the initial chart -->
        <xsl:variable name="initialChart">
            <chart>
                <hypotheses>
                    <!-- For each grammar rule with S on the left hand side create a hypothesis. -->
                    <xsl:for-each select="$grammarRules[lhs/nt='S']">
                        <hypothesis when="inital" initalHypothesesProcessed="false"
                            constituentsCombined="0" run="0">
                            <!-- Start position of the hypothesis -->
                            <i>0</i>

                            <!-- End  position of the hypothesis -->
                            <j>0</j>
                            <struct nt="S">
                                <!-- The current position in  the hypothesis -->
                                <current/>
                                <!-- The right hand side of the rule -->
                                <xsl:copy-of select="./rhs/*"/>
                            </struct>

                        </hypothesis>
                    </xsl:for-each>
                </hypotheses>
                <!-- The are no constituents here yet.-->
                <constituents/>
            </chart>
        </xsl:variable>
        <!-- Calling the parsing template -->
        <xsl:call-template name="parse">

            <xsl:with-param name="chart" select="$initialChart" as="node()"/>
            <xsl:with-param name="wordPos">0</xsl:with-param>
            <xsl:with-param name="run">0</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="parse">
        <xsl:param name="chart"/>
        <xsl:param name="wordPos"/>
        <xsl:param name="run"/>
        <!-- Combining hypotheses with constituences. -->
        <xsl:variable name="hypothesesAndConstituentsCombined">
            <xsl:for-each select="$chart/chart/hypotheses/hypothesis">
                <xsl:variable name="rowNumberHypothesis">
                    <xsl:number/>
                </xsl:variable>
                <xsl:variable name="constituentsCombined" select="@constituentsCombined"/>
                <xsl:variable name="hypothesisCheck">

                    <!-- We define the variables of the hypothesis in question, needed for the test below. -->
                    <xsl:variable name="currentHypothesis" select="self::*"/>
                    <xsl:variable name="i" select="i"/>
                    <xsl:variable name="j" select="j"/>
                    <xsl:variable name="Y" select=".//current/following-sibling::*[1]"/>
                    <xsl:variable name="X" select="struct/@nt"/>
                    <!-- We are running through all constituents which have not been combined with the hypothesis, and define the variables needed here. -->
                    <xsl:for-each
                        select="$chart/chart/constituents/constituent[position() &gt; $constituentsCombined]">
                        <xsl:variable name="rowNumber">

                            <xsl:number/>
                        </xsl:variable>
                        <xsl:variable name="j_Con" select="i"/>
                        <xsl:variable name="k_Con" select="j"/>
                        <xsl:variable name="Y_Con" select="struct/@t | struct/@nt"/>
                        <!-- CASE 1: If there is a hypothesis "i, j, [… $Y …]X" in the chart and a constituent "j, k, [… ]Y" in row (m), add a hypothesis "i, k, [… KON(m)$…]X" to the chart. CASE 2: If $Y is the last to be found constituent in the hypothesis, complete the hypothesis and add a constituent to the chart .-->
                        <!--     <xsl:message><xsl:if test="$Y_Con = 'ADJP-X' and $currentHypothesis/@sig[contains(.,'ADJP-X')]">Now working on ADJP-X: <xsl:copy-of select="$currentHypothesis"></xsl:copy-of>  
                        <xsl:text>J: </xsl:text><xsl:value-of select="$j"></xsl:value-of>
                            <xsl:text>j_Con: </xsl:text><xsl:value-of select="$j_Con"></xsl:value-of>
                            <xsl:text>Y: </xsl:text><xsl:value-of select="$Y"></xsl:value-of>
                            <xsl:text>Y_Con: </xsl:text><xsl:value-of select="$Y_Con"></xsl:value-of></xsl:if></xsl:message> -->
                        <xsl:choose>
                            <!-- This is what we do if the hypothesis can be combined with a constituent. -->

                            <xsl:when test="$j = $j_Con and $Y = $Y_Con">
                                <xsl:choose>
                                    <!-- CASE 1 here: the hypothesis still contains stuff to be found. -->
                                    <xsl:when
                                        test="count($currentHypothesis//current/following-sibling::*) &gt; 1">
                                        <hypothesis when="combinationCase1" new="true"
                                            constituentsCombined="0"
                                            initalHypothesesProcessed="false"
                                            constituentUsed="{$rowNumber}" run="{$run}"
                                            hypothesisUsed="{$rowNumberHypothesis}">
                                            <i>
                                                <xsl:value-of select="$i"/>
                                            </i>
                                            <j>

                                                <xsl:value-of select="$k_Con"/>
                                            </j>
                                            <struct>
                                                <xsl:attribute name="{name($X)}" select="$X"/>
                                                <xsl:apply-templates
                                                  select="$currentHypothesis/struct/*"
                                                  mode="copyHypothesisStruct">
                                                  <xsl:with-param name="conRow" select="$rowNumber"
                                                  tunnel="yes"/>
                                                </xsl:apply-templates>
                                            </struct>
                                        </hypothesis>

                                    </xsl:when>
                                    <!-- CASE 2 here: There is nothing left in the hypothesis to be combined with a constituent, so we have a new constituent and can add it to the list of constituents. -->
                                    <xsl:otherwise>
                                        <constituent rowNumberHypothesis="{$rowNumberHypothesis}"
                                            run="{$run}">
                                            <xsl:attribute name="{name($X)}" select="$X"/>
                                            <i>
                                                <xsl:value-of select="$i"/>
                                            </i>
                                            <j>

                                                <xsl:value-of select="$k_Con"/>
                                            </j>
                                            <struct>
                                                <xsl:attribute name="{name($X)}" select="$X"/>
                                                <xsl:apply-templates
                                                  select="$currentHypothesis/struct/*"
                                                  mode="copyConstStruct">
                                                  <xsl:with-param name="conRow" select="$rowNumber"
                                                  tunnel="yes"/>
                                                </xsl:apply-templates>
                                            </struct>
                                        </constituent>

                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:if test="count($hypothesisCheck/*)&gt;0">
                    <xsl:copy-of select="$hypothesisCheck"/>
                </xsl:if>

                <hypothesis when="hasBeenCombined"
                    constituentsCombined="{count($chart/chart/constituents/constituent)}"
                    run="{$run}">
                    <xsl:copy-of
                        select="./@*[not(name()='new') and not(name()='constituentsCombined')]"/>
                    <xsl:copy-of select="./*"/>
                </hypothesis>
            </xsl:for-each>
        </xsl:variable>
        <!-- Now we need to reorder all the hypotheses and new constituents: old ones, including the ones combined with a constituent, and after that the new ones. -->
        <xsl:variable name="hypothesesAndConstituentsReordered">
            <chart>

                <hypotheses>
                    <xsl:variable name="doublesToBeDeleted"><xsl:copy-of
                        select="$hypothesesAndConstituentsCombined/hypothesis[not(@new='true')]"/>
                    <xsl:copy-of select="$hypothesesAndConstituentsCombined/hypothesis[@new='true']"
                    /></xsl:variable>                    
                    <!-- Getting rid of double hypothesis. >   -->
                    <xsl:copy-of select="my:deleteDoublets($doublesToBeDeleted)"/>
                </hypotheses>
                <constituents>
                    <xsl:copy-of select="$chart/chart/constituents/constituent"/>
                    <!-- Now the new constituents, if there are any. -->

                    <xsl:copy-of select="$hypothesesAndConstituentsCombined/constituent"/>
                </constituents>
            </chart>
        </xsl:variable>
        <!-- Creating initial hypotheses: If there is a hypothesis "i, j, [… $Y …]X" in the chart, add  for all rules in the grammar "Y  => Z1 … Zn" a new hypothesis "j,
        j, [$Z1 … Zn]Y" to the chart -->
        <xsl:variable name="newInitialAndOldHypotheses">
            <!-- Copying all existing hypotheses and adding a value @initalHypothesesProcessed='true'-->
            <xsl:for-each select="$hypothesesAndConstituentsReordered/chart/hypotheses/hypothesis">
                <xsl:copy>

                    <xsl:copy-of select="@*[not(name()='initalHypothesesProcessed')]"/>
                    <xsl:attribute name="initalHypothesesProcessed">true</xsl:attribute>
                    <xsl:copy-of select="./*"/>
                </xsl:copy>
            </xsl:for-each>
            <!-- Looking at all existing hypotheses. For whose not yet processed against the grammar, go on. -->
            <xsl:variable name="newStuffFromGrammar">
                <xsl:for-each
                    select="$hypothesesAndConstituentsReordered/chart/hypotheses/hypothesis[not(@initalHypothesesProcessed='true')]">

                    <xsl:variable name="currentHypothesis" select="."/>
                    <xsl:variable name="Y" select=".//current/following-sibling::*[1]"/>
                    <xsl:variable name="Y-after-empty-nt" select=".//current/following-sibling::*[position()&gt;1]"/>
                    <!--    <xsl:if test="not($Y-after-empty-nt)">  <xsl:message>now: <xsl:copy-of select="."></xsl:copy-of></xsl:message></xsl:if>-->
                    <!-- Looking at the grammar rules with left hand side = Y. -->
                    <xsl:for-each select="$grammarRules[lhs/nt=$Y]">
                        <xsl:variable name="no" select="@no"/>
                            <!-- tbd: empty check here? There is a rule with an empty rhs. If in the current hypothesis there is still stuff after Y, create a new hypothesis with the next symbol. -->
                        <xsl:choose>

                            <xsl:when test="rhs/empty">
                                <!-- If there is still stuff in the hypothesis, create a new one, with $Y-after-empty-nt. -->                
                                <!--         <xsl:message>Found "empty" rule. Hypothesis: <xsl:copy-of select="$currentHypothesis"></xsl:copy-of></xsl:message>  -->  
                                <xsl:choose>
                                    <xsl:when test="$Y-after-empty-nt">    
                                        <xsl:variable name="newHypothesis">
                                        <hypothesis when="derivedFromGrammar" constituentsCombined="0"
                                            initalHypothesesProcessed="false" run="{$run}" Y="{$currentHypothesis/struct/@nt}" no="{$no}">
                                            <i>
                                                <xsl:value-of select="$currentHypothesis/j"/>
                                            </i>

                                            <j>
                                                <xsl:value-of select="$currentHypothesis/j"/>
                                            </j>
                                            <struct nt="{$currentHypothesis/struct/@nt}">
                                                <current/>
                                                <xsl:copy-of select="$Y-after-empty-nt"/>
                                            </struct>
                                        </hypothesis>
                                        </xsl:variable>

                                        <xsl:copy-of select="$newHypothesis"/>
                                        <!--      <xsl:message>New added Hypothesis: <xsl:copy-of select="$newHypothesis"/></xsl:message>   --> 
                                    </xsl:when>
                                    <!-- If not, add a constituent to the chart. -->   
                                    <xsl:otherwise>
                                        <!--          <xsl:message terminate="no">Found an empty rule and got a constituent! <xsl:copy-of select="$currentHypothesis"></xsl:copy-of></xsl:message>   -->
                                        <!-- <hypothesis when="combinationCase1" new="true" constituentsCombined="0" initalHypothesesProcessed="false" constituentUsed="1" run="1" hypothesisUsed="4" sig="i 0 j 1 NP &gt;  $ ADJP"><i>0</i><j>1</j><struct nt="NP"><constRef row="1"/><current/><nt>ADJP</nt></struct></hypothesis> -->
                                        <xsl:variable name="newConstituent">
                                        <constituent rowNumberHypothesis="{count($currentHypothesis/preceding-sibling::hypothesis)}"
                                            run="{$currentHypothesis/@run}" nt="{$currentHypothesis/struct/@nt}">
                                            <i>

                                                <xsl:value-of select="$currentHypothesis/i"/>
                                            </i>
                                            <j>
                                                <xsl:value-of select="$currentHypothesis/j"/>
                                            </j>
                                            <struct nt="{$currentHypothesis/struct/@nt}">
                                                <xsl:copy-of select="$currentHypothesis/struct/*[not(self::current or preceding-sibling::current)]"></xsl:copy-of><!--  
                                                <xsl:attribute name="{name($X)}" select="$X"/>-->
                                                <!--  <xsl:apply-templates
                                                    select="$currentHypothesis/struct/*[not(position()=last())]"
                                                    mode="copyConstStruct">
                                                    <xsl:with-param name="conRow" select="'AA'"
                                                    tunnel="yes"/> 
                                                    </xsl:apply-templates>-->
                                            </struct>

                                        </constituent>
                                        </xsl:variable>
                                        <xsl:copy-of select="$newConstituent"/>
                                        <!--        <xsl:message>New constituent: <xsl:copy-of select="$newConstituent"/></xsl:message>  --> 
                                    </xsl:otherwise>
                                </xsl:choose>                                
                            </xsl:when>                      
                       <xsl:otherwise>
                        <hypothesis when="derivedFromGrammar" constituentsCombined="0"
                            initalHypothesesProcessed="false" run="{$run}" Y="{$Y}" no="{$no}">
                            <i>

                                <xsl:value-of select="$currentHypothesis/j"/>
                            </i>
                            <j>
                                <xsl:value-of select="$currentHypothesis/j"/>
                            </j>
                            <struct nt="{$Y}">
                                <current/>
                                <xsl:copy-of select="./rhs/*"/>
                            </struct>

                        </hypothesis>
                       </xsl:otherwise> 
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            <!-- Getting rid of double hypothesis -->
            <xsl:copy-of select="my:deleteDoublets($newStuffFromGrammar)"/>
            <xsl:copy-of select="$newStuffFromGrammar/constituent"/>
        </xsl:variable>
        <!-- Now taking a look at the lexicon -->
        <xsl:variable name="lexiconLookup">
            <!-- Make the lexicon lookup only if we have not processed the whole input string yet. -->
            <xsl:if test="count($wordPos) &lt; (count($input/token) -1)">
                <xsl:variable name="currentWord"
                    select="$input/token[position()=$wordPos+1]"/>
                <xsl:for-each select="$lexicon">
                    <xsl:if test="matches($currentWord,.)">
                    <constituent run="{$run}">
                        <i>
                            <xsl:value-of select="$wordPos"/>
                        </i>
                        <j>
                            <xsl:value-of select="$wordPos+1"/>
                        </j>
                        <struct t="{./@type}">
                            <xsl:copy-of select="$currentWord"/>
                        </struct>
                    </constituent>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:variable>
        <!--  Now assemble the new chart -->
        <xsl:variable name="newChart">
            <chart>

                <hypotheses>
                    <xsl:for-each select="$newInitialAndOldHypotheses/hypothesis">
                        <xsl:copy>
                            <xsl:copy-of select="@*"/>
                            <xsl:copy-of select="./*"/>
                        </xsl:copy>
                    </xsl:for-each>
                </hypotheses>
                <constituents>

                    <xsl:copy-of
                        select="$hypothesesAndConstituentsReordered/chart/constituents/constituent"/>
                    <xsl:copy-of select="$lexiconLookup"/>
                    <!-- We need this for constituents produced by empty rules. -->
                    <xsl:copy-of select="$newInitialAndOldHypotheses//constituent"/>
                    <!--      <xsl:message>Constituents within the hypotheses: <xsl:copy-of select="$newInitialAndOldHypotheses//constituent"/></xsl:message> -->
                </constituents>
            </chart>
        </xsl:variable>   <!--  
            <xsl:message>COMPLETE CHART: <xsl:copy-of select="$newChart"/></xsl:message> -->

        <!-- TBD: here we could just make the null rules thing ... 
            0-Regeln: Nach intialen Regeln, Lexikon und Konstitutenten: Mit Ergebnis nach 0-
            Regeln suchen. Wenn gefunden: danach noch Symbol? Neue Hypothese + alte 
            Konstituente mit "initial processed: true". Nicht: Neue Konstituente. -->
        <xsl:choose>
            <xsl:when
                test="count(($chart//hypothesis, $chart//constituent)) &lt; count(($newChart//hypothesis, $newChart//constituent))">
                <xsl:call-template name="parse">
                    <xsl:with-param name="chart" select="$newChart"/>
                    <xsl:with-param name="wordPos" select="$wordPos+1"/>
                    <xsl:with-param name="run" select="$run+1"/>
                </xsl:call-template>
            </xsl:when>

            <xsl:otherwise>
                <chart>
                    <hypotheses>
                        <xsl:for-each select="$newChart/chart/hypotheses/hypothesis">
                            <xsl:copy>
                                <xsl:copy-of select="@*"/>
                                <xsl:attribute name="row">
                                    <xsl:number/>
                                </xsl:attribute>

                                <xsl:copy-of select="./*"/>
                            </xsl:copy>
                        </xsl:for-each>
                    </hypotheses>
                    <constituents>
                        <xsl:for-each select="$newChart/chart/constituents/constituent">
                            <xsl:copy>
                                <xsl:copy-of select="@*"/>
                                <xsl:attribute name="row">

                                    <xsl:number/>
                                </xsl:attribute>
                                <xsl:copy-of select="./*"/>
                            </xsl:copy>
                        </xsl:for-each>
                    </constituents>
                </chart>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <!-- This template just copies the parts of the constituents not to be touched.-->
    <xsl:template match="@* |node()" mode="copyConstStruct">
        <xsl:copy>
            <xsl:apply-templates select="@* |node()" mode="copyConstStruct"/>
        </xsl:copy>
    </xsl:template>
    <!-- This template integrates the reference to the constituent which has been found into the hypothesis. -->
    <xsl:template match="current" mode="copyConstStruct">

        <xsl:param name="conRow" tunnel="yes"/>
        <constRef row="{$conRow}"/>
    </xsl:template>
    <!-- This template deletes the name of the constituents which has been found.-->
    <xsl:template mode="copyConstStruct" match="*[preceding-sibling::current][1]"/>
    <!-- This template copies the parts of the hypothesis not to be touched.-->
    <xsl:template match="@* |node()" mode="copyHypothesisStruct">
        <xsl:copy>
            <xsl:apply-templates select="@* |node()" mode="copyHypothesisStruct"/>

        </xsl:copy>
    </xsl:template>
    <!-- This template copies the constituent which has been found into the hypothesis. -->
    <xsl:template match="current" mode="copyHypothesisStruct">
        <xsl:param name="conRow" tunnel="yes"/>
        <constRef row="{$conRow}"/>
        <current/>
        <xsl:apply-templates select="@* |node()" mode="copyHypothesisStruct">
            <xsl:with-param name="conRow"/>

        </xsl:apply-templates>
    </xsl:template>
    <xsl:template mode="copyHypothesisStruct" match="*[preceding-sibling::current][1]"/>
</xsl:stylesheet>
