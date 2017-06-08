SELECT DISTINCT z.ZimmerId
	FROM Zimmer z
    LEFT OUTER JOIN ZimmerBelegung zb ON (z.ZimmerId = zb.ZimmerId)
    WHERE z.ZimmerId = ?
    AND zb.BuchungId NOT IN (
		SELECT b.BuchungId FROM Buchung b
              WHERE (b.AbreiseDatum > @AnreiseDatum
              AND b.AnreiseDatum < @AbreiseDatum)
              AND b.Storno = FALSE
              AND b.BuchungId = zb.BuchungId
    );
