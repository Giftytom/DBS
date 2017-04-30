/**
Hotelverwaltung DDL
Authors: Thomas André, Sergio Rupena, Samuel Hopf, Marco Akeret
**/

/* SCHEMA ERSTELLEN */
-- Schema löschen und wiederherstellen, Schema-Name 'hotel' gemäss Anforderungen
DROP SCHEMA IF EXISTS hotel;
CREATE SCHEMA hotel DEFAULT CHARACTER SET 'utf8';

-- Erstelltes Schema verwenden
USE hotel;

/* PERSONENVERWALTUNG - BASIS */
-- Titel für die Ansprache
CREATE TABLE Titel (
	TitelId INT NOT NULL,
    Bezeichnung VARCHAR(20),
    CONSTRAINT PKTitelId PRIMARY KEY(TitelId)
);

-- Person (Container für eindeutige Personensdaten)
CREATE TABLE Person (
	PersonId INT NOT NULL,
    Vorname VARCHAR(255), -- Vorname darf gemäss den Normalisierungen NULL sein
    Nachname VARCHAR(255) NOT NULL,
    Sprache CHAR(2),
    Geburtsdatum DATE,
    TitelId INT, -- gemäss Normalisierungen
    Geschlecht ENUM('m','f'), -- gemäss Normalisierungen
    CONSTRAINT PKPersonId PRIMARY KEY(PersonId),
    CONSTRAINT FKPersonTitelId FOREIGN KEY(TitelId) REFERENCES Titel(TitelId)
);

/* FIRMEN UND BUSINESSKUNDEN */
-- Firma
CREATE TABLE Firma (
	FirmaId INT NOT NULL,
    FirmenName VARCHAR(255),
    CONSTRAINT PKFirmaId PRIMARY KEY(FirmaId)
);

-- Ansprechperson beim Reisunternehmen
CREATE TABLE AnsprechPerson (
	AnsprechPersonId INT NOT NULL,
    PersonId INT NOT NULL,
    CONSTRAINT PKAnsprechPersonId PRIMARY KEY(AnsprechPersonId),
    CONSTRAINT FKAnsprechPersonPersonId FOREIGN KEY(PersonId) REFERENCES Person(PersonId)
);

-- Reiseunternehmen 
CREATE TABLE Reiseunternehmen (
	ReiseunternehmenId INT NOT NULL,
    FirmaId INT NOT NULL,
    AnsprechPersonId INT NOT NULL,
    CONSTRAINT PKReiseunternehmenId PRIMARY KEY(ReiseunternehmenId),
    CONSTRAINT FKReiseunternehmenFirmaId FOREIGN KEY(FirmaId) REFERENCES Firma(FirmaId),
    CONSTRAINT FKReiseunternehmenAnsprechPersonId FOREIGN KEY(AnsprechPersonId) REFERENCES AnsprechPerson(AnsprechPersonId)
);

-- Business Partner
CREATE TABLE GeschaeftsPartner (
	GeschaeftsPartnerId INT NOT NULL,
    FirmaId INT NOT NULL,
    CONSTRAINT PKGeschaeftsPartnerId PRIMARY KEY(GeschaeftsPartnerId),
    CONSTRAINT FKGeschaeftsPartnerFirmaId FOREIGN KEY(FirmaId) REFERENCES Firma(FirmaId)
);

/* PERSONENDATEN - KONTAKT */
-- Mitarbeiter des Hotels
CREATE TABLE Mitarbeiter (
	MitarbeiterId INT NOT NULL,
    PersonId INT NOT NULL,
    SVNummer BIGINT NOT NULL,
    AHVNummer INT, 
    CONSTRAINT PKMitarbeiterId PRIMARY KEY(MitarbeiterId),
    CONSTRAINT FKMitarbeiterPersonId FOREIGN KEY(PersonId) REFERENCES Person(PersonId)
);

-- Kunden des Hotels (Supertyp)
CREATE TABLE Kunde (
	KundeId INT NOT NULL,
    PersonId INT NOT NULL, 
    CONSTRAINT PKKundeId PRIMARY KEY(KundeId),
    CONSTRAINT FKKundePersonId FOREIGN KEY(PersonId) REFERENCES Person(PersonId)
);

