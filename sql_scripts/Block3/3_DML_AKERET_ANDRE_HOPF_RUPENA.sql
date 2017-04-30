/**
Hotelverwaltung DML
Authors: Thomas André, Sergio Rupena, Samuel Hopf, Marco Akeret
**/

USE hotel;

/* Einige Tabellen lassen sich wegen der Fremdschlüssel nicht mittels TRUNCATE löschen.
   Umgehungslösungen wie DELETE ohne Klausel sind nicht ideal, deshalb sollte das Schema 
   vor der Ausführung dieses Scripts unbedingt neu erstellt werden!
*/

/* PERSONENVERWALTUNG - BASIS */
-- Titel
INSERT INTO Titel (TitelId, Bezeichnung)
-- Beispiele aus den Normalisierungen (Aufgaben)
	VALUES (9020, "Prof."),
		   (9021, "Dr."),
           (9022, "Prof. Dr.");
           
-- Person
-- Eigene Beispiele
INSERT INTO Person (PersonId, Vorname, Nachname, Sprache, Geburtsdatum) 
	VALUES (1000, "Samuel", "Hopf", "DE", "1978-07-05"),
           (1001, "Marco", "Akeret", "DE", NULL),
           (1002, "Sergio", "Rupena", "IT", NULL),
           (1003, "Thomas", "Andre", NULL, NULL);
INSERT INTO Person (PersonId, TitelId, Vorname, Nachname, Sprache, Geschlecht, Geburtsdatum) 
	VALUES (1004, 9022, "Hans", "Meier", "de", "m", "1970-03-24"),
           (1005, NULL, "Margrith", "Meier", "de", "f", "1971-02-26"),
           (1006, 9021, "Tim", "Müller", NULL, "m", "1969-01-15"),
           (1007, NULL, "Svenja", "Rickli", "fr", "f", "1985-09-23"),
           (1008, NULL, "Maximilian", "Brunner", "de", "m", "1973-08-09"),
		   (1009, NULL, "Klara", "Brunner", "de", "f", "1973-08-12"),
           (1010, NULL, "Aurelia", "Meier", "de", "f", "1987-11-21"),
           (1011, NULL, "Max", "Keller", "de", "m", "1969-04-05"),
           (1012, NULL, "Janine", "Keller", "de", "f", "1970-08-03"),
           (1013, NULL, "Hans", "Einstein", NULL, "m", "1987-03-19"),
           (1014, NULL, "Violetta", "Frick", NULL, "f", "1977-06-12"),
           (1015, NULL, "Bernd", "Haag", NULL, "m", "1978-07-03");
-- Beispiele aus den Normalisierungen (Aufgaben)
INSERT INTO Person (PersonId, Vorname, Nachname, Geburtsdatum) -- Kunden
	VALUES (1020, "John", "Miller", "1973-05-12"),
           (1021, "Verena", "Huber", "1976-06-24"),
           (1022, "Hans-Ludwig", "Schmidt", "1965-07-19");
INSERT INTO Person (PersonId, TitelId, Vorname, Nachname, Geschlecht) -- Kunden
	VALUES (1023, 9020, "Karin", "Heim", "m"),
           (1024, NULL, "Ferdinand", "Meier", "m"),
           (1025, 9021, "A.", "Meiner", "f"),
           (1026, NULL, NULL, "Keller", "f"),
           (1031, NULL, "Luzius", "Starview", "m");
INSERT INTO Person (PersonId, Vorname, Nachname) -- Ansprechpersonen
	VALUES (1027, "Toshi", "Nakanura"),
           (1028, "F.", "Hasler");

-- Beispiel PVA 3
INSERT INTO Person (PersonId, Vorname, Nachname, Geburtsdatum, Sprache, Geschlecht)
	VALUES (1029, "Hans", "Muster", "1950-05-12", "en", "m"),
		   (1030, "Lotti", "Hauser", "1965-02-11", "en", "f");

/* FIRMEN UND BUSINESSKUNDEN */
-- Firma
INSERT INTO Firma (FirmaId, FirmenName)
-- Eigene Beispiele
	VALUES (3000, "Traumreisen AG"),
           (3001, "DeineReise.ch"),
           (3002, "MakeYourOwnTravel.com"),
           (3004, "Müller AG"),
           (3005, "Starview AG"),
           (3006, "Muster AG"),
           (3007, "AbInDenUrlaub"),
           (3008, "Swoodoo"),
-- Beispiele aus den Normalisierungen (Aufgaben)
           (3020, "Yamanda Travel");
           
           
