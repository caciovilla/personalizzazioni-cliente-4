(:Layout 257:)
(: PRELIEVO DATI DA CONTROLLARE CON ETL UnaRataCodelineImportoVirtualIban :)
(: Restituisce i dati da controllare con l'ETL :)

(: modifiche da apportare prima dell'esecuzione:
 Riga: for $r in db:open("23091-CommesseCarico-3274") :modificare la commessa 
 IN CASO DI RISULTATO TROPPO GRANDE CHE VIENE CHOPPATO, scommentare le righe dopo il return
 NOTA BENE: Dare un nuovo nome al file o assicurarsi che sia vuoto, altrimenti le righe verranno aggiunte a quanto già presente nel file
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

let $tipoDocumento := $r//ns4:EstremiDocumento/ns4:TipoDocumento/ns4:CodiceDocumento
let $cVIban := count($r//ns4:Rate/ns4:Rata/ns4:CanaleIncasso/ns4:CCP/ns4:CanaleIncassoAusiliari/ns4:VirtualIBAN) +  count($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:CCP/ns4:CanaleIncassoAusiliari/ns4:VirtualIBAN)
let $idCartellazione := $r//ns4:EstremiDocumento/@idCartellazione



return 

element cartella {
  attribute idCartella { $r//ns4:EstremiDocumento/@id },
  attribute idRichiestaProcedura {$r//ns4:EstremiDocumento/@idRichiestaProcedura},
  attribute idLotto {$r//ns4:EstremiDocumento/@idLotto},
  attribute tipoDocumento {$r//ns4:EstremiDocumento/ns4:TipoDocumento/ns4:CodiceDocumento},
  attribute importo{ $r//ns4:EstremiDocumento/ns4:Importo },
  $r//ns4:EstremiDocumento/@id ! element idCartella { data() },
  $r//ns4:SoggettoEmittente/@codiceEnte ! element codiceEnte { data() },
  $r//ns4:SoggettoIntestatario/PersonaGiuridica/@keyesterna ! element keyesterna { data() },
  $r//ns4:SoggettoIntestatario/PersonaFisica/@keyesterna ! element keyesterna { data() },
  $r//ns4:EstremiDocumento/ns4:Importo ! element importo { data() },  
  $r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:CCP/ns4:CanaleIncassoAusiliari/ns4:VirtualIBAN ! element VirtualIBAN { data() },
  $r//ns4:Rate/ns4:Rata/ns4:CanaleIncasso/ns4:CCP/ns4:CanaleIncassoAusiliari/ns4:VirtualIBAN ! element VirtualIBAN { data() },
  $r//ns4:EstremiDocumento/ns4:Numero ! element numeroDocumento { data() },
  $r//ns4:Rate/ns4:Rata/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns6:IdentificativoOperazioneDaEnte ! element codeline { data() },
  $r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns6:IdentificativoOperazioneDaEnte ! element codeline { data() },
  $r//ns4:Rate/ns4:Rata/ns4:CanaleIncasso/ns4:CCP/ns4:CodiceCliente ! element codeline { data() },
  $r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:CCP/ns4:CodiceCliente ! element codeline { data() },
  $r//ns4:EstremiDocumento/@idLotto ! element idLotto  { data() },
  $r//ns4:EstremiDocumento/ns4:TipoDocumento/ns4:CodiceDocumento ! element tipoDocumento  { data() }

}


')
return 


  file:append("E:\DatiE\gestel\ControlliMassiviXmlv3\OUTxBASE\DATIcARTELLE_3274.txt",  (:SCOMMENTARE PER SCRITTURA RISULTATO SU FILE:)

$cartelle



)   (:SCOMMENTARE PER SCRITTURA RISULTATO SU FILE:)



