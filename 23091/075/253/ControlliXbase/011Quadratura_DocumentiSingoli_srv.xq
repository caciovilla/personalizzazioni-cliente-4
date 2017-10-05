(:Layout 253:)
(: Quadrature totali di tutto il plico da raffrontare anche sui totali presenti su DB tramite Select  :)
(: Restituisce i valori dei totali delle voci presenti sull'avviso :)

(: modifiche da apportare prima dell'esecuzione:
 Riga: for $r in db:open("2904-CommesseCarico-2990") :modificare la commessa
 Righe:  $idCartellazioneProcedura = "68509" or ... modificare gli id o eliminare il controllo
 Verificare l'utilizzo del modello layout specifico, altrimenti rimodulare i controlli sul nuovo layout
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

let $imp := $r//ns4:EstremiDocumento/xs:decimal(ns4:Importo)

(:calcolo contatori:)
let $cVIban := $r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:CCP/ns4:CanaleIncassoAusiliari/ns4:VirtualIBAN
let $cittaVerona := ($r//ns4:RecapitoDocumento[ns2:Citta="VERONA"])
let $cittaNotVerona := ($r//ns4:RecapitoDocumento[ns2:Citta!="VERONA"])
let $Domestica :=  $r//ns4:Articoli/ns4:Articolo/ns4:StrutturaArticolo/OGGETTO/UTENZA[@TIPO-UTENZA="DOMESTICA"]
let $DomesticaSI := $r//ns4:Articoli/ns4:Articolo/ns4:StrutturaArticolo/OGGETTO/SERVIZI_INDIVISIBILI[@TIPO-UTENZA="DOMESTICA"]
let $NonDomestica :=  $r//ns4:Articoli/ns4:Articolo/ns4:StrutturaArticolo/OGGETTO/UTENZA[@TIPO-UTENZA="NON DOMESTICA"]
let $NonDomesticaSI := $r//ns4:Articoli/ns4:Articolo/ns4:StrutturaArticolo/OGGETTO/SERVIZI_INDIVISIBILI[@TIPO-UTENZA="NON DOMESTICA"]
let $CognomeFunzionarioPieno := $r//ns4:Informative/ns4:Funzionari/ns4:Funzionario[ns4:Ruolo="Presidente Concessionario" and ns4:Cognome!="" and ns4:Cognome!=" "]
let $docCollegati := $r//ns4:DocumentiCollegati/ns4:DocumentoCollegato
    

(:calcoli prospetto vecchio avviso:)
let $importoOrigine := sum($r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/xs:decimal(ns4:Importo))
let $importoDiscaricato :=  sum($r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/xs:decimal(ns4:ImportoDiscaricato))
let $importoRiscosso :=  sum($r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/xs:decimal(ns4:ImportoPagato))
let $Residuo := $importoOrigine - $importoDiscaricato - $importoRiscosso



(:totali dell articolo:)
let $idCarOR2 := $r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/@id
let $ImportoQUOTAFISSA :=  sum($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="QUOTA FISSA"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoQUOTAVARIABILE := sum($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="QUOTA VARIABILE"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoAddProv := sum($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="Addizionale Provinciale"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoTassaPura := sum($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="TASSA PURA"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoSI := sum($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="Servizi Indivisibili"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoSERVIZI := ($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="SERVIZI"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoDiversoPrec := sum($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce!="QUOTA FISSA" and ns4:DescrizioneVoce!="QUOTA VARIABILE" and ns4:DescrizioneVoce!="Addizionale Provinciale" and ns4:DescrizioneVoce!="TASSA PURA" and ns4:DescrizioneVoce!="Servizi Indivisibili" and ns4:DescrizioneVoce!="SERVIZI"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoTotale :=  sum($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce/xs:decimal(ns4:ImponibileVoce))

let $AltroArr :=  sum($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio!="18"]/ns4:Voci/ns4:Voce/xs:decimal(ns4:ImponibileVoce))

(:totali dell accertamento:)
let $TotaleDovuto :=  sum($r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/xs:decimal(ns4:Importo))
let $ImportoPagato := sum($r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/xs:decimal(ns4:ImportoPagato))
let $ImportoDiscaricato := sum($r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/xs:decimal(ns4:ImportoDiscaricato))
let $TotaleVersato := $ImportoPagato + $ ImportoDiscaricato
let $Differenza := $TotaleDovuto -  $TotaleVersato
let $DirittiDiNotifica :=  sum($r//ns4:Spese/ns4:Spesa[@tipoSpesa="N" and @idCartellaOrigine="0" and ns4:DescrizioneSpesa="Spese di notifica del presente atto"]/xs:decimal(ns4:ImportoSpesa))
let $TotaleDaVersareEstremiDoc :=  ($r//ns4:EstremiDocumento/xs:decimal(ns4:Importo))
let $TotCalcolato := $Differenza + $DirittiDiNotifica

(: CONTEGGI F24 RATA TOTALE :)

let $sommaImportoRata := sum($r//ns4:Rate/ns4:RataTotale/xs:decimal(ns4:ImportoRata))     
let $sommaImportoDebitoRigaF24 := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Righe/ns5:Riga/xs:decimal(ns5:ImportoDebito))
let $sommaImportoDebitoRigaF24_3944 := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Righe/ns5:Riga[ns5:CodiceTributo="3944"]/xs:decimal(ns5:ImportoDebito))
let $sommaImportoDebitoRigaF24_3955 := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Righe/ns5:Riga[ns5:CodiceTributo="3955"]/xs:decimal(ns5:ImportoDebito))
  (: sezione totali fuori dalla riga:)
let $sommaTotaleDebito := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Totali/xs:decimal(ns5:TotaleDebito))
let $sommaTotaleCredito := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Totali/xs:decimal(ns5:TotaleCredito))
let $sommaTotaleSaldo := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Totali/xs:decimal(ns5:TotaleSaldo))  
let $sommaTotaleDelega := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Delega/xs:decimal(ns5:SaldoTotaleDebito))  


(: CONTEGGI BOLLETTINO :)
(:
let $sommaImportoRata := sum($r//ns4:Rate/ns4:RataTotale/xs:decimal(ns4:ImportoRata))     
let $sommaImportoCCP := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:CCP/xs:decimal(ns4:ImportoRata))
:)

(:
let $difBOLL1 := $sommaImportoRata - $sommaImportoCCP
let $difBOLL2 := $sommaImportoRata - $TotaleDaVersareEstremiDoc
:)
let $difTotale := $TotaleDaVersareEstremiDoc - $TotCalcolato

let $pt := substring(db:path($r),1,11)
let $idDocumento := $r//ns4:EstremiDocumento/@id
let $idRichiestaProcedura := $r//ns4:EstremiDocumento/@idRichiestaProcedura

where
(  
   (: ( $idRichiestaProcedura = "2141" or
      $idRichiestaProcedura = "2142" )
        and
   :) 
   
   
   
   (: ( $idDocumento = "4231263" ) and :)
   
   (       
     ( $sommaImportoRata !=  $sommaImportoDebitoRigaF24 ) or
     ( $sommaImportoDebitoRigaF24 != $sommaImportoDebitoRigaF24_3944 ) or
     ( $sommaTotaleDebito != $sommaImportoDebitoRigaF24_3944 ) or
     ( $sommaTotaleCredito != 0 ) or
     ( $sommaTotaleSaldo != 0 ) or
     ( $sommaTotaleDelega != $sommaImportoDebitoRigaF24_3944 ) or
     ( $sommaImportoRata != $TotaleDaVersareEstremiDoc) or       
     ( $TotaleDaVersareEstremiDoc != $TotCalcolato ) or 
     ( $sommaImportoDebitoRigaF24_3955 != 0) or
     ( ( $ImportoTotale + $AltroArr ) != $importoOrigine) or
     
     ( $Differenza != $Residuo)
   )
)

return 
<Estratto idRichiestaProcedura="{$idRichiestaProcedura}" pt="{$pt}" numeroCartella="{$r//ns4:EstremiDocumento/ns4:Numero}" idDocumento="{$idDocumento}" cf="{$r//ns4:SoggettoIntestatario/PersonaFisica/CodiceFiscale}" piva="{$r//ns4:SoggettoIntestatario/PersonaGiuridica/PartitaIva}" denominazioneItestatario="{$r//ns4:SoggettoIntestatario/PersonaGiuridica/Denominazione}{$r//ns4:SoggettoIntestatario/PersonaFisica/Cognome} {$r//ns4:SoggettoIntestatario/PersonaFisica/Nome}">
<differenzaImporto>
 <!-- 
<conteggiCCP>
<sommaImportoRata>{sum($sommaImportoRata)}</sommaImportoRata>
<sommaImportoCCP>{sum($sommaImportoCCP)}</sommaImportoCCP>
</conteggiCCP>
 -->

<ConteggiF24>
   <RataTotale>
    <sommaImportoRata>{sum($sommaImportoRata)}</sommaImportoRata>    
    <sommaImportoDebitoRigaF24>{sum($sommaImportoDebitoRigaF24)}</sommaImportoDebitoRigaF24>     
    <sommaImportoDebitoRigaF24_3955>{sum($sommaImportoDebitoRigaF24_3955)}</sommaImportoDebitoRigaF24_3955>    
    <sommaImportoDebitoRigaF24_3944>{sum($sommaImportoDebitoRigaF24_3944)}</sommaImportoDebitoRigaF24_3944>        
    <TotaliOutRiga nota="A livello sezione, fuori dalla riga">
      <sommaTotaleDebito>{sum($sommaTotaleDebito)}</sommaTotaleDebito>
      <sommaTotaleCredito>{sum($sommaTotaleCredito)}</sommaTotaleCredito>
      <sommaTotaleSaldo>{sum($sommaTotaleSaldo)}</sommaTotaleSaldo>
    </TotaliOutRiga>
    <Delega>{sum($sommaTotaleDelega)}</Delega>
  </RataTotale>
</ConteggiF24>
  <ImportoTotale>{$ImportoTotale}</ImportoTotale>
  <AltroArr>{$AltroArr}</AltroArr>
  <importoOrigine>{$importoOrigine}</importoOrigine>
  <TotaleDaVersareEstremiDoc>{$TotaleDaVersareEstremiDoc}</TotaleDaVersareEstremiDoc>    
  <TotCalcolato>{$TotCalcolato}</TotCalcolato>

  <difTotale>*****{$difTotale}*****</difTotale>
</differenzaImporto>
<importi>
  <TotaleDovuto>{$TotaleDovuto}</TotaleDovuto>

  <TotaleVersato>{$TotaleVersato}</TotaleVersato>
  <Differenza>{$Differenza}</Differenza>
  <DirittiDiNotifica>{$DirittiDiNotifica}</DirittiDiNotifica> 
  <TotCalcolato>{$TotCalcolato}</TotCalcolato>
  <TotaleDaVersareEstremiDoc>{$TotaleDaVersareEstremiDoc}</TotaleDaVersareEstremiDoc>
</importi>

</Estratto>
')
return $cartelle