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
