(:Layout rinotifiche:)
(: PRELIEVO DATI DA CONTROLLARE CON ETL ControlloEtichettaDestinatario.ktr :)
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

let $idCartellazione := $r//ns4:EstremiDocumento/@idCartellazione
let $idLotto := $r//ns4:EstremiDocumento/@idLotto


return 

element EtichettaDestinatario {
  attribute idRichiestaProcedura {$r//ns4:EstremiDocumento/@idRichiestaProcedura},
  $r//ns4:EstremiDocumento/@id ! element idCartella { data() },
  $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:Destinatario ! element Destinatario { data() },
  $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:InfoDestinatario ! element InfoDestinatario { data() },
  $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:Edificio ! element Edificio { data() },
  $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:Indirizzo ! element Indirizzo { data() },
  $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:Localita ! element Localita { data() },
  $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:StatoEstero ! element StatoEstero { data() },
  $r//ns4:EstremiDocumento/@idLotto ! element idLotto  { data() }

}


')
return 

 file:append("E:\DatiE\gestel\ControlliMassiviXmlv3\OUTxBASE\ETICHETTA_tutti.txt",   (:SCOMMENTARE PER SCRITTURA RISULTATO SU FILE:)

$cartelle



)   (:SCOMMENTARE PER SCRITTURA RISULTATO SU FILE:)


