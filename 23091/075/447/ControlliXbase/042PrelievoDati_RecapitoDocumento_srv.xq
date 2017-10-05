(:Layout rinotifiche:)
(: PRELIEVO DATI DA CONTROLLARE CON ETL ControlloRecapitoDocumento.ktr :)
(: Restituisce i dati da controllare con l'ETL :)

(: modifiche da apportare prima dell'esecuzione:
 Riga: for $r in db:open("23091-CommesseCarico-3042") :modificare la commessa 
 IN CASO DI RISULTATO TROPPO GRANDE CHE VIENE CHOPPATO, scommentare le righe dopo il return
 NOTA BENE: Dare un nuovo nome al file o assicurarsi che sia vuoto, altrimenti le righe verranno aggiunte a quanto già presente nel file
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

let $idLotto :=  $r//ns4:EstremiDocumento/@idLotto
where ($idLotto = "24415" or $idLotto ="24447" or $idLotto ="24448") 
return 

element RecapitoDocumento {
 
  $r//ns4:EstremiDocumento/@id ! element idCartella { data() },
  $r//ns4:RecapitoDocumento/@Presso ! element Presso { data() },
  $r//ns4:RecapitoDocumento/@TipoIndirizzo ! element TipoIndirizzo { data() },
  $r//ns4:RecapitoDocumento/@destinatarioPostale ! element destinatarioPostale { data() },
  $r//ns4:RecapitoDocumento/@id ! element idRecapito { data() },
  $r//ns4:RecapitoDocumento/ns2:Strada ! element Strada { data() },
  $r//ns4:RecapitoDocumento/ns2:Strada/@DUG ! element DUG { data() },
  $r//ns4:RecapitoDocumento/ns2:Strada/@codiceStradaComunale ! element codiceStradaComunale { data() },
  $r//ns4:RecapitoDocumento/ns2:Strada/@denominazioneStrada ! element denominazioneStrada { data() },
  $r//ns4:RecapitoDocumento/ns2:Strada/@id ! element idStrada { data() },
  $r//ns4:RecapitoDocumento/ns2:NumeroCivico ! element NumeroCivico { data() },
  $r//ns4:RecapitoDocumento/ns2:Esponente ! element Esponente { data() },
  $r//ns4:RecapitoDocumento/ns2:Cap ! element Cap { data() },
  $r//ns4:RecapitoDocumento/ns2:Localita ! element Localita { data() },
  $r//ns4:RecapitoDocumento/ns2:Citta ! element Citta { data() },
  $r//ns4:RecapitoDocumento/ns2:Provincia ! element Provincia { data() },
  $r//ns4:RecapitoDocumento/ns2:Note ! element Note { data() },
  $r//ns4:RecapitoDocumento/ns2:UbicazioneInterna/ns2:Scala ! element Scala { data() },
  $r//ns4:RecapitoDocumento/ns2:UbicazioneInterna/ns2:Interno ! element Interno { data() },
  $r//ns4:RecapitoDocumento/ns2:UbicazioneInterna/ns2:Piano ! element Piano { data() },
  $r//ns4:EstremiDocumento/@idLotto ! element idLotto  { data() }

}



')
return 


  file:append("/home/teresa/Scrivania/Dati Gestel/SOLORI/Controlli BaseX/Verona/075/447/3497/EstrazioneDatiRecapitoDocumento_3497.xml",  (:SCOMMENTARE PER SCRITTURA RISULTATO SU FILE:)

$cartelle



)   (:SCOMMENTARE PER SCRITTURA RISULTATO SU FILE:)


