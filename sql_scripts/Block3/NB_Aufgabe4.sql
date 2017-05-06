/*
Erstellen Sie eine SQL-Abfrage, mit welcher die folgende Anforderung von Luzius erfüllt werden kann:

Bei der Buchung muss natürlich klar sein, ob das Hotel überhaupt Platz hat für die Übernachtung.

Die Abfrage soll für eine Buchung für ein Doppelzimmer, sowie für eine Verfügbarkeitsanfrage funktionieren.
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
