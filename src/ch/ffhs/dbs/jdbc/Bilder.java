package ch.ffhs.dbs.jdbc;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Scanner;


public class Bilder {


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

			String insertString = "insert into bilder (id, bild) values (?,?)";
			PreparedStatement insert  = con.prepareStatement(insertString);
							
			int myId = 100;
		
			String pfadZumInputBild = "/home/dbt/Documents/all-skripts/bild.jpg";
			File fileIn = new File(pfadZumInputBild);
	        FileInputStream myBlob = new FileInputStream(fileIn);
			insert.setInt(1, myId);
			insert.setBlob(2, myBlob);
			
			insert.execute();
			
			//Bild wieder lesen
			String selectString = "select bild from bilder where id = ?";
			PreparedStatement select  = con.prepareStatement(selectString);
			
			select.setInt(1, myId);
			ResultSet rs = select.executeQuery();
			
			
			String pfadZumOutputBild = "/home/dbt/Documents/all-skripts/bildOut.jpg";
			File fileOut = new File(pfadZumOutputBild);
			FileOutputStream output = new FileOutputStream(fileOut);

			while (rs.next()) {
			    InputStream input = rs.getBinaryStream("bild");
			    byte[] buffer = new byte[1024];
			    while (input.read(buffer) > 0) {
			        output.write(buffer);
			    }
			    output.flush();
			    output.close();
			}
			
			insert.close();
			rs.close();
			select.close();
			con.commit();
			con.close();
		} catch (SQLException es) {
			es.printStackTrace();
		} catch (FileNotFoundException ef) {

		} catch (IOException ef) {
			ef.printStackTrace();
		}
			
		

	

	}

}