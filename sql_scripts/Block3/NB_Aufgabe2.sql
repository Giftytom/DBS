/*
Erstellen Sie eine SQL-Abfrage, mit welcher die folgende Anforderung von Luzius erfüllt werden kann:

Die Zusammenarbeit mit Reisebüros hat sich bewährt. Luzius möchte eine Übersicht erhalten, welches Reisebüro pro Jahr wieviele Übernachtungen bringt. 
Er trägt sich mit dem Gedanken, besonders guten Reisebüros Rabatt zu geben, oder auch besonders guten Mitarbeitern in Reisebüros zum Geburtstag eine 
kleine Aufmerksamkeit zu schicken.
Die Abfrage soll alle Reisebüromitarbeiter, Firmenmitarbeiter auflisten mit Name, Vorname, und postalischer Adresse für welche diese Anforderung zutrifft.

Identifizieren Sie alle Testfälle, welche in Ihren Testdaten vorhanden sein müssen.

Dokumentieren Sie.
*/
use hotel;
-- Auflistung Anzahl Uebernachtungen pro Jahr pro Reisebüro (AnreiseDatum ist hier ausschlaggebend. Über Silvester/Neujahr wird nicht berücksichtigt) 
SELECT f.FirmenName
-- Differenz An- und Abreisedatum -1  - Hier ist nur auf die Buchungen bezogen, dies müsste noch multipliziert mit Anzahl ZimmerBelegungPerson
, sum(
	(timestampdiff(DAY, b.AnreiseDatum, b.AbreiseDatum) -1) *
		(SELECT count(*) 
			FROM ZimmerBelegungPerson zbp
            JOIN ZimmerBelegung zb ON (zbp.ZimmerBelegungId = zb.ZimmerBelegungId)
			WHERE zb.BuchungId = b.BuchungId) ) AS 'Uebernachtungen'
, year(b.AnreiseDatum) AS 'Jahr'
	FROM Buchung b
JOIN Reiseunternehmen r ON (b.ReiseunternehmenId = r.ReiseunternehmenId)
JOIN Firma f ON (r.FirmaId = f.FirmaId)
JOIN ZimmerBelegung zb ON (b.BuchungId = zb.BuchungId)
JOIN ZimmerBelegungPerson zbp ON (zb.ZimmerBelegungId = zbp.ZimmerBelegungId)
-- Optional
-- WHERE year(b.AnreiseDatum) = 2017
GROUP BY Jahr, f.FirmenName;


SELECT DISTINCT p.Nachname
, p.Vorname
, o.PLZ
, a.AdressZeile1
, a.AdressZeile2
, a.AdressZeile3
, o.OrtName
, l.LandName
	FROM Reiseunternehmen r
    JOIN Firma f ON (r.FirmaId = f.FirmaId)
    JOIN AnsprechPerson ap ON (r.AnsprechPersonId = ap.AnsprechPersonId)
    JOIN Person p ON (ap.PersonId = p.PersonId)
    JOIN Buchung b ON (r.ReiseunternehmenId = b.ReiseunternehmenId)
    JOIN ZimmerBelegung zb ON (b.BuchungId = zb.BuchungId)
    JOIN ZimmerBelegungPerson zbp ON (zb.ZimmerBelegungId = zbp.ZimmerBelegungId)
    LEFT JOIN Adresse a ON (p.PersonId = a.PersonId OR f.FirmaId = a.FirmaId)
    JOIN Ort o ON (a.OrtId = o.OrtId)
    JOIN Land l on (o.LandId = l.LandId)  
-- Wenn Geburtstag
WHERE month(p.Geburtsdatum) = month(curdate()) AND dayofmonth(p.Geburtsdatum) = dayofmonth(curdate())
-- Vom Reiseunternehmen, dass > x Uebernachtungen geschafft hat (Optional pro Jahr)
AND (SELECT u.Uebernachtungen FROM 
	( SELECT f.FirmenName
	-- Differenz An- und Abreisedatum -1  - Hier ist nur auf die Buchungen bezogen, dies müsste noch multipliziert mit Anzahl ZimmerBelegungPerson
	, sum(
	(timestampdiff(DAY, b.AnreiseDatum, b.AbreiseDatum) -1) *
		(SELECT count(*) 
			FROM ZimmerBelegungPerson zbp
            JOIN ZimmerBelegung zb ON (zbp.ZimmerBelegungId = zb.ZimmerBelegungId)
			WHERE zb.BuchungId = b.BuchungId) ) AS 'Uebernachtungen'
, year(b.AnreiseDatum) AS 'Jahr'
	FROM Buchung b
JOIN Reiseunternehmen r ON (b.ReiseunternehmenId = r.ReiseunternehmenId)
JOIN Firma f ON (r.FirmaId = f.FirmaId)
JOIN ZimmerBelegung zb ON (b.BuchungId = zb.BuchungId)
JOIN ZimmerBelegungPerson zbp ON (zb.ZimmerBelegungId = zbp.ZimmerBelegungId)
-- Optional
-- WHERE year(b.AnreiseDatum) = 2017 -- Variable im Programm
-- Zahl kann auch entsprechend erhöht werden (Variable im Programm)
GROUP BY Jahr, f.FirmenName ) u) > 1;

	 
