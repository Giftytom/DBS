SELECT z.ZimmerId, b.AnreiseDatum, b.AbreiseDatum
 FROM Zimmer z
 JOIN ZimmerBelegung zb ON zb.ZimmerId = z.ZimmerId
 JOIN Buchung b on b.BuchungId = zb.BuchungId
 WHERE z.ZimmerId = ?
 AND b.AbreiseDatum > ?
 AND b.AnreiseDatum < ?
 AND b.storno = FALSE
 FOR UPDATE