# steuer-id
Checksum calculation for German 11-digit Tax IDs

This XSLT program implements the checksum calculation algorithm described in [Steueridentifikationsnummer (IdNr) nach § 139b AO – Informationen zur Berechnung gültiger Prüfziffern](https://www.zfa.deutsche-rentenversicherung-bund.de/de/Inhalt/public/4_ID/47_Pruefziffernberechnung/001_Pruefziffernberechnung.pdf?__blob=publicationFile&v=1).

## Invocation

(Assumption: You have a wrapper script that invokes Saxon (should run with any edition, at least version 9.8), called `saxon`)

```
saxon -xsl:SteuerIDPruefZiffer.xsl -it -ea num=57549285017
```

If the 11th digit is the correct checksum, the program exits with code 0 (at least on POSIX systems), without any further output.

Several prerequisites will be checked by means of `xsl:assert`:

- input must consist of 11 digits
- input must not start with 0
- 2 or 3 of the first 10 digits must be equal
- 3 consecutive digits must not be equal
- finally, the calculated checksum must be equal to the 11th digit

Violation of any of these assertions will create a (German-language) error message and a non-zero exit status.
