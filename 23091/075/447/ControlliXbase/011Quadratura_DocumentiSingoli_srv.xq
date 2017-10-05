(:Layout 447:)
(: Quadrature totali di tutto il plico da raffrontare anche sui totali presenti su DB tramite Select  :)
(: Restituisce i valori dei totali delle voci presenti sull'avviso :)

(: modifiche da apportare prima dell'esecuzione:
 Riga: for $r in db:open("23091-CommesseCarico-3042") :modificare la commessa
 Righe:  $idCartellazione = "68509" or ... modificare gli id o eliminare il controllo 
 Verificare l'utilizzo del modello layout specifico, altrimenti rimodulare i controlli sul nuovo layout
:)

let $c := client:connect('128.1.0.234', 1984, 'admin', 'admin')

for $cartelle in client:query($c,'
declare namespace ns4="urn:it:sintax:schema:cartellazione";
declare namespace ns2="urn:it:sintax:schema:indirizzi";
declare namespace ns5="urn:it:sintax:schema:f24";
declare default element namespace "urn:it:sintax:schema:soggetto";
declare decimal-format local:it decimal-separator = "," grouping-separator = "." ;
let $numberFormat := "#,##"
let $formatName := "local:it"

for $r in db:open("23091-CommesseCarico-3497")

let $imp := $r//ns4:EstremiDocumento/xs:decimal(ns4:Importo)

(:calcolo contatori:)
let $cVIban := $r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:CCP/ns4:CanaleIncassoAusiliari/ns4:VirtualIBAN
let $cittaVerona := ($r//ns4:RecapitoDocumento[ns2:Citta="VERONA"])
let $cittaNotVerona := ($r//ns4:RecapitoDocumento[ns2:Citta!="VERONA"])
let $Domestica :=  $r//ns4:Articoli/ns4:Articolo/ns4:StrutturaArticolo/OGGETTO/UTENZA[@TIPO-UTENZA="DOMESTICA"]
let $DomesticaSI := $r//ns4:Articoli/ns4:Articolo/ns4:StrutturaArticolo/OGGETTO/SERVIZI_INDIVISIBILI[@TIPO-UTENZA="DOMESTICA"]
let $NonDomestica :=  $r//ns4:Articoli/ns4:Articolo/ns4:StrutturaArticolo/OGGETTO/UTENZA[@TIPO-UTENZA="NON DOMESTICA"]
let $NonDomesticaSI := $r//ns4:Articoli/ns4:Articolo/ns4:StrutturaArticolo/OGGETTO/SERVIZI_INDIVISIBILI[@TIPO-UTENZA="NON DOMESTICA"]
let $CognomeFunzionarioResTribPieno := $r//ns4:Informative/ns4:Funzionari/ns4:Funzionario[ns4:Ruolo="Funzionario Responsabile Tributo" and ns4:Cognome="Ing. Livio Simone"]
let $docCollegati := $r//ns4:DocumentiCollegati/ns4:DocumentoCollegato
let $RataTotale := $r//ns4:Rate/ns4:RataTotale
let $Rate := $r//ns4:Rate/ns4:Rata

let $countNotifica := count($r//ns4:Spese/ns4:Spesa[@tipoSpesa="N" and @idCartellaOrigine="0" and ns4:DescrizioneSpesa="Spese di notifica del presente atto"])
let $countRiNotifica := count($r//ns4:Spese/ns4:Spesa[@tipoSpesa="N" and @idCartellaOrigine="0" and ns4:DescrizioneSpesa="DIRITTI DI RINOTIFICA"])
let $countDiritti := $countNotifica + $countRiNotifica
let $countContoCorrentePostale := 0

(:calcoli prospetto vecchio avviso:)
let $importoOrigine := sum($r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/xs:decimal(ns4:Importo))
let $importoDiscaricato :=  sum($r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/xs:decimal(ns4:ImportoDiscaricato))
let $importoRiscosso :=  sum($r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/xs:decimal(ns4:ImportoPagato))
let $Residuo := $importoOrigine - $importoDiscaricato - $importoRiscosso


(:totali dell articolo funziona anche con più di un documenti collegato:)

let $IMPORTO := sum($r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/xs:decimal(ns4:Importo))

let $idCarOR2 := $r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/@id
let $ImportoTotale :=  sum($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="18"]/ns4:Voci/ns4:Voce/xs:decimal(ns4:ImponibileVoce))
let $Altro :=  sum($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio!="18" and @codiceServizio!="32"]/ns4:Voci/ns4:Voce/xs:decimal(ns4:ImponibileVoce))
let $Arrotondamento :=  sum($r//ns4:Articoli/ns4:Articolo[@idDocumentoCollegato=$idCarOR2 and @codiceServizio="32"]/ns4:Voci/ns4:Voce/xs:decimal(ns4:ImponibileVoce))

let $IMPORTOCalcolato := $ImportoTotale + $Altro + $Arrotondamento

let $difIMPORTO :=  $IMPORTOCalcolato - $IMPORTO     (:*****************:)
let $difIMPORTOImportoOrigine := $IMPORTO - $importoOrigine (:*****************:)




(:totali dell accertamento:)
let $TOTALE_DOVUTO :=  sum($r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/xs:decimal(ns4:Importo))
let $TOTALE_VERSATO := sum($r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/xs:decimal(ns4:ImportoPagato)) + sum($r//ns4:DocumentiCollegati/ns4:DocumentoCollegato/xs:decimal(ns4:ImportoDiscaricato))
let $DIFFERENZA := $TOTALE_DOVUTO - $TOTALE_VERSATO
let $DIRITTI_DI_NOTIFICA :=  sum($r//ns4:Spese/ns4:Spesa[@tipoSpesa="N" and @idCartellaOrigine="0" and ns4:DescrizioneSpesa="Spese di notifica del presente atto"]/xs:decimal(ns4:ImportoSpesa))
let $DIRITTI_DI_RINOTIFICA :=  sum($r//ns4:Spese/ns4:Spesa[@tipoSpesa="N" and @idCartellaOrigine="0" and ns4:DescrizioneSpesa="DIRITTI DI RINOTIFICA"]/xs:decimal(ns4:ImportoSpesa))

let $TotaleDaVersareEstremiDoc :=  sum($r//ns4:EstremiDocumento/xs:decimal(ns4:Importo))

let $TotCalcolato := $DIFFERENZA + $DIRITTI_DI_NOTIFICA + $DIRITTI_DI_RINOTIFICA

let $DIF_TOTALE := $TotCalcolato - $TotaleDaVersareEstremiDoc    (:*****************:)
let $DIF_DIFFERENZA_RESIDUO := $DIFFERENZA - $Residuo  (:*****************:)

(: CONTEGGI F24 RATA TOTALE :)

let $sommaImportoRata := sum($r//ns4:Rate/ns4:RataTotale/xs:decimal(ns4:ImportoRata))     
let $sommaImportoDebitoRigaF24 := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Righe/ns5:Riga/xs:decimal(ns5:ImportoDebito))
let $sommaImportoDebitoRigaF24_3944 := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Righe/ns5:Riga[ns5:CodiceTributo="3944"]/xs:decimal(ns5:ImportoDebito))
let $sommaImportoDebitoRigaF24_3955 := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Righe/ns5:Riga[ns5:CodiceTributo="3955"]/xs:decimal(ns5:ImportoDebito))
let $sommaImportoDebitoRigaF24_NOT_3944_3955 := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Righe/ns5:Riga[ns5:CodiceTributo!="3955" and ns5:CodiceTributo!="3944"]/xs:decimal(ns5:ImportoDebito))
let $sommaRateSingoleTotaleDebito := sum($r//ns4:Rate/ns4:Rata/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Totali/xs:decimal(ns5:TotaleDebito))
let $sommaRateSingoleTotaleRighe := sum($r//ns4:Rate/ns4:Rata/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Righe/ns5:Riga/xs:decimal(ns5:ImportoDebito))
  (: sezione totali fuori dalla riga:)
let $sommaTotaleDebito := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Totali/xs:decimal(ns5:TotaleDebito))
let $sommaTotaleCredito := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Totali/xs:decimal(ns5:TotaleCredito))
let $sommaTotaleSaldo := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Sezione/ns5:Totali/xs:decimal(ns5:TotaleSaldo))  
let $sommaTotaleDelega := sum($r//ns4:Rate/ns4:RataTotale/ns4:CanaleIncasso/ns4:ModelloF24Semplificato/ns5:Delega/xs:decimal(ns5:SaldoTotaleDebito))  


let $TipoPostaliz:=  ($r//ns4:Postalizzazione/ns4:TipoPostalizzazione)
let $DataDecesso := $r//ns4:SoggettoIntestatario/PersonaFisica/DataDecesso
let $EtichettaDestinatario := $r//ns4:Postalizzazione/ns4:EtichettaDestinatario/ns4:Destinatario

let $pt := substring(db:path($r),1,11) 

let $idDocumento := $r//ns4:EstremiDocumento/@id
let $idRichiestaProcedura := $r//ns4:EstremiDocumento/@idRichiestaProcedura
let $idCartellazione := $r//ns4:EstremiDocumento/@idCartellazione
let $tipoDocumento := $r//ns4:EstremiDocumento/ns4:TipoDocumento/ns4:CodiceDocumento
let $idLotto :=  $r//ns4:EstremiDocumento/@idLotto

where ($idLotto = "24415" or $idLotto ="24447" or $idLotto ="24448") and

  (
    $tipoDocumento != "075" or      
  
    $difIMPORTO != 0 or
    $difIMPORTOImportoOrigine != 0 or
    $DIF_TOTALE != 0 or
    $DIF_DIFFERENZA_RESIDUO != 0 or
   
    
    (:$DIRITTI_DI_NOTIFICA != 2.15 or:)
    $DIRITTI_DI_RINOTIFICA = 0 or
    (:$countDiritti != 1 or :)
    $countNotifica != 1 or 
    $countRiNotifica = 0 or
    
    count($CognomeFunzionarioResTribPieno) != 1 or
    
    (:$TipoPostaliz != "002" or:)
    $sommaImportoDebitoRigaF24 != $TotaleDaVersareEstremiDoc or     
    $sommaTotaleDebito != $TotaleDaVersareEstremiDoc
         
   
  )

group by $idLotto, $idDocumento
return
<Res idLotto="{$idLotto}" idDocumento="{$idDocumento}" tipoDocumento="{distinct-values($tipoDocumento)}" nCartelle="{count($r)}" totaleEstremiDocumento="{sum($TotaleDaVersareEstremiDoc)}" nVirtualIban="{count($cVIban)}" >
<contatori>
  <idDocumento>{$idDocumento}</idDocumento>
  <nCartelle>{count($r)}</nCartelle>
  <cVIban>{count($cVIban)}</cVIban>
  <cittaVerona>{count($cittaVerona)}</cittaVerona>
  <cittaNotVerona>{count($cittaNotVerona)}</cittaNotVerona>
  <Domestica>{count($Domestica)}</Domestica>
  <NonDomestica>{count($NonDomestica)}</NonDomestica>
  <DomesticaSI>{count($DomesticaSI)}</DomesticaSI>
  <NonDomesticaSI>{count($NonDomesticaSI)}</NonDomesticaSI>  
  <CognomeFunzionarioResTribPieno>{count($CognomeFunzionarioResTribPieno)}</CognomeFunzionarioResTribPieno>
  <docCollegati>{count($docCollegati)}</docCollegati>
  <numeroRate>{count($RataTotale)+count($Rate)}</numeroRate>
  <countDiritti>{sum($countDiritti)}</countDiritti>
  <countNotifica>{sum($countNotifica)}</countNotifica>
  <countRiNotifica>{sum($countRiNotifica)}</countRiNotifica>
  <countContoCorrentePostale>{sum($countContoCorrentePostale)}</countContoCorrentePostale>
  <TipoPostaliz>{$TipoPostaliz}</TipoPostaliz>
</contatori>

<differenze>
    <difIMPORTO>{sum($difIMPORTO)}</difIMPORTO>
    <difIMPORTOImportoOrigine>{sum($difIMPORTOImportoOrigine)}</difIMPORTOImportoOrigine>
    <DIF_TOTALE>{sum($DIF_TOTALE)}</DIF_TOTALE>   
    <DIF_DIFFERENZA_RESIDUO>{sum($DIF_DIFFERENZA_RESIDUO)}</DIF_DIFFERENZA_RESIDUO> 
</differenze>


<ProspettoVecchioAvviso> 
  <importoOrigine>{sum($importoOrigine)}</importoOrigine>
  <importoDiscaricato>{sum($importoDiscaricato)}</importoDiscaricato>
  <importoRiscosso>{sum($importoRiscosso)}</importoRiscosso>
  <Residuo>{sum($Residuo)}</Residuo>
</ProspettoVecchioAvviso>

<TotaliArticolo>
  <IMPORTO>{sum($IMPORTO)}</IMPORTO>
  <ImportoTotale>{sum($ImportoTotale)}</ImportoTotale>
  <Altro>{sum($Altro)}</Altro>
  <Arrotondamento>{sum($Arrotondamento)}</Arrotondamento>

  <Nota>IMPORTOCalcolato deve essere uguale importo origine e IMPORTO</Nota>
  <IMPORTOCalcolato>{sum($IMPORTOCalcolato)}</IMPORTOCalcolato> 
  <difIMPORTO>{sum($difIMPORTO)}</difIMPORTO>
  <difIMPORTOImportoOrigine>{sum($difIMPORTOImportoOrigine)}</difIMPORTOImportoOrigine>
</TotaliArticolo>

<TotaliDellAccertamento>
  <Nota2>TotaleDovuto deve essere uguale a dovuto calcolato e importo origine</Nota2>
  <TOTALE_DOVUTO>{sum($TOTALE_DOVUTO)}</TOTALE_DOVUTO>
  <TOTALE_VERSATO>{sum($TOTALE_VERSATO)}</TOTALE_VERSATO>
  <Nota3>Differenza deve essere uguale a Residuo</Nota3>
  <DIFFERENZA>{sum($DIFFERENZA)}</DIFFERENZA>
  <DIRITTI_DI_NOTIFICA>{sum($DIRITTI_DI_NOTIFICA)}</DIRITTI_DI_NOTIFICA>
  <DIRITTI_DI_RINOTIFICA>{sum($DIRITTI_DI_RINOTIFICA)}</DIRITTI_DI_RINOTIFICA>
  <TotaleDaVersareEstremiDoc>{sum($TotaleDaVersareEstremiDoc)}</TotaleDaVersareEstremiDoc>
  <TotCalcolato>{sum($TotCalcolato)}</TotCalcolato>
  <DIF_TOTALE>{sum($DIF_TOTALE)}</DIF_TOTALE>
  <DIF_DIFFERENZA_RESIDUO>{sum($DIF_DIFFERENZA_RESIDUO)}</DIF_DIFFERENZA_RESIDUO>
</TotaliDellAccertamento>

<ConteggiF24>
   <RataTotale>
    <sommaImportoRata>{sum($sommaImportoRata)}</sommaImportoRata>    
    <sommaImportoDebitoRigaF24>{sum($sommaImportoDebitoRigaF24)}</sommaImportoDebitoRigaF24>     
    <sommaImportoDebitoRigaF24_3955>{sum($sommaImportoDebitoRigaF24_3955)}</sommaImportoDebitoRigaF24_3955>    
    <sommaImportoDebitoRigaF24_3944>{sum($sommaImportoDebitoRigaF24_3944)}</sommaImportoDebitoRigaF24_3944>   
    <sommaImportoDebitoRigaF24_NOT_3944_3955>{sum($sommaImportoDebitoRigaF24_NOT_3944_3955)}</sommaImportoDebitoRigaF24_NOT_3944_3955>
    <sommaRateSingoleTotaleDebito>{sum($sommaRateSingoleTotaleDebito)}</sommaRateSingoleTotaleDebito>
    <sommaRateSingoleTotaleRighe>{sum($sommaRateSingoleTotaleRighe)}</sommaRateSingoleTotaleRighe>
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