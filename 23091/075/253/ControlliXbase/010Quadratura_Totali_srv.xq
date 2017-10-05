(:Layout 253:)
(: Quadrature totali di tutto il plico da raffrontare anche sui totali presenti su DB tramite Select  :)
(: Restituisce i valori dei totali delle voci presenti sull'avviso :)

(: modifiche da apportare prima dell'esecuzione:
 Riga: for $r in db:open("29021-CommesseCarico-2990") :modificare la commessa
 Righe:  $idCartellazione = "68509" or ... modificare gli id o eliminare il controllo 
 Verificare l'utilizzo del modello layout specifico, altrimenti rimodulare i controlli sul nuovo layout
:)

let $c := client:connect('128.1.0.210', 1984, 'admin', 'admin')

for $cartelle in client:query($c,'
declare namespace ns4="urn:it:sintax:schema:cartellazione";
declare namespace ns2="urn:it:sintax:schema:indirizzi";
declare namespace ns5="urn:it:sintax:schema:f24";
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


(:totali dell articolo con un solo doc collegato:)

let $idCarOR2 := $r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/@id
let $ImportoQUOTAFISSA :=  ($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="QUOTA FISSA"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoQUOTAVARIABILE := ($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="QUOTA VARIABILE"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoTASSAPURA := ($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="TASSA PURA"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoAddProv := ($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="Addizionale Provinciale"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoSI := ($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="Servizi Indivisibili"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoSERVIZI := ($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="SERVIZI"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoDiversoPrec := ($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce!="QUOTA FISSA" and ns4:DescrizioneVoce!="QUOTA VARIABILE" and ns4:DescrizioneVoce!="Addizionale Provinciale" and ns4:DescrizioneVoce!="TASSA PURA" and ns4:DescrizioneVoce!="Servizi Indivisibili" and ns4:DescrizioneVoce!="SERVIZI"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoTotale :=  ($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce/xs:decimal(ns4:ImponibileVoce))
let $AltroTrib :=  ($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio!="32" and @codiceServizio!="18"]/ns4:Voci/ns4:Voce/xs:decimal(ns4:ImponibileVoce))
let $AltroArr :=  ($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="32"]/ns4:Voci/ns4:Voce/xs:decimal(ns4:ImponibileVoce))


(:totali dell articolo con piu doc collegati :)
(:
let $ImportoQUOTAFISSA :=  sum($r//ns4:Articoli/ns4:Articolo[@codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="QUOTA FISSA"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoQUOTAVARIABILE := sum($r//ns4:Articoli/ns4:Articolo[@codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="QUOTA VARIABILE"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoAddProv := sum($r//ns4:Articoli/ns4:Articolo[@codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce="Addizionale Provinciale"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoDiversoPrec := sum($r//ns4:Articoli/ns4:Articolo[@codiceServizio="18"]/ns4:Voci/ns4:Voce[ns4:DescrizioneVoce!="QUOTA FISSA" and ns4:DescrizioneVoce!="QUOTA VARIABILE" and ns4:DescrizioneVoce!="Addizionale Provinciale"]/xs:decimal(ns4:ImponibileVoce))
let $ImportoTotale :=  sum($r//ns4:Articoli/ns4:Articolo[@codiceServizio="18"]/ns4:Voci/ns4:Voce/xs:decimal(ns4:ImponibileVoce))

let $AltroArr :=  sum($r//ns4:Articoli/ns4:Articolo[@codiceServizio!="18"]/ns4:Voci/ns4:Voce/xs:decimal(ns4:ImponibileVoce))
:)


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

let $pt := substring(db:path($r),1,11)
let $idDocumento := $r//ns4:EstremiDocumento/@id
let $idRichiestaProcedura := $r//ns4:EstremiDocumento/@idRichiestaProcedura

(:
where
 (:$idDocumento = "4357704" and :)
(

      $idRichiestaProcedura = "2141" or
      $idRichiestaProcedura = "2142"
)
:)

group by $pt, $idRichiestaProcedura
return
<Res path="{$pt}" idRichiestaProcedura="{$idRichiestaProcedura}" nCartelle="{count($r)}" totaleEstremiDocumento="{sum($imp)}" nVirtualIban="{count($cVIban)}" >
<contatori>
  <nCartelle>{count($r)}</nCartelle>
  <cVIban>{count($cVIban)}</cVIban>
  <cittaVerona>{count($cittaVerona)}</cittaVerona>
  <cittaNotVerona>{count($cittaNotVerona)}</cittaNotVerona>
  <Domestica>{count($Domestica)}</Domestica>
  <NonDomestica>{count($NonDomestica)}</NonDomestica>
  <DomesticaSI>{count($DomesticaSI)}</DomesticaSI>
  <NonDomesticaSI>{count($NonDomesticaSI)}</NonDomesticaSI>
  <CognomeFunzionarioPieno>{count($CognomeFunzionarioPieno)}</CognomeFunzionarioPieno>
  <docCollegati>{count($docCollegati)}</docCollegati>
</contatori>

<ProspettoVecchioAvviso> 
  <importoOrigine>{sum($importoOrigine)}</importoOrigine>
  <importoDiscaricato>{sum($importoDiscaricato)}</importoDiscaricato>
  <importoRiscosso>{sum($importoRiscosso)}</importoRiscosso>
  <Residuo>{sum($Residuo)}</Residuo>
</ProspettoVecchioAvviso>

<TotaliArticolo>
  <ImportoQUOTAFISSA>{sum($ImportoQUOTAFISSA)}</ImportoQUOTAFISSA>
  <ImportoQUOTAVARIABILE>{sum($ImportoQUOTAVARIABILE)}</ImportoQUOTAVARIABILE>
  <ImportoAddProv>{sum($ImportoAddProv)}</ImportoAddProv>
  <ImportoTassaPura>{sum($ImportoTASSAPURA)}</ImportoTassaPura>
  <ImportoSI>{sum($ImportoSI)}</ImportoSI>
  <ImportoSERVIZI>{sum($ImportoSERVIZI)}</ImportoSERVIZI>
  <ImportoDiversoPrec>{sum($ImportoDiversoPrec)}</ImportoDiversoPrec>
  <ImportoTotale>{sum($ImportoTotale)}</ImportoTotale>  
  <AltroArr>{sum($AltroArr)}</AltroArr>   
  <AltroTrib>{sum($AltroTrib)}</AltroTrib>
  <Nota>dovuto calcolato deve essere uguale importo origine</Nota>
  <Dovutocalcolato>{sum($ImportoTotale) + sum($AltroArr) + sum($AltroTrib) }</Dovutocalcolato> 
</TotaliArticolo>

<TotaliDellAccertamento>
  <Nota2>TotaleDovuto deve essere uguale a dovuto calcolato e importo origine</Nota2>
  <TotaleDovuto>{sum($TotaleDovuto)}</TotaleDovuto>
  <TotaleVersato>{sum($TotaleVersato)}</TotaleVersato>
  <Nota3>Differenza deve essere uguale a Residuo</Nota3>
  <Differenza>{sum($Differenza)}</Differenza>
  <DirittiDiNotifica>{sum($DirittiDiNotifica)}</DirittiDiNotifica>
  <DirittiDiNotificaCalc>{count($r)*2.15}</DirittiDiNotificaCalc>
  <TotaleDaVersareEstremiDoc>{sum($TotaleDaVersareEstremiDoc)}</TotaleDaVersareEstremiDoc>
  <TotCalcolato>{sum($TotCalcolato)}</TotCalcolato>
</TotaliDellAccertamento>
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

</Res>
')
return $cartelle