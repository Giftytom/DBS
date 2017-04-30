/*
Erstellen Sie eine SQL-Abfrage, mit welcher die folgende Anforderung von Luzius erfüllt werden kann:

Mitarbeiter, welche auch Gäste sind, erhalten Sonderkonditionen für sich und ihre Begleitpersonen.

Die Abfrage soll alle Hotelgäste auflisten mit Name, Vorname für welche diese Anforderung zutrifft.

Identifizieren Sie alle Testfälle, welche in Ihren Testdaten vorhanden sein müssen.

Dokumentieren Sie.
*/
use hotel;
-- Nachname und Vorname in Tabelle Person
SELECT p.Nachname
, p.Vorname
FROM Person p
-- gleichzeitig auch Mitarbeiter
JOIN Mitarbeiter m ON (p.PersonId = m.PersonId)
-- gleichzeitig auch als Gast/Kunde erfasst - sie hatten schon mal eine Buchung
JOIN Kunde k ON (p.PersonId = k.PersonId)
-- Begleitpersonen von diesen müssen auch noch rein -> UNION
UNION
SELECT p.Nachname
, p.Vorname
FROM Person p
-- muss Hotelgast sein, also in ZimmerBelegungPerson
WHERE p.PersonId IN 
	(SELECT DISTINCT zbp.PersonId FROM ZimmerBelegungPerson zbp)
-- und in der selben ZimmerBelegungId muss auch eine Buchung durch einen Mitarbeiter stattgefunden haben
AND 1 -- Buchung.KundeId IN ()