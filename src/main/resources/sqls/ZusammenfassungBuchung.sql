SELECT b.AnreiseDatum
, b.AbreiseDatum
, z.ZimmerId, ZimmerNummer AS 'Nummer'
, Stockwerk, t.Name AS 'Trakt'
, CASE Alpenblick WHEN TRUE THEN 'ja' ELSE 'nein' END AS 'Alpenblick'
, CASE Whirlpool WHEN TRUE THEN 'ja' ELSE 'nein' END AS 'Whirlpool'
, CASE Bad WHEN TRUE THEN 'Bad' ELSE 'Dusche' END AS 'Ausstattung'
, zt.Bezeichnung AS 'Typ', bt.Bezeichnung AS 'Bett'
, bt.AnzahlPersonen AS 'Personen'
	FROM Buchung b
    JOIN ZimmerBelegung zb ON (b.BuchungId = zb.BuchungId)
    JOIN Zimmer z ON (zb.ZimmerId = z.ZimmerId)
    JOIN ZimmerTyp zt ON (z.ZimmerTypId = zt.ZimmerTypId)
    JOIN BettenTyp bt ON (zt.BettenTypId = bt.BettenTypId)
    WHERE b.BuchungId = ?;