/*
Aufgabe 3

Die Liste aller Mitarbeiter mit Nachname, Vorname, AHV-Nummer und allen bekannten E-Mail-Adressen.

Stellen Sie sicher, dass in Ihren Testdaten die folgenden Fälle erfasst sind und dass Ihre SQL-Abfrage die entsprechenden Ergebnisse liefert:

Mitarbeiter ohne E-Mail-Adresse
Mitarbeiter mit einer E-Mail-Adresse
Mitarbeiter mit mehr als einer E-Mail-Adresse
*/
USE hotel;

SELECT p.Nachname
, p.Vorname
, m.AHVNummer
, e.EMailAdresse
FROM Mitarbeiter m
JOIN Person p ON (m.PersonId = p.PersonId)
LEFT JOIN EMail e ON (p.PersonId = e.PersonId)