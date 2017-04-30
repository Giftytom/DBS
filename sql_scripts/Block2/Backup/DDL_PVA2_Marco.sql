/**
Hotelverwaltung DDL
Authors: Thomas André, Sergio Rupena, Samuel Hopf, Marco Akeret
**/

-- First, drop the schmea if it already exists
DROP SCHEMA IF EXISTS Hotelverwaltung;

-- Create schema 'Hotelverwaltung'
CREATE SCHEMA Hotelverwaltung DEFAULT CHARACTER SET 'utf8';

-- 'Use Hotelverwaltung'
USE Hotelverwaltung;

CREATE TABLE Land (
	LandId INT NOT NULL,
    LandName VARCHAR(100),
    CONSTRAINT PKLandId PRIMARY KEY(LandId)
);

CREATE TABLE Ort (
	OrtId INT NOT NULL,
    LandId INT NOT NULL,
    OrtName VARCHAR(255) NOT NULL,
    PLZ VARCHAR(20) NOT NULL,
    CONSTRAINT PKOrtId PRIMARY KEY(OrtId),
    CONSTRAINT FKOrtLandId FOREIGN KEY (LandId) REFERENCES Land(LandId)
);

CREATE TABLE AdressTyp (
	AdressTypId INT NOT NULL,
    AdressTypName VARCHAR(12),
    CONSTRAINT PKAdressTypId PRIMARY KEY(AdressTypId)
);

CREATE TABLE TelefonTyp (
	TelefonTypId INT NOT NULL,
    TelefonTypName VARCHAR(12),
    CONSTRAINT PKTelefonTypId PRIMARY KEY(TelefonTypId)
);

CREATE TABLE Titel (
	TitelId INT NOT NULL,
    Bezeichnung VARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT PKTitelId PRIMARY KEY(TitelId)
);

CREATE TABLE Person (
	PersonId INT NOT NULL,
    TitelId INT,
    Vorname VARCHAR(150),
    Nachname VARCHAR(150) NOT NULL,
    Sprache VARCHAR(4),
    Geschlecht ENUM('m', 'f'),
    Geburtsdatum DATE,
    CONSTRAINT PKPersonId PRIMARY KEY(PersonId),
    CONSTRAINT FKPersonTitelId FOREIGN KEY(TitelId) REFERENCES Titel(TitelId)
);

CREATE TABLE Firma (
	FirmaId INT NOT NULL,
    FirmenName VARCHAR(255),
    CONSTRAINT PKFirmaId PRIMARY KEY(FirmaId)
);


CREATE TABLE Adresse (
	AdresseId INT NOT NULL,
    AdressTypId INT NOT NULL,
    PersonId INT,
    FirmaId INT,
    AdressZeile1 VARCHAR(255),
    AdressZeile2 VARCHAR(255),
    AdressZeile3 VARCHAR(255),
    OrtId INT,
    CONSTRAINT PKAdresseId PRIMARY KEY(AdresseId),
    CONSTRAINT FKAdressePersonId FOREIGN KEY (PersonId) REFERENCES Person(PersonId),
    CONSTRAINT FKAdresseOrtId FOREIGN KEY (OrtId) REFERENCES Ort(OrtId),
    CONSTRAINT FKAdresseFirmaId FOREIGN KEY (FirmaId) REFERENCES Firma(FirmaId),
    CONSTRAINT FKAdresseAdressTypId FOREIGN KEY (AdressTypId) REFERENCES AdressTyp(AdressTypId)
);

CREATE TABLE AnsprechPerson (
	AnsprechPersonId INT NOT NULL,
    PersonId INT NOT NULL,
    CONSTRAINT PKAnsprechPersonId PRIMARY KEY(AnsprechPersonId),
    CONSTRAINT FKAnsprechPersonPersonId FOREIGN KEY(PersonId) REFERENCES Person(PersonId)
);

