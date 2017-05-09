/*
Erstellen Sie eine SQL-Abfrage, mit welcher die folgende Anforderung von Luzius erfüllt werden kann:
Bei der Buchung muss natürlich klar sein, ob das Hotel überhaupt Platz hat für die Übernachtung. 
Die Abfrage soll für eine Buchung für ein Doppelzimmer, sowie für ein Anreise- und ein Abreisedatum funktionieren.
Identifizieren Sie alle Testfälle, welche in Ihren Testdaten vorhanden sein müssen.
Dokumentieren Sie.
*/
USE hotel;
-- beliebiges Datum
SET @AnreiseDatum = '2017-08-01';
SET @AbreiseDatum = '2017-08-07';    

-- setze die ZimmerId
SET @FreiesZimmer = (SELECT z.ZimmerId
	FROM Zimmer z
    LEFT JOIN ZimmerBelegung zb ON (z.ZimmerId = zb.ZimmerId) -- Join von Tabellen
    JOIN Buchung b ON (zb.BuchungId = b.BuchungId)
    JOIN ZimmerTyp zt ON (z.ZimmerTypId = zt.ZimmerTypId)
    JOIN BettenTyp bt ON (zt.BettenTypId = bt.BettenTypId)
    WHERE bt.AnzahlPersonen = 2 -- 2 Personen - also Doppelzimmer
    AND z.ZimmerId NOT IN ( -- Es existiert keine Buchung, die entsprechende ZimmeriD in dem Zeitraum blockiert
		SELECT zb.ZimmerId
			FROM Buchung b, ZimmerBelegung zb
            WHERE (b.AbreiseDatum between @AnreiseDatum AND @AbreiseDatum  -- in dem Zeitraum Abreise
			OR b.AnreiseDatum between  @AnreiseDatum AND @AbreiseDatum) -- in dem Zeitraum Anreise
			AND b.Storno = FALSE -- nicht storniert
            AND b.BuchungId = zb.BuchungId) -- Keine Zimmerbelegung
	LIMIT 1);-- ein freies Zimmer
    
-- erhalte neachste BuchungId, falls es ein Freies Zimmer gibt
SET @BuchungId = (SELECT if(@FreiesZimmer IS NULL, NULL, (SELECT max(b.BuchungId) + 1 FROM Buchung b)));

-- mit diesen Werten, und einer KundenId koennte jetzt eine Buchung getetigt werden
-- Kunden suchen über Name
SET @KundeId = (SELECT max(KundeId) 
	FROM Person p, Kunde k 
    WHERE p.PersonId = k.PersonId AND Nachname = "Andre" AND Vorname = "Thomas");

-- taetige die Buchung
INSERT INTO Buchung (BuchungId, KundeId, AnreiseDatum, AbreiseDatum)
	VALUES (@BuchungId, @KundeId, @AnreiseDatum, @AbreiseDatum);
INSERT INTO ZimmerBelegung (ZimmerBelegungId, ZimmerId, BuchungId)
-- ZimmerBelegungId wird eins hochgezaehlt, durch Sub-Select. Hier und auch schon bei BuchungId wuerde auto_increment helfen 
	VALUES ((SELECT max(zb.ZimmerBelegungId) +1 FROM ZimmerBelegung zb),@FreiesZimmer, @BuchungId);