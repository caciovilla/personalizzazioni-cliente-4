(: Verifiche varie: n CCP, eventuali date (emissione, rate), eventuali spese, etc.  :)
(: Restituisce i documenti che differiscono da quanto impostato nella where :)

(: modifiche da apportare prima dell'esecuzione:
 Riga: for $r in db:open("2904-CommesseCarico-2904") :modificare la commessa
 Righe:  $idCartellazioneProcedura = "68509" or ... modificare gli id o eliminare il controllo
 Verificare i controlli che devono essere effettuati per l'emissione ed eventualmente rimodulare i controlli della where
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
let $idDocumento := $r//ns4:EstremiDocumento/@id 
let $idRichiestaProcedura := $r//ns4:EstremiDocumento/@idRichiestaProcedura
let $idCartellazione := $r//ns4:EstremiDocumento/@idCartellazione


let $citta := ($r//ns4:RecapitoDocumento/xs:string(ns2:Citta))

let $spese := sum($r//ns4:Spese/ns4:Spesa/xs:decimal(ns4:ImportoSpesa)) 

let $TipoDocumento := $r//ns4:EstremiDocumento/ns4:TipoDocumento/@codice


let $DataEmissioneEstremi := $r//ns4:EstremiDocumento/xs:date(ns4:DataEmissione)

let $contoCorrentePostale := ($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:CCP/ns4:ContoCorrentePostale)

let $contoCorrentePostalePieno := $r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:CCP[ns4:ContoCorrentePostale!="" and ns4:ContoCorrentePostale!=" "]

let $CognomeFunzionario := $r//ns4:Informative/ns4:Funzionari/ns4:Funzionario[ns4:Ruolo="Presidente Concessionario"]/ns4:Cognome

let $TipoPostaliz:=  ($r//ns4:Postalizzazione/ns4:TipoPostalizzazione)

let $DataDecesso := $r//ns4:SoggettoIntestatario/PersonaFisica/DataDecesso
let $EtichettaDestinatario := $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:Destinatario

let $DataRataUnica := $r//ns4:Rate/ns4:RataTotale/ns4:ScadenzaRata

where
(  
  
      
   (          
    
     ( $TipoDocumento != "075") or                        
 
     ($spese !=  xs:decimal("2.15") ) or 
          
     ($DataEmissioneEstremi !=  xs:date("2016-02-22") ) or  
    
     
      
     
     ($CognomeFunzionario = "" or $CognomeFunzionario != "Alessandro Tatini") 
     
   )
 
)

return 

<Estratto path="{$pt}" idRichiestaProcedura="{$idRichiestaProcedura}" idCartellazione="{$idCartellazione}" nCartelle="{count($r)}" numeroCartella="{$r//ns4:EstremiDocumento/ns4:Numero}" idDocumento="{$idDocumento}">
<estremiDocumento>{xs:string($r//ns4:EstremiDocumento)}</estremiDocumento>
<errori>
 <TipoDocumento>{$TipoDocumento}</TipoDocumento>
 <citta>{$citta}</citta>
 <Spese>{$spese}</Spese> 
 <DataEmissione>{$DataEmissioneEstremi}</DataEmissione>
 <contoCorrentePostale>{xs:string($contoCorrentePostale)}</contoCorrentePostale>
 <contoCorrentePostaleRataTotalePieno>{count($contoCorrentePostalePieno)}</contoCorrentePostaleRataTotalePieno>
 <CognomeFunzionario>{xs:string($CognomeFunzionario)}</CognomeFunzionario>
 <DataDecesso>{$DataDecesso}</DataDecesso>
</errori>
</Estratto>
')

return $cartelle