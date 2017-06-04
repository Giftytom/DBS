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
