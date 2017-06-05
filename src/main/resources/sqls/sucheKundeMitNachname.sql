SELECT k.KundeId, p.Nachname, p.Vorname, p.Geburtsdatum
	FROM Kunde k, Person p
    WHERE k.PersonId = p.PersonId
    AND p.Nachname LIKE ?;