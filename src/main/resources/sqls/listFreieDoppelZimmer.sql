SELECT zi.ZimmerId AS 'ID' FROM Zimmer zi
  JOIN ZimmerTyp zt ON zi.ZimmerTypId = zt.ZimmerTypId
  JOIN BettenTyp bt ON zt.BettenTypId = bt.BettenTypId
  WHERE AnzahlPersonen = 2
  AND zi.ZimmerId NOT IN (
    SELECT z.ZimmerId FROM Zimmer z
      JOIN ZimmerBelegung zb ON zb.ZimmerId = z.ZimmerId
      JOIN Buchung b on b.BuchungId = zb.BuchungId
      AND (b.AbreiseDatum > ?
      AND b.AnreiseDatum < ?)
      AND b.storno = FALSE);
