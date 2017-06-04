/*
Erstellen Sie eine Java/JDBC-Programm, mit welchem alle Buchungen einer bestimmten Periode ausgegeben werden können.

Implementieren Sie mit Prepared Statements und verwenden Sie die Start- und Enddaten der abgefragen Periode als Parameter des Queries.
*/
USE hotel;

SET @AnreiseDatum = "2016-09-11";
SET @AbreiseDatum = "2017-09-15";
SELECT b.BuchungId
, b.AnreiseDatum
, b.AbreiseDatum
, b.Storno
	FROM Buchung b
	WHERE (b.AbreiseDatum > @AnreiseDatum 
	AND b.AnreiseDatum < @AbreiseDatum)