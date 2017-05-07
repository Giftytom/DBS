package ch.ffhs.dbs.jdbc;

import java.sql.*;


public class Test3 {


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
						
			String query = "select id, bezeichnung from geraetetyp where id = ? ";
			
			PreparedStatement stmt = con.prepareStatement(query);
			
			int idToSelect = 99;
			
			stmt.setInt(1,idToSelect);
			ResultSet res = stmt.executeQuery();
			
			while (res.next()) {
			
				int id = res.getInt("id");
				String bezeichnung = res.getString("bezeichnung");
				System.out.println(id+" "+bezeichnung);
			}
				
			idToSelect = 9;
			stmt.setInt(1,idToSelect);
			res = stmt.executeQuery();
			
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
