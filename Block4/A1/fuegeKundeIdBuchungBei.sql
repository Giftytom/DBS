-- Füge KundeId der Buchung hinzu
UPDATE Buchung SET KundeId = @KundeId WHERE BuchungId = @BuchungId;
-- Commit - Buchung abgeschlossen
