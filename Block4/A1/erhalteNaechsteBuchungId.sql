-- Buchungs des Zimmers
-- setze neue BuchungId -> Auto-Increment wäre auch eine Möglichkeit
SET @BuchungId = (SELECT max(b.BuchungId) +1
	FROM Buchung b);
