(: Verifica le tipologie indirizzo alle quali vengono fatte le spedizioni  :)
(: Restituisce il numero di ogni tipologia presente :)

(: modifiche da apportare prima dell'esecuzione:
 Riga: for $r in db:open("2904-CommesseCarico-2904") :modificare la commessa
 Righe:  $idCartellazioneProcedura = "68509" or ... modificare gli id o eliminare il controllo
 :)
 
let $c := client:connect("128.1.0.210", 1984, "admin", "admin")

for $cartelle in client:query($c,'
declare namespace ns4="urn:it:sintax:schema:cartellazione";
declare namespace ns2="urn:it:sintax:schema:indirizzi";
declare namespace ns5="urn:it:sintax:schema:f24";
declare namespace ns6="urn:it:sintax:schema:f24";
declare default element namespace "urn:it:sintax:schema:soggetto";
declare decimal-format local:it decimal-separator = "," grouping-separator = "." ;
let $numberFormat := "#,##"
let $formatName := "local:it"

for $r in db:open("23091-CommesseCarico-2991")

  let $pt := substring(db:path($r),1,11)
  let $idRichiestaProcedura := $r//ns4:EstremiDocumento/@idRichiestaProcedura
  let $idCartellazione := $r//ns4:EstremiDocumento/@idCartellazione
  let $codice := $r//ns4:RecapitoDocumento/@TipoIndirizzo


group by  $pt, $codice, $idRichiestaProcedura
order by $pt, $codice
return
<Conteggi>

    <Res lotto="{$pt}" idRichiestaProcedura="{$idRichiestaProcedura}" idCartellazione="{$idCartellazione}" codice="{$codice}" nCartelle="{count($r)}"/>

</Conteggi>
')

return $cartelle
  