CREATE TABLE Reiseunternehmen (
	ReiseunternehmenId INT NOT NULL,
    FirmaId INT NOT NULL,
    AnsprechPersonId INT NOT NULL,
    CONSTRAINT PKReiseunternehmenId PRIMARY KEY(ReiseunternehmenId),
    CONSTRAINT FKReiseunternehmenFirmaId FOREIGN KEY(FirmaId) REFERENCES Firma(FirmaId),
    CONSTRAINT FKReiseunternehmenAnsprechPersonId FOREIGN KEY(AnsprechPersonId) REFERENCES AnsprechPerson(AnsprechPersonId)
);

CREATE TABLE EMail (
	EmailId INT NOT NULL,
    EMailAdresse VARCHAR(255) NOT NULL UNIQUE,
    PersonId INT,
    FirmaId INT,
    CONSTRAINT PKEmailId PRIMARY KEY(EmailId),
    CONSTRAINT FKEMailPersonId FOREIGN KEY (PersonId) REFERENCES Person(PersonId),
    CONSTRAINT FKEMailFirmaId FOREIGN KEY (FirmaId) REFERENCES Firma(FirmaId)
);

CREATE TABLE Telefon (
	TelefonId INT NOT NULL,
    PersonId INT,
    FirmaId INT,
    TelefonTypId INT NOT NULL,
    TelefonNummer VARCHAR(255),
    CONSTRAINT PKTelefonId PRIMARY KEY(TelefonId),
    CONSTRAINT FKTelefonPersonId FOREIGN KEY (PersonId) REFERENCES Person(PersonId),
    CONSTRAINT FKTelefonFirmaId FOREIGN KEY (FirmaId) REFERENCES Firma(FirmaId),
    CONSTRAINT FKTelefonTypId FOREIGN KEY (TelefonTypId) REFERENCES TelefonTyp(TelefonTypId)
);


CREATE TABLE Mitarbeiter (
	MitarbeiterId INT NOT NULL,
    PersonId INT NOT NULL,
    SVNummer BIGINT NOT NULL,
    AHVNummer INT, 
    CONSTRAINT PKMitarbeiterId PRIMARY KEY(MitarbeiterId),
    CONSTRAINT FKMitarbeiterPersonId FOREIGN KEY(PersonId) REFERENCES Person(PersonId)
);


CREATE TABLE Kunde (
	KundenId INT NOT NULL,
    PersonId INT NOT NULL,
    CONSTRAINT PKKundenId PRIMARY KEY(KundenId),
    CONSTRAINT FKKundePersonId FOREIGN KEY(PersonId) REFERENCES Person(PersonId)
);

CREATE TABLE PrivatKunde (
	KundeId INT NOT NULL,
    CONSTRAINT PKKundeId PRIMARY KEY(KundeId)
);

CREATE TABLE GeschaeftsPartner (
	GeschaeftsPartnerId INT NOT NULL,
    FirmaId INT NOT NULL,
    CONSTRAINT PKGeschaeftsPartnerId PRIMARY KEY(GeschaeftsPartnerId),
    CONSTRAINT FKGeschaeftsPartnerFirmaId FOREIGN KEY(FirmaId) REFERENCES Firma(FirmaId)
);

CREATE TABLE GeschaeftsKunde (
	GeschaeftsKundeId INT NOT NULL,
    GeschaeftsPartnerId INT NOT NULL,
    CONSTRAINT PKGeschaeftsKundeId PRIMARY KEY(GeschaeftsKundeId),
    CONSTRAINT FKGeschaeftsKundeGeschaeftsPartnerId FOREIGN KEY(GeschaeftsPartnerId) REFERENCES GeschaeftsPartner(GeschaeftsPartnerId)
);

CREATE TABLE BettenTyp (
	BettenTypId INT NOT NULL,
    AnzahlPersonen INT NOT NULL,
    Bezeichnung VARCHAR(255),
    CONSTRAINT PKBettenTypId PRIMARY KEY(BettenTypId)
);

CREATE TABLE ZimmerTyp (
	ZimmerTypId INT NOT NULL,
    BettenTypId INT NOT NULL,
    Bezeichnung VARCHAR(255),
    Bad BOOLEAN,
    Whirlpool BOOLEAN,
    Minibar BOOLEAN,
    CONSTRAINT PKZimmerTypId PRIMARY KEY(ZimmerTypId),
    CONSTRAINT FKZimmerTypBettenTypId FOREIGN KEY(BettenTypId) REFERENCES BettenTyp(BettenTypId)
);

