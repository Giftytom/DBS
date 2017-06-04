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
