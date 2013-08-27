* * * * *
* Naam adapl: pidserviceIncr.ada
* Type adapl: adeval adapl. 
* Gekoppeld aan/behorend bij: collect.inf
* Datum gemaakt: 9 oktober 2012
* Naam programmeur: Lizzy Jongma
* Opmerkingen/ beschrijving adapl:
*     Stand alone script om, na stand alone gestart te zijn, alle PIDs uit Adlib uitleest en naar het juiste XML formaat transformeert.
*		Alle PIDs van het Rijksmuseum worden opgebouwd uit een prefix hdl.handle.net/10934 en dan volgt het databasenummer, de databasenaam en het recordnummer van het object
*
* * * * *

* -----------------------------------------------------------
* declaratie FACS bestand + variabelen
* -----------------------------------------------------------

/*FDSTART COLLECT 'J:\CMS\data+collect'
FDSTART COLLECT 'R:\CMS\data+collect>object'
   %0 is RecordNumber
   di is DatumInvoer
   dm is DatumMutatie
   IN is InventoryNumber
   PI is PersistentIdentifier
   PW is PublishWebsite
FDEND

* -----------------------------------------------------------
* openen text uitvoerbestand 
* -----------------------------------------------------------
/*pdest 'full_pids_' + date$(8) + '.xml' file
pdest 'pidsincr.xml' file
* -----------------------------------------------------------
* openen FACS bestanden
* -----------------------------------------------------------
print 1, 0, '<pids>'
output

open COLLECT
if (&E <> 0) {
  errorm 'Fout bij het openen van de database: ' + &E
  end
}
while (not &E){
  /* read COLLECT next using RecordNumber = '*' /* alle records uitlezen levert ruim 500.000 PIDS op
  
  text datum[10]
  datum = left$(date$(8), 4) + '-' + MID$(date$(8), 6, 2)
  
  read COLLECT next using DatumMutatie = datum /* Incrementele script
  if (PublishWebsite <> '3') { /* Alle objecten die online mogen worden naar het XML bestand geschreven
	if (PersistentIdentifier <> '') {
		print 1, 0, '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pid="http://pid.socialhistoryservices.org/">'
		output
		print 3, 0, '<soapenv:Body>'
		output
		print 7, 0, '<pid:UpsertPidRequest>'
		output
		print 9, 0, '<pid:na>10934</pid:na>'
		output
		print 9, 0, '<pid:handle>'
		output
		print 11, 0, '<pid:pid>10934/' + PersistentIdentifier + '</pid:pid>'
		output
		print 11, 0, '<pid:locAtt>'
		output
		print 13, 0, '<pid:location pid:href="http://www.rijksmuseum.nl/collectie/'+ InventoryNumber + '" pid:weight="1"/>'
		output
		print 13, 0, '<pid:location pid:href="http://www.rijksmuseum.nl/collectie/'+ InventoryNumber + '" pid:weight="0" pid:view="collectie"/>'
		output
		/* LJ 2013/08/19 ik heb het maken van een PID voor afbeeldingen nog even uitgeschakeld omdat lang niet alle objecten in de collectie van het Rijksmuseum een
		/* afbeelding hebben.
		if (PublishWebsite <> '2') { /* alleen objecten waarvan beeld getoond mag worden krijgen deze PID
			print 13, 0, '<pid:location pid:href="http://www.rijksmuseum.nl/media/assets/'+ InventoryNumber + '" pid:weight="0" pid:view="asset"/>'
			output
		}
		print 11, 0, '</pid:locAtt>'
		output
		print 9, 0, '</pid:handle>'
		output
		print 7, 0, '</pid:UpsertPidRequest>'
		output
		print 3, 0, '</soapenv:Body>'
		output
		print 1, 0, '</soapenv:Envelope>' 
		output
	}
  }
  If (&E <> 0) {
    print 1, 0, '</pids>'
    output
    end
  }
} 

end