package ch.ffhs.dbs.jdbc;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Properties;


/**
 * Erstellen Sie eine Java/JDBC-Programm, mit welchem alle Buchungen einer
 * bestimmten Periode ausgegeben werden können. Implementieren Sie mit Prepared
 * Statements und verwenden Sie die Start- und Enddaten der abgefragen Periode
 * als Parameter des Queries.
 *
 * Created by Thomas Andre on 28.05.17.
 */
public class SelectBuchung {
	private String dbDriver;
	private String connectionString;
	private String user;
	private String passwd;
	private Connection connection;

	public SelectBuchung() {
		setConfig();
	}

	/**
	 * Set initial parameters from Configfile
	 */
	protected void setConfig() {
		Properties properties = new Properties();
		InputStream input = null;
		try {
			input = new FileInputStream("DB_NB4.properties");
			properties.load(input);

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		dbDriver = properties.getProperty("dbDriver");
		connectionString = properties.getProperty("connection");
		user = properties.getProperty("user");
		passwd = properties.getProperty("passwd");
		
	}
	
	public String getDbDriver(){
		return dbDriver;
	}
	
	public String getConnectionString(){
		return connectionString;
	}
	
	public String getUser(){
		return user;
	}
	
	public String getPasswd(){
		return passwd;
	}
	
	public Connection getConnection(){
		return connection;
	}
	
	public void buildUpConnection() throws SQLException{
		try {
			Class.forName(getDbDriver()).newInstance();
		} catch (Exception e) {
			e.printStackTrace();
		}

		connection = DriverManager.getConnection(getConnectionString(), getUser(), getPasswd());
	}

	public void closeConnection() throws SQLException{
		if (connection != null){
			connection.close();
		}
	}

	public static void main(String[] args) {

		String datum1 = "";
		String datum2 = "";
		/*
		 * String datum1 = "2016-09-01"; String datum2 = "2017-10-20";
		 */
		if (args.length == 2) {
			datum1 = args[0];
			datum2 = args[1];
		} else {
			System.out.println("Call Programm mit 2 parameters, Datum1 und Datum2\n\n"
					+ "e.g. >java SelectBuchung 2016-10-01 2017-11-15   \n\n");
			System.exit(0);
		}
		
		SelectBuchung sb = new SelectBuchung();
		String selectString = "SELECT b.BuchungId AS 'id', b.AnreiseDatum AS 'Anreise' "
				+ ", b.AbreiseDatum AS 'Abreise', b.Storno AS 'Storno' FROM Buchung b "
				+ "WHERE b.AbreiseDatum > ? AND b.AnreiseDatum < ?";
		
		
		try{
			sb.buildUpConnection();
			PreparedStatement select = sb.getConnection().prepareStatement(selectString);
			// Mit Scanner waere auch eine Moeglichkeit:
			// Scanner sc = new Scanner(System.in);

            // Sicherstellen, dass wir den String im richtigen Format erhalten und als Date-Objekt parsen koennen
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            Date date1 = null;
            Date date2 = null;
            try {
                System.out.println(df.parse(datum1));
                date1 = new Date(df.parse(datum1).getTime());
                date2 = new Date(df.parse(datum2).getTime());

            }catch (ParseException e){
                e.printStackTrace();
                System.exit(1);
            }

            select.setDate(1, date1);
            select.setDate(2, date2);

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
			sb.closeConnection();

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
