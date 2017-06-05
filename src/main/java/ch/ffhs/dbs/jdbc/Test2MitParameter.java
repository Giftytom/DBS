package ch.ffhs.dbs.jdbc;

import java.sql.*;


public class Test2MitParameter {


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
				
			String query = "select id, bezeichnung from geraetetyp order by id";
			
			Statement stmt = con.createStatement();
			ResultSet res = stmt.executeQuery(query);
			
			while (res.next()) {
			
				int id = res.getInt("id");
				String bezeichnung = res.getString("bezeichnung");
				System.out.println(id+" "+bezeichnung);
			}
			System.out.println("**********************");
			int newId = 100;
			String newBezeichnung = "Eine \'Bezeichnung\' als Test";
			
			String insert = "insert into geraetetyp (id, bezeichnung) "
					+ " value (" 
					+ newId + ", '"
					+ newBezeichnung + "');";
			
			System.out.println(insert);
			
			int num = stmt.executeUpdate(insert);
			System.out.println("**********************");
			
			stmt = con.createStatement();
			res = stmt.executeQuery(query);
			
			while (res.next()) {
				
				int id = res.getInt("id");
				String bezeichnung = res.getString("bezeichnung");
				System.out.println(id+" "+bezeichnung);
			}
			
			
			
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		

	

	}

}
