-- Reiseunternehmen (sofern noch nicht vorhanden - iD nicht nötig, nur für Verständnis)
INSERT INTO Land (LandName) VALUES ('Schweiz');
INSERT INTO ORT (OrtName, LandId, PLZ) VALUES ('Zürich', (SELECT LandId FROM Land WHERE LandName = 'Schweiz'), '9022');
INSERT INTO Adresse (AdressZeile1, OrtId) VALUES('Bahnhofstrasse 28', (SELECT OrtId FROM Ort WHERE OrtName = 'Zürich' AND PLZ = '9022'));
INSERT INTO Firma (AdresseId, FirmaName) VALUES (
			SELECT AdresseId FROM Adresse WHERE AdressZeile1 = 'Bahnhofstrasse 28' 
				AND OrtId = (SELECT OrtId FROM Ort WHERE OrtName = 'Zürich' AND PLZ = '9022'), 'Muster AG');
-- ReiseunternehmenId nur zum TEst hier fix gesetzt, normalerweise wird es automatisch hochgesetzt
INSERT INTO Reiseunternehmen (ReiseunternehmenId, FirmaId, UnternehmenName) VALUES(42,(SELECT distinct(FirmaName) FROM Firma WHERE FirmaName = 'Muster AG'),
		 'Muster AG');
-- bekommt iD 42



-- Personen PersonId muss normalerweise nicht gesetzt werden, wird automatisch hochgezählt, nur für Erlöärung in weiteren Inserts
INSERT INTO Person (PersonId, Vorname, Nachname, Geschlecht) VALUES (4 ,'Ferdinand', 'Meier', 'm');
INSERT INTO Person (PersonId, Vorname, Nachname, Geschlecht) VALUES (5, 'Max', 'Keller', 'm');
INSERT INTO Person (PersonId, Vorname, Nachname, Geschlecht) VALUES (6, 'A.', 'Meier', 'w');
INSERT INTO Person (PersonId Nachname, Geschlecht) VALUES (7, 'Keller', 'w');

-- Yamada Travel hat schon eine iD, muss nicht nochmal hinzugefügt werden
INSERT INTO Land (Landname) VALUES('Japan');
INSERT INTO ORT (OrtName, PLZ, LandId) VALUES ('Tokyo', '135-0063', (SELECT LandId FROM Land WHERE LandName = 'Japan'));
INSERT INTO Adresse (AdressZeile1, AdressZeile2, OrtId) VALUES('Tokyo-BigSight', '3-16-8 Ariake Koto',  
				 (SELECT OrtId FROM Ort WHERE OrtName = 'Tokyo' AND PLZ = '135-0063'));
INSERT INTO Firma (AdresseId, FirmaName) VALUES (
			(SELECT AdresseId FROM Adresse WHERE AdressZeile1 = 'Tokyo-BigSight' AND AdressZeile2 = '3-16-8 Ariake Koto'
				AND OrtId = (SELECT OrtId FROM Ort WHERE OrtName = 'Tokyo' AND PLZ = '135-0063')),
				 'Yamada Travel');
INSERT INTO Reiseunternehmen (ReiseunternehmenId, FirmaId, UnternehmenName) VALUES (123456, (SELECT distinct(FirmaName) FROM Firma WHERE FirmaName = 'Yamada Travel'),
				'Yamada Travel');


-- Buchung und Anfrage aus Aufgabe 1 und 2 ins ERM

-- Buchung Muster AG
INSERT INTO Buchung (ReiseunternehmenId, AnreiseDatum, AbreiseDatum) VALUES(42, 2017-08-12, 2017-08-19);

SET @BuchungId = SELECT BuchungId
		FROM Buchung
		WHERE ReiseunternehmenId = 42
		AND AnreiseDatum = 2017-08-12
		AND AbreiseDatum = 2017-08-19
);
		
