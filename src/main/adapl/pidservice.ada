* * * * *
* Naam adapl: CONA_DC.ada
* Type adapl: printadapl
* Gekoppeld aan/behorend bij: collect.inf
* Datum gemaakt: 9 oktober 2012
* Naam programmeur: Lizzy Jongma
* Opmerkingen/ beschrijving adapl:
*     Export gegevens in CDWA achtig formaat tbv Open Data.
*
* * * * *

* -----------------------------------------------------------
* declaratie FACS bestand + variabelen
* -----------------------------------------------------------

FDSTART COLLECT 'J:\CMS\data+collect'
   di is DatumInvoer
   dm is DatumMutatie
   IN is InventoryNumber
   PI is PersistentIdentifier
FDEND

* -----------------------------------------------------------
* openen text uitvoerbestand 
* -----------------------------------------------------------
pdest 'pids.xml' file

* -----------------------------------------------------------
* openen FACS bestanden
* -----------------------------------------------------------

OPEN COLLECT 
if (&E <> 0) {
  errorm 'Fout bij het openen van de database: ' + &E
  end
}

print 1, 0, '<pids>'
output

read COLLECT next using DatumMutatie = date$(8)
while (not &E) {
 

  
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
print 13, 0, '<pid:location pid:href="http://www.rijksmuseum.nl/media/assets/'+ InventoryNumber + '" pid:weight="0" pid:view="asset"/>'
output
print 11, 0, '</pid:locAtt>'
output
print 9, 0, '</pid:handle>'
output
print 7, 0, '</pid:UpsertPidRequest>'
output


/** Laatste Record =============================-->

  print 3, 0, '</soapenv:Body>'
  output
  print 1, 0, '</soapenv:Envelope>' 
  output
}
close COLLECT

print 1, 0, '</pids>'
output


end
