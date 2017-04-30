
/**
	Liste aller Hotelgäste, für welche die Sprache "englisch" hinterlegt ist, 
    und welche im Monat Mai Geburtstag haben. 
    Anrede, Nachname, Vorname, Geburtsdatum, alle E-Mail-Adressen

	Authors: Thomas André, Sergio Rupena, Samuel Hopf, Marco Akeret

	tellen Sie sicher, dass dies mehrere Hotelgäste betrifft.
	Stellen Sie sicher, dass es auch Hotelgäste gibt, für welche andere Sprachen hinterlegt sind und dass diese in Ihrer Liste nicht erscheinen.
	Stelle Sie sicher, dass es auch Hotelgäste gibt, für welche keine E-Mail-Adressen hinterlegt ist und dass diese Gäste in Ihrer Liste nicht erscheinen.
**/

SELECT 
	CASE Geschlecht WHEN 'm' THEN 'Herr' WHEN 'f' THEN 'Frau' ELSE '' END AS Anrede,
    Nachname, Vorname, DATE_FORMAT (Geburtsdatum, '%d.%m.%Y') AS Geburtsdatum,
    EMailAdresse AS Email
    FROM Kunde k
	JOIN Person p ON p.PersonId = k.PersonId
    LEFT OUTER JOIN Email e ON e.PersonId = p.PersonId
    
    WHERE UPPER(Sprache) = 'EN'
		AND MONTH (Geburtsdatum) = 5