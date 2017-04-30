/**
* Hotelverwaltung DML
* PVA 2 - Marco Akeret
**/

-- Datenbank wählen
USE Hotelverwaltung;

-- Delete all Data
DELETE FROM Adresse;
DELETE FROM AdressTyp;
DELETE FROM BuchungAnfrage;
DELETE FROM EMail;
DELETE FROM GeschaeftsKunde;
DELETE FROM GeschaeftsPartner;
DELETE FROM Mitarbeiter;
DELETE FROM Ort;
DELETE FROM PrivatKunde;
DELETE FROM Telefon;
DELETE FROM TelefonTyp;
DELETE FROM Trakt;
DELETE FROM ZimmerBelegung;
DELETE FROM ZimmerBelegungPerson;
DELETE FROM Land;
DELETE FROM Buchung;
DELETE FROM Reiseunternehmen;
DELETE FROM AnsprechPerson;
DELETE FROM Kunde;
DELETE FROM OnlineBuchung;
DELETE FROM Firma;
DELETE FROM Person;
DELETE FROM Titel;
DELETE FROM Zimmer;
DELETE FROM ZimmerTyp;
DELETE FROM BettenTyp;

-- Titel erfassen
INSERT INTO Titel VALUES (1, "Prof.");
INSERT INTO Titel VALUES (2, "Dr.");
INSERT INTO Titel VALUES (3, "Prof. Dr.");

-- AdressTypen erfassen
INSERT INTO AdressTyp VALUES (1, "Geschäftlich");
INSERT INTO AdressTyp VALUES (2, "Privat");

-- Telefontypen
INSERT INTO TelefonTyp VALUES (1, "Privat");
INSERT INTO TelefonTyp VALUES (2, "Geschäftlich");
INSERT INTO TelefonTyp VALUES (3, "Mobil");

-- Trakte erfassen
INSERT INTO Trakt VALUES (1, "Hauptgebäude");
INSERT INTO Trakt VALUES (2, "Anbau");
INSERT INTO Trakt VALUES (3, "Chalet");

-- Bettentypen erfassen
INSERT INTO BettenTyp VALUES (1, 1, "Einzelbett");
INSERT INTO BettenTyp VALUES (2, 2, "Doppelbett");
INSERT INTO BettenTyp VALUES (3, 10, "Massenschlag");

-- Zimmertypen erfassen
INSERT INTO ZimmerTyp VALUES (1, 1, "Suite EZ", TRUE, TRUE, TRUE);
INSERT INTO ZimmerTyp VALUES (2, 2, "Suite DZ", TRUE, TRUE, TRUE);
INSERT INTO ZimmerTyp VALUES (3, 3, "Massenschlag", FALSE, FALSE, FALSE);
INSERT INTO ZimmerTyp VALUES (4, 1, "Standard-EZ", TRUE, FALSE, TRUE);
INSERT INTO ZimmerTyp VALUES (5, 2, "Standard-DZ", TRUE, FALSE, TRUE);

-- Zimmer erfassen
INSERT INTO Zimmer VALUES (1, 1, 3, 0, TRUE);
INSERT INTO Zimmer VALUES (2, 2, 3, 0, TRUE);
INSERT INTO Zimmer VALUES (3, 3, 1, 1, FALSE);
INSERT INTO Zimmer VALUES (4, 4, 2, 1, TRUE);
INSERT INTO Zimmer Values (5, 5, 2, 1, TRUE);

-- Länder erfassen
INSERT INTO Land VALUES (1, "Schweiz");
INSERT INTO Land VALUES (2, "Deutschland");
INSERT INTO Land VALUES (3, "Österreich");
INSERT INTO Land VALUES (4, "USA");
INSERT INTO Land VALUES (5, "Japan");

INSERT INTO Ort VALUES (1, 1, "St. Gallen", 9000);
INSERT INTO Ort VALUES (2, 1, "Zürich", 8000);
INSERT INTO Ort VALUES (3, 2, "München", 80331);
INSERT INTO Ort VALUES (4, 3, "Wien", 1005);
INSERT INTO Ort VALUES (5, 4, "New York", 10001);
INSERT INTO Ort VALUES (6, 1, "Zürich", 8022);
INSERT INTO Ort VALUES (7, 5, "Tokyo", "135-0063");

