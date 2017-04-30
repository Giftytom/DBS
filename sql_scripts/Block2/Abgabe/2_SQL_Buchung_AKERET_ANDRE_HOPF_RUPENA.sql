/**
	Hotelverwaltung: Buchungsbeispiel
	Authors: Thomas André, Sergio Rupena, Samuel Hopf, Marco Akeret
**/
 
/* 
	Beispiel 1:
    Standard-Buchung eines Kunden, der bereits registriert ist 
    Doppelzimmer
*/

-- Kunden suchen über Name
SET @KundeId = (SELECT max(KundeId) FROM Person p, Kunde k WHERE p.PersonId = k.PersonId AND Nachname = "Hopf" AND Vorname = "Samuel");

-- Buchung erstellen
SET @NeueBuchungId = (SELECT max(BuchungId) + 1 FROM Buchung);
SET @AnreiseDatum = "2017-07-01";
SET @AbreiseDatum = "2017-07-07";
INSERT INTO Buchung (BuchungId, KundeId, AnreiseDatum, AbreiseDatum, Bemerkung)
	VALUES (@NeueBuchungId, @KundeId, @AnreiseDatum, @AbreiseDatum, "Dies ist ein Test");

-- das erste aller freien Zimmer mit entsprechendem Platz
SET @FreiesZimmer = (SELECT z.ZimmerId FROM Zimmer z
	LEFT OUTER JOIN ZimmerBelegung zb ON zb.ZimmerId = z.ZimmerId
	JOIN ZimmerTyp zt ON z.ZimmerTypId = zt.ZimmerTypId 
    JOIN BettenTyp bt ON zt.BettenTypId = bt.BettenTypId -- JOIN
	WHERE AnzahlPersonen = 2 -- richtige Anzahl Betten
    AND NOT EXISTS (
		SELECT BuchungId FROM Buchung b
			WHERE (b.AbreiseDatum >= @AnreiseDatum 
			OR b.AnreiseDatum <= @AbreiseDatum) 
			AND b.Storno = FALSE
            AND b.BuchungId = zb.BuchungId
		)
	LIMIT 1);
    
-- Zimmerbelegung    
SET @NeueZimmerBelegungId = (SELECT max(ZimmerBelegungId) + 1 FROM ZimmerBelegung);
INSERT INTO ZimmerBelegung (ZimmerBelegungId, ZimmerId, BuchungId)
	VALUES (@NeueZimmerBelegungId, @FreiesZimmer, @NeueBuchungId);
	
/* 	
	Beispiel 2:
    Standard-Buchung eines Kunden ohne Registrierung 
    Einzelzimmer
*/

-- Person erstellen
SET @NeuePersonId = (SELECT max(PersonId) + 1 FROM Person);
-- oder eine Nummer wie 1099
INSERT INTO Person (PersonId, Vorname, Nachname, Sprache, Geschlecht)
	VALUES (@NeuePersonId, "Harry", "Hasler", "DE", "m");

-- Kunde erstellen
SET @NeueKundeId = (SELECT max(KundeId) + 1 FROM Kunde);
-- oder eine Nummer wie 3599
INSERT INTO Kunde (KundeId, PersonId)
	VALUES (@NeueKundeId, @NeuePersonId);

-- Buchung erstellen
SET @NeueBuchungId = (SELECT max(BuchungId) + 1 FROM Buchung);
SET @AnreiseDatum = "2017-08-01";
SET @AbreiseDatum = "2017-08-07";
-- oder eine Nummer wie 7099
INSERT INTO Buchung (BuchungId, KundeId, AnreiseDatum, AbreiseDatum, Bemerkung)
	VALUES (@NeueBuchungId, @NeueKundeId, @AnreiseDatum, @AbreiseDatum, "Auch dies ist ein Test");

-- das erste aller freien Zimmer mit entsprechendem Platz
SET @FreiesZimmer = (SELECT z.ZimmerId FROM Zimmer z
	LEFT OUTER JOIN ZimmerBelegung zb ON zb.ZimmerId = z.ZimmerId
	JOIN ZimmerTyp zt ON z.ZimmerTypId = zt.ZimmerTypId 
    JOIN BettenTyp bt ON zt.BettenTypId = bt.BettenTypId -- JOIN
	WHERE AnzahlPersonen = 1 -- richtige Anzahl Betten
    AND NOT EXISTS (
		SELECT BuchungId FROM Buchung b
			WHERE (b.AbreiseDatum >= @AnreiseDatum 
			OR b.AnreiseDatum <= @AbreiseDatum)
			AND b.Storno = FALSE
            AND b.BuchungId = zb.BuchungId
		)
	LIMIT 1);
    
-- Zimmerbelegung    
SET @NeueZimmerBelegungId = (SELECT max(ZimmerBelegungId) + 1 FROM ZimmerBelegung);
INSERT INTO ZimmerBelegung (ZimmerBelegungId, ZimmerId, BuchungId)
	VALUES (@NeueZimmerBelegungId, @FreiesZimmer, @NeueBuchungId);
	
