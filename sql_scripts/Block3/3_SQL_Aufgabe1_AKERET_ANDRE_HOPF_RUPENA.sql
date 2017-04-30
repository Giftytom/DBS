/**
	Die Liste aller Firmen mit Name und Land.
	Authors: Thomas André, Sergio Rupena, Samuel Hopf, Marco Akeret

	Die Adresse kann sowohl an der Ansprechperson, als auch an der Firma hängen.
    Aus diesem Grund gibt es mehrere Verbindungen zwischen Adresse und Firma und damit
    mehrere Einträge.
    Aussortiert werden kann mit DISTINCT oder GROUP BY
**/

SELECT FirmenName, LandName FROM Firma f
	LEFT OUTER JOIN Adresse a ON a.FirmaId = f.FirmaId
    LEFT OUTER JOIN Ort o ON a.OrtId = o.OrtId
    LEFT OUTER JOIN Land l ON l.LandId = o.LandId
    GROUP BY FirmenName, LandName -- alternativ zu 
	