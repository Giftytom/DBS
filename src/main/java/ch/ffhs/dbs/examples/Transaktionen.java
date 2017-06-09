package ch.ffhs.dbs.examples;

import java.sql.*;
import java.util.Scanner;


public class Transaktionen {


	public static void main(String[] args) {
		String dbDriver = "com.mysql.jdbc.Driver";
		try {
			Class.forName( dbDriver).newInstance();
		} catch (Exception e) {
			e.printStackTrace();
		} 
		// Credentials in produktiven Programmen in ein Konfigurationsfile auslagern
		String connectString = "jdbc:mysql://localhost:3307/inventar?verifyServerCertificate=false&useSSL=false";
		String user = "root";
		String password = "DBS";
		try {
			Connection con = 	DriverManager.getConnection(connectString, 	user, password);
			
			con.setAutoCommit(false);
			con.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

			String selectString = "select id, bezeichnung from geraetetyp where id = ? for update";
			PreparedStatement select = con.prepareStatement(selectString);
			
			String updateString = "update geraetetyp set bezeichnung = ? where id = ?";
			PreparedStatement update = con.prepareStatement(updateString);
						
			int myId = 100;
			select.setInt(1, myId);
			
			ResultSet res = select.executeQuery();
			
			while (res.next()) {
			
				int id = res.getInt("id");
				String bezeichnung = res.getString("bezeichnung");
				System.out.println(id+" "+bezeichnung);
			}
			
			System.out.println("Warte ");
			Scanner sc = new Scanner(System.in);
			int i = sc.nextInt();	
			
			String bessereBezeichnung = "Firmenjet";
			

			update.setString(1, bessereBezeichnung);
			update.setInt(2, myId);
			int num = update.executeUpdate();
			
			System.out.println(num + " nachgeführt - warte auf Commit ");
			i = sc.nextInt();
			
			con.commit();
			System.out.println("Commit fertig");
			
			res.close();
			select.close();
			update.close();
			con.close();
			sc.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		

	

	}

}