-- Kunden über Businesspartner
CREATE TABLE GeschaeftsKunde (
	GeschaeftsKundeId INT NOT NULL,
    GeschaeftsPartnerId INT NOT NULL,
    CONSTRAINT PKGeschaeftsKundeId PRIMARY KEY(GeschaeftsKundeId),
    CONSTRAINT FKGeschaeftsKundeGeschaeftsPartnerId FOREIGN KEY(GeschaeftsPartnerId) REFERENCES GeschaeftsPartner(GeschaeftsPartnerId),
	CONSTRAINT PKGeschaeftsKundeIdKundeId FOREIGN KEY(GeschaeftsKundeId) REFERENCES Kunde(KundeId) -- Subtyp
);

/* KONTAKTDATEN - EMAIL */
-- Email Adressen
CREATE TABLE EMail (
	EmailId INT NOT NULL,
    EMailAdresse VARCHAR(255) NOT NULL UNIQUE,
    PersonId INT,
    FirmaId INT,
    CONSTRAINT PKEmailId PRIMARY KEY(EmailId),
    CONSTRAINT FKEMailPersonId FOREIGN KEY (PersonId) REFERENCES Person(PersonId),
    CONSTRAINT FKEMailFirmaId FOREIGN KEY (FirmaId) REFERENCES Firma(FirmaId)
);

/* KONTAKTDATEN - TELEFON */
-- Telefontyp
CREATE TABLE TelefonTyp (
	TelefonTypId INT NOT NULL,
    TelefonTypName VARCHAR(12),
    CONSTRAINT PKTelefonTypId PRIMARY KEY(TelefonTypId)
);

-- Telefonnummern
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

/* KONTAKTDATEN - ADRESSE */
-- Land
CREATE TABLE Land (
	LandId INT NOT NULL,
    LandName VARCHAR(100),
    CONSTRAINT PKLandId PRIMARY KEY(LandId)
);

-- Ort
CREATE TABLE Ort (
	OrtId INT NOT NULL,
    LandId INT NOT NULL,
    OrtName VARCHAR(255) NOT NULL,
    PLZ VARCHAR(20) NOT NULL,
    CONSTRAINT PKOrtId PRIMARY KEY(OrtId),
    CONSTRAINT FKOrtLandId FOREIGN KEY (LandId) REFERENCES Land(LandId)
);

-- Adresstyp
CREATE TABLE AdressTyp (
	AdressTypId INT NOT NULL,
    AdressTypName VARCHAR(12),
    CONSTRAINT PKAdressTypId PRIMARY KEY(AdressTypId)
);

-- Adresse
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

/* ZIMMERVERALTUNG*/
-- Bettentyp
CREATE TABLE BettenTyp (
	BettenTypId INT NOT NULL,
	AnzahlPersonen INT NOT NULL,
	Bezeichnung VARCHAR(255) NOT NULL,
	CONSTRAINT PKBettenTypId PRIMARY KEY(BettenTypId)
);

-- Trakt in dem sich das Zimmer befindet
CREATE TABLE Trakt (
	TraktId INT NOT NULL,
	Name VARCHAR(255) NOT NULL,
	CONSTRAINT PKTraktId PRIMARY KEY(TraktId)
);

-- Verschieden Zimmertypen
CREATE TABLE ZimmerTyp (
	ZimmerTypId INT NOT NULL,
	BettenTypId INT NOT NULL,
	Bezeichnung VARCHAR(255) NOT NULL,
	Bad BOOLEAN DEFAULT FALSE,
	Whirlpool BOOLEAN DEFAULT FALSE,
	Minibar BOOLEAN DEFAULT FALSE,
	CONSTRAINT PKZimmerTypId PRIMARY KEY(ZimmerTypId),
	CONSTRAINT FKZimmerTypBettenTyp FOREIGN KEY (BettenTypId) REFERENCES BettenTyp(BettenTypId)
);

