(: CONTROLLO DATI ETICHETTA DESTINATARIO :)
(: DESTINATARIO-INFO DESTINATARIO-EDIFICIO-INDIRIZZO-LOCALITA :)
(: NON DOVREBBE RESTITUIRE ALCUNA RIGA: LE RIGHE RESTITUITE SONO ANOMALIE :)

(: modifiche da apportare prima dell'esecuzione:
 Riga: for $r in db:open("23091-CommesseCarico-3274") :modificare la commessa
 Righe:  $idRichiestaProcedura = "2476" or ... modificare gli id o eliminare il controllo
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

  let $pt := substring(db:path($r),1,11)
  
  let $idRichiestaProcedura := $r//ns4:EstremiDocumento/@idRichiestaProcedura
  let $idCartellazione := $r//ns4:EstremiDocumento/@idCartellazione
  let $idDocumento := $r//ns4:EstremiDocumento/@id || ";"
  let $TipoDocumento := $r//ns4:EstremiDocumento/ns4:TipoDocumento/ns4:CodiceDocumento     
  
  let $numeroCartella := $r//ns4:EstremiDocumento/xs:string(ns4:Numero) || ";"
           
  let $lengthDestinatario := string-length($r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:Destinatario)
  let $Destinatario := $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/xs:string(ns4:Destinatario) || ";"
  
  let $lengthInfoDestinatario := string-length($r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:InfoDestinatario)
  let $InfoDestinatario := $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/xs:string(ns4:InfoDestinatario) || ";"
       
  let $lengthEdificio := string-length($r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:Edificio)
  let $Edificio := $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/xs:string(ns4:Edificio) || ";"
                
  let $lengthIndirizzo := string-length($r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:Indirizzo)
  let $Indirizzo := $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/xs:string(ns4:Indirizzo) || ";"
  
  let $lengthLocalita := string-length($r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:Localita)
  let $Localita := $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/xs:string(ns4:Localita) || ";"
  let $lengthStatoEstero := string-length($r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:StatoEstero)
  let $StatoEstero := $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/xs:string(ns4:StatoEstero) || ";"
    
  let $erratoLengthDestinatario     := if ($lengthDestinatario < 4 or $lengthDestinatario > 40 ) then 1 else 0   
  let $erratoLengthInfoDestinatario := if ($lengthInfoDestinatario > 0 and ($lengthInfoDestinatario < 4 or $lengthInfoDestinatario > 40) ) then 1 else 0   
  let $erratoLengthEdificio         := if ($lengthEdificio > 0 and ($lengthEdificio < 7 or $lengthEdificio > 40) ) then 1 else 0   
  let $erratoLengthIndirizzo        := if ($lengthIndirizzo < 6 or $lengthIndirizzo > 40 ) then 1 else 0   
  let $erratoLengthLocalita         := if ($lengthLocalita < 12 or $lengthLocalita > 40 ) then 1 else 0   

 where
 (       
      ( 
         ( $lengthDestinatario < 4 or $lengthDestinatario > 40 ) or
         ( $lengthInfoDestinatario > 0 and ($lengthInfoDestinatario < 4 or $lengthInfoDestinatario > 40) ) or
         ( $lengthEdificio > 0 and ($lengthEdificio < 7 or $lengthEdificio > 40) )  or
         ( $lengthIndirizzo < 6 or $lengthIndirizzo > 40 ) or
         ( ($lengthLocalita < 12 and $lengthStatoEstero < 4 )or $lengthLocalita > 40 )

      )         
 ) 
      
group by  $TipoDocumento
return

<Conteggi>
 <Res nCartelle="{count($r)}" lotto="{distinct-values($pt)}" TipoDocumento="{$TipoDocumento}">
   <DatiIdentificativi>
      <idDocumento>{$idDocumento}</idDocumento>
      <numeroCartella>{$numeroCartella}</numeroCartella>
   </DatiIdentificativi>
   <valoriCampi>
     <Destinatario>{($Destinatario)}</Destinatario>       
      <InfoDestinatario>{($InfoDestinatario)}</InfoDestinatario>  
      <Edificio>{($Edificio)}</Edificio>   
      <Indirizzo>{($Indirizzo)}</Indirizzo> 
      <Localita>{($Localita)}</Localita>    
      <StatoEstero>{($StatoEstero)}</StatoEstero>    
   </valoriCampi>  
   <Errori>
    <erratoLengthDestinatario____ nErrori="{sum($erratoLengthDestinatario)}">{$erratoLengthDestinatario}</erratoLengthDestinatario____>
    <erratoLengthInfoDestinatario nErrori="{sum($erratoLengthInfoDestinatario)}">{$erratoLengthInfoDestinatario}</erratoLengthInfoDestinatario>
    <erratoLengthEdificio________ nErrori="{sum($erratoLengthEdificio)}">{$erratoLengthEdificio}</erratoLengthEdificio________>
    <erratoLengthIndirizzo_______ nErrori="{sum($erratoLengthIndirizzo)}">{$erratoLengthIndirizzo}</erratoLengthIndirizzo_______>
    <erratoLengthLocalita________ nErrori="{sum($erratoLengthLocalita)}">{$erratoLengthLocalita}</erratoLengthLocalita________>
   </Errori>
 </Res>
</Conteggi>
')

return $cartelle
  