-- Ansprechpersonen
-- Eigene Beispiele
INSERT INTO AnsprechPerson (AnsprechPersonId, PersonId)
	VALUES (3100, 1011),
-- Beispiele aus den Normalisierungen (Aufgaben)
		   (3120, 1027),
           (3121, 1028);

-- Reiseunternehmen 
-- Eigene Beispiele
INSERT INTO Reiseunternehmen (ReiseunternehmenId, FirmaId, AnsprechPersonId)
    VALUES (3200, 3006, 3121),
		   (3201, 3002, 3100),
-- Beispiele aus den Normalisierungen (Aufgaben)
           (3220, 3020, 3120);

-- Business Partner
-- Eigene Beispiele
INSERT INTO GeschaeftsPartner (GeschaeftsPartnerId, FirmaId)
	VALUES (3300, 3004);

/* PERSONENDATEN - KONTAKT */
-- Mitarbeiter des Hotels
-- Eigene Beispiele
INSERT INTO Mitarbeiter (MitarbeiterId, PersonId, AHVNummer, SVNummer)
	VALUES (3400, 1004, "123456789", "756020202"), 
           (3402, 1005, "456788903", "756133943"),
           (3403, 1010, "345234345", "756090929"),
           (3404, 1013, "356634743", "756040595"),
           (3405, 1014, "056464554", "756029393"),
           (3406, 1015, "043422234", "756009433"),
           (3407, 1003, NULL, "24905670");

-- Kunden des Hotels
-- Eigene Beispiele
INSERT INTO Kunde (KundeId, PersonId)
	VALUES (3500, 1003),
           (3501, 1004),
           (3503, 1005),
           (3504, 1007),
           (3505, 1008),
           (3506, 1009),
           (3507, 1009),
           (3508, 1000);
-- Beispiele PVA 3
INSERT INTO Kunde (KundeId, PersonId)
	VALUES
           (3509, 1029),
           (3510, 1030);


-- Kunden über Businesspartner
-- Eigene Beispiele
INSERT INTO GeschaeftsKunde (GeschaeftsKundeId, GeschaeftsPartnerId)
	VALUES (3506, 3300),
           (3507, 3300);


/* KONTAKTDATEN - EMAIL */
-- Email Adressen

INSERT INTO EMail(EMailId, EMailAdresse, PersonId, FirmaId)
	VALUES (9600, "hans.meier@starview.ch", 1004, 3005),
           (9601, "margrith.meier@starview.ch", 1010, 3005),
           (9602, "aureilia.meier@starview.ch", 1004, 3005),
           (9603, "max.keller@muellerag.ch", 1011, NULL),
           (9604, "janine.keller@muellerag.ch", 1012, NULL),
           (9605, "thomas.andre@students.ffhs.ch", 1003, NULL),
           (9607, "example@example.org", 1003, NULL);

-- Beispiele PVA 3
INSERT INTO EMail(EMailId, EMailAdresse, PersonId)
    VALUES (9608, "hans.muster@schnellweb.ch", 1029),
           (9609, "lotti@bigapple.ch", 1030);

/* KONTAKTDATEN - TELEFON */
-- Telefontyp
INSERT INTO TelefonTyp (TelefonTypId, TelefonTypName)

	VALUES (9300, "Mobil"),
-- Beispiele aus den Normalisierungen (Aufgaben)
           (9320, "Privat"),
		   (9321, "Geschäftlich");

-- Telefonnummern

INSERT INTO Telefon (TelefonId, PersonId, FirmaId, TelefonTypId, TelefonNummer)
	VALUES (9500, 1027, NULL, 9300, "+41 79 123 00 43"),
-- Beispiele aus den Normalisierungen (Aufgaben)
           (9501, NULL, 3004, 9321, "+41 44 234 00 32"),
		   (9502, 1027, 3020, 9321, "+31 07 9382 038 00");
           
/* KONTAKTDATEN - ADRESSE */
-- Land
-- Eigene Beispiele
INSERT INTO Land (LandId, LandName)
	VALUES (9100, "Italien"),
		   (9101, "Frankreich"),
           (9102, "Österreich"),
           (9103, "Lichtenstein"),
           (9104, "USA"),
-- Beispiele aus den Normalisierungen (Aufgaben)
		   (9120, "Grossbritannien"),
		   (9121, "Schweiz"),
           (9122, "Deutschland"),
           (9123, "Japan");

