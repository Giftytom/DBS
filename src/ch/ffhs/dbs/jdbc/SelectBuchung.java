package ch.ffhs.dbs.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Erstellen Sie eine Java/JDBC-Programm, mit welchem alle Buchungen einer
 * bestimmten Periode ausgegeben werden können. Implementieren Sie mit Prepared
 * Statements und verwenden Sie die Start- und Enddaten der abgefragen Periode
 * als Parameter des Queries.
 *
 * Created by Thomas Andre on 28.05.17.
 */
public class SelectBuchung {

	public static void main(String[] args) {
		String dbDriver = "com.mysql.jdbc.Driver";

		try {
			Class.forName(dbDriver).newInstance();
		} catch (Exception e) {
			e.printStackTrace();
		}

		String connectString = "jdbc:mysql://localhost:3307/hotel?verifyServerCertificate=false&useSSL=false";
		String user = "root";
		String password = "DBS";
		try {
			Connection con = DriverManager.getConnection(connectString, user, password);
			String selectString = "SELECT b.BuchungId AS 'id', b.AnreiseDatum AS 'Anreise' "
					+ ", b.AbreiseDatum AS 'Abreise', b.Storno AS 'Storno' FROM Buchung b "
					+ "WHERE b.AbreiseDatum > ? AND b.AnreiseDatum < ?";
			PreparedStatement select = con.prepareStatement(selectString);

			// Eingabe von Datum1 und 2

			String datum1 = "";
			String datum2 = "";
			/*
			String datum1 = "2016-09-01";
			String datum2 = "2017-10-20";
			*/
			if (args.length == 2) {
				datum1 = args[0];
				datum2 = args[1];
			} else {
				System.out.println("Call Programm mit 2 parameters, Datum1 und Datum2");
				System.exit(0);
			}

			// Scanner sc = new Scanner(System.in);

			select.setString(1, datum1);
			select.setString(2, datum2);

			ResultSet res = select.executeQuery();

			while (res.next()) {
				int id = res.getInt("id");
				String anreise = res.getString("Anreise");
				String abreise = res.getString("Abreise");
				int storno = res.getInt("Storno");
				System.out.println(id + " " + anreise + " " + abreise + " " + storno);

			}

			res.close();
			select.close();
			con.close();

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
