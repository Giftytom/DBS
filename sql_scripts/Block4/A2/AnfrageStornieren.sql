-- nicht genug frei, Buchunganfrage stornieren
UPDATE BuchungAnfrage SET (Storno = 1) WHERE BuchungAnfrageId = @BuchungAnfrId;