INSERT INTO ZimmerBelegung (ZimmerId, BuchungId) VALUES (
	(SELECT distinct(ZimmerId) 
		FROM Zimmer
		WHERE Alpenblick = 1
		AND ZimmerTypId = (
			SELECT distinct(ZimmerTypId) 
				FROM ZimmerTyp
				WHERE BettenTypId = (
					SELECT distinct(BettenTypId) 
						FROM BettenTyp
						WHERE AnzahlPersonen = 2
						)
				)
		),  @BuchungId);


INSERT INTO ZimmerBelegungPerson (ZimmerBelegungId, PersonId) VALUES(
		(SELECT distinct(ZimmerBelegungId)
			FROM Zimmerbelegung
			WHERE BuchungId = @BuchungId
	), PersonId = 4);

INSERT INTO ZimmerBelegungPerson (ZimmerBelegungId, PersonId) VALUES (
		(SELECT distinct(ZimmerBelegungId)
			FROM Zimmerbelegung
			WHERE BuchungId = @BuchungId
	), PersonId = 6);

-- Und jetzt die 2. Buchung mit 2 Einzelzimmern, alle Zimmer sind Nichtraucher

INSERT INTO Buchung (ReiseunternehmenId, AnreiseDatum, AbreiseDatum) VALUES(42, 2017-08-15, 2017-08-22);
SET @BuchungId = SELECT BuchungId
		FROM Buchung
		WHERE ReiseunternehmenId = 42
		AND AnreiseDatum = 2017-08-12
		AND AbreiseDatum = 2017-08-19
);

INSERT INTO ZimmerBelegung (ZimmerId, BuchungId) VALUES (
	(SELECT distinct(ZimmerId) 
		FROM Zimmer
		WHERE Alpenblick = 1
		AND ZimmerTypId = (
			SELECT distinct(ZimmerTypId) 
				FROM ZimmerTyp
				WHERE BettenTypId = (
					SELECT distinct(BettenTypId) 
						FROM BettenTyp
						WHERE AnzahlPersonen = 1
						)
				)
		) @BuchungId);

INSERT INTO ZimmerBelegung (ZimmerId, BuchungId) VALUES (
	(SELECT distinct(ZimmerId) 
		FROM Zimmer
		WHERE Alpenblick = 1
		AND ZimmerTypId = (
			SELECT distinct(ZimmerTypId) 
				FROM ZimmerTyp
				WHERE BettenTypId = (
					SELECT distinct(BettenTypId) 
						FROM BettenTyp
						WHERE AnzahlPersonen = 1
						)
				)
		), @BuchungId);


-- bekommt eines von den beiden Zimmern
INSERT INTO ZimmerBelegungPerson (ZimmerBelegungId, PersonId) VALUES (
		(SELECT distinct(ZimmerBelegungId)
			FROM Zimmerbelegung
			WHERE BuchungId = @BuchungId
	), 5);

-- bekommt das freie Zimmer
INSERT INTO ZimmerBelegungPerson (ZimmerBelegungId, PersonId) VALUES (
		(SELECT distinct(ZimmerBelegungId)
			FROM Zimmerbelegung
			WHERE BuchungId = @BuchungId
			AND ZimmerBelegungId NOT IN (
				SELECT ZimmerBelegungId 
					FROM ZimmerBelegungPerson
					)
	), 7);


-- Anfrage Yamada
INSERT INTO BuchungAnfrage (ReiseunternehmenId, AnreiseDatum, AbreiseDatum, AnzahlPersonen, AnfrageDatum, NachfrageGetaetigt) VALUES (
	 (SELECT distinct(ReiseunternehmenId) FROM Reiseunternehmen WHERE UnternehmenName = 'Yamada Travel'),
		2017-05-12, 2017-05-19, 12, CURDATE(), 0);

INSERT INTO BuchungAnfrage (ReiseunternehmenId, AnreiseDatum, AbreiseDatum, AnzahlPersonen, AnfrageDatum, NachfrageGetaetigt) VALUES ( 
 	(SELECT FROM Reiseunternehmen WHERE UnternehmenName = 'Yamada Travel'),
		2017-05-15, 2017-05-22, 16, CURDATE(), 0);				