-- Zimmer
CREATE TABLE Zimmer (
	ZimmerId INT NOT NULL,
	ZimmerTypId INT NOT NULL,
    ZimmerNummer INT NOT NULL UNIQUE,
	TraktId INT NOT NULL,
	Stockwerk INT NOT NULL,
	Alpenblick BOOLEAN DEFAULT TRUE,
	CONSTRAINT PKZimmerId PRIMARY KEY(ZimmerId),
	CONSTRAINT FKZimmerZimmerTyp FOREIGN KEY (ZimmerTypId) REFERENCES ZimmerTyp(ZimmerTypId),
    CONSTRAINT FKZimmerTraktId FOREIGN KEY (TraktId) REFERENCES Trakt(TraktId)
);

/* BUCHUNGEN, ANFRAGEN UND CHECK-IN */
-- Online Buchungen
CREATE TABLE OnlineBuchung (
	OnlineBuchungId INT NOT NULL,
	Vorname VARCHAR(255) NOT NULL,
	Nachname VARCHAR(255) NOT NULL,
	EMail VARCHAR(255) NOT NULL,
	CONSTRAINT PKOnlineBuchungId PRIMARY KEY(OnlineBuchungId)
);

-- Anfragen von Reiseunternehmen
CREATE TABLE BuchungAnfrage (
	BuchungAnfrageId INT NOT NULL,
    ReiseunternehmenId INT NOT NULL,
    AnreiseDatum DATE NOT NULL,
    AbreiseDatum DATE NOT NULL,
    AnzahlPersonen INT NOT NULL,
    AnfrageDatum DATE NOT NULL,
    NachfrageGetaetigt BOOLEAN,
    Reisegruppe VARCHAR(50),
    Bemerkung TEXT,
    CONSTRAINT PKBuchungAnfrageId PRIMARY KEY(BuchungAnfrageId),
    CONSTRAINT FKBuchungAnfrageReiseunternehmenId FOREIGN KEY (ReiseunternehmenId) REFERENCES Reiseunternehmen(ReiseunternehmenId)
);

-- Buchungen
CREATE TABLE Buchung (
	BuchungId INT NOT NULL,
    KundeId INT,
    ReiseunternehmenId INT,
    BuchungAnfrageId INT,
    OnlineBuchungId INT,
    Kreditkarte VARCHAR(50),
    AnreiseDatum DATE NOT NULL,
    AbreiseDatum DATE NOT NULL,
    Bemerkung TEXT,
    Storno BOOLEAN DEFAULT FALSE,
    CONSTRAINT PKBuchungId PRIMARY KEY(BuchungId),
    CONSTRAINT FKBuchungKundeId FOREIGN KEY (KundeId) REFERENCES Kunde(KundeId),
    CONSTRAINT FKBuchungReiseunternehmenId FOREIGN KEY (ReiseunternehmenId) REFERENCES Reiseunternehmen(ReiseunternehmenId),
    CONSTRAINT FKBuchungBuchungAnfrageId FOREIGN KEY (BuchungAnfrageId) REFERENCES BuchungAnfrage(BuchungAnfrageId),
    CONSTRAINT FKBuchungOnlineBuchungId FOREIGN KEY (OnlineBuchungId) REFERENCES OnlineBuchung(OnlineBuchungId)
);

-- Zimmerbelegung beim Check-In
CREATE TABLE ZimmerBelegung (
	ZimmerBelegungId INT NOT NULL,
    ZimmerId INT NOT NULL,
    BuchungId INT NOT NULL,
    CONSTRAINT PKZimmerBelegungId PRIMARY KEY(ZimmerBelegungId),
    CONSTRAINT FKZimmerBelegungZimmerId FOREIGN KEY(ZimmerId) REFERENCES Zimmer(ZimmerId),
    CONSTRAINT FKZimmerBelegungBuchungId FOREIGN KEY(BuchungId) REFERENCES Buchung(BuchungId)
);
    
-- Zimmerbelegungen, Auflösung eines n..m zw. Person und Zimmerbelegungadresse
CREATE TABLE ZimmerBelegungPerson (
	ZimmerBelegungId INT NOT NULL,
    PersonId INT NOT NULL,
    CONSTRAINT PKZimmerBelegungId PRIMARY KEY(ZimmerBelegungId, PersonId),
    CONSTRAINT FKZimmerBelegungPersonPersonId FOREIGN KEY (PersonId) REFERENCES Person (PersonId)
);