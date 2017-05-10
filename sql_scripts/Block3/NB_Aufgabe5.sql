/*
Erstellen Sie eine SQL-Abfrage, mit welcher die folgende Anforderung von Luzius erfüllt werden kann:

Aurelias Bemerkung zur Verfügbarkeitsanfrage:

Ich möchte nochmals darauf hinweisen, dass ich eine sehr präzise Liste führe, welche mir Auskunft darüber gibt, 
wieviele Verfügbarkeitsanfragen zu einer Buchung führen. So kann ich bei der Disposition besser abschätzen, 
mit welcher Wahrscheinlichkeit eine Anfrage eines Reisebüros zu einer Buchung führt.

Die Abfrage soll alle Hotelgäste auflisten mit Name, Vorname für welche diese Anforderung zutrifft.

Identifizieren Sie alle Testfälle, welche in Ihren Testdaten vorhanden sein müssen.

Dokumentieren Sie.
*/
USE hotel;

SELECT p.Nachname
, p.Vorname
, b.BuchungAnfrageId
, ba.Reisegruppe
, ba.AnzahlPersonen
-- , r.ReiseunternehmenId
, f.FirmenName
FROM ZimmerBelegungPerson zbp, ZimmerBelegung zb, Buchung b, Person p, BuchungAnfrage ba, Reiseunternehmen r, Firma f
WHERE zbp.PersonId = p.PersonId
AND zbp.ZimmerBelegungId = zb.ZimmerBelegungId
AND zb.BuchungId = b.BuchungId
AND b.BuchungAnfrageId = ba.BuchungAnfrageId
AND ba.ReiseunternehmenId = r.ReiseunternehmenId
AND r.FirmaId = f.FirmaId
AND ba.Storno = false