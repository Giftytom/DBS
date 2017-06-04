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
