/**
 * 
 */
package ch.ffhs.dbs.jdbc;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * @author Thomas Andre
 *
 */
public class JdbcGelb {
	private String dbDriver;
	private String connectionString;
	private String user;
	private String passwd;
	private Connection connection;

	public JdbcGelb() {
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
	
}
