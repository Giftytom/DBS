/*
Erstellen Sie eine SQL-Abfrage, mit welcher die folgende Anforderung von Luzius erfüllt werden kann:

Bei der Buchung muss natürlich klar sein, ob das Hotel überhaupt Platz hat für die Übernachtung. 

Die Abfrage soll für eine Buchung für ein Doppelzimmer, sowie für ein Anreise- und ein Abreisedatum funktionieren.

Identifizieren Sie alle Testfälle, welche in Ihren Testdaten vorhanden sein müssen.

Dokumentieren Sie.
*/
-- Buchung erstellen
SET @NeueBuchungId = (SELECT max(BuchungId) + 1 FROM Buchung);
SET @AnreiseDatum = "2017-08-01";
SET @AbreiseDatum = "2017-08-07";
-- oder eine Nummer wie 7099
INSERT INTO Buchung (BuchungId, KundeId, AnreiseDatum, AbreiseDatum, Bemerkung)
	VALUES (@NeueBuchungId, @NeueKundeId, @AnreiseDatum, @AbreiseDatum, "Auch dies ist ein Test");


-- das erste aller freien Zimmer mit entsprechendem Platz
SELECT z.ZimmerId FROM Zimmer z
	LEFT OUTER JOIN ZimmerBelegung zb ON zb.ZimmerId = z.ZimmerId
	JOIN ZimmerTyp zt ON z.ZimmerTypId = zt.ZimmerTypId 
    JOIN BettenTyp bt ON zt.BettenTypId = bt.BettenTypId -- JOIN
	WHERE AnzahlPersonen = 1 -- richtige Anzahl Betten
    AND NOT EXISTS (
		SELECT BuchungId FROM Buchung b
			WHERE (b.AbreiseDatum >= @AnreiseDatum 
			OR b.AnreiseDatum <= @AbreiseDatum)
			AND b.Storno = FALSE
            AND b.BuchungId = zb.BuchungId
		)
	LIMIT 1;