-- Stammdaten für Firma erfassen
INSERT INTO Firma VALUES (1, "Traumreisen AG");
INSERT INTO Firma VALUES (2, "DeineReise.ch");
INSERT INTO Firma VALUES (3, "MakeYourOwnTravel.com");
INSERT INTO Firma VALUES (4, "Yamanda Travel");
INSERT INTO Firma VALUES (5, "Müller AG");
INSERT INTO Firma VALUES (6, "Starview AG");
INSERT INTO Firma VALUES (7, "Muster AG");

-- Personen erfassen
INSERT INTO Person VALUES (1, 3, "Hans", "Meier", "de", "m", "1970-03-24");
INSERT INTO Person VALUES (2, NULL, "Margrith", "Meier", "de", "f", "1971-02-26");
INSERT INTO Person VALUES (3, 2, "Tim", "Müller", NULL, "m", "1969-01-15");
INSERT INTO Person VALUES (4, NULL, "Svenja", "Rickli", "fr", "f", "1985-09-23"); 
INSERT INTO Person VALUES (5, NULL, "Maximilian", "Brunner", "de", "m", "1973-08-09");
INSERT INTO Person VALUES (6, NULL, "Aurelia", "Meier", "de", "f", "1987-11-21");
INSERT INTO Person VALUES (7, NULL, "Toshi", "Nakanura", "en", "m", "1972-08-01");
INSERT INTO Person VALUES (8, NULL, "Max", "Keller", "de", "m", "1969-04-05");
INSERT INTO Person VALUES (9, NULL, "Janine", "Keller", "de", "f", "1970-08-03");
INSERT INTO Person VALUES (10, NULL, "F.", "Hasler", "de", "m", NULL);
INSERT INTO Person VALUES (11, 1, "Ferdiand", "Meier", NULL, "m", NULL);
INSERT INTO Person VALUES (12, 2, "A.", "Meier", NULL, "f", NULL);
INSERT INTO Person VALUES (13, NULL, "Max", "Keller", NULL, "m", NULL);
INSERT INTO Person VALUES (14, NULL, "Hans", "Einstein", NULL, "m", "1987-03-19");
INSERT INTO Person VALUES (15, NULL, "Violetta", "Frick", NULL, "f", "1977-06-12");
INSERT INTO Person VALUES (16, NULL, "Bernd", "Haag", NULL, "m", "1978-07-03");

-- Ansprechpersonen anlegen
INSERT INTO AnsprechPerson VALUES (1, 7);
INSERT INTO AnsprechPerson VALUES (2, 5);
INSERT INTO AnsprechPerson VALUES (3, 10);

-- Stammdaten für Reiseunternehmen
INSERT INTO Reiseunternehmen VALUES (1, 4, 1);
INSERT INTO Reiseunternehmen VALUES (2, 3, 2);
INSERT INTO Reiseunternehmen VALUES (3, 7, 3);

-- Telefone erfassen
INSERT INTO Telefon VALUES (1, 7, 4, 2, "+31 07 9382 038 00");
INSERT INTO Telefon VALUES (2, 8, NULL, 3, "+41 79 123 00 43");
INSERT INTO Telefon VALUES (3, NULL, 1, 2, "+41 44 234 00 32");

-- EMail-Adressen erfassen
INSERT INTO EMail VALUES (1, "hans.meier@starview.ch", 1, 6);
INSERT INTO EMail VALUES (2, "margrith.meier@starview.ch", 2, 6);
INSERT INTO EMail VALUES (3, "aureilia.meier@starview.ch", 6, 6);
INSERT INTO EMail VALUES (4, "max.keller@muellerag.ch", 8, NULL);
INSERT INTO EMail VALUES (5, "janine.keller@muellerag.ch", 9, NULL);

-- Mitarbeiter anlegen
INSERT INTO Mitarbeiter VALUES (1, 1, "123456789", "756020202");
INSERT INTO Mitarbeiter VALUES (2, 2, "456788903", "756133943");
INSERT INTO Mitarbeiter VALUES (3, 6, "345234345", "756090929");
INSERT INTO Mitarbeiter VALUES (4, 14, "356634743", "756040595");
INSERT INTO Mitarbeiter VALUES (5, 15, "056464554", "756029393");
INSERT INTO Mitarbeiter VALUES (6, 16, "043422234", "756009433");

-- Kunden anlegen
INSERT INTO Kunde VALUES (1, 3);
INSERT INTO Kunde VALUES (2, 4);
INSERT INTO Kunde VALUES (3, 5);
INSERT INTO Kunde VALUES (4, 7);
INSERT INTO Kunde VALUES (5, 8);
INSERT INTO Kunde VALUES (6, 9);