-- Ort
INSERT INTO Ort (OrtId, LandId, OrtName, PLZ)
	VALUES (9200, 9121, "Thalwil", "8800"),
           (9201, 9121, "Zürich", "8000"),
           (9202, 9121, "Luzern", "6004"),
           (9203, 9121, "St. Gallen", "9000"),
           (9204, 9104, "New York", "10001"),
           (9205, 9102, "Wien", "1005"),
           (9206, 9122, "München", "80331"),
           (9207, 9121, "Kestenholz", "4703"),
-- Beispiele aus den Normalisierungen (Aufgaben)
		   (9221, 9123, "Tokyo", "35-0063"),
           (9222, 9121, "Zürich", "8022"),
		   (9223, 9120, "London", "SW1H 0QW"),
           (9224, 9122, "Frankfurt/Main", "60284"),
		   (9225, 9122, "Frankfurt/Main", "60639"),
		   (9226, 9121, "Zollikofen", "3052");

-- Adresstyp
INSERT INTO AdressTyp(AdressTypId, AdressTypName)
	VALUES (9400, "Geschäftlich"),
		   (9401, "Privat");

-- Adresse
-- Eigene Beispiele
INSERT INTO Adresse (AdresseId, AdressTypId, PersonId, FirmaId, AdressZeile1, AdressZeile2, AdressZeile3, OrtId)
	VALUES (9700, 9401, 1005, NULL, "Bahnhofstrasse 11", NULL, NULL, 9203),
           (9701, 9400, NULL, 3004, "Müllerstrasse 10", "Postfach", NULL, 9201),
           (9702, 9400, 1006, 3004, "Müllerstrasse 12", "Abt. AX", "Büro 1", 9201),
           (9703, 9400, 1007, 3004, "Müllerstrasse 12", "Abt. AY", "Büro 3", 9201),
           (9704, 9401, 1000, NULL, "Rainstrasse 365", NULL, NULL, 9207),
           (9705, 9400, NULL, 3002, "Poststrasse 18", NULL, NULL, 9203),
-- Beispiele aus den Normalisierungen (Aufgaben)
		   (9706, 9400, NULL, 3020, "Tokyo-Big-Sight", "3-16-8 Ariake Koto", NULL, 9221),
		   (9707, 9401, 1021, NULL, "Mörbacher-Landstrasse 712", NULL, NULL, 9224),
		   (9708, 9400, 1021, NULL, "Lyoner Strasse 18", NULL, NULL, 9225),
           (9709, 9400, NULL, 3006, "Bahnhofstrasse 28", NULL, NULL, 9222);

-- Beispiel PVA 3
-- INSERT INTO Adresse (9710, 9401, 1029, "")

/* ZIMMERVERALTUNG*/
-- Bettentyp
INSERT INTO BettenTyp(BettenTypId, AnzahlPersonen, Bezeichnung)
	-- eigene Beispiele
	VALUES (4000, 2, "Doppel Queensize"),
           (4001, 2, "Doppel Kingsize"),
           (4002, 2, "Himmelbett"),
           (4003, 10, "Massenschlag"),
    -- aus den Anforderungen
           (4020, 2, "Kingsize"),
           (4021, 2, "Doppel Standardbett"),
           (4022, 1, "Standardbett"),
		   (4023, 2, "Queensize");

-- Trakt in dem sich das Zimmer befindet
INSERT INTO Trakt (TraktId, Name)
    -- aus den Anforderungen
	VALUES (4220, "Haupttrakt"),
           (4221, "Dépendence"),
           (4222, "Chalet");

-- Zimmertyp
INSERT INTO ZimmerTyp(ZimmerTypId, BettenTypId, Bezeichnung, Bad, Whirlpool, Minibar)
	-- eigene Beispiele
	VALUES (4100, 4003, "Massenschlag", FALSE, FALSE, FALSE),
    -- aus den Anforderungen
	       (4120, 4020, "Hochzeit-Suite", TRUE, TRUE, TRUE),
		   (4121, 4023, "Blauer Salon", FALSE, TRUE, TRUE),
           (4122, 4022, "Standard Einzelzimmer", FALSE, FALSE, FALSE),
           (4123, 4022, "Standard Einzelzimmer Plus", TRUE, FALSE, TRUE),
           (4124, 4021, "Standard Doppelzimmer", FALSE, FALSE, FALSE),
           (4125, 4021, "Standard Doppelzimmer Plus", TRUE, FALSE, TRUE),
           (4126, 4023, "Deluxe Doppelzimmer", FALSE, FALSE, FALSE),
           (4127, 4023, "Deluxe Doppelzimmer Plus", TRUE, FALSE, TRUE);


