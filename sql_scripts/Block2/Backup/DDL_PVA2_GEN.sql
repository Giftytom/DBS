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

insert into Titel values (1, 'Professor');
insert into Titel values (2, 'Doktor');
insert into Titel values (3, 'Dipl.Ing.');

CREATE TABLE `Ort` (
  `OrtId` NUMBER,
  `OrtName` VARCHAR,
  `PLZ` VARCHAR,
  `LandId` NUMBER,
  PRIMARY KEY (`OrtId`),
  KEY `FK` (`LandId`)
);

CREATE TABLE `Mitarbeiter` (
  `MitarbeiterId` NUMBER,
  `PersonId` NUMBER,
  `SVNummer` NUMBER(13),
  `AHVNummer` NUMBER(11) NULL,
  PRIMARY KEY (`MitarbeiterId`),
  KEY `FK` (`PersonId`)
);

CREATE TABLE `Kunde` (
  `KundenId` NUMBER,
  `PersonId` NUMBER,
  PRIMARY KEY (`KundenId`),
  KEY `FK` (`PersonId`)
);

CREATE TABLE `Privatkunde` (
  `KundeId` NUMBER,
  PRIMARY KEY (`KundeId`)
);

CREATE TABLE `Reiseunternehmen` (
  `ReiseunternehmenId` NUMBER,
  `FirmaId` NUMBER,
  `Ansprechperson` NUMBER,
  PRIMARY KEY (`ReiseunternehmenId`),
  KEY `FK` (`FirmaId`, `Ansprechperson`)
);

CREATE TABLE `BuchungAnfrage` (
  `BuchungAnfrageId` NUMBER,
  `ReiseunternehmenId` NUMBER,
  `AnreiseDatum` DATE,
  `AbreiseDatum` DATE,
  `AnzahlPersonen` NUMBER,
  `AnfrageDatum` DATE,
  `NachfrageGetaetigt` BOOLEAN,
  PRIMARY KEY (`BuchungAnfrageId`),
  KEY `FK` (`ReiseunternehmenId`)
);

CREATE TABLE `GeschaeftsKunde` (
  `GeschaeftsKundeId` NUMBER,
  `GeschaeftsPartnerId` NUMBER,
  PRIMARY KEY (`GeschaeftsKundeId`),
  KEY `FK` (`GeschaeftsPartnerId`)
);

CREATE TABLE `ZimmerBelegungPerson` (
  `ZimmerBelegungId` NUMBER,
  `PersonId` NUMBER,
  PRIMARY KEY (`ZimmerBelegungId`, `PersonId`)
);

CREATE TABLE `ZimmerTyp` (
  `ZimmerTypId` NUMBER,
  `BettenTypId` NUMBER,
  `Bezeichnung` VARCHAR,
  `Bad` BOOLEAN,
  `Whirlpool` BOOLEAN,
  `Minibar` BOOLEAN,
  PRIMARY KEY (`ZimmerTypId`),
  KEY `FK` (`BettenTypId`)
);

CREATE TABLE `ZimmerBelegung` (
  `ZimmerBelegungId` NUMBER,
  `ZimmerId` NUMBER,
  `BuchungId` NUMBER,
  PRIMARY KEY (`ZimmerBelegungId`),
  KEY `FK` (`ZimmerId`, `BuchungId`)
);

CREATE TABLE `Telefon` (
  `TelefonId` NUMBER,
  `PersonId` NUMBER NULL,
  `FirmaId` NUMBER NULL,
  `TelefonTypId` NUMBER,
  `Nummer` VARCHAR,
  PRIMARY KEY (`TelefonId`),
  KEY `FK` (`PersonId`, `FirmaId`, `TelefonTypId`)
);

CREATE TABLE `OnlineBuchung` (
  `OnlineBuchungId` NUMBER,
  `Vorname` VARCHAR,
  `Nachname` VARCHAR,
  `EMail` VARCHAR,
  PRIMARY KEY (`OnlineBuchungId`)
);

CREATE TABLE `AnsprechPerson` (
  `AnsprechPersonId` NUMBER,
  `PersonId` NUMBER,
  PRIMARY KEY (`AnsprechPersonId`),
  KEY `FK` (`PersonId`)
);

CREATE TABLE `Firma` (
  `FirmaId` NUMBER,
  `FirmenName` VARCHAR,
  PRIMARY KEY (`FirmaId`)
);

CREATE TABLE `Zimmer` (
  `ZimmerId` NUMBER,
  `ZimmerTypId` NUMBER,
  `TraktId` NUMBER,
  `Stockwerk` NUMBER,
  `Alpenblick` BOOLEAN,
  PRIMARY KEY (`ZimmerId`),
  KEY `FK` (`ZimmerTypId`, `TraktId`)
);

CREATE TABLE `Email` (
  `EmailId` NUMBER,
  `EmailAdressse` VARCHAR,
  `PersonId` NUMBER NULL,
  `FirmaId` NUMBER NULL,
  PRIMARY KEY (`EmailId`),
  KEY `UK` (`EmailAdressse`),
  KEY `FK` (`PersonId`, `FirmaId`)
);

CREATE TABLE `Land` (
  `LandId` NUMBER,
  `LandName` VARCHAR,
  PRIMARY KEY (`LandId`)
);

CREATE TABLE `TelefonTyp` (
  `TelefonTypId` NUMBER,
  `Beschreibung` VARCHAR,
  PRIMARY KEY (`TelefonTypId`)
);

CREATE TABLE `Adresse` (
  `AdresseId` NUMBER,
  `AdressZeile1` VARCHAR NULL,
  `AdressZeile2` VARCHAR NULL,
  `AdressZeile3` VARCHAR NULL,
  `OrtId` NUMBER,
  `PersonId` NUMBER NULL,
  `FirmaId` NUMBER NULL,
  PRIMARY KEY (`AdresseId`),
  KEY `FK` (`OrtId`, `PersonId`, `FirmaId`)
);

CREATE TABLE `Person` (
  `PersonId` NUMBER,
  `TitelId` NUMBER NULL,
  `Vorname` VARCHAR NULL,
  `Nachname` VARCHAR,
  `Sprache` VARCHAR NULL,
  `Geschlecht` ENUM NULL,
  `Geburtsdatum` DATE NULL,
  PRIMARY KEY (`PersonId`),
  KEY `FK` (`TitelId`)
);

CREATE TABLE `GeschaeftsPartner` (
  `GeschaeftsPartnerId` NUMBER,
  `FirmaId` NUMBER,
  PRIMARY KEY (`GeschaeftsPartnerId`),
  KEY `FK` (`FirmaId`)
);

CREATE TABLE `Buchung` (
  `BuchungId` NUMBER,
  `KundenId` NUMBER NULL,
  `ReiseunternehmenId` NUMBER NULL,
  `BuchungAnfrageId` NUMBER NULL,
  `OnlineBuchungId` NUMBER NULL,
  `Kreditkarte` VARCHAR NULL,
  `AnreiseDatum` DATE,
  `AbreiseDatum` DATE,
  PRIMARY KEY (`BuchungId`),
  KEY `FK` (`KundenId`, `ReiseunternehmenId`, `BuchungAnfrageId`, `OnlineBuchungId`)
);

CREATE TABLE `BettenTyp` (
  `BettenTypId` NUMBER,
  `AnzahlPersonen` NUMBER,
  `Bezeichnung` VARCHAR,
  PRIMARY KEY (`BettenTypId`)
);

CREATE TABLE `Trakt` (
  `TraktId` NUMBER,
  `TraktName` VARCHAR,
  PRIMARY KEY (`TraktId`)
);