-- Privatkunden anlegen
INSERT INTO PrivatKunde VALUES (8);
INSERT INTO PrivatKunde VALUES (9);

-- Online Buchung Anlegen
INSERT INTO OnlineBuchung VALUES (1, "Hanspeter", "Fässler", "hansfaes@hotmail.com");
INSERT INTO OnlineBuchung VALUES (2, "Peter", "Eugster", "peter.eugster@bluewin.ch");
INSERT INTO OnlineBuchung VALUES (3, "Paul", "Brühwiler", "paul@brühwiler.ch");

-- Adressen anlegen
INSERT INTO Adresse VALUES (1, 2, 3, NULL, "Bahnhofstrasse 11", NULL, NULL, 1);
INSERT INTO Adresse VALUES (2, 1, NULL, 5, "Müllerstrasse 10", "Postfach", NULL, 2);
INSERT INTO Adresse VALUES (3, 1, 4, 5, "Müllerstrasse 12", "Abt. AX", "Büro 1", 2);
INSERT INTO Adresse VALUES (4, 1, 5, 5, "Müllerstrasse 12", "Abt. AY", "Büro 3", 2);
INSERT INTO Adresse VALUES (5, 1, NULL, 4, "Tokyo-Big-Sight", "3-16-8 Ariake Koto", NULL, 7);

-- Buchungsanfragen anlegen
INSERT INTO BuchungAnfrage VALUES (1, 1, "2017-10-11", "2017-10-18", 10, "2017-03-29", FALSE, NULL);
INSERT INTO BuchungAnfrage VALUES (2, 3, "2017-05-12", "2017-05-19", 8, "2017-01-01", TRUE, "Watanabe");
INSERT INTO BuchungAnfrage VALUES (3, 3, "2017-05-12", "2017-05-22", 10, "2017-01-01", TRUE, "Sekiguchi");

-- Geschäftspartner erfassen
INSERT INTO GeschaeftsPartner VALUES (1, 5);

 -- Geschäftskunde erfassen
INSERT INTO GeschaeftsKunde VALUES (5, 1);
INSERT INTO GeschaeftsKunde VALUES (6, 1);

-- Buchungen erfassen
INSERT INTO Buchung VALUES (1, 1, NULL, NULL, NULL, "2435246245745", "2017-09-10", "2017-09-17");
INSERT INTO Buchung VALUES (2, NULL, NULL, NULL, 1, NULL, "2017-08-10", "2017-08-17");
INSERT INTO Buchung VALUES (3, NULL, NULL, NULL, 2, NULL, "2017-03-09", "2017-03-16");
INSERT INTO Buchung VALUES (4, NULL, NULL, NULL, 3, NULL, "2017-04-01", "2017-04-08");
INSERT INTO Buchung VALUES (5, 5, 1, NULL, NULL, "458458913451345", "2017-05-03", "2017-06-21");
INSERT INTO Buchung VALUES (6, NULL, NULL, NULL, NULL, NULL, "2017-11-10", "2017-11-11");
INSERT INTO Buchung VALUES (7, NULL, 3, NULL, NULL, NULL, "2017-08-12", "2017-08-19");
INSERT INTO Buchung VALUES (8, NULL, 3, NULL, NULL, NULL, "2017-08-15", "2017-08-22");

-- Zimmerbelegung erfassen
INSERT INTO ZimmerBelegung VALUES (1, 1, 1);
INSERT INTO ZimmerBelegung VALUES (2, 1, 1);
INSERT INTO ZimmerBelegung VALUES (3, 4, 6);
INSERT INTO ZimmerBelegung VALUES (4, 4, 6);
INSERT INTO ZimmerBelegung VALUES (5, 2, 7);
INSERT INTO ZimmerBelegung VALUES (6, 5, 8);

-- ZimmerbelegungPerson erfassen
INSERT INTO ZimmerBelegungPerson VALUES (1, 3);
INSERT INTO ZimmerBelegungPerson VALUES (2, 5);
INSERT INTO ZimmerBelegungPerson VALUES (3, 8);
INSERT INTO ZimmerBelegungPerson VALUES (4, 9); 
INSERT INTO ZimmerBelegungPerson VALUES (5, 11);
INSERT INTO ZimmerBelegungPerson VALUES (5, 12);
INSERT INTO ZimmerBelegungPerson VALUES (6, 13);
