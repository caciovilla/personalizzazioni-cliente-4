(:Layout :)
(: Verifica le tipologie indirizzo alle quali vengono fatte le spedizioni  :)
(: Restituisce il numero di ogni tipologia presente :)

(: modifiche da apportare prima dell'esecuzione:
 Riga: for $r in db:open("23091-CommesseCarico-3274") :modificare la commessa
 :)
 
let $c := client:connect("128.1.2.106", 1984, "admin", "admin")

for $cartelle in client:query($c,'
declare namespace ns4="urn:it:sintax:schema:cartellazione";
declare namespace ns2="urn:it:sintax:schema:indirizzi";
declare namespace ns5="urn:it:sintax:schema:f24";
declare namespace ns6="urn:it:sintax:schema:f24";
declare default element namespace "urn:it:sintax:schema:soggetto";
declare decimal-format local:it decimal-separator = "," grouping-separator = "." ;
let $numberFormat := "#,##"
let $formatName := "local:it"

for $r in db:open("23091-CommesseCarico-3274")

  let $pt := substring(db:path($r),1,10)
  let $idRichiestaProcedura := $r//ns4:EstremiDocumento/@idRichiestaProcedura
  let $idCartellazione := $r//ns4:EstremiDocumento/@idCartellazione
  let $codice := $r//ns4:RecapitoDocumento/@TipoIndirizzo
  
  let $TipoDocumento := $r//ns4:EstremiDocumento/ns4:TipoDocumento/ns4:CodiceDocumento
  let $idLotto :=  $r//ns4:EstremiDocumento/@idLotto



group by  $TipoDocumento, $idLotto, $codice
order by $TipoDocumento, $idLotto, $codice
return
<Conteggi>

    <Res idLotto="{distinct-values($idLotto)}" TipoDocumento="{$TipoDocumento}" codice="{$codice}" nCartelle="{count($r)}"/>

</Conteggi>
')

return $cartelle
  