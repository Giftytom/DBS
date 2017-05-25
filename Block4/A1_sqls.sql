/*
SQL-Abfragen bei Zimmerbuchung
*/
SET @MitarbeiterId = 3400; -- Vom Login des Mitarbeiters
SET @AnreiseDatum = "2017-07-01";
SET @AbreiseDatum = "2017-07-07";
SET @AnzahlPersonen = 2;

-- Alle freien Zimmer (im Zeitraum nicht gebucht, ohne Berücksichtigung der Anfragen)
SELECT DISTINCT z.ZimmerId, ZimmerNummer AS 'Nummer', Stockwerk, t.Name AS 'Trakt', 
    CASE Alpenblick WHEN TRUE THEN 'ja' ELSE 'nein' END AS 'Alpenblick', 
    CASE Whirlpool WHEN TRUE THEN 'ja' ELSE 'nein' END AS 'Whirlpool', 
    CASE Bad WHEN TRUE THEN 'Bad' ELSE 'Dusche' END AS 'Ausstattung',
    zt.Bezeichnung AS 'Typ', bt.Bezeichnung AS 'Bett', bt.AnzahlPersonen AS 'Personen'
        FROM Zimmer z
            LEFT OUTER JOIN ZimmerBelegung zb ON zb.ZimmerId = z.ZimmerId
           JOIN Trakt t ON t.TraktId = z.TraktId
          JOIN ZimmerTyp zt ON z.ZimmerTypId = zt.ZimmerTypId 
          JOIN BettenTyp bt ON zt.BettenTypId = bt.BettenTypId -- JOIN
          WHERE AnzahlPersonen = @AnzahlPersonen -- richtige Anzahl Betten
              AND NOT EXISTS (
                 SELECT BuchungId FROM Buchung b
                    WHERE (b.AbreiseDatum > @AnreiseDatum 
                       AND b.AnreiseDatum < @AbreiseDatum)
                       AND b.Storno = FALSE
                       AND b.BuchungId = zb.BuchungId
);

-- Ein Zimmer kann selektiert werden. Die ZimmerId wird dabei im Programm gemerkt
SET @ZimmerID = 4920;

-- Anschliessend wird ein Zimmer ausgewählt
-- erneute Pruefung mit ZimmerId, ob noch frei
SET @Zimmer = (SELECT DISTINCT z.ZimmerId
	FROM Zimmer z
    LEFT OUTER JOIN ZimmerBelegung zb ON (z.ZimmerId = zb.ZimmerId)
    WHERE z.ZimmerId = @ZimmerId 
    AND NOT EXISTS (
		SELECT b.BuchungId FROM Buchung b
              WHERE (b.AbreiseDatum > @AnreiseDatum 
              AND b.AnreiseDatum < @AbreiseDatum)
              AND b.Storno = FALSE
              AND b.BuchungId = zb.BuchungId
    )
	);

-- SELECT @Zimmer;  wird im Programm abgefangen, wenn leer, dann zurück und Hinweis, dass Zimmer bereits gebucht wurde

-- Buchungs des Zimmers
-- setze neue BuchungId -> Auto-Increment wäre auch eine Möglichkeit
SET @BuchungId = (SELECT max(b.BuchungId) +1
	FROM Buchung b);
-- setze ZimmerBelegungId -> Auto-Increment ...
SET @ZimmerBelegungId = (SELECT max(zb.ZimmerBelegungId) +1
	FROM ZimmerBelegung zb);
    
INSERT INTO Buchung (BuchungId, MitarbeiterId, AnreiseDatum, AbreiseDatum) VALUES(@BuchungId, @MitarbeiterId, @AnreiseDatum, @AbreiseDatum);
INSERT INTO ZimmerBelegung (ZimmerBelegungId, ZimmerId, BuchungId) VALUES(@ZimmerBelegungId, @ZimmerId, @BuchungId);
-- Zimmer sind somit blockiert

-- Falls Buchungsvorgang abgebrochen wird "Cancel", bzw, Buchung gelöscht werden soll vor entgültigem Abschluss der Buchung - es wird kein Storno gemacht
DELETE FROM ZimmerBelegung WHERE ZimmerBelegungId = @ZimmerBelegungId;
DELETE FROM Buchung WHERE BuchungId = @BuchungId;

-- Definitive Belegung
-- Falls Kunde noch nicht in unserer DB, Kunde hinzufügen

SET @KundeId = 2364
-- Falls Kunde schon vorhanden
UPDATE Buchung SET KundeId = @KundeId WHERE BuchungId = @BuchungId;

-- Personen werden erst bei Checkin ZimmerBelegungPerson hinzugefügt
