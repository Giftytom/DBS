/**
Hotelverwaltung DDL
Authors: Thomas André, Sergio Rupena, Samuel Hopf, Marco Akeret
**/

-- First, drop the schmea if it already exists
DROP SCHEMA IF EXISTS hotel;

-- -- Create schema 'hotel' acc. to requirements
CREATE SCHEMA hotel DEFAULT CHARACTER SET 'utf8';

-- -- 'Use hotel'
USE hotel;

CREATE TABLE `Titel` (
  `TitelId` INT NOT NULL,
  `Bezeichnung` VARCHAR(30),
  PRIMARY KEY (`TitelId`)
);

CREATE TABLE `Person` (
  `PersonId` INT,
  `TitelId` INT NULL,
  `Vorname` VARCHAR(32) NULL,
  `Nachname` VARCHAR(32),
  `Sprache` VARCHAR(32) NULL,
  `Geschlecht` ENUM('m', 'f') NULL,
  `Geburtsdatum` DATE NULL,
  PRIMARY KEY (`PersonId`),
  FOREIGN KEY (`TitelId`) REFERENCES Titel(TitelId) 
);

CREATE TABLE `TelefonTyp` (
  `TelefonTypId` INT,
  `Beschreibung` VARCHAR(32),
  PRIMARY KEY (`TelefonTypId`)
);

CREATE TABLE `Mitarbeiter` (
  `MitarbeiterId` INT,
  `PersonId` INT,
  `SVNummer` VARCHAR(13),
  `AHVNummer` VARCHAR(11) NULL,
  PRIMARY KEY (`MitarbeiterId`),
  FOREIGN KEY (`PersonId`) REFERENCES Person(PersonId)
);

CREATE TABLE `AnsprechPerson` (
  `AnsprechPersonId` INT,
  `PersonId` INT,
  PRIMARY KEY (`AnsprechPersonId`),
  FOREIGN KEY (`PersonId`) REFERENCES Person(PersonId)
);

CREATE TABLE `Firma` (
  `FirmaId` INT,
  `FirmenName` VARCHAR(32),
  PRIMARY KEY (`FirmaId`)
);

CREATE TABLE `GeschaeftsPartner` (
  `GeschaeftsPartnerId` INT,
  `FirmaId` INT,
  PRIMARY KEY (`GeschaeftsPartnerId`),
  FOREIGN KEY (`FirmaId`) REFERENCES Firma(FirmaId)
);

CREATE TABLE `Telefon` (
  `TelefonId` VARCHAR(32),
  `PersonId` INT NULL,
  `FirmaId` INT NULL,
  `TelefonTypId` INT,
  `Nummer` VARCHAR(32),
  PRIMARY KEY (`TelefonId`),
  FOREIGN KEY (`TelefonTypId`) REFERENCES TelefonTyp(TelefonTypId),
  FOREIGN KEY (`FirmaId`) REFERENCES Firma(FirmaId),
  FOREIGN KEY (`PersonId`) REFERENCES Person(PersonId));

CREATE TABLE `Email` (
  `EmailId` INT,
  `EmailAdressse` VARCHAR(32),
  `PersonId` INT NULL,
  `FirmaId` INT NULL,
  PRIMARY KEY (`EmailId`),
  KEY `UK` (`EmailAdressse`),
  FOREIGN KEY (`PersonId`) REFERENCES Person(PersonId),
  FOREIGN KEY (`FirmaId`) REFERENCES Firma(FirmaId)
);

CREATE TABLE `Land` (
  `LandId` INT,
  `LandName` VARCHAR(32),
  PRIMARY KEY (`LandId`)
);

CREATE TABLE `Ort` (
  `OrtId` INT,
  `OrtName` VARCHAR(30),
  `PLZ` VARCHAR(30),
  `LandId` INT,
  PRIMARY KEY (`OrtId`),
  FOREIGN KEY (`LandId`) REFERENCES Land(LandId)
);

CREATE TABLE `Privatkunde` (
  `KundeId` INT,
  PRIMARY KEY (`KundeId`)
);

CREATE TABLE `Kunde` (
  `KundenId` INT,
  `PersonId` INT,
  PRIMARY KEY (`KundenId`),
  FOREIGN KEY (`PersonId`) REFERENCES Person(PersonId)
);

CREATE TABLE `Reiseunternehmen` (
  `ReiseunternehmenId` INT,
  `FirmaId` INT,
  `AnsprechpersonId` INT,
  PRIMARY KEY (`ReiseunternehmenId`),
  FOREIGN KEY (`FirmaId`) REFERENCES Firma(FirmaId),
  FOREIGN KEY (`AnsprechpersonId`) REFERENCES Person(PersonId)
);

