-- Erstellen Sie mit einer SQL-Abfrage die Liste aller Mitarbeiter mit Nachname, Vorname, AHV-Nummer sortiert nach Nachname.

SELECT p.Nachname AS NachName
	, p.Vorname AS Vorname
	, m.AHVNummer
	FROM Mitarbeiter m, Person p
	ORDER BY p.Nachname;