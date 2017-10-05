(: CONTROLLO DATI RECAPITO :)
(: PRESSO :)
(: NON DOVREBBE RESTITUIRE ALCUNA RIGA: LE RIGHE RESTITUITE SONO ANOMALIE :)

(: modifiche da apportare prima dell'esecuzione:
 Riga: for $r in db:open("23091-CommesseCarico-2932") :modificare la commessa
 Righe:  $idRichiestaProcedura = "2476" or ... modificare gli id o eliminare il controllo
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
  let $idDocumento := $r//ns4:EstremiDocumento/@id
    
  let $numeroCartella := $r//ns4:EstremiDocumento/xs:string(ns4:Numero) || ";"
      
      
  let $lengthPresso := string-length($r//ns4:RecapitoDocumento/@Presso)
  let $presso := $r//ns4:RecapitoDocumento/xs:string(@Presso) || ";"

 where
  (    
    (:  (
        $idRichiestaProcedura = "2512"  or
        $idRichiestaProcedura = "2451" or
        $idRichiestaProcedura = "2452" or
        $idRichiestaProcedura = "2474" or
        $idRichiestaProcedura = "2450" 
      )
     
      and  :)
    ( $lengthPresso = 0)
  ) 
      
group by  $pt, $lengthPresso, $idRichiestaProcedura, $idCartellazione
return
<Conteggi>

    <Res idRichiestaProcedura="{$idRichiestaProcedura}" idCartellazione="{$idCartellazione}" lotto="{$pt}" lengthPresso="{$lengthPresso}" nCartelle="{count($r)}">
      <numeroCartella>{$numeroCartella}</numeroCartella>
      <presso>{($presso)}</presso> 
    </Res>

</Conteggi>
')

return $cartelle
  