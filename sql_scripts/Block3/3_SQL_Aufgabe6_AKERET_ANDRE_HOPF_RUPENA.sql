/*
Aufgabe 6

Eine Liste, welche pro Land die Anzahl der Gäste ausgibt, 
welche eine Adresse in diesem Land haben, 
absteigend sortiert nach Anzahl Gäste.
*/
USE hotel;
SELECT LandName, count(Kunden) AS "ANZAHL"
FROM
	(SELECT l.Landname AS "LandName"
    , k.KundeId AS "Kunden"
    FROM Kunde k
    JOIN Person p ON (k.PersonId = p.PersonId)
    JOIN Adresse a ON (p.PersonId = a.PersonId)
    JOIN Ort o ON (a.OrtId = o.OrtId)
    JOIN Land l ON (o.LandId = l.LandId)
    ) s
GROUP BY LandName
ORDER BY ANZAHL ASC
