<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ext="xalan://it.sintax.util.xml.XSLExtensions">
	<xsl:key name="AnniInclusi"
		match="/Cartella/Articoli/Articolo[@codiceServizio='18']/Anno/text()"
		use="." />

	<xsl:decimal-format name="euro" decimal-separator=","
		grouping-separator="." />
	<xsl:output method="xml" indent="no" />
	<xsl:key name="progr"
		match="/Cartella/Articoli/Articolo[@codiceServizio = '18']/StrutturaArticolo/OGGETTO/UTENZA/@ID-CONTRATTO"
		use="." />
	<xsl:template match="/">
		<xsl:variable name="white-space" select="' '" />
		<xsl:variable name="blank" select="''" />
		<xsl:variable name="curr" select="'#.##0,00'" />
		<xsl:variable name="numero-rate" select="count(/Cartella/Rate/Rata)" />
		<xsl:variable name="dataEmissione"
			select="concat(substring(/Cartella/EstremiDocumento/DataEmissione,9,2),'/',substring(/Cartella/EstremiDocumento/DataEmissione,6,2),'/',substring(/Cartella/EstremiDocumento/DataEmissione,1,4))" />
		<xsl:variable name="dataScadenza"
			select="concat(substring(/Cartella/EstremiDocumento/dataScadenza,9,2),'/',substring(/Cartella/EstremiDocumento/dataScadenza,6,2),'/',substring(/Cartella/EstremiDocumento/dataScadenza,1,4))" />

		<xsl:variable name="dataDocRettifica"
			select="concat(substring(/Cartella/DocumentoRiferimento/DataEmissione,9,2),'/',substring(/Cartella/DocumentoRiferimento/DataEmissione,6,2),'/',substring(/Cartella/DocumentoRiferimento/DataEmissione,1,4))" />
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<fo:layout-master-set>
				<fo:simple-page-master  auto-adjust-regions="true" margin-top="1cm"
					margin-bottom="1cm" margin-right="1cm" margin-left="1cm"
					page-width="21cm" page-height="29.7cm" master-name="first">
					<fo:region-body margin-right="0cm" margin-bottom="1cm"/>
					<fo:region-before extent="0cm" />
					<fo:region-after extent="1cm" />
					<fo:region-end reference-orientation="90" extent="0.6cm" />
				</fo:simple-page-master>
				<fo:simple-page-master  auto-adjust-regions="true" margin-top="1cm"
					margin-bottom="1cm" margin-right="1cm" margin-left="1cm"
					page-width="21cm" page-height="29.7cm" master-name="others">
					<fo:region-body margin-top="0cm" margin-bottom="1cm"
						margin-right="0cm" />
					<fo:region-before extent="0cm" />
					<fo:region-after extent="1cm" />
					<fo:region-end reference-orientation="90" extent="0.6cm" />
				</fo:simple-page-master>

				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference
							master-reference="first" page-position="first" />
						<fo:conditional-page-master-reference
							master-reference="others" page-position="rest" />
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
			</fo:layout-master-set>
			<fo:page-sequence master-reference="first"
				force-page-count="end-on-even" id="seq1">
				<fo:static-content flow-name="xsl-region-before">
					<fo:block-container height="25mm" width="44mm"
						top="47mm" left="0cm" position="absolute">
						<fo:block>
							<fo:retrieve-marker retrieve-class-name="BARCODERACC"
								retrieve-boundary="page" retrieve-position="first-starting-within-page" />
						</fo:block>
					</fo:block-container>
				</fo:static-content>
				<fo:static-content flow-name="xsl-region-after">
					<fo:table>
						<fo:table-column column-width="9cm" />
						<fo:table-column column-width="9cm" />
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell text-align="left" padding="2pt">
									<fo:block text-align="left" font-family="Courier"
										font-size="5.5pt">
										<xsl:text>Cod: </xsl:text>
										<xsl:value-of
											select="/Cartella/EstremiDocumento/TipoDocumento/@codice" />
										<xsl:text>-</xsl:text>
										<xsl:value-of select="/Cartella/Layout/@idLayout" />
									</fo:block>
								</fo:table-cell>
								<fo:table-cell padding="2pt" display-align="bottom">
									<fo:block text-align="right" font-family="Courier"
										font-size="8.5pt">
										<xsl:text>Pagina </xsl:text>
										<fo:page-number />
										<xsl:text> di </xsl:text>
										<fo:page-number-citation-last
											ref-id="seq1" />
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>

				</fo:static-content>
				<fo:flow flow-name="xsl-region-body">

					<fo:block></fo:block>
					<fo:table keep-together="always" border-width="0mm" border-color="white" table-layout="fixed" width="100%" space-before="-0.8cm">
				<fo:table-column column-width="8cm"/>
				<fo:table-column column-width="5cm"/>
				<fo:table-column column-width="5cm"/>
				<fo:table-body>
	  				<fo:table-row>
						<fo:table-cell display-align="center" text-align="center" vertical-align="top">
		      				 <fo:block content-height="1.3cm"><fo:external-graphic content-height="1.3cm" src="file:gst03/RS/images/solori.jpg"/></fo:block>
		      				<fo:block font-style="italic" font-family="Arial" space-before="1pt" font-size="8pt">Società Locale di Riscossione S.p.a.</fo:block>
		      				<fo:block font-style="italic" font-family="Arial" space-before="1pt" font-size="8pt">Vicolo Volto Cittadella 4, 37122 Verona</fo:block>
		      				<fo:block font-style="italic" font-family="Arial" space-before="1pt" font-size="8pt">Tel. 045/9236700 - FAX 045/9236799</fo:block>
		      				<fo:block font-style="italic" font-family="Arial" space-before="1pt" font-size="8pt">Mail: info@solori.it</fo:block>
		      				<fo:block font-style="italic" font-family="Arial" space-before="1pt" font-size="8pt">C.F.: 04222030233</fo:block>
		      			
		      				 	</fo:table-cell>
		   				<fo:table-cell text-align="center" vertical-align="top">
		      				<fo:block content-height="1.84cm"><fo:external-graphic content-height="1.84cm" src="file:gst03/RS/images/logoComuneVerona.jpg"/></fo:block>	
		      		
							</fo:table-cell>
		   				<fo:table-cell>
		      				<fo:block></fo:block> 
		      				
							</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
			<!--		<xsl:if
						test="/Cartella/Postalizzazione/TipoPostalizzazione = '002'or /Cartella/Postalizzazione/TipoPostalizzazione = '004'">
						<fo:block space-before="0.6cm">
							<fo:marker marker-class-name="BARCODERACC">
								<fo:table border-width="0mm" border-color="white"
									table-layout="fixed">
									<fo:table-column column-width="1.3cm" />
									<fo:table-column column-width="3.4cm" />
									<fo:table-body>
										<fo:table-row>
											<fo:table-cell text-align="center" padding="0pt"
												vertical-align="text-bottom">
												<xsl:if
													test="/Cartella/Postalizzazione/TipoPostalizzazione = '002'">
													<fo:block font-family="Arial" font-weight="bold"
														font-size="22pt" color="#FFFFFF">R</fo:block>
													<fo:block font-family="Arial" font-weight="bold"
														font-size="25pt">R</fo:block>
												</xsl:if>
												<xsl:if
													test="/Cartella/Postalizzazione/TipoPostalizzazione = '004'">
													<fo:block font-family="Arial" font-weight="bold"
														font-size="22pt" color="#FFFFFF">R</fo:block>
													<fo:block font-family="Arial" font-weight="bold"
														font-size="25pt">AG</fo:block>
												</xsl:if>
											</fo:table-cell>
											<fo:table-cell display-align="center"
												text-align="left" padding="0pt">
												<fo:block font-family="Arial">
													<xsl:if test="/Cartella/Postalizzazione/CodiceRaccomandata">
														<fo:external-graphic content-width="3.4cm">
															<xsl:attribute name="src">
													<xsl:variable name="file"
																select="/Cartella/Postalizzazione/CodiceRaccomandata" />
															<xsl:value-of
																select="concat('file:/mounts/mount01/gst03_temp/tmp/',/Cartella/Postalizzazione/CodiceRaccomandata,/Cartella/Postalizzazione/CinNotifica,'.jpg')" />
													</xsl:attribute>
														</fo:external-graphic>
													</xsl:if>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
										<fo:table-row>
											<fo:table-cell display-align="center"
												text-align="left" padding="0pt">
												<fo:block font-size="10pt" text-align="left"></fo:block>
											</fo:table-cell>
											<fo:table-cell display-align="center"
												text-align="center" padding="0pt">
												<fo:block text-align="center" font-size="10pt"
													font-family="Arial">
													<xsl:value-of
														select="/Cartella/Postalizzazione/CodiceRaccomandata" />
													<xsl:text>-</xsl:text>
													<xsl:value-of select="/Cartella/Postalizzazione/CinNotifica" />
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
									</fo:table-body>
								</fo:table>
							</fo:marker>
						</fo:block>
					</xsl:if>-->
					<fo:table keep-together="always" border-width="0mm" border-color="black" table-layout="fixed" space-before="2.8cm" width="100%">
				<fo:table-column column-width="8.7cm"/>
				<fo:table-column column-width="10.3cm"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell text-align="left" padding="1pt">
	      						<fo:block space-before="2pt" font-size="10pt"> </fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="before" text-align="left" padding="1pt">
							<fo:table keep-together="always" border-width="0mm" border-color="black" table-layout="fixed" space-before="0.5cm" width="100%">
								<fo:table-column column-width="8.8cm"/>
								<fo:table-body>
					  				<fo:table-row>
					  					<fo:table-cell display-align="before" text-align="left" padding="1pt">
											<fo:block font-family="Arial" space-before="0.3cm"
				     			 				 font-size="10pt" start-indent="0.8cm">
				     			 				 <xsl:value-of select="/Cartella/Postalizzazione/EtichettaDestinatario/Destinatario"/>
				     			 				</fo:block>
				     			 				<xsl:if test="/Cartella/Postalizzazione/EtichettaDestinatario/InfoDestinatario != ''">
				     			 				 	<fo:block font-family="Arial" space-before="2pt"
				     			 				 	font-size="10pt" start-indent="0.8cm">
					     			 					<xsl:value-of select="/Cartella/Postalizzazione/EtichettaDestinatario/InfoDestinatario"/>
													</fo:block>
				     			 				</xsl:if>
				     			 				<xsl:if test="/Cartella/Postalizzazione/EtichettaDestinatario/Edificio != ''">
								     			 	<fo:block font-family="Arial" space-before="2pt"
				     			 				 		font-size="10pt" start-indent="0.8cm">
								     			 			<xsl:value-of select="/Cartella/Postalizzazione/EtichettaDestinatario/Edificio"/>
								     			 	</fo:block>
							     			 	</xsl:if>
				
											<fo:block font-family="Arial" space-before="2pt"
				     			 				 font-size="10pt" start-indent="0.8cm">
				     			 				 <xsl:value-of select="/Cartella/Postalizzazione/EtichettaDestinatario/Indirizzo"/>
				     			 			</fo:block>
				
											<fo:block font-family="Arial" space-before="2pt"
				     			 				 font-size="10pt" start-indent="0.8cm">
				     			 				<xsl:value-of select="/Cartella/Postalizzazione/EtichettaDestinatario/Localita"/>
				     			 			</fo:block>
				     			 			<xsl:if test="/Cartella/Postalizzazione/EtichettaDestinatario/StatoEstero != ''">
							     			 	<fo:block font-family="Arial" space-before="2pt"
				     			 				 	font-size="10pt" start-indent="0.8cm">
							     			 			<xsl:value-of select="/Cartella/Postalizzazione/EtichettaDestinatario/StatoEstero"/>
							     			 	</fo:block>
						     			 	</xsl:if>
				     			 		</fo:table-cell>
				     			 	</fo:table-row>
				     			</fo:table-body>
							</fo:table>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>		
					<fo:block space-before="0.4cm" />
					<xsl:for-each select="/Cartella/Informative/InfoTestata/Info">
						<xsl:sort data-type="number" select="@progressivo" />
						<fo:block text-align="justify" font-family="Courier"
							font-size="7.5pt" white-space-collapse="false"
							white-space-treatment="preserve">
							<xsl:variable name="testoAnno">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="text()" />
									<xsl:with-param name="sostituisci" select="'&lt;! $ANNO&gt;'" />
									<xsl:with-param name="con"
										select="substring(/documento/@anni-imposta,21,200)" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="testoNumero">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="$testoAnno" />
									<xsl:with-param name="sostituisci" select="'&lt;! $NUMERO&gt;'" />
									<xsl:with-param name="con" select="/documento/@numero" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="testoImportoRidotto">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="$testoNumero" />
									<xsl:with-param name="sostituisci"
										select="'&lt;! $IMPORTO-RIDOTTO&gt;'" />
									<xsl:with-param name="con"
										select="/documento/@importo-ridotto" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="testoImporto">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="$testoImportoRidotto" />
									<xsl:with-param name="sostituisci" select="'&lt;! $IMPORTO&gt;'" />
									<xsl:with-param name="con" select="/documento/@importo" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$testoImporto"
								disable-output-escaping="yes" />
						</fo:block>
					</xsl:for-each>

					<xsl:if test="/Cartella/DocumentoRiferimento/Numero">
						<xsl:text>. Documento di rettifica n. </xsl:text>
						<xsl:value-of
							select="concat(/Cartella/DocumentoRiferimento/Numero, ' del ', $dataDocRettifica)" />
						<xsl:text> - Causale Rettifica: </xsl:text>
						<xsl:value-of select="/Cartella/EstremiDocumento/CausaleRettifica" />
					</xsl:if>



					<xsl:choose>
						<xsl:when
							test="string-length(/Cartella/DocumentoRiferimento/Numero) &gt; 0">
							<fo:block font-family="Arial" font-size="8pt" color="#000000"
								text-align="justify" space-before="0cm">
								<fo:inline font-weight="bold">
									<xsl:text>Oggetto</xsl:text>
								</fo:inline>
								<xsl:text>: Avviso di accertamento n. </xsl:text>
								<xsl:value-of select="/Cartella/EstremiDocumento/Numero"></xsl:value-of>
								<fo:inline font-weight="bold"> (*) </fo:inline>
								<xsl:value-of
									select="concat(' del ',substring(/Cartella/EstremiDocumento/DataEmissione,9,2),'/',substring(/Cartella/EstremiDocumento/DataEmissione,6,2),'/',substring(/Cartella/EstremiDocumento/DataEmissione,1,4))"></xsl:value-of>
								<xsl:text> per omesso pagamento TARES ANNO </xsl:text>
								<xsl:value-of
									select="substring(/Cartella/Articoli/Articolo[@codiceServizio='18']/Anno, 1,4)" />


							</fo:block>
							<fo:block font-family="Arial" font-size="8pt" color="#000000"
								text-align="justify">
								<xsl:text>         Rettifica dell'Accertamento: </xsl:text>
								<xsl:value-of
									select="concat(/Cartella/DocumentoRiferimento/Numero, ' del ', $dataDocRettifica)" />
							</fo:block>
							<fo:block font-family="Arial" font-size="8pt" color="#000000"
								text-align="justify">
								<xsl:text>         Causale Rettifica: </xsl:text>
								<fo:inline font-weight="bold">
									<xsl:value-of select="/Cartella/EstremiDocumento/CausaleRettifica"></xsl:value-of>
								</fo:inline>
							</fo:block>

							<fo:block font-family="Arial" font-size="9pt" color="#000000"
								text-align="justify" space-before="0.3cm">
								<xsl:text>Gentile contribuente,</xsl:text>
							</fo:block>
							<fo:block font-family="Arial" font-size="8pt" color="#000000"
								text-align="justify">
								<xsl:text>con il presente atto siamo a RETTIFICARE l'accertamento n. </xsl:text>
								<xsl:value-of
									select="concat(/Cartella/DocumentoRiferimento/Numero, ' del ', $dataDocRettifica)" />
								<xsl:text> già inviatoLe. Di seguito Le indichiamo le somme ancora dovute:</xsl:text>
							</fo:block>
						</xsl:when>
						<xsl:otherwise>
							<fo:block font-family="Arial" font-size="8pt" color="#000000"
								text-align="justify" space-before="0.8cm">
								<fo:inline font-weight="bold" text-decoration="underline">
									<xsl:text>Oggetto</xsl:text>
								</fo:inline>
								<xsl:text>: Avviso di accertamento n. </xsl:text>
								<xsl:value-of select="/Cartella/EstremiDocumento/Numero"></xsl:value-of>
								<fo:inline font-weight="bold"> (*) </fo:inline>
								<xsl:value-of
									select="concat(' del ' ,substring(/Cartella/EstremiDocumento/DataEmissione,9,2),'/',substring(/Cartella/EstremiDocumento/DataEmissione,6,2),'/',substring(/Cartella/EstremiDocumento/DataEmissione,1,4))"></xsl:value-of>

								<xsl:text> per omesso pagamento TARES ANNO </xsl:text>
								<xsl:value-of
									select="substring(/Cartella/Articoli/Articolo[@codiceServizio='18']/Anno, 1,4)" />

							</fo:block>

							<fo:block font-family="Arial" font-size="8pt" color="#000000"
								text-align="justify" space-before="0.1cm">
								<xsl:text>Gentile contribuente,</xsl:text>
							</fo:block>
							<fo:block font-family="Arial" font-size="8pt" color="#000000"
								text-align="justify">
								<xsl:text>dalle verifiche effettuate, non ci risulta ancora pervenuto il pagamento dei seguenti avvisi:</xsl:text>
							</fo:block>
						</xsl:otherwise>
					</xsl:choose>

					<fo:table keep-together="always" width="17.5cm"
						space-before="0.1cm" space-after="0.1cm" table-layout="fixed">
						<fo:table-column column-width="4cm" />
						<fo:table-column column-width="3cm" />
						<fo:table-column column-width="2cm" />
						<fo:table-column column-width="2cm" />
						<fo:table-column column-width="2cm" />
						<fo:table-column column-width="2cm" />
						<fo:table-column column-width="2cm" />
						<fo:table-column column-width="2cm" />
						<fo:table-body>
							<fo:table-row background-color="#F1F1F1">
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000">Tipo
										Documento</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000">Numero
										Documento</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000">Data
										Documento</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000">Scaduto
										al</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="right"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000">Importo
										Origine</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="right"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000">Importo
										Discaricato</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="right"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000">Riscosso
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="right"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000">Residuo
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<xsl:for-each select="/Cartella/DocumentiCollegati/DocumentoCollegato">
								<xsl:sort select="Numero" />

								<fo:table-row>
									<fo:table-cell text-align="left" padding="2pt"
										border-width="0.2mm" border-left-color="#000000" border-style="solid">
										<fo:block font-family="Arial" font-size="8pt">
											<xsl:choose>
												<xsl:when test="TipoDocumento/Descrizione='Quota stato TARES'">
													<xsl:text>Maggiorazione TARES</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="TipoDocumento/Descrizione" />
												</xsl:otherwise>
											</xsl:choose>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="justify" padding="2pt"
										border-width="0.2mm" border-left-color="#000000" border-style="solid">
										<fo:block font-family="Arial" font-size="8pt">
											<xsl:value-of select="Numero" />
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="justify" padding="2pt"
										border-width="0.2mm" border-left-color="#000000" border-style="solid">
										<fo:block font-family="Arial" font-size="8pt">
											<xsl:value-of
												select="concat(substring(DataEmissione,9,2),'/',substring(DataEmissione,6,2),'/',substring(DataEmissione,1,4))" />
										</fo:block>
									</fo:table-cell>

									<fo:table-cell text-align="justify" padding="2pt"
										border-width="0.2mm" border-left-color="#000000" border-style="solid">
										<fo:block font-family="Arial" font-size="8pt">
											<xsl:value-of
												select="concat(substring(DataScadenza,9,2),'/',substring(DataScadenza,6,2),'/',substring(DataScadenza,1,4))" />
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="right" padding="2pt"
										border-width="0.2mm" border-left-color="#000000" border-style="solid">
										<fo:block font-family="Arial" font-size="8pt">
											<xsl:value-of select="format-number(Importo, '#.##0,00', 'euro')" />
											&#8364;
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="right" padding="2pt"
										border-width="0.2mm" border-left-color="#000000" border-style="solid">
										<fo:block font-family="Arial" font-size="8pt">
											<xsl:value-of
												select="format-number(ImportoDiscaricato, '#.##0,00', 'euro')" />
											&#8364;
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="right" padding="2pt"
										border-width="0.2mm" border-left-color="#000000" border-style="solid">
										<fo:block font-family="Arial" font-size="8pt">
											<xsl:value-of
												select="format-number(ImportoPagato, '#.##0,00', 'euro')" />
											&#8364;
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="right" padding="2pt"
										border-width="0.2mm" border-left-color="#000000" border-style="solid">
										<fo:block font-family="Arial" font-size="8pt">
											<xsl:value-of
												select="format-number((Importo - ImportoDiscaricato - ImportoPagato), '#.##0,00', 'euro')" />
											&#8364;
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:for-each>

						</fo:table-body>
					</fo:table>




					<fo:block font-family="Arial" font-size="8pt" color="#000000"
						text-align="justify" space-before="0.1cm">
						<xsl:text>per l'importo complessivo di euro </xsl:text>
						<xsl:value-of
							select="format-number(sum(/Cartella/DocumentiCollegati/DocumentoCollegato/Importo) - sum(/Cartella/DocumentiCollegati/DocumentoCollegato/ImportoDiscaricato ) - sum(/Cartella/DocumentiCollegati/DocumentoCollegato/ImportoPagato ), '#.##0,00', 'euro')" />
						<xsl:text> relativo al tributo comunale sui rifiuti e sui servizi - TARES - dovuto per l ' ANNO </xsl:text>

						<xsl:value-of
							select="substring(/Cartella/Articoli/Articolo[@codiceServizio='18']/Anno, 1,4)" />
						<xsl:choose>
							<xsl:when
								test="substring(/Cartella/Articoli/Articolo[@codiceServizio='18']/Anno, 1,4) = 2013">
								<xsl:text> (tariffe approvate con Delibera Consiliare n. 50 del 25/07/2013).</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>.</xsl:text>
							</xsl:otherwise>
						</xsl:choose>

					</fo:block>
					<fo:block font-family="Arial" font-size="8pt" color="#000000"
						text-align="justify" space-before="0.1cm">
						<xsl:text>Nella pagina riportata nel retro viene descritto il dettaglio degli importi non pagati.</xsl:text>
					</fo:block>
					<fo:block font-family="Arial" font-size="8pt" color="#000000"
						text-align="justify" space-before="0.1cm" text-decoration="underline">
						<xsl:text>Con la presente, La invitiamo a pagare la somma dovuta</xsl:text>


						<xsl:if
							test="string-length(/Cartella/DocumentoRiferimento/Numero) &gt; 0">
							<xsl:text> in base alla presente rettifica</xsl:text>
						</xsl:if>
						<xsl:text>, in soluzione unica, entro e non oltre 60 giorni dal ricevimento del presente atto.</xsl:text>
					</fo:block>
					<!--<fo:block font-family="Arial" font-size="10pt" color="#000000" text-align="justify" 
						space-before="0.3cm"> <xsl:text>Il versamento dovrà essere effettuato utilizzando 
						il bollettino premarcato allegato, secondo le modalità indicate.</xsl:text> 
						</fo:block> -->
					<fo:block font-family="Arial" font-size="8pt" color="#000000"
						text-align="justify" space-before="0.1cm">
						<xsl:text>Se avesse effettuato il pagamento, La preghiamo di </xsl:text>
						<xsl:choose>
							<xsl:when
								test="string-length(/Cartella/DocumentoRiferimento/Numero) &gt; 0">
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>non tenere conto del presente avviso e, per rimuovere la causa che non ne ha consentito la corretta acquisizione, d'</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text>inviare copia della ricevuta a So.Lo.Ri. SpA Vicolo Volto Cittadella,4 - 37122 Verona o in allegato a una mail a info@solori.it o tramite fax al numero 045 9236799.</xsl:text>
					</fo:block>
					<fo:block font-family="Arial" font-size="8pt" color="#000000"
						text-align="justify" space-before="0.1cm">
						<xsl:text>In caso di mancato pagamento, trascorsi 60 giorni dalla data di notifica, inizieranno a decorrere gli interessi di mora computati nella misura del vigente tasso legale e calcolati con maturazione giornaliera come previsto dalla normativa vigente e verrà applicata la sanzione nella misura del </xsl:text>
						<fo:inline font-weight="bold">30%</fo:inline>
						<xsl:text> dell'importo non pagato (pari a </xsl:text>
						<xsl:value-of
							select="concat(format-number((sum(/Cartella/Articoli/Articolo/Voci/Voce[CodiceVoce='RE01' or CodiceVoce='RE03']/ImportoResiduoVoce)* 30 div 100),'#.##0,00','euro'), '€')" />
						<!--<xsl:value-of select="concat(format-number((( sum(/Cartella/DocumentiCollegati/DocumentoCollegato/Importo) 
							- sum(/Cartella/DocumentiCollegati/DocumentoCollegato/ImportoDiscaricato 
							) - sum(/Cartella/DocumentiCollegati/DocumentoCollegato/ImportoPagato ) ) 
							div 1.05 * 30 div 100),'#.##0,00','euro'), '€')" /> -->
						<xsl:text>) come previsto dall'art. 13 del D.Lgs 471/97 e successive integrazioni e modificazioni. Non sarà ammessa definizione agevolata.</xsl:text>
					</fo:block>
					<fo:block font-family="Arial" font-size="8pt" color="#000000"
						text-align="justify" space-before="0.1cm">
						<xsl:text>L’importo del presente avviso con l'aggravio di sanzioni e interessi verrà riscosso coattivamente previa la notifica di una ingiunzione di pagamento secondo le disposizioni del R.D. 14/4/1910 n. 639 e del D.P.R. 29/9/1973 n. 602.</xsl:text>
					</fo:block>
					<!--<fo:block font-family="Arial" font-size="10pt" color="#000000" text-align="justify" 
						space-before="0.2cm"> <xsl:text>Il presente atto può essere impugnato, con 
						ricorso motivato alla Commissione Tributaria provinciale di Verona, entro 
						60 giorni dalla data di ricevimento ai sensi degli artt.18 e seg, del D.Lgs.546/1992.</xsl:text> 
						</fo:block> -->
					  <fo:block font-family="Arial" font-size="8pt" color="#000000" text-align="justify" space-before="0.1cm">
					  	<xsl:text>Il ricorso contro il presente atto(a norma del D. Lgs 31.12 1992, n. 546)  è proposto avanti alla Commissione Tributaria Provinciale di Verona, Via Sommacampagna, 63H – Verona, entro 60 (sessanta) giorni, a pena di inammissibilità, dalla data di notificazione dello stesso. Il ricorso, intestato alla predetta Commissione, va notificato a SOLORI mediante le seguenti modalità:</xsl:text>
					  </fo:block>
					  <fo:block font-family="Arial" font-size="8pt" color="#000000" text-align="justify">
					  	<xsl:text>1. secondo le norme dell'art.137 e seguenti del codice di procedura civile;</xsl:text>
					  </fo:block>
					  <fo:block font-family="Arial" font-size="8pt" color="#000000" text-align="justify">
					  	<xsl:text>2. spedizione postale con raccomandata A/R in plico senza busta;</xsl:text>
					  </fo:block>
					  <fo:block font-family="Arial" font-size="8pt" color="#000000" text-align="justify">
					  	<xsl:text>3. consegna diretta presso ufficio protocollo di SOLORI in vicolo volto Cittadella 4  - 37122 VERONA.</xsl:text>
					  </fo:block>
					  <fo:block font-family="Arial" font-size="8pt" color="#000000" text-align="justify">
					  	<xsl:text>Tale ricorso, purché la controversia abbia valore inferiore a € 20.000,00 (art.12 c.2), produce gli effetti di un reclamo (ricorso-reclamo). Lo stesso può contenere una proposta di mediazione con rideterminazione dell’ammontare della pretesa (art. 17 bis). Il ricorso-reclamo, non è procedibile per 90 gg dalla notifica a SOLORI, termine entro il quale deve essere conclusa la procedura del reclamo-mediazione. Trascorso tale termine, il ricorrente entro 30 gg, deve depositare, a pena di inammissibilità, presso la segreteria della Commissione Tributaria Provinciale l’originale del ricorso notificato o la copia conforme del ricorso spedito per posta o consegnato a mano (nel qual caso sulla copia stessa il ricorrente dovrà apporre e sottoscrivere la dicitura “copia conforme all'originale”), ai sensi dell’art. 22 del D.Lgs citato.</xsl:text>
					  </fo:block>
					  <fo:block font-family="Arial" font-size="8pt" color="#000000" text-align="justify">
					  	<xsl:text>Se la controversia ha un valore inferiore a € 3000,00, il ricorso può essere proposto direttamente dall’interessato, che può stare in giudizio senza assistenza di un difensore abilitato (art. 12 D. Lgs citato).</xsl:text>
					  </fo:block>
					  <fo:block font-family="Arial" font-size="8pt" color="#000000" text-align="justify">
					  	<xsl:text>La parte soccombente è condannata a rimborsare le spese di giudizio, che sono liquidate con la sentenza (art. 15 D. Lgs citato).</xsl:text>
					  </fo:block>
				<!--<fo:block font-family="Arial" font-size="8pt" color="#000000"
						text-align="justify" space-before="0.1cm">
						<xsl:text>Per eventuali chiarimenti sulla posizione tributaria che ha dato seguito all'emissione dell'avviso di pagamento in origine (trasferimento in altra abitazione, componenti nucleo familiare etc), la invitiamo a rivolgersi agli sportelli di Solori in Vicolo Volto Cittadella,4   37122 Verona che sono aperti dal Lunedi al Venerdì dalle 8.30 alle 13.30.</xsl:text>
					</fo:block>-->
					<fo:block font-family="Arial" font-size="8pt" color="#000000"
						text-align="justify" space-before="0.1cm">
						<xsl:text>Il Responsabile del procedimento amministrativo è Monica Buttinoni. </xsl:text>
					</fo:block>
					<fo:block font-family="Arial" font-size="8pt" color="#000000"
						text-align="justify" space-before="0.1cm">
						<xsl:text>Per eventuali richieste di riesame dell'atto stesso, è possibile presentare istanza scritta in autotutela, ai sensi dell'Art. 68 del DPR n. 287/92, dell'Art. 2 quater del DL n. 564/94 convertito nella legge 656/94 e del DM n. 37/97 indirizzato al Funzionario Responsabile della gestione della Tassa Rifiuti - Ing. Livio Simone - Solori.</xsl:text>
					</fo:block>

					<!--<fo:block font-family="Arial" font-size="10pt" color="#000000" text-align="justify" 
						space-before="0.3cm"> <xsl:text>Entro il termine di trenta giorni dal ricevimento 
						della presente è possibile inoltrare istanza motivata di revisione del calcolo 
						del dovuto al funzionario responsabile TARES </xsl:text> <xsl:value-of select="concat(/documento/informative/funzioniRuoli/funzioneRuolo[@carica='Funzionario 
						Responsabile']/@titolo, ' ', /documento/informative/funzioniRuoli/funzioneRuolo[@carica='Funzionario 
						Responsabile']/@descrizione)"/> <xsl:text> presso gli uffici di AMIA VERONA 
						SPA, VIA BARTOLOMEO AVESANI 31 -37135 Verona.</xsl:text> </fo:block> -->

					<xsl:for-each select="/Cartella/Informative/InfoDettaglio/Info">
						<xsl:sort data-type="number" select="@progressivo" />
						<fo:block text-align="justify" font-family="Courier"
							font-size="7.5pt" white-space-collapse="false"
							white-space-treatment="preserve">
							<xsl:variable name="testoAnno">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="text()" />
									<xsl:with-param name="sostituisci" select="'&lt;! $ANNO&gt;'" />
									<xsl:with-param name="con"
										select="substring(/documento/@anni-imposta,21,200)" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="testoNumero">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="$testoAnno" />
									<xsl:with-param name="sostituisci" select="'&lt;! $NUMERO&gt;'" />
									<xsl:with-param name="con" select="/documento/@numero" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="testoImportoRidotto">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="$testoNumero" />
									<xsl:with-param name="sostituisci"
										select="'&lt;! $IMPORTO-RIDOTTO&gt;'" />
									<xsl:with-param name="con"
										select="/documento/@importo-ridotto" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="testoImporto">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="$testoImportoRidotto" />
									<xsl:with-param name="sostituisci" select="'&lt;! $IMPORTO&gt;'" />
									<xsl:with-param name="con" select="/documento/@importo" />
								</xsl:call-template>
							</xsl:variable>


							<xsl:value-of select="$testoImporto"
								disable-output-escaping="yes" />
						</fo:block>
					</xsl:for-each>

					<xsl:for-each select="/Cartella/Informative/InfoScadenze/Info">
						<xsl:sort data-type="number" select="@progressivo" />
						<fo:block text-align="justify" font-family="Courier"
							font-size="7.5pt" white-space-collapse="false"
							white-space-treatment="preserve">
							<xsl:variable name="testoAnno">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="text()" />
									<xsl:with-param name="sostituisci" select="'&lt;! $ANNO&gt;'" />
									<xsl:with-param name="con"
										select="substring(/documento/@anni-imposta,21,200)" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="testoNumero">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="$testoAnno" />
									<xsl:with-param name="sostituisci" select="'&lt;! $NUMERO&gt;'" />
									<xsl:with-param name="con" select="/documento/@numero" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="testoImportoRidotto">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="$testoNumero" />
									<xsl:with-param name="sostituisci"
										select="'&lt;! $IMPORTO-RIDOTTO&gt;'" />
									<xsl:with-param name="con"
										select="/documento/@importo-ridotto" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="testoImporto">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="$testoImportoRidotto" />
									<xsl:with-param name="sostituisci" select="'&lt;! $IMPORTO&gt;'" />
									<xsl:with-param name="con" select="/documento/@importo" />
								</xsl:call-template>
							</xsl:variable>


							<xsl:value-of select="$testoImporto"
								disable-output-escaping="yes" />
						</fo:block>
					</xsl:for-each>


					<fo:block color="#FFFFFF">.</fo:block>
					<xsl:for-each select="/Cartella/Informative/InfoPiede/Info">
						<xsl:sort data-type="number" select="@progressivo" />
						<fo:block text-align="justify" font-family="Courier"
							font-size="7.5pt" white-space-collapse="false"
							white-space-treatment="preserve">
							<xsl:variable name="testoAnno">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="text()" />
									<xsl:with-param name="sostituisci" select="'&lt;! $ANNO&gt;'" />
									<xsl:with-param name="con"
										select="substring(/documento/@anni-imposta,21,200)" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="testoNumero">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="$testoAnno" />
									<xsl:with-param name="sostituisci" select="'&lt;! $NUMERO&gt;'" />
									<xsl:with-param name="con" select="/documento/@numero" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="testoImportoRidotto">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="$testoNumero" />
									<xsl:with-param name="sostituisci"
										select="'&lt;! $IMPORTO-RIDOTTO&gt;'" />
									<xsl:with-param name="con"
										select="/documento/@importo-ridotto" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="testoImporto">
								<xsl:call-template name="stringReplaceAll">
									<xsl:with-param name="testo" select="$testoImportoRidotto" />
									<xsl:with-param name="sostituisci" select="'&lt;! $IMPORTO&gt;'" />
									<xsl:with-param name="con" select="/documento/@importo" />
								</xsl:call-template>
							</xsl:variable>


							<xsl:value-of select="$testoImporto"
								disable-output-escaping="yes" />
						</fo:block>
					</xsl:for-each>



					<fo:block break-before="page" />


					<xsl:for-each select="/Cartella/DocumentiCollegati/DocumentoCollegato">
						<xsl:sort select="Numero" />

						<xsl:variable name="idCarOR" select="@id" />



						<fo:table table-layout="fixed">
							<fo:table-column column-width="18cm" />
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell display-align="center" text-align="center"
										padding="2pt" background-color="#F1F1F1" border-bottom-width="0.2mm"
										border-bottom-color="#000000" border-bottom-style="solid"
										border-top-width="0.2mm" border-top-color="#000000"
										border-top-style="solid" border-left-width="0.2mm"
										border-left-color="#000000" border-left-style="solid"
										border-right-width="0.2mm" border-right-color="#000000"
										border-right-style="solid">
										<fo:block font-family="Arial" font-size="8pt" color="#000000"
											font-weight="bold" font-style="italic">
											<xsl:choose>
												<xsl:when test="TipoDocumento/Descrizione='Quota stato TARES'">
													<xsl:text>Maggiorazione TARES</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="TipoDocumento/Descrizione" />
												</xsl:otherwise>
											</xsl:choose>
											<xsl:value-of
												select="concat(' N&#xB0;: ', Numero, ' del ', substring(DataEmissione,9,2),'/',substring(DataEmissione,6,2),'/',substring(DataEmissione,1,4))" />
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row>
									<fo:table-cell display-align="center" text-align="right"
										padding="2pt" background-color="#F1F1F1" border-bottom-width="0.2mm"
										border-bottom-color="#000000" border-bottom-style="solid"
										border-top-width="0.2mm" border-top-color="#000000"
										border-top-style="solid" border-left-width="0.2mm"
										border-left-color="#000000" border-left-style="solid"
										border-right-width="0.2mm" border-right-color="#000000"
										border-right-style="solid">
										<fo:block font-family="Arial" font-size="8pt" color="#000000"
											font-weight="bold" font-style="italic">
											<xsl:text>IMPORTO: </xsl:text>
											<xsl:value-of select="format-number(Importo, '#.##0,00', 'euro')" />
											<xsl:text> &#8364;</xsl:text>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
						<fo:table space-before="0.1cm" table-layout="fixed">
							<fo:table-column column-width="2cm" />
							<fo:table-column column-width="2cm" />
							<fo:table-column column-width="2cm" />
							<fo:table-column column-width="2cm" />
							<fo:table-column column-width="2cm" />
							<fo:table-column column-width="2cm" />
							<fo:table-column column-width="2cm" />
							<fo:table-column column-width="2cm" />
							<fo:table-column column-width="2cm" />

							<fo:table-body>
								<xsl:for-each
									select="/Cartella/Articoli/Articolo[@idDocumentoCollegato=$idCarOR and @codiceServizio='18']">
									<xsl:if test="Voci/Voce">
										<!-- Imposizione: TIA -->
										<!--<xsl:if test="@codiceServizio='18'"> -->


										<xsl:for-each select="StrutturaArticolo/OGGETTO/UTENZA">
											<fo:table-row>
												<fo:table-cell display-align="center"
													text-align="center" padding="0pt" number-columns-spanned="9"
													border-width="0.1mm" border-color="#000000" border-style="solid">
													<fo:block font-size="7.5pt" text-align="left" color="#000000"
														font-weight="bold">
														<xsl:text>Articolo </xsl:text>
														<xsl:value-of select="@ID-CONTRATTO" />
														<xsl:text>: UTENZA </xsl:text>
														<xsl:value-of select="@TIPO-UTENZA" />
														<xsl:text>: </xsl:text>
														<xsl:value-of select="OGGETTO-CATASTALE/DATI-CATASTALI/text()" />
														<xsl:text>, Indirizzo: </xsl:text>
														<xsl:value-of select="../../../DescrizioneArticolo" />
													</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<xsl:for-each select="RIGA-DENUNCIATA">
												<fo:table-row>
													<fo:table-cell display-align="center"
														text-align="center" padding="3pt">
														<fo:block>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row>
													<fo:table-cell display-align="center"
														text-align="center" padding="2pt" number-columns-spanned="9"
														border-bottom-width="0.2mm" border-bottom-color="#000000"
														border-bottom-style="solid" border-top-width="0.2mm"
														border-top-color="#000000" border-top-style="solid"
														border-left-width="0.2mm" border-left-color="#000000"
														border-left-style="solid" border-right-width="0.2mm"
														border-right-color="#000000" border-right-style="solid"
														background-color="#D1D1D1">
														<fo:block font-family="Arial" font-size="7.5pt"
															color="#000000" font-weight="bold">
															<xsl:text>CALCOLO DELLA TARIFFA DI IGIENE AMBIENTALE: Importi </xsl:text>
															<xsl:value-of select="TIPO-IMPORTOADD"></xsl:value-of>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>



												<fo:table-row>
													<fo:table-cell display-align="center"
														text-align="center" padding="2pt" number-columns-spanned="3"
														border-bottom-width="0.2mm" border-bottom-color="#000000"
														border-bottom-style="solid" border-top-width="0mm"
														border-top-color="#000000" border-top-style="solid"
														border-left-width="0.2mm" border-left-color="#000000"
														border-left-style="solid" border-right-width="0mm"
														border-right-color="#000000" border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt"
															color="#000000">Periodo Calcolato</fo:block>
													</fo:table-cell>

													<fo:table-cell display-align="center"
														text-align="center" padding="2pt" number-rows-spanned="2"
														border-bottom-width="0.2mm" border-bottom-color="#000000"
														border-bottom-style="solid" border-top-width="0mm"
														border-top-color="#000000" border-top-style="solid"
														border-left-width="0.2mm" border-left-color="#000000"
														border-left-style="solid" border-right-width="0mm"
														border-right-color="#000000" border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt"
															color="#000000">GG. Att. Temp.</fo:block>
													</fo:table-cell>

													<fo:table-cell display-align="center"
														text-align="center" padding="2pt" number-rows-spanned="2"
														number-columns-spanned="4" border-bottom-width="0.2mm"
														border-bottom-color="#000000" border-bottom-style="solid"
														border-top-width="0mm" border-top-color="#000000"
														border-top-style="solid" border-left-width="0.2mm"
														border-left-color="#000000" border-left-style="solid"
														border-right-width="0mm" border-right-color="#000000"
														border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt"
															color="#000000">
															<xsl:value-of select="ETIC-DESTUSO/text()"></xsl:value-of>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell display-align="center"
														text-align="center" padding="2pt" number-rows-spanned="2"
														border-bottom-width="0.2mm" border-bottom-color="#000000"
														border-bottom-style="solid" border-top-width="0mm"
														border-top-color="#000000" border-top-style="solid"
														border-left-width="0.2mm" border-left-color="#000000"
														border-left-style="solid" border-right-width="0.2mm"
														border-right-color="#000000" border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt"
															color="#000000">Sup. m&#178;</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row>
													<fo:table-cell display-align="center"
														text-align="center" padding="2pt" border-bottom-width="0.2mm"
														border-bottom-color="#000000" border-bottom-style="solid"
														border-top-width="0mm" border-top-color="#000000"
														border-top-style="solid" border-left-width="0.2mm"
														border-left-color="#000000" border-left-style="solid"
														border-right-width="0mm" border-right-color="#000000"
														border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt"
															color="#000000">Inizio</fo:block>
													</fo:table-cell>
													<fo:table-cell display-align="center"
														text-align="center" padding="2pt" border-bottom-width="0.2mm"
														border-bottom-color="#000000" border-bottom-style="solid"
														border-top-width="0mm" border-top-color="#000000"
														border-top-style="solid" border-left-width="0.2mm"
														border-left-color="#000000" border-left-style="solid"
														border-right-width="0mm" border-right-color="#000000"
														border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt"
															color="#000000">Fine</fo:block>
													</fo:table-cell>
													<fo:table-cell display-align="center"
														text-align="center" padding="2pt" border-bottom-width="0.2mm"
														border-bottom-color="#000000" border-bottom-style="solid"
														border-top-width="0mm" border-top-color="#000000"
														border-top-style="solid" border-left-width="0.2mm"
														border-left-color="#000000" border-left-style="solid"
														border-right-width="0mm" border-right-color="#000000"
														border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt"
															color="#000000">
															<xsl:value-of select="ETIC-MESI-FATTURATI" />
														</fo:block>
													</fo:table-cell>
												</fo:table-row>



												<fo:table-row>
													<fo:table-cell display-align="center"
														text-align="center" padding="1pt" border-bottom-width="0.2mm"
														border-bottom-color="#000000" border-bottom-style="solid"
														border-top-width="0mm" border-top-color="#000000"
														border-top-style="solid" border-left-width="0.2mm"
														border-left-color="#000000" border-left-style="solid"
														border-right-width="0mm" border-right-color="#000000"
														border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt">
															<xsl:value-of select="INIZIO-TASSAZIONE" />
														</fo:block>
													</fo:table-cell>
													<fo:table-cell display-align="center"
														text-align="center" padding="1pt" border-bottom-width="0.2mm"
														border-bottom-color="#000000" border-bottom-style="solid"
														border-top-width="0mm" border-top-color="#000000"
														border-top-style="solid" border-left-width="0.2mm"
														border-left-color="#000000" border-left-style="solid"
														border-right-width="0mm" border-right-color="#000000"
														border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt">
															<xsl:value-of select="FINE-TASSAZIONE" />
														</fo:block>
													</fo:table-cell>
													<fo:table-cell display-align="center"
														text-align="center" padding="1pt" border-bottom-width="0.2mm"
														border-bottom-color="#000000" border-bottom-style="solid"
														border-top-width="0mm" border-top-color="#000000"
														border-top-style="solid" border-left-width="0.2mm"
														border-left-color="#000000" border-left-style="solid"
														border-right-width="0mm" border-right-color="#000000"
														border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt">
															<xsl:value-of select="MESI-FATTURATI" />
														</fo:block>
													</fo:table-cell>
													<fo:table-cell display-align="center"
														text-align="center" padding="1pt" border-bottom-width="0.2mm"
														border-bottom-color="#000000" border-bottom-style="solid"
														border-top-width="0mm" border-top-color="#000000"
														border-top-style="solid" border-left-width="0.2mm"
														border-left-color="#000000" border-left-style="solid"
														border-right-width="0mm" border-right-color="#000000"
														border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt">
															<xsl:value-of select="GG-ATT-TEMP"></xsl:value-of>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell display-align="center"
														text-align="center" padding="1pt" number-columns-spanned="4"
														border-bottom-width="0.2mm" border-bottom-color="#000000"
														border-bottom-style="solid" border-top-width="0mm"
														border-top-color="#000000" border-top-style="solid"
														border-left-width="0.2mm" border-left-color="#000000"
														border-left-style="solid" border-right-width="0mm"
														border-right-color="#000000" border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt">
															<xsl:choose>
																<xsl:when test="ETIC-DESTUSO = 'Occupanti'">
																	<xsl:value-of select="NUMERO-OCCUPANTI"></xsl:value-of>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="VALORE-DESTUSO" />
																</xsl:otherwise>
															</xsl:choose>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell display-align="center"
														text-align="right" padding="1pt" border-bottom-width="0.2mm"
														border-bottom-color="#000000" border-bottom-style="solid"
														border-top-width="0mm" border-top-color="#000000"
														border-top-style="solid" border-left-width="0.2mm"
														border-left-color="#000000" border-left-style="solid"
														border-right-width="0.2mm" border-right-color="#000000"
														border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt">
															<xsl:value-of select="SUPERFICIE" />
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row>
													<fo:table-cell number-columns-spanned="9"
														display-align="center" text-align="left" padding="0pt"
														border-bottom-width="0.mm" border-bottom-color="#000000"
														border-bottom-style="solid" border-top-width="0mm"
														border-top-color="#000000" border-top-style="solid"
														border-left-width="0mm" border-left-color="#000000"
														border-left-style="solid" border-right-width="0mm"
														border-right-color="#000000" border-right-style="solid">
														<fo:block font-family="Arial" font-size="7.5pt"
															color="#FFFFFF">
															.
														</fo:block>
													</fo:table-cell>
												</fo:table-row>


												<fo:table-row>
													<fo:table-cell number-columns-spanned="9">
														<fo:table space-before.optimum="0cm"
															space-after.optimum="0.1cm" table-layout="fixed">
															<fo:table-column column-width="2cm" />
															<fo:table-column column-width="2cm" />
															<fo:table-column column-width="1cm" />
															<fo:table-column column-width="2cm" />
															<fo:table-column column-width="5cm" />
															<fo:table-column column-width="3cm" />
															<fo:table-column column-width="3cm" />
															<fo:table-body>
																<xsl:for-each select="RIDUZIONE-MAGGIORAZIONE">
																	<fo:table-row>
																		<fo:table-cell display-align="center"
																			number-columns-spanned="3" text-align="left" padding="2pt"
																			background-color="#E1E1E1" border-width="0.2mm"
																			border-color="#000000" border-style="solid">
																			<fo:block font-family="Arial" font-size="7.5pt">Riduzioni/maggiorazioni
																			</fo:block>
																		</fo:table-cell>
																		<fo:table-cell display-align="center"
																			number-columns-spanned="2" text-align="right"
																			padding="2pt" border-width="0.2mm"
																			border-bottom-color="#000000" border-bottom-style="solid"
																			border-top-color="#000000" border-top-style="solid"
																			border-left-color="#000000" border-left-style="solid">
																			<fo:block font-family="Arial" font-size="7.5pt">
																				<xsl:value-of select="DESCRIZIONE" />
																				<xsl:text> </xsl:text>
																				<xsl:value-of select="VALORE" />
																			</fo:block>
																		</fo:table-cell>
																		<fo:table-cell display-align="center"
																			number-columns-spanned="2" text-align="center"
																			padding="2pt" border-width="0.2mm"
																			border-bottom-color="#000000" border-bottom-style="solid"
																			border-top-color="#000000" border-top-style="solid"
																			border-left-color="#000000" border-left-style="solid"
																			border-right-color="#000000" border-right-style="solid">
																			<fo:block font-family="Arial" font-size="7.5pt">
																				dal
																				<xsl:value-of select="INIZIO-VALIDITA" />
																				al
																				<xsl:value-of select="FINE-VALIDITA" />
																			</fo:block>
																		</fo:table-cell>
																	</fo:table-row>
																</xsl:for-each>
															</fo:table-body>
														</fo:table>
													</fo:table-cell>
												</fo:table-row>

											</xsl:for-each>
										</xsl:for-each>
										<xsl:for-each select="StrutturaArticolo/OGGETTO/SERVIZI_INDIVISIBILI">
											<fo:table-row>
												<fo:table-cell display-align="center"
													text-align="left" padding="0pt" number-columns-spanned="9"
													border-bottom-width="0.2mm" border-bottom-color="#000000"
													border-bottom-style="solid" border-top-width="0.2mm"
													border-top-color="#000000" border-top-style="solid"
													border-left-width="0.2mm" border-left-color="#000000"
													border-left-style="solid" border-right-width="0.2mm"
													border-right-color="#000000" border-right-style="solid">
													<fo:block font-size="7.5pt" text-align="left" color="#000000"
														font-weight="bold">
														<xsl:text>Articolo </xsl:text>
														<xsl:value-of select="@ID-CONTRATTO" />
														<xsl:text>: UTENZA </xsl:text>
														<xsl:value-of select="@TIPO-UTENZA" />
														<xsl:text>: </xsl:text>
														<xsl:value-of select="@DATI-CATASTALI" />
														<xsl:text>, Indirizzo: </xsl:text>
														<xsl:value-of select="@INDIRIZZO"></xsl:value-of>
													</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell display-align="center"
													text-align="center" padding="3pt">
													<fo:block>
													</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell display-align="center"
													text-align="center" padding="2pt" number-columns-spanned="9"
													border-bottom-width="0.2mm" border-bottom-color="#000000"
													border-bottom-style="solid" border-top-width="0.2mm"
													border-top-color="#000000" border-top-style="solid"
													border-left-width="0.2mm" border-left-color="#000000"
													border-left-style="solid" border-right-width="0.2mm"
													border-right-color="#000000" border-right-style="solid"
													background-color="#D1D1D1">
													<fo:block font-family="Arial" font-size="7.5pt"
														color="#000000" font-weight="bold">
														<xsl:text>Calcolo TARES Servizi Indivisibili: Tariffa 0.30 Eu/mq </xsl:text>
													</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell display-align="center"
													text-align="center" padding="2pt" number-columns-spanned="3"
													border-bottom-width="0.2mm" border-bottom-color="#000000"
													border-bottom-style="solid" border-top-width="0mm"
													border-top-color="#000000" border-top-style="solid"
													border-left-width="0.2mm" border-left-color="#000000"
													border-left-style="solid" border-right-width="0mm"
													border-right-color="#000000" border-right-style="solid">
													<fo:block font-family="Arial" font-size="7.5pt"
														color="#000000">Periodo Calcolato</fo:block>
												</fo:table-cell>

												<fo:table-cell display-align="center"
													text-align="center" padding="2pt" number-rows-spanned="2"
													number-columns-spanned="3" border-bottom-width="0.2mm"
													border-bottom-color="#000000" border-bottom-style="solid"
													border-top-width="0mm" border-top-color="#000000"
													border-top-style="solid" border-left-width="0.2mm"
													border-left-color="#000000" border-left-style="solid"
													border-right-width="0mm" border-right-color="#000000"
													border-right-style="solid">
													<fo:block font-family="Arial" font-size="7.5pt"
														color="#000000">Sup. m&#178;</fo:block>
												</fo:table-cell>
												<fo:table-cell display-align="center"
													text-align="center" padding="2pt" number-rows-spanned="2"
													number-columns-spanned="3" border-bottom-width="0.2mm"
													border-bottom-color="#000000" border-bottom-style="solid"
													border-top-width="0mm" border-top-color="#000000"
													border-top-style="solid" border-left-width="0.2mm"
													border-left-color="#000000" border-left-style="solid"
													border-right-width="0.2mm" border-right-color="#000000"
													border-right-style="solid">
													<fo:block font-family="Arial" font-size="7.5pt"
														color="#000000">% Calcolo</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell display-align="center"
													text-align="center" padding="2pt" border-bottom-width="0.2mm"
													border-bottom-color="#000000" border-bottom-style="solid"
													border-top-width="0mm" border-top-color="#000000"
													border-top-style="solid" border-left-width="0.2mm"
													border-left-color="#000000" border-left-style="solid"
													border-right-width="0mm" border-right-color="#000000"
													border-right-style="solid">
													<fo:block font-family="Arial" font-size="7.5pt"
														color="#000000">Inizio</fo:block>
												</fo:table-cell>
												<fo:table-cell display-align="center"
													text-align="center" padding="2pt" border-bottom-width="0.2mm"
													border-bottom-color="#000000" border-bottom-style="solid"
													border-top-width="0mm" border-top-color="#000000"
													border-top-style="solid" border-left-width="0.2mm"
													border-left-color="#000000" border-left-style="solid"
													border-right-width="0mm" border-right-color="#000000"
													border-right-style="solid">
													<fo:block font-family="Arial" font-size="7.5pt"
														color="#000000">Fine</fo:block>
												</fo:table-cell>
												<fo:table-cell display-align="center"
													text-align="center" padding="2pt" border-bottom-width="0.2mm"
													border-bottom-color="#000000" border-bottom-style="solid"
													border-top-width="0mm" border-top-color="#000000"
													border-top-style="solid" border-left-width="0.2mm"
													border-left-color="#000000" border-left-style="solid"
													border-right-width="0mm" border-right-color="#000000"
													border-right-style="solid">
													<fo:block font-family="Arial" font-size="7.5pt"
														color="#000000">
														<xsl:value-of select="@ETIC-MESI-FATTURATI" />
													</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell display-align="center"
													text-align="center" padding="1pt" border-bottom-width="0.2mm"
													border-bottom-color="#000000" border-bottom-style="solid"
													border-top-width="0mm" border-top-color="#000000"
													border-top-style="solid" border-left-width="0.2mm"
													border-left-color="#000000" border-left-style="solid"
													border-right-width="0mm" border-right-color="#000000"
													border-right-style="solid">
													<fo:block font-family="Arial" font-size="7.5pt">
														<xsl:value-of select="@INIZIO-TASSAZIONE" />
													</fo:block>
												</fo:table-cell>
												<fo:table-cell display-align="center"
													text-align="center" padding="1pt" border-bottom-width="0.2mm"
													border-bottom-color="#000000" border-bottom-style="solid"
													border-top-width="0mm" border-top-color="#000000"
													border-top-style="solid" border-left-width="0.2mm"
													border-left-color="#000000" border-left-style="solid"
													border-right-width="0mm" border-right-color="#000000"
													border-right-style="solid">
													<fo:block font-family="Arial" font-size="7.5pt">
														<xsl:value-of select="@FINE-TASSAZIONE" />
													</fo:block>
												</fo:table-cell>
												<fo:table-cell display-align="center"
													text-align="center" padding="1pt" border-bottom-width="0.2mm"
													border-bottom-color="#000000" border-bottom-style="solid"
													border-top-width="0mm" border-top-color="#000000"
													border-top-style="solid" border-left-width="0.2mm"
													border-left-color="#000000" border-left-style="solid"
													border-right-width="0mm" border-right-color="#000000"
													border-right-style="solid">
													<fo:block font-family="Arial" font-size="7.5pt">
														<xsl:value-of select="@MESI-FATTURATI" />
													</fo:block>
												</fo:table-cell>
												<fo:table-cell display-align="center"
													text-align="center" padding="1pt" number-columns-spanned="3"
													border-bottom-width="0.2mm" border-bottom-color="#000000"
													border-bottom-style="solid" border-top-width="0mm"
													border-top-color="#000000" border-top-style="solid"
													border-left-width="0.2mm" border-left-color="#000000"
													border-left-style="solid" border-right-width="0mm"
													border-right-color="#000000" border-right-style="solid">
													<fo:block font-family="Arial" font-size="7.5pt">
														<xsl:value-of
															select="format-number(@SUP-DENUNCIA,'#.##0,00','euro')" />
													</fo:block>
												</fo:table-cell>
												<fo:table-cell display-align="center"
													text-align="right" padding="1pt" number-columns-spanned="3"
													border-bottom-width="0.2mm" border-bottom-color="#000000"
													border-bottom-style="solid" border-top-width="0mm"
													border-top-color="#000000" border-top-style="solid"
													border-left-width="0.2mm" border-left-color="#000000"
													border-left-style="solid" border-right-width="0.2mm"
													border-right-color="#000000" border-right-style="solid">
													<fo:block font-family="Arial" font-size="7.5pt">
														<xsl:value-of select="@PERC-CALCOLO" />
													</fo:block>
												</fo:table-cell>
											</fo:table-row>



										</xsl:for-each>
										<fo:table-row>
											<fo:table-cell display-align="center"
												text-align="center" padding="2pt" number-columns-spanned="9"
												border-bottom-width="0.2mm" border-bottom-color="#000000"
												border-bottom-style="solid" border-top-width="0.2mm"
												border-top-color="#000000" border-top-style="solid"
												border-left-width="0.2mm" border-left-color="#000000"
												border-left-style="solid" border-right-width="0.2mm"
												border-right-color="#000000" border-right-style="solid"
												background-color="#D1D1D1">
												<fo:block font-family="Arial" font-size="7.5pt"
													color="#000000" font-weight="bold">
													<xsl:text>TOTALI DELL'ARTICOLO</xsl:text>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>

										<fo:table-row>
											<fo:table-cell display-align="center"
												text-align="center" padding="0pt" number-columns-spanned="6"
												border-bottom-width="0.2mm" border-bottom-color="#000000"
												border-bottom-style="solid" border-top-width="0.2mm"
												border-top-color="#eeeeed" border-top-style="solid"
												border-left-width="0.2mm" border-left-color="#000000"
												border-left-style="solid" border-right-width="0.2mm"
												border-right-color="#FFFFFF" border-right-style="solid">
												<fo:block font-size="7.5pt" text-align="center"
													color="#000000">
													<xsl:text>Addebito </xsl:text>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell display-align="center"
												text-align="right" padding="0pt" number-columns-spanned="3"
												border-bottom-width="0.2mm" border-bottom-color="#000000"
												border-bottom-style="solid" border-top-width="0.2mm"
												border-top-color="#eeeeed" border-top-style="solid"
												border-left-width="0.2mm" border-left-color="#000000"
												border-left-style="solid" border-right-width="0.2mm"
												border-right-color="#000000" border-right-style="solid">
												<fo:block font-size="7.5pt" text-align="right"
													color="#000000">
													<xsl:text>Imponibile </xsl:text>
												</fo:block>
											</fo:table-cell>

										</fo:table-row>

										<xsl:for-each select="Voci/Voce">
											<fo:table-row>
												<fo:table-cell display-align="center"
													text-align="left" padding="0pt" number-columns-spanned="6"
													border-bottom-width="0.2mm" border-bottom-color="#000000"
													border-bottom-style="solid" border-top-width="0.2mm"
													border-top-color="#FFFFFF" border-top-style="solid"
													border-left-width="0.2mm" border-left-color="#000000"
													border-left-style="solid" border-right-width="0.2mm"
													border-right-color="#FFFFFF" border-right-style="solid">
													<fo:block font-size="7.5pt" text-align="left"
														color="#000000">
														<xsl:value-of select="DescrizioneVoce" />
													</fo:block>
												</fo:table-cell>
												<fo:table-cell display-align="center"
													text-align="right" padding="0pt" number-columns-spanned="3"
													border-bottom-width="0.2mm" border-bottom-color="#000000"
													border-bottom-style="solid" border-top-width="0.2mm"
													border-top-color="#FFFFFF" border-top-style="solid"
													border-left-width="0.2mm" border-left-color="#000000"
													border-left-style="solid" border-right-width="0.2mm"
													border-right-color="#000000" border-right-style="solid">
													<fo:block font-size="7.5pt" text-align="right"
														color="#000000">
														<xsl:value-of
															select="concat(format-number(ImponibileVoce,'#.##0,00','euro'), '€')" />
													</fo:block>
												</fo:table-cell>

											</fo:table-row>
										</xsl:for-each>
										<fo:table-row>
											<fo:table-cell display-align="center"
												text-align="left" padding="0pt" number-columns-spanned="6"
												border-bottom-width="0.2mm" border-bottom-color="#000000"
												border-bottom-style="solid" border-top-width="0.2mm"
												border-top-color="#FFFFFF" border-top-style="solid"
												border-left-width="0.2mm" border-left-color="#000000"
												border-left-style="solid" border-right-width="0.2mm"
												border-right-color="#FFFFFF" border-right-style="solid">
												<fo:block font-size="7.5pt" text-align="left"
													color="#000000" font-weight="bold">
													<xsl:text>IMPORTO TOTALE </xsl:text>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell display-align="center"
												text-align="right" padding="0pt" number-columns-spanned="3"
												border-bottom-width="0.2mm" border-bottom-color="#000000"
												border-bottom-style="solid" border-top-width="0.2mm"
												border-top-color="#FFFFFF" border-top-style="solid"
												border-left-width="0.2mm" border-left-color="#000000"
												border-left-style="solid" border-right-width="0.2mm"
												border-right-color="#000000" border-right-style="solid">
												<fo:block font-size="7.5pt" text-align="right"
													color="#000000" font-weight="bold">
													<xsl:value-of
														select="concat(format-number(sum(Voci/Voce/ImponibileVoce),'#.##0,00','euro'), '€')" />
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
										<fo:table-row>
											<fo:table-cell display-align="center"
												text-align="right" padding="0pt" number-columns-spanned="9"
												border-bottom-width="0.2mm" border-bottom-color="#FFFFFF"
												border-bottom-style="solid" border-top-width="0.2mm"
												border-top-color="#FFFFFF" border-top-style="solid"
												border-left-width="0.2mm" border-left-color="#FFFFFF"
												border-left-style="solid" border-right-width="0.2mm"
												border-right-color="#FFFFFF" border-right-style="solid">
												<fo:block font-size="8pt" text-align="right" color="#FFFFFF"
													font-weight="bold">
													.
												</fo:block>
											</fo:table-cell>
										</fo:table-row>

										<!-- </xsl:if> -->
									</xsl:if>

								</xsl:for-each>

								<xsl:for-each
									select="/Cartella/Articoli/Articolo[@idDocumentoCollegato=$idCarOR and @codiceServizio!='18' and @codiceServizio!='32']">
									<xsl:if test="Voci/Voce">
										<xsl:for-each select="Voci/Voce">
											<fo:table-row>
												<fo:table-cell display-align="center"
													text-align="left" padding="0pt" number-columns-spanned="6"
													border-bottom-width="0.2mm" border-bottom-color="#000000"
													border-bottom-style="solid" border-top-width="0.2mm"
													border-top-color="#000000" border-top-style="solid"
													border-left-width="0.2mm" border-left-color="#000000"
													border-left-style="solid" border-right-width="0.2mm"
													border-right-color="#FFFFFF" border-right-style="solid">
													<fo:block font-size="7.5pt" text-align="left"
														color="#000000">
														<xsl:value-of select="DescrizioneVoce" />
													</fo:block>
												</fo:table-cell>
												<fo:table-cell display-align="center"
													text-align="right" padding="0pt" number-columns-spanned="3"
													border-bottom-width="0.2mm" border-bottom-color="#000000"
													border-bottom-style="solid" border-top-width="0.2mm"
													border-top-color="#000000" border-top-style="solid"
													border-left-width="0.2mm" border-left-color="#000000"
													border-left-style="solid" border-right-width="0.2mm"
													border-right-color="#000000" border-right-style="solid">
													<fo:block font-size="7.5pt" text-align="right"
														color="#000000">
														<xsl:value-of
															select="concat(format-number(ImponibileVoce,'#.##0,00','euro'), '€')" />
													</fo:block>
												</fo:table-cell>

											</fo:table-row>
										</xsl:for-each>

									</xsl:if>

								</xsl:for-each>
								<xsl:if test="count(/Cartella/Articoli/Articolo[@idDocumentoCollegato=$idCarOR and @codiceServizio='32']) &gt; 0">
									<xsl:if test="/Cartella/Articoli/Articolo[@idDocumentoCollegato=$idCarOR and @codiceServizio='32']/Voci/Voce">
											<fo:table-row>
												<fo:table-cell display-align="center"
													text-align="left" padding="0pt" number-columns-spanned="6"
													border-bottom-width="0.2mm" border-bottom-color="#000000"
													border-bottom-style="solid" border-top-width="0.2mm"
													border-top-color="#000000" border-top-style="solid"
													border-left-width="0.2mm" border-left-color="#000000"
													border-left-style="solid" border-right-width="0.2mm"
													border-right-color="#FFFFFF" border-right-style="solid">
													<fo:block font-size="7.5pt" text-align="left"
														color="#000000">
														<xsl:text>Arrotondamento</xsl:text>
													</fo:block>
												</fo:table-cell>
												<fo:table-cell display-align="center"
													text-align="right" padding="0pt" number-columns-spanned="3"
													border-bottom-width="0.2mm" border-bottom-color="#000000"
													border-bottom-style="solid" border-top-width="0.2mm"
													border-top-color="#000000" border-top-style="solid"
													border-left-width="0.2mm" border-left-color="#000000"
													border-left-style="solid" border-right-width="0.2mm"
													border-right-color="#000000" border-right-style="solid">
													<fo:block font-size="7.5pt" text-align="right"
														color="#000000">
														<xsl:value-of
															select="concat(format-number(sum(/Cartella/Articoli/Articolo[@idDocumentoCollegato=$idCarOR and @codiceServizio='32']/Voci/Voce/ImponibileVoce),'#.##0,00','euro'), '€')" />
													</fo:block>
												</fo:table-cell>

											</fo:table-row>

									</xsl:if>
								</xsl:if>
							</fo:table-body>
						</fo:table>

					</xsl:for-each>

					<fo:table keep-together="always" table-layout="fixed"
						space-before="0.1cm" space-after="0cm">

						<fo:table-column column-width="14.5cm" />
						<fo:table-column column-width="3.5cm" />
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell display-align="center" text-align="center"
									padding="2pt" number-columns-spanned="2" background-color="#F1F1F1"
									border-bottom-width="0.2mm" border-bottom-color="#000000"
									border-bottom-style="solid" border-top-width="0.2mm"
									border-top-color="#000000" border-top-style="solid"
									border-left-width="0.2mm" border-left-color="#000000"
									border-left-style="solid" border-right-width="0.2mm"
									border-right-color="#000000" border-right-style="solid">
									<fo:block font-family="Arial" font-size="7.5pt" color="#000000"
										font-weight="bold">TOTALI DELL'ACCERTAMENTO</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell text-align="left" padding="2pt"
									border-width="0.2mm" border-color="#000000" border-style="solid">
									<fo:block font-family="Arial" font-size="7.5pt"
										font-weight="bold">TOTALE DOVUTO</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="right" padding="2pt"
									border-width="0.2mm" border-color="#000000" border-style="solid">
									<fo:block font-family="Arial" font-size="7.5pt"
										font-weight="bold">
										<xsl:value-of
											select="format-number(sum(/Cartella/DocumentiCollegati/DocumentoCollegato/Importo) , '#.##0,00', 'euro')" />
										&#8364;
									</fo:block>
								</fo:table-cell>
							</fo:table-row>

							<fo:table-row>
								<fo:table-cell text-align="left" padding="2pt"
									border-width="0.2mm" border-color="#000000" border-style="solid">
									<fo:block font-family="Arial" font-size="7.5pt"
										font-weight="bold">TOTALE VERSATO</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="right" padding="2pt"
									border-width="0.2mm" border-color="#000000" border-style="solid">
									<fo:block font-family="Arial" font-size="7.5pt"
										font-weight="bold">
										<xsl:value-of
											select="format-number(sum(/Cartella/DocumentiCollegati/DocumentoCollegato/ImportoPagato) + sum(/Cartella/DocumentiCollegati/DocumentoCollegato/ImportoDiscaricato) , '#.##0,00', 'euro')" />
										&#8364;
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell text-align="left" padding="2pt"
									border-width="0.2mm" border-color="#000000" border-style="solid">
									<fo:block font-family="Arial" font-size="8pt"
										font-weight="bold">DIFFERENZA</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="right" padding="2pt"
									border-width="0.2mm" border-color="#000000" border-style="solid">
									<fo:block font-family="Arial" font-size="8pt"
										font-weight="bold">
										<xsl:value-of
											select="format-number(sum(/Cartella/DocumentiCollegati/DocumentoCollegato/Importo) - sum(/Cartella/DocumentiCollegati/DocumentoCollegato/ImportoDiscaricato) - sum(/Cartella/DocumentiCollegati/DocumentoCollegato/ImportoPagato ), '#.##0,00', 'euro')" />
										&#8364;
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell text-align="left" padding="2pt"
									border-width="0.2mm" border-color="#000000" border-style="solid">
									<fo:block font-family="Arial" font-size="7.5pt"
										font-weight="bold">DIRITTI DI NOTIFICA</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="right" padding="2pt"
									border-width="0.2mm" border-color="#000000" border-style="solid">
									<fo:block font-family="Arial" font-size="7.5pt"
										font-weight="bold">
										<xsl:value-of
											select="concat(format-number(sum(/Cartella/Spese/Spesa[@tipoSpesa='N' and  @idCartellaOrigine='0' and DescrizioneSpesa='Spese di notifica del presente atto']/ImportoSpesa),'#.##0,00','euro'), ' €')" />
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<xsl:if
								test="/Cartella/Spese/Spesa[@tipoSpesa='N' and  @idCartellaOrigine='0' and DescrizioneSpesa='DIRITTI DI RINOTIFICA']">

								<fo:table-row>
									<fo:table-cell text-align="left" padding="2pt" border-width="0.2mm" border-color="#000000" border-style="solid">
										<fo:block font-family="Arial" font-size="8pt" font-weight="bold">
											<xsl:value-of
												select="/Cartella/Spese/Spesa[@tipoSpesa='N' and  @idCartellaOrigine='0' and DescrizioneSpesa='DIRITTI DI RINOTIFICA']/DescrizioneSpesa" />

										</fo:block>
									</fo:table-cell>

									<fo:table-cell text-align="right" padding="2pt" border-width="0.2mm" border-color="#000000" border-style="solid">
										<fo:block font-family="Arial" font-size="8pt" font-weight="bold">
											<xsl:value-of
												select="concat(format-number( sum(/Cartella/Spese/Spesa[@tipoSpesa='N' and  @idCartellaOrigine='0' and DescrizioneSpesa='DIRITTI DI RINOTIFICA']/ImportoSpesa), '#.##0,00', 'euro'), ' €')" />

										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:if>
							<fo:table-row>

								<fo:table-cell text-align="left" padding="2pt"
									border-width="0.2mm" border-color="#000000" border-style="solid">
									<fo:block font-family="Arial" font-size="7.5pt"
										font-weight="bold">TOTALE DA VERSARE</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="right" padding="2pt"
									border-width="0.2mm" border-color="#000000" border-style="solid">
									<fo:block font-family="Arial" font-size="7.5pt"
										font-weight="bold">
										<xsl:value-of
											select="format-number(/Cartella/EstremiDocumento/Importo, '#.##0,00', 'euro')" />
										&#8364;
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>

					<fo:table table-layout="fixed" space-before="0.1cm">
						<fo:table-column column-width="17cm" />
						<fo:table-column column-width="1cm" />
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell display-align="center"
									background-color="#D0D0D0" padding="2pt">
									<fo:block text-align="justify" font-family="Arial"
										font-size="8pt" font-weight="bold">
										<xsl:text>Per avere maggiori informazioni sulle sue utenze, sullo stato dei suoi pagamenti e per visualizzare i documenti da noi inviati la invitiamo a registrarsi presso il ns portale www.solori.it, alla sezione "ESTRATTO CONTO".</xsl:text>
									</fo:block>
									<fo:block text-align="justify" font-family="Arial"
										font-size="8pt" font-weight="bold">
										<xsl:text>Per registrarsi è necessario avere a portata di mano il codice fiscale/la p.IVA dell'intestatario dell'utenza e un numero di documento da noi inviato (*). Una volta terminato il processo di registrazione sarà possibile accedere alle stesse informazioni che potrete avere presso i ns sportelli.</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center">
									<fo:block content-width="1.8cm">
										<fo:external-graphic content-width="1.8cm"
											src="file:gst03/RS/images/qr_code_portaleSOLORI.jpg" />
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
					<fo:block font-family="Arial" font-size="8pt"
						space-before="0.1cm" color="#000000" text-align="justify"
						font-weight="bold">
						<xsl:text>Per eventuali chiarimenti sulla posizione tributaria che ha dato seguito all'emissione dell'avviso di pagamento 
						(trasferimento in altra abitazione, componenti nucleo famigliare etc) e per richiedere un riesame dell'atto in sede di autotutela,
						 la invitiamo a rivolgersi agli sportelli di Solori spa Vicolo Volto Cittadella 4 - 37122 Verona che sono aperti nei seguenti giorni ed orari:</xsl:text>
					</fo:block>
					<fo:table space-before="0.1cm" table-layout="fixed" width="auto"
						margin-left="auto" margin-right="auto">
						<fo:table-column column-width="4.5cm" />
						<fo:table-column column-width="3cm" />
						<fo:table-column column-width="3cm" />
						<fo:table-column column-width="3cm" />
						<fo:table-column column-width="4.5cm" />
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm"></fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text>Lunedì</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text>7.45 - 13.15</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">

									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm"></fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm"></fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text>Martedì</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text>7.45 - 13.15</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text>14.30 - 16.00</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm"></fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm"></fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text>Mercoledì</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text>7.45 - 13.15</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text></xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm"></fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm"></fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text>Giovedì</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text>7.45 - 13.15</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text>14.30 - 16.00</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm"></fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm"></fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text>Venerdì</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text>7.45 - 13.15</xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0.2mm" border-color="#000000"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										font-style="italic" start-indent="0.1cm">
										<xsl:text></xsl:text>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm"></fo:table-cell>
							</fo:table-row>

						</fo:table-body>
					</fo:table>
					<fo:block font-family="Arial" font-size="8pt"
						space-before="0.1cm" color="#000000" text-align="justify"
						font-weight="bold">
						<xsl:text> oppure scrivere al ns. indirizzo di posta elettronica info@solori.it o inviare un fax ai numeri 045/9236799 - 045/9236798.</xsl:text>

					</fo:block>

					<fo:block font-family="Arial" font-size="8pt"
						space-before="0.1cm" color="#000000" text-align="justify"
						font-style="italic">
						<xsl:text>MODALITÀ DI PAGAMENTO</xsl:text>
					</fo:block>
					<fo:block font-family="Arial" font-size="8pt"
						space-before="0.1cm" color="#000000" text-align="justify"
						font-style="italic">
						<xsl:text>Il pagamento del presente avviso può essere effettuato alle scadenze indicate o in unica soluzione e dovrà essere eseguito esclusivamente tramite i modd. F24 allegati presso tutti gli sportelli bancari e postali e presso gli sportelli di Equitalia e non prevede nessuna spesa di commissione.</xsl:text>
					</fo:block>
					<fo:block font-family="Arial" font-size="8pt" color="#000000"
						text-align="justify" font-style="italic">
						<xsl:text>In caso di mancato pagamento SOLORI SPA si vedrà costretta ad attivare tutte le misure previste dalla legge per il recupero coattivo delle somme indicate nel presente avviso con inevitabile aggravio dei costi a carico dei contribuenti inadempienti.</xsl:text>
					</fo:block>


					<fo:table space-before="0.1cm" table-layout="fixed" keep-together="always">
						<fo:table-column column-width="9cm" />
						<fo:table-column column-width="9cm" />
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm" border-color="#FFFFFF"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										start-indent="3pt" text-align="left">
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm" border-color="#FFFFFF"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										start-indent="3pt" text-align="center">

									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm" border-color="#FFFFFF"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										start-indent="3pt" text-align="left">

									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm" border-color="#FFFFFF"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										start-indent="3pt" text-align="center">
										<xsl:text></xsl:text>
									</fo:block>
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										start-indent="3pt" text-align="center">SOLORI SPA</fo:block>
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										start-indent="3pt" text-align="center">IL FUNZIONARIO RESPONSABILE DEL
										TRIBUTO</fo:block>

								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm" border-color="#FFFFFF"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										start-indent="3pt" text-align="left">

									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="left"
									padding="2pt" border-width="0mm" border-color="#FFFFFF"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										start-indent="3pt" text-align="center">
										Ing. Livio Simone
									</fo:block>

								</fo:table-cell>
							</fo:table-row>
							<fo:table-row>
								<fo:table-cell display-align="center" text-align="center"
									padding="2pt" border-width="0mm" border-color="#FFFFFF"
									border-style="solid">
									<fo:block font-family="Arial" font-size="8pt" color="#000000"
										start-indent="3pt" text-align="left">

									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center" text-align="center"
									padding="2pt" border-width="0mm" border-color="#FFFFFF"
									border-style="solid">
									<fo:block content-height="1cm">
										<fo:external-graphic content-height="1cm"
											src="file:gst03/RS/images/firma_Simone.jpg" />
									</fo:block>
										<fo:block font-family="Arial" font-size="9pt"
														space-before="0cm" color="#000000">firma a stampa ai sensi dell'art. 1, comma 87,
													</fo:block>
													<fo:block font-family="Arial" font-size="9pt"
														space-before="0cm" color="#000000">della L. 28/12/1995 n. 549 - determina A.U. del 14/05/2015
													</fo:block>
													<fo:block text-align="center" font-family="Courier"
														font-size="20pt" color="#FFFFFF">
														<xsl:text>_</xsl:text>
													</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
					<fo:block font-family="Arial" font-size="7pt" color="#000000"
						text-align="justify" space-before="0.5cm">
						<xsl:text>TUTELA DATI PERSONALI -In ottemperanza a quanto previsto dal D.lgs.30.06.2003 n. 196, Codice della "privacy" SOLORI Spa, società concessionaria per la riscossione delle entrate del Comune di Verona, informa che dispone dei suoi dati personali che provengono dalle banche dati del comune stesso. I dati vengono trattati da soggetti abilitati con l'ausilio di strumenti elettronici per finalità strettamente connesse alla attività di riscossione volontaria e coattiva delle entrate comunali.</xsl:text>
					</fo:block>



				</fo:flow>
			</fo:page-sequence>
		</fo:root>

	</xsl:template>
	<xsl:template name="removeNaN">
		<xsl:param name="txt" />
		<xsl:choose>
			<xsl:when test="contains($txt,'NaN')">
				<xsl:variable name="pre" select="substring-before($txt,'NaN')" />
				<xsl:variable name="pos" select="substring-after($txt,'NaN')" />
				<xsl:variable name="res" select="concat($pre, '#', $pos)" />
				<xsl:choose>
					<xsl:when test="contains($pre,'NaN')">
						<xsl:call-template name="removeNaN">
							<xsl:with-param name="txt" select="$res" />
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$res" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$txt" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="stringReplaceAll">
		<xsl:param name="testo" />
		<xsl:param name="sostituisci" />
		<xsl:param name="con" />
		<xsl:choose>
			<xsl:when test="contains($testo, $sostituisci)">
				<xsl:value-of select="substring-before($testo,$sostituisci)" />
				<xsl:value-of select="$con" />
				<xsl:call-template name="stringReplaceAll">
					<xsl:with-param name="testo"
						select="substring-after($testo,$sostituisci)" />
					<xsl:with-param name="sostituisci" select="$sostituisci" />
					<xsl:with-param name="con" select="$con" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$testo" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

