-- Falls Buchungsvorgang abgebrochen wird "Cancel", bzw, Buchung gelöscht werden soll vor entgültigem Abschluss der Buchung - es wird kein Storno gemacht
DELETE FROM ZimmerBelegung WHERE ZimmerBelegungId = @ZimmerBelegungId;
DELETE FROM Buchung WHERE BuchungId = @BuchungId;
