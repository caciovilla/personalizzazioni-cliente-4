
(: CONTROLLO DECEDUTI  :)
(: Restituisce I DECEDUTI CHE NON HANNO LA DICITURA eREDI DI :)

(: modifiche da apportare prima dell'esecuzione:
 Riga: for $r in db:open("23091-CommesseCarico-3274") :modificare la commessa
 Righe:  $idCartellazione = "68477" or ... modificare gli id o eliminare il controllo 
 Verificare l'utilizzo del modello layout specifico, altrimenti rimodulare i controlli sul nuovo layout
:)

let $c := client:connect('128.1.2.106', 1984, 'admin', 'admin')

for $cartelle in client:query($c,'
declare namespace ns4="urn:it:sintax:schema:cartellazione";
declare namespace ns2="urn:it:sintax:schema:indirizzi";
declare namespace ns6="urn:it:sintax:schema:f24";
declare default element namespace "urn:it:sintax:schema:soggetto";
declare decimal-format local:it decimal-separator = "," grouping-separator = "." ;

declare namespace functx = "http://www.functx.com";
declare function functx:value-except
  ( $arg1 as xs:anyAtomicType* ,
    $arg2 as xs:anyAtomicType* )  as xs:anyAtomicType* {

  distinct-values($arg1[not(.=$arg2)])
 } ;
 
 
let $numberFormat := "#,##"
let $formatName := "local:it"

for $r in db:open("23091-CommesseCarico-3274")

let $TipoPostaliz:=  ($r//ns4:Postalizzazione/ns4:TipoPostalizzazione)
let $DataDecesso := $r//ns4:SoggettoIntestatario/PersonaFisica/DataDecesso
let $EtichettaDestinatario := $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:Destinatario

let $pt := substring(db:path($r),1,11) 

let $idDocumento := $r//ns4:EstremiDocumento/@id
let $NumeroDocumento := $r//ns4:EstremiDocumento/ns4:Numero
let $idRichiestaProcedura := $r//ns4:EstremiDocumento/@idRichiestaProcedura
let $idCartellazione := $r//ns4:EstremiDocumento/@idCartellazione
let $tipoDocumento := $r//ns4:EstremiDocumento/ns4:TipoDocumento/ns4:CodiceDocumento
let $idLotto :=  $r//ns4:EstremiDocumento/@idLotto
let $TipoIndirizzo := $r//ns4:RecapitoDocumento/@TipoIndirizzo

where                 
    
    ( $DataDecesso != "" and (not(fn:contains($EtichettaDestinatario, "Eredi di" )) and not(fn:contains($EtichettaDestinatario, "EREDI DI" )) )) or
    
    ( $DataDecesso = "" and (fn:contains($EtichettaDestinatario, "Eredi di" ) or (fn:contains($EtichettaDestinatario, "EREDI DI" )) ))

group by $idLotto, $tipoDocumento, $idDocumento

return

<Res>
<contatori>  
  <idLotto>{xs:string($idLotto)}</idLotto>
  <idDocumento>{xs:string($idDocumento)}</idDocumento>
  <NumeroDocumento>''{xs:string($NumeroDocumento)}</NumeroDocumento> 
  <tipoDocumento>{xs:string($tipoDocumento)}</tipoDocumento> 
</contatori>
<varie>
 <TipoIndirizzo>{xs:string($TipoIndirizzo)}</TipoIndirizzo>
 <DataDecesso>{xs:string($DataDecesso)}</DataDecesso>
 <EtichettaDestinatario>{xs:string($EtichettaDestinatario)}</EtichettaDestinatario>
 <TipoPostaliz>{xs:string($TipoPostaliz)}</TipoPostaliz>
 </varie>
</Res>

')
return $cartelle