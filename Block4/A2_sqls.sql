/*
Anfrage in Buchung
*/
use hotel;

SET @MitarbeiterId = 3400; -- Vom Login des Mitarbeiters

-- Darstellung der offenen Anfragen
SELECT * 
	FROM BuchungAnfrage ba
	LEFT JOIN Buchung b ON (ba.BuchungAnfrageId = b.BuchungAnfrageId);
 --   WHERE b.BuchungId = NULL;