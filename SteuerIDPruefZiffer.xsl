<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:gi="https://github.com/gimsieke/"
  exclude-result-prefixes="xs gi"
  version="3.0">
  
  <xsl:output method="text"/>
  
  <xsl:param name="num" as="xs:string"/>
  
  <xsl:template name="xsl:initial-template">
    <xsl:assert test="matches($num, '^\d{11}$')">Es müssen exakt 11 Ziffern angegeben werden (z.B. num=47036892816).</xsl:assert>
    <xsl:variable name="digits" as="xs:integer+" 
      select="string-to-codepoints($num) ! (. - 48)"/>
    <xsl:assert test="not($digits[1] = 0)">Die erste Ziffer darf nicht Null sein.</xsl:assert>
    <xsl:variable name="ten-digits" as="xs:integer+" 
      select="$digits[position() lt last()]"/>
    <xsl:assert test="count(distinct-values($ten-digits)) = (8, 9)">Zwei oder drei der ersten zehn Ziffern müssen gleich sein.</xsl:assert>
    <xsl:assert test="every $pos in (3 to 10)
                      satisfies not($ten-digits[$pos] = $ten-digits[$pos - 1]
                                     and $ten-digits[$pos] = $ten-digits[$pos - 2])">Es dürfen nicht drei gleiche Ziffern aufeinanderfolgen.</xsl:assert>
    <xsl:variable name="pz" select="gi:tax-id-checksum($ten-digits)" as="xs:integer"/>
    <xsl:assert test="$pz = $digits[last()]" expand-text="yes">Die Prüfziffer muss {$pz} lauten.</xsl:assert>
  </xsl:template>

  <xsl:function name="gi:tax-id-checksum" as="xs:integer">
    <xsl:param name="nums" as="xs:integer+"/>
    <xsl:iterate select="$nums">
      <xsl:param name="m10" select="0" as="xs:integer"/>
      <xsl:param name="m11" select="10" as="xs:integer"/>
      <xsl:on-completion>
        <xsl:sequence select="((11 - $m11)[not(. = 10)], 0)[1]"/>
      </xsl:on-completion>
      <xsl:variable name="new-m10" select="let $tmp := (. + $m11) mod 10 
                                           return if ($tmp = 0) then 10 else $tmp" as="xs:integer"/>
      <xsl:next-iteration>
        <xsl:with-param name="m10" select="$new-m10" as="xs:integer"/>
        <xsl:with-param name="m11" select="(2 * $new-m10) mod 11" as="xs:integer"/>
      </xsl:next-iteration>
    </xsl:iterate>
  </xsl:function>

</xsl:stylesheet>