(:Layout 447:)
(: Verifiche varie: n CCP, eventuali date (emissione, rate), eventuali spese, etc.  :)
(: Restituisce i documenti che differiscono da quanto impostato nella where :)

(: modifiche da apportare prima dell'esecuzione:
 Riga: for $r in db:open("23091-CommesseCarico-2898") :modificare la commessa
 
 Righe: CognomeFunzionario viene controllato in quanto l'immagine della firma ha un valore fisso, viene quindi raffrontata la firma usata nell'xslt con il nominativo impostato nell'xml
 
 Righe:  ($idLotto = "11144" and ($TipoPostalizzazione != "003" or $citta != "VERONA")) or
 ($idLotto = "11145" and ($TipoPostalizzazione != "007" or $citta = "VERONA")) :modificare l'id lotto
 
 Verificare i controlli che devono essere effettuati per l'emissione ed eventualmente rimodulare i controlli della where
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


let $citta := ($r//ns4:RecapitoDocumento/xs:string(ns2:Citta))

let $DirittiDiNotifica :=  sum($r//ns4:Spese/ns4:Spesa[@tipoSpesa="N" and  @idCartellaOrigine="0" and ns4:DescrizioneSpesa!="DIRITTI DI RINOTIFICA"]/xs:decimal(ns4:ImportoSpesa))

let $TipoDocumento := $r//ns4:EstremiDocumento/ns4:TipoDocumento/@codice

let $DataEmissioneEstremi := $r//ns4:EstremiDocumento/xs:date(ns4:DataEmissione)
let $idLotto := $r//ns4:EstremiDocumento/@idLotto
let $contoCorrentePostale := ($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:CCP/ns4:ContoCorrentePostale)

let $contoCorrentePostalePieno := $r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:CCP[ns4:ContoCorrentePostale!="" and ns4:ContoCorrentePostale!=" "]

let $CognomeFunzionarioPresidente := $r//ns4:Informative/ns4:Funzionari/ns4:Funzionario[ns4:Ruolo="Presidente Concessionario"]/ns4:Cognome
let $CognomeFunzionarioMesso := $r//ns4:Informative/ns4:Funzionari/ns4:Funzionario[ns4:Ruolo="Messo Notificatore"]/ns4:Cognome

let $TipoPostalizzazione := $r//ns4:Postalizzazione/xs:string(ns4:TipoPostalizzazione)
 

where ($idLotto = "24415" or $idLotto ="24447" or $idLotto ="24448")  and (  

 ( $TipoDocumento != "075")  or 
 (:$DirittiDiNotifica!=xs:decimal("2.15") or
  
 ($DataEmissioneEstremi !=  xs:date("2017-02-06") ) or  :)
 ($contoCorrentePostale != "1019361698") or  
 ($CognomeFunzionarioPresidente != "Alessandro Tatini" ) or
 ($CognomeFunzionarioMesso != "Rosa Caldarelli") 
 
 
)

return 
<Estratto numeroCartella="{$r//ns4:EstremiDocumento/ns4:Numero}" cf="{$r//ns4:SoggettoIntestatario/PersonaFisica/CodiceFiscale}" piva="{$r//ns4:SoggettoIntestatario/PersonaGiuridica/PartitaIva}" denominazioneItestatario="{$r//ns4:SoggettoIntestatario/PersonaGiuridica/Denominazione}{$r//ns4:SoggettoIntestatario/PersonaFisica/Cognome} {$r//ns4:SoggettoIntestatario/PersonaFisica/Nome}">
<estremiDocumento>{$r//ns4:EstremiDocumento}</estremiDocumento>
<errori>
 <TipoDocumento>{$TipoDocumento}</TipoDocumento>
 <!-- <TipoDocumentoCollegato>{$TipoDocumentoCollegato}</TipoDocumentoCollegato> -->
 <citta>{$citta}</citta>
 <DirittiDiNotifica>{$DirittiDiNotifica}</DirittiDiNotifica> 
 <DataEmissione>{$DataEmissioneEstremi}</DataEmissione>
 <contoCorrentePostale>{xs:string($contoCorrentePostale)}</contoCorrentePostale>
 <contoCorrentePostalePieno>{count($contoCorrentePostalePieno)}</contoCorrentePostalePieno>
 <CognomeFunzionarioPresidente>{xs:string($CognomeFunzionarioPresidente)}</CognomeFunzionarioPresidente>
 <CognomeFunzionarioMesso>{xs:string($CognomeFunzionarioMesso)}</CognomeFunzionarioMesso>
 <idLotto>{$idLotto}</idLotto>
 <TipoPostalizzazione>{$TipoPostalizzazione}</TipoPostalizzazione>
</errori>
</Estratto>
')

return $cartelle