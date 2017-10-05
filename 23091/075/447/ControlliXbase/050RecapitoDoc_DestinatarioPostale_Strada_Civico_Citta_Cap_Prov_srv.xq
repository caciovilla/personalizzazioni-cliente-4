(: CONTROLLO DATI RECAPITO :)
(: DESTINATARIO POSTALE-STRADA-CIVICO-CITTA-CAP-PROV :)
(: NON DOVREBBE RESTITUIRE ALCUNA RIGA: LE RIGHE RESTITUITE SONO ANOMALIE :)

(: modifiche da apportare prima dell'esecuzione:
 Riga: for $r in db:open("23091-CommesseCarico-3042") :modificare la commessa
 Righe:  $idRichiestaProcedura = "2476" or ... modificare gli id o eliminare il controllo
:)

let $c := client:connect("128.1.0.234", 1984, "admin", "admin")

for $cartelle in client:query($c,'
declare namespace ns4="urn:it:sintax:schema:cartellazione";
declare namespace ns2="urn:it:sintax:schema:indirizzi";
declare namespace ns5="urn:it:sintax:schema:f24";
declare namespace ns6="urn:it:sintax:schema:f24";
declare default element namespace "urn:it:sintax:schema:soggetto";
declare decimal-format local:it decimal-separator = "," grouping-separator = "." ;
let $numberFormat := "#,##"
let $formatName := "local:it"

for $r in db:open("23091-CommesseCarico-3497")

  let $pt := substring(db:path($r),1,11)
  let $idRichiestaProcedura := $r//ns4:EstremiDocumento/@idRichiestaProcedura
  let $idDocumento := $r//ns4:EstremiDocumento/@id || ";"
  
  let $numeroCartella := $r//ns4:EstremiDocumento/xs:string(ns4:Numero) || ";"
  let $TipoDocumento := $r//ns4:EstremiDocumento/ns4:TipoDocumento/ns4:CodiceDocumento      
      
  let $lengthDestinatarioPostale := string-length($r//ns4:RecapitoDocumento/@destinatarioPostale)
  let $DestinatarioPostale := $r//ns4:RecapitoDocumento/xs:string(@destinatarioPostale) || ";"  
     
  let $lengthStrada := string-length($r//ns4:RecapitoDocumento/ns2:Strada)
  let $Strada := $r//ns4:RecapitoDocumento/xs:string(ns2:Strada) || ";"
  
  let $lengthNumeroCivico := string-length($r//ns4:RecapitoDocumento/ns2:NumeroCivico)
  let $NumeroCivico := $r//ns4:RecapitoDocumento/xs:string(ns2:NumeroCivico) || ";"
          
  let $lengthCitta := string-length($r//ns4:RecapitoDocumento/ns2:Citta)
  let $Citta := $r//ns4:RecapitoDocumento/xs:string(ns2:Citta) || ";"
  
  let $lengthCap := string-length($r//ns4:RecapitoDocumento/ns2:Cap)
  let $cap := $r//ns4:RecapitoDocumento/xs:string(ns2:Cap) || ";"
 
  let $lengthProvincia := string-length($r//ns4:RecapitoDocumento/ns2:Provincia)
  let $Provincia := $r//ns4:RecapitoDocumento/xs:string(ns2:Provincia) || ";"
  
  let $erratoDestinatarioPostale := if ($lengthDestinatarioPostale < 5) then 1 else 0    
  let $erratoLengthStrada        := if ($lengthStrada < 6) then 1 else 0 
  let $erratoLengthNumeroCivico  := if ($lengthNumeroCivico < 1 or $NumeroCivico = "0;") then 1 else 0 
  let $erratoLengthCitta         := if ($lengthCitta < 4) then 1 else 0 
  let $erratoLengthCap           := if ($lengthCap != 5 or $cap = "99999;") then 1 else 0 
  let $erratoLengthProvincia     := if ($lengthProvincia != 2) then 1 else 0 


let $idLotto :=  $r//ns4:EstremiDocumento/@idLotto

where ($idLotto = "24415" or $idLotto ="24447" or $idLotto ="24448") and

(
  
   ( $lengthDestinatarioPostale < 5) or
   ( $lengthStrada < 6) or
   (:
   ( $lengthNumeroCivico < 1 or $NumeroCivico = "0;") or
   :)
   ( $lengthCitta < 4) or
   ( $lengthCap != 5 or $cap = "99999;") 
   
  
  or
   ( $lengthProvincia != 2)
    
)
       
      
group by  $TipoDocumento
          
return
<Conteggi>
  <Res nCartelle="{count($r)}" lotto="{distinct-values($pt)}" >
    <DatiIdentificativi>
      <idDocumento>{$idDocumento}</idDocumento>
      <numeroCartella>{$numeroCartella}</numeroCartella>
    </DatiIdentificativi>
    <valoriCampi>
      <DestinatarioPostale>{($DestinatarioPostale)}</DestinatarioPostale> 
      <Strada>{($Strada)}</Strada>
      <NumeroCivico>{($NumeroCivico)}</NumeroCivico> 
      <Citta>{$Citta}</Citta> 
      <cap>{($cap)}</cap> 
      <Provincia>{($Provincia)}</Provincia>    
   </valoriCampi>  
   <Errori>
    <erratoDestinatarioPostale nErrori="{sum($erratoDestinatarioPostale)}">{$erratoDestinatarioPostale}</erratoDestinatarioPostale>
    <erratoLengthStrada_______ nErrori="{sum($erratoLengthStrada)}">{$erratoLengthStrada}</erratoLengthStrada_______>
    <erratoLengthNumeroCivico_ nErrori="{sum($erratoLengthNumeroCivico)}">{$erratoLengthNumeroCivico}</erratoLengthNumeroCivico_>
    <erratoLengthCitta________ nErrori="{sum($erratoLengthCitta)}">{$erratoLengthCitta}</erratoLengthCitta________>
    <erratoLengthCap__________ nErrori="{sum($erratoLengthCap)}">{$erratoLengthCap}</erratoLengthCap__________>
    <erratoLengthProvincia____ nErrori="{sum($erratoLengthProvincia)}">{$erratoLengthProvincia}</erratoLengthProvincia____>
   </Errori>
  </Res>
</Conteggi>
')

return $cartelle
  