SELECT zi.ZimmerId AS 'ID', ZimmerNummer AS 'Nummer', Stockwerk, t.Name AS 'Trakt',
 CASE Alpenblick WHEN TRUE THEN 'ja' ELSE 'nein' END AS 'Alpenblick',
 CASE Whirlpool WHEN TRUE THEN 'ja' ELSE 'nein' END AS 'Whirlpool',
 CASE Bad WHEN TRUE THEN 'Bad' ELSE 'Dusche' END AS 'Ausstattung',
 zt.Bezeichnung AS 'Typ', bt.Bezeichnung AS 'Bett', bt.AnzahlPersonen AS 'Personen'
 FROM Zimmer zi
  JOIN ZimmerTyp zt ON zi.ZimmerTypId = zt.ZimmerTypId
  JOIN BettenTyp bt ON zt.BettenTypId = bt.BettenTypId
  JOIN Trakt t ON zi.TraktId = t.TraktId
  WHERE AnzahlPersonen = 2
  AND zi.ZimmerId NOT IN (
    SELECT z.ZimmerId FROM Zimmer z
      JOIN ZimmerBelegung zb ON zb.ZimmerId = z.ZimmerId
      JOIN Buchung b on b.BuchungId = zb.BuchungId
      AND (b.AbreiseDatum > ?
      AND b.AnreiseDatum < ?)
      AND b.storno = FALSE);