CREATE TABLE Trakt (
	TraktId INT NOT NULL,
    TraktName VARCHAR(255),
    CONSTRAINT PKTraktId PRIMARY KEY(TraktId)
);

CREATE TABLE Zimmer (
	ZimmerId INT NOT NULL,
    ZimmerTypId INT NOT NULL,
    TraktId INT NOT NULL,
    Stockwerk INT NOT NULL,
    Alpenblick BOOLEAN,
    CONSTRAINT PKZimmerId PRIMARY KEY(ZimmerId),
    CONSTRAINT FKZimmerZimmerTypId FOREIGN KEY(ZimmerTypId) REFERENCES ZimmerTyp(ZimmerTypId)
);

CREATE TABLE OnlineBuchung (
	OnlineBuchungId INT NOT NULL,
    Vorname VARCHAR(100) NOT NULL,
    Nachname VARCHAR(100) NOT NULL,
    EMail VARCHAR(150) NOT NULL,
    CONSTRAINT PKOnlineBuchungId PRIMARY KEY(OnlineBuchungId)
);

CREATE TABLE BuchungAnfrage (
	BuchungAnfrageId INT NOT NULL,
    ReiseunternehmenId INT NOT NULL,
    AnreiseDatum DATE NOT NULL,
    AbreiseDatum DATE NOT NULL,
    AnzahlPersonen INT NOT NULL,
    AnfrageDatum DATE NOT NULL,
    NachfrageGetaetigt BOOLEAN,
    Reisegruppe VARCHAR(50),
    CONSTRAINT PKBuchungAnfrageId PRIMARY KEY(BuchungAnfrageId),
    CONSTRAINT FKBuchungAnfrageReiseunternehmenId FOREIGN KEY (ReiseunternehmenId) REFERENCES Reiseunternehmen(ReiseunternehmenId)
);

CREATE TABLE Buchung (
	BuchungId INT NOT NULL,
    KundenId INT,
    ReiseunternehmenId INT,
    BuchungAnfrageId INT,
    OnlineBuchungId INT,
    Kreditkarte VARCHAR(50),
    AnreiseDatum DATE NOT NULL,
    AbreiseDatum DATE NOT NULL,
    CONSTRAINT PKBuchungId PRIMARY KEY(BuchungId),
    CONSTRAINT FKBuchungKundenId FOREIGN KEY (KundenId) REFERENCES Kunde(KundenId),
    CONSTRAINT FKBuchungReiseunternehmenId FOREIGN KEY (ReiseunternehmenId) REFERENCES Reiseunternehmen(ReiseunternehmenId),
    CONSTRAINT FKBuchungBuchungAnfrageId FOREIGN KEY (BuchungAnfrageId) REFERENCES BuchungAnfrage(BuchungAnfrageId),
    CONSTRAINT FKBuchungOnlineBuchungId FOREIGN KEY (OnlineBuchungId) REFERENCES OnlineBuchung(OnlineBuchungId)
);


CREATE TABLE ZimmerBelegung (
	ZimmerBelegungId INT NOT NULL,
    ZimmerId INT NOT NULL,
    BuchungId INT NOT NULL,
    CONSTRAINT PKZimmerBelegungId PRIMARY KEY(ZimmerBelegungId),
    CONSTRAINT FKZimmerBelegungZimmerId FOREIGN KEY(ZimmerId) REFERENCES Zimmer(ZimmerId),
    CONSTRAINT FKZimmerBelegungBuchungId FOREIGN KEY(BuchungId) REFERENCES Buchung(BuchungId)
);
    

CREATE TABLE ZimmerBelegungPerson (
	ZimmerBelegungId INT NOT NULL,
    PersonId INT NOT NULL,
    CONSTRAINT PKZimmerBelegungId PRIMARY KEY(ZimmerBelegungId, PersonId),
    CONSTRAINT FKZimmerBelegungPersonPersonId FOREIGN KEY (PersonId) REFERENCES Person (PersonId)
);