-- Zimmer
INSERT INTO Zimmer(ZimmerId, ZimmerTypId, TraktId, Stockwerk, Alpenblick, ZimmerNummer)
    -- aus den Anforderungen
    VALUES (4920, 4120, 4220, 2, TRUE, 201),
           (4921, 4121, 4220, 1, FALSE, 101),
		   (4922, 4122, 4220, 0, FALSE, 1),
           (4923, 4123, 4220, 1, FALSE, 102),
           (4924, 4124, 4220, 1, TRUE, 103),
           (4925, 4125, 4220, 0, TRUE, 2),
           (4926, 4126, 4220, 2, TRUE, 202),
           (4927, 4127, 4220, 2, FALSE, 203),
           (4928, 4100, 4221, 3, FALSE, 3001),
           (4930, 4125, 4220, 1, FALSE, 104);

/* BUCHUNGEN, ANFRAGEN UND CHECK-IN */
-- Online Buchungen
-- Eigene Beispiele
INSERT INTO OnlineBuchung (OnlineBuchungId, Vorname, Nachname, EMail) 
	VALUES (6000, "Hanspeter", "Fässler", "hansfaes@hotmail.com"),
           (6001, "Peter", "Eugster", "peter.eugster@bluewin.ch"),
           (6002, "Paul", "Brühwiler", "paul@brühwiler.ch");

-- Anfragen von Reiseunternehmen
-- Eigene Beispiele
INSERT INTO BuchungAnfrage (BuchungAnfrageId, ReiseunternehmenId, AnreiseDatum, AbreiseDatum, AnzahlPersonen, AnfrageDatum, NachfrageGetaetigt, Reisegruppe)
	VALUES (6100, 3201, "2017-10-11", "2017-10-18", 10, "2017-03-29", FALSE, NULL),
-- Beispiele aus den Normalisierungen (Aufgaben)
		   (6120, 3220, "2017-05-12", "2017-05-19", 8, "2017-01-01", TRUE, "Watanabe");

-- Beispiel mit Kommentar
INSERT INTO BuchungAnfrage (BuchungAnfrageId, ReiseunternehmenId, AnreiseDatum, AbreiseDatum, AnzahlPersonen, AnfrageDatum, NachfrageGetaetigt, Reisegruppe, Bemerkung)
    VALUES (6121, 3220, "2017-05-12", "2017-05-22", 10, "2017-01-01", TRUE, "Sekiguchi", "1 babybed please");

-- Buchungen
-- Eigene Beispiele
INSERT INTO Buchung (BuchungId, KundeId, ReiseunternehmenId, BuchungAnfrageId, OnlineBuchungId, Kreditkarte, AnreiseDatum, AbreiseDatum)
	VALUES (7000, 3500, NULL, NULL, NULL, "2435246245745", "2017-09-10", "2017-09-17"),
           (7001, NULL, NULL, NULL, 6000, NULL, "2017-08-10", "2017-08-17"),
           (7002, 3504, 3200, NULL, NULL, "458458913451345", "2017-05-03", "2017-06-21"),
           (7003, NULL, NULL, NULL, NULL, NULL, "2017-11-10", "2017-11-11"),
-- Beispiele aus den Normalisierungen (Aufgaben)
		   (7020, NULL, NULL, 6120, NULL, NULL, "2017-03-09", "2017-03-16"),
           (7021, NULL, NULL, 6121, NULL, NULL, "2017-04-01", "2017-04-08");
-- Beispiele mit Bemerkungen
INSERT INTO Buchung (BuchungId, KundeId, ReiseunternehmenId, BuchungAnfrageId, OnlineBuchungId, Kreditkarte, AnreiseDatum, AbreiseDatum, Bemerkung) 
    VALUES (7004, NULL, 3220, NULL, NULL, NULL, "2017-08-12", "2017-08-19", "Bergsicht"),
           (7005, NULL, 3220, NULL, NULL, NULL, "2017-08-15", "2017-08-22", "Nichtraucher Einzelzimmer");


-- Zimmerbelegung beim Check-In
-- Eigene Beispiele
INSERT INTO ZimmerBelegung (ZimmerBelegungId, ZimmerId, BuchungId)
	VALUES (6200, 4920, 7000),
           (6201, 4920, 7000),
           (6202, 4923, 7020),
           (6203, 4923, 7021),
           (6204, 4921, 7005),
           (6205, 4924, 7005);
    
-- Zimmerbelegungen
-- Eigene Beispiele
INSERT INTO ZimmerBelegungPerson (ZimmerBelegungId, PersonId)
	VALUES (6200, 1002),
           (6201, 1004),
           (6201, 1005),
           (6202, 1007),
           (6203, 1010),
           (6204, 1011),
           (6205, 1012);

