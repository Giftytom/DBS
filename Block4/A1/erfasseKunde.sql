- Falls Kunde noch nicht in unserer DB, Kunde hinzufügen
SET @PersonId = (SELECT max(PersonId) +1 FROM Person);
SET @NewKundeId = (SELECT max(KundeId) +1 FROM Kunde);
SET @EMailId = (SELECT max(EmailId) +1 FROM EMail);

SET @Vorname = "Christoph";
SET @Nachname = "Frei";
SET @GebDatum = "1982-09-21";
SET @Geschlecht = "m";
SET @EMail = "chr.frei@gmx.ch";
-- Eventuell auch weitere Adress-Eingaben
-- Insert Person und anschliessend Kunde
INSERT INTO Person (PersonId, Vorname, Nachname, Geburtsdatum, Geschlecht) VALUES (@PersonId, @Vorname, @Nachname, @Geburtsdatum, @Geschlecht);
INSERT INTO EMail (EMailId, EMailAdresse, PersonId) VALUES (@EmailId, @EMail, @PersonId);
INSERT INTO Kunde (KundeId, PersonId) VALUES(@NewKundeId, @PersonId);

SET @KundeId = @NewKundeId;
