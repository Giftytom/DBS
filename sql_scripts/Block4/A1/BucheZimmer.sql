INSERT INTO Buchung (BuchungId, MitarbeiterId, AnreiseDatum, AbreiseDatum) VALUES(@BuchungId, @MitarbeiterId, @AnreiseDatum, @AbreiseDatum);
INSERT INTO ZimmerBelegung (ZimmerBelegungId, ZimmerId, BuchungId) VALUES(@ZimmerBelegungId, @ZimmerId, @BuchungId);
