package ch.ffhs.dbs.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class VerbindungAufbauen {

	public static void main(String[] args) {
		String dbDriver = "com.mysql.jdbc.Driver";
		try {
			Class.forName( dbDriver).newInstance();
		} catch (Exception e) {
			e.printStackTrace();
		} 
		// Credentials in produktiven Programmen in ein Konfigurationsfile auslagern
		String connectString = "jdbc:mysql://localhost:3306/inventar?verifyServerCertificate=false&useSSL=false";
		String user = "root";		
		String password = "dbt";
		try {
			Connection con = 	DriverManager.getConnection(connectString, 	user, password);
			
			System.out.println("Wir haben eine Verbindung");
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}

