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
JOIN ZimmerBelegungPerson zbp ON (p.PersonId = zbp.PersonId) 
-- weitere Tabellen verbinden
JOIN ZimmerBelegung zb ON (zbp.ZimmerBelegungId = zb.ZimmerBelegungId)
JOIN Buchung b ON (zb.BuchungId = b.BuchungId)
-- Bis hierhin muss eine Begelitperson keine eigene KundeId haben
-- Die Eingrenzung, dass die Buchung von einen Mitarbeiter getaetigt wurde
WHERE b.KundeId IN -- Subselect 
		(SELECT k.KundeId 
			FROM Kunde k
            JOIN Person p ON (k.PersonId = p.PersonId)
            JOIN Mitarbeiter m ON (p.PersonId = m.PersonId) )
		