/**
Hotelverwaltung View 01
Generiert eine View, welche alle Reiseunternehmen mit Adresse und deren Ansprechperson anzeigt.
Authors: Thomas André, Sergio Rupena, Samuel Hopf, Marco Akeret
**/
-- View Löschen und wiederherstellen, Schema-Name 'hotel' gemäss Anforderungen
DROP VIEW IF EXISTS hotel.ReiseunternehmenAnsprechperson;

-- View erstellen
CREATE VIEW hotel.ReiseunternehmenAnsprechperson AS
	SELECT r.ReiseunternehmenId, f.Firmenname, a.AdressZeile1, a.AdressZeile2, a.AdressZeile3, o.OrtName, o.PLZ, l.LandName, ap.PersonId, p.Vorname, p.Nachname 
    FROM Reiseunternehmen r, Adresse a, AnsprechPerson ap, Person p, Ort o, Land l, Firma f 
    WHERE r.FirmaId = a.FirmaId AND r.AnsprechPersonId = ap.AnsprechPersonId AND ap.PersonId = p.PersonId AND o.LandId = l.LandId AND a.OrtId = o.OrtId AND f.FirmaId = r.FirmaId;