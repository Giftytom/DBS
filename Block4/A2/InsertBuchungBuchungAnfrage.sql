-- Die folgenden Schrite werden nicht sofort commited, erst nach Erfolg, oder ein Rollback
INSERT INTO Buchung (BuchungId, MitarbeiterId, ReiseunternehmenId, BuchungAnfrageId, AnreiseDatum, AbreiseDatum)
	VALUES (@BuchungId, @MitarbeiterId, @ReiseunternehmenId, @BuchungAnfrageId, @AnreiseDatum, @AbreiseDatum);