CREATE TABLE `BuchungAnfrage` (
  `BuchungAnfrageId` INT,
  `ReiseunternehmenId` INT,
  `AnreiseDatum` DATE,
  `AbreiseDatum` DATE,
  `AnzahlPersonen` INT,
  `AnfrageDatum` DATE,
  `NachfrageGetaetigt` BOOLEAN,
  PRIMARY KEY (`BuchungAnfrageId`),
  FOREIGN KEY (`ReiseunternehmenId`) REFERENCES Reiseunternehmen(ReiseunternehmenId)
);

CREATE TABLE `GeschaeftsKunde` (
  `GeschaeftsKundeId` INT,
  `GeschaeftsPartnerId` INT,
  PRIMARY KEY (`GeschaeftsKundeId`),
  FOREIGN KEY (`GeschaeftsPartnerId`) REFERENCES GeschaeftsPartner(GeschaeftsPartnerId)
);

CREATE TABLE `BettenTyp` (
  `BettenTypId` INT,
  `AnzahlPersonen` INT,
  `Bezeichnung` VARCHAR(32),
  PRIMARY KEY (`BettenTypId`)
);

CREATE TABLE `ZimmerTyp` (
  `ZimmerTypId` INT,
  `BettenTypId` INT,
  `Bezeichnung` VARCHAR(32),
  `Bad` BOOLEAN,
  `Whirlpool` BOOLEAN,
  `Minibar` BOOLEAN,
  PRIMARY KEY (`ZimmerTypId`),
  FOREIGN KEY (`BettenTypId`) REFERENCES BettenTyp(BettenTypId)
);

CREATE TABLE `Trakt` (
  `TraktId` INT,
  `TraktName` VARCHAR(32),
  PRIMARY KEY (`TraktId`)
);

CREATE TABLE `Zimmer` (
  `ZimmerId` INT,
  `ZimmerTypId` INT,
  `TraktId` INT,
  `Stockwerk` INT,
  `Alpenblick` BOOLEAN,
  PRIMARY KEY (`ZimmerId`),
  FOREIGN KEY (`ZimmerTypId`) REFERENCES ZimmerTyp(ZimmerTypId),
  FOREIGN KEY (`TraktId`) REFERENCES Trakt(TraktId)
);

CREATE TABLE `ZimmerBelegungPerson` (
  `ZimmerBelegungId` INT,
  `PersonId` INT,
  PRIMARY KEY (`ZimmerBelegungId`, `PersonId`),
  FOREIGN KEY (`PersonId`) REFERENCES Person(PersonId)
);

CREATE TABLE `OnlineBuchung` (
  `OnlineBuchungId` INT,
  `Vorname` VARCHAR(32),
  `Nachname` VARCHAR(32),
  `EMail` VARCHAR(32),
  PRIMARY KEY (`OnlineBuchungId`)
);

CREATE TABLE `Adresse` (
  `AdresseId` INT,
  `AdressZeile1` VARCHAR(32) NULL,
  `AdressZeile2` VARCHAR(32) NULL,
  `AdressZeile3` VARCHAR(32) NULL,
  `OrtId` INT,
  `PersonId` INT NULL,
  `FirmaId` INT NULL,
  PRIMARY KEY (`AdresseId`),
  FOREIGN KEY (`PersonId`) REFERENCES Person(PersonId),
  FOREIGN KEY (`FirmaId`) REFERENCES Firma(FirmaId),
  FOREIGN KEY (`OrtId`) REFERENCES Ort(OrtId)
);

CREATE TABLE `Buchung` (
  `BuchungId` INT,
  `KundenId` INT NULL,
  `ReiseunternehmenId` INT NULL,
  `BuchungAnfrageId` INT NULL,
  `OnlineBuchungId` INT NULL,
  `Kreditkarte` VARCHAR(32) NULL,
  `AnreiseDatum` DATE,
  `AbreiseDatum` DATE,
  PRIMARY KEY (`BuchungId`),
  FOREIGN KEY (`KundenId`) REFERENCES Kunde(KundenId),
  FOREIGN KEY (`ReiseunternehmenId`) REFERENCES Reiseunternehmen(ReiseunternehmenId),
  FOREIGN KEY (`BuchungAnfrageId`) REFERENCES BuchungAnfrage(BuchungAnfrageId),
  FOREIGN KEY (`OnlineBuchungId`) REFERENCES OnlineBuchung(OnlineBuchungId)
);

CREATE TABLE `ZimmerBelegung` (
  `ZimmerBelegungId` INT,
  `ZimmerId` INT,
  `BuchungId` INT,
  PRIMARY KEY (`ZimmerBelegungId`),
  FOREIGN KEY (`ZimmerId`) REFERENCES Zimmer(ZimmerId),
  FOREIGN KEY (`BuchungId`) REFERENCES Buchung(BuchungId)
);
