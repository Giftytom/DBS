/*
Anfrage in Buchung
*/
use hotel;

SET @MitarbeiterId = 3400; -- Vom Login des Mitarbeiters

-- Darstellung der offenen Anfragen
SELECT ba.BuchungAnfrageId -- muss nicht dargestellt werden, braucht es im System für die Buchung
, ba.ReiseunternehmenId -- wird zwischengespeichert, muss nicht dargestellt werden im der GUI
, f.FirmenName
, ba.AnreiseDatum -- benötigen wir zum Finden der freien Zimmer
, ba.AbreiseDatum -- benötigen wir zum Finden der freien Zimmer
, ba.AnzahlPersonen
, ba.Bemerkung -- hier stehen eventuell Zimmerwünsche drauf, oder wurden bei Nachfrage nachgetragen, ansonsten wwerden Zimmer einfach zugewiesen, wie verfuegbar
, ba.Reisegruppe -- Manchmal liefern Reiseunternehmen einen Namen für eine Reisegruppe 
	FROM BuchungAnfrage ba
	LEFT JOIN Buchung b ON (ba.BuchungAnfrageId = b.BuchungAnfrageId)
    JOIN Reiseunternehmen ru ON (ba.ReiseunternehmenId = ru.ReiseunternehmenId)
    JOIN Firma f ON (ru.FirmaId = f.FirmaId)
	WHERE ba.NachfrageGetaetigt = 0 -- Bereits nachgefragt, ob wirklich stattfindet
    AND ba.Storno = 0
    AND b.BuchungId is null; -- es gibt noch keine Buchung zur Anfrage

-- Eine Anfrage wurde ausgewählt, Parameter werden zwischengespeichert für Folge-Requests
SET @BuchungAnfrId = 6001;
SET @ReiseunternehmenId = 3201;
SET @AnreiseDatum = "2017-10-11";
SET @AbreiseDatum = "2017-10-18";

-- Select aller freien Zimmer im Zeitraum
SELECT DISTINCT z.ZimmerId, ZimmerNummer AS 'Nummer', Stockwerk, t.Name AS 'Trakt', 
    CASE Alpenblick WHEN TRUE THEN 'ja' ELSE 'nein' END AS 'Alpenblick', 
    CASE Whirlpool WHEN TRUE THEN 'ja' ELSE 'nein' END AS 'Whirlpool', 
    CASE Bad WHEN TRUE THEN 'Bad' ELSE 'Dusche' END AS 'Ausstattung',
    zt.Bezeichnung AS 'Typ', bt.Bezeichnung AS 'Bett', bt.AnzahlPersonen AS 'PersonenAnzahl'
        FROM Zimmer z
            LEFT OUTER JOIN ZimmerBelegung zb ON zb.ZimmerId = z.ZimmerId
           JOIN Trakt t ON t.TraktId = z.TraktId
          JOIN ZimmerTyp zt ON z.ZimmerTypId = zt.ZimmerTypId 
          JOIN BettenTyp bt ON zt.BettenTypId = bt.BettenTypId -- JOIN
          WHERE NOT EXISTS (
                 SELECT BuchungId FROM Buchung b
                    WHERE (b.AbreiseDatum > @AnreiseDatum 
                       AND b.AnreiseDatum < @AbreiseDatum)
                       AND b.Storno = FALSE
                       AND b.BuchungId = zb.BuchungId
);

-- Das Programm könnte noch die PersonenAnzahl summieren und diese separat anzeigen, für einen schnellen Vergleich ob allgemein noch genug Plätze vorhanden sind

-- nicht genug frei, Buchunganfrage stornieren
UPDATE BuchungAnfrage SET (Storno = 1) WHERE BuchungAnfrageId = @BuchungAnfrId;


-- Anschliessend ist eine Mehrfachauswahl von Zimmern ind er UI möglich. ZimmerId's werden gespeichert, sofern genug Zimmer frei sind, sonst absagen/stornieren
-- Es wird eine Liste der freien ZimmerId's in der Session gespeichert

-- Mit Auto-Increment, würde dieser Schrit erspart bleiben
SET @BuchungId = (SELECT max(BuchungId) +1 FROM Buchung);

-- Die folgenden Schrite werden nicht sofort commited, erst nach Erfolg, oder ein Rollback
INSERT INTO Buchung (BuchungId, MitarbeiterId, ReiseunternehmenId, BuchungAnfrageId, AnreiseDatum, AbreiseDatum)
	VALUES (@BuchungId, @MitarbeiterId, @ReiseunternehmenId, @BuchungAnfrageId, @AnreiseDatum, @AbreiseDatum);
    
-- Schleife über die Liste der ZimmerIds, ob es noch frei und dann gleich der Buchung zuweisen
-- Beispiel mit einer ZimmerId
SET @ZimmerId = 4920;
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
-- Falls @Zimmer Null, dann Abbruch und rollback - Meldung in der GUI das Buchung nicht erfolgreich war und zurück zur Zimmerzuweisung (Select freie Zimmer)
-- setze ZimmerBelegungId -> Auto-Increment ...
SET @ZimmerBelegungId = (SELECT max(zb.ZimmerBelegungId) +1
	FROM ZimmerBelegung zb);
INSERT INTO ZimmerBelegung (ZimmerBelegungId, ZimmerId, BuchungId) VALUES(@ZimmerBelegungId, @ZimmerId, @BuchungId);

-- Wenn alles erfolgreich geklappt hat - commit

-- Anschliessende Zusammenfassung der Buchung
SELECT f.FirmenName AS 'Reiseunternehmen', b.AnreiseDatum AS 'Anreise',
	b.AbreiseDatum AS 'Abreise', z.ZimmerNummer AS 'Nummer', Stockwerk, t.Name AS 'Trakt', 
    CASE Alpenblick WHEN TRUE THEN 'ja' ELSE 'nein' END AS 'Alpenblick', 
    CASE Whirlpool WHEN TRUE THEN 'ja' ELSE 'nein' END AS 'Whirlpool', 
    CASE Bad WHEN TRUE THEN 'Bad' ELSE 'Dusche' END AS 'Ausstattung',
    zt.Bezeichnung AS 'Typ', bt.Bezeichnung AS 'Bett', bt.AnzahlPersonen AS 'PersonenAnzahl',
    ba.Reisegruppe AS 'Reisegruppe'
        FROM Zimmer z
		JOIN ZimmerBelegung zb ON zb.ZimmerId = z.ZimmerId
        JOIN Buchung b ON zb.BuchungId = b.BuchungId
        JOIN BuchungAnfrage ba ON b.BuchungAnfrageId = ba.BuchungAnfrageId
        JOIN Reiseunternehmen r ON b.ReiseunternehmenId = r.ReiseunternehmenId
        JOIN Firma f ON r.FirmaId = f.FirmaId
        WHERE b.BuchungId = @BuchungId;