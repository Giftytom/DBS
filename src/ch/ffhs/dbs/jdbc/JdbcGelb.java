/**
 * 
 */
package ch.ffhs.dbs.jdbc;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.sql.Date;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

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
	private int mitarbeiterID;
	private Date anreiseDatum;
	private Date abreiseDatum;

	/**
	 * Constructor
	 */
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

	public String getMitarbeiterID() {return mitarbeiterID; }

	public Date getAnreiseDatum() {return anreiseDatum;}

	public Date getAbreiseDatum() {return getAbreiseDatum();}

	public void setMitarbeiterID(int mitarbeiterID) {
		this.mitarbeiterID = mitarbeiterID;
	}

	/**
	 * Setze An- und Abreisedatum gleichzeitig
	 * @param anreise
	 * @param abreise
	 */
	public void setAnUndAbreiseDatum(String anreise, String abreise) {
		DateFormat df  = new SimpleDateFormat("yyyy-MM-dd");
		try {
			anreiseDatum = new Date(df.parse(anreise));
			abreiseDatum = new Date(df.parse(abreise));
		}catch (ParseException e){
			System.out.println("Could not parse Anreise- und Abreise Datum Strings");
			e.printStackTrace();
		}
		// man koente noch pruefen, ob AnreiseDatum aelter als das AbreiseSatum ist und sonst vertauschen
	}

	/**
	 * Baue eine Verbindung zur DB auf
	 * @throws SQLException
	 */
	public void buildUpConnection() throws SQLException{
		try {
			Class.forName(getDbDriver()).newInstance();
		} catch (Exception e) {
			e.printStackTrace();
		}

		connection = DriverManager.getConnection(getConnectionString(), getUser(), getPasswd());
	}

	/**
	 * Baue die Verbindung zur DB ab
	 * @throws SQLException
	 */
	public void closeConnection() throws SQLException{
		if (connection != null){
			connection.close();
		}
	}

    /**
     * Prints the Content of a List of Maps.
     * @param data
     */
	public static void printSelectReturn(List<Map<String, Object>> data) {
		for (int i = 0; i < data.size(); i++){
            for (String key : data.get(i).keySet()){
                // needs maybe some beautification at print
                System.out.print("" + data.get(i).get(key) + ", ");
            }
            System.out.println("");
        }
	}

	public List<Map<String, Object>> getFreieDoppelZimmer() throws SQLException {
        List<Map<String, Object>> data = null;
	    buildUpConnection();
	    String freieZimmer = "";
        PreparedStatement stmt = getConnection().prepareStatement(freieZimmer);
        stmt.setDate(1, abreiseDatum);
        stmt.setDate(2, anreiseDatum);
        data = doSelectRLock(stmt);
        closeConnection();
        return data;

    }

    private List<Map<String, Object>> doSelectRLock(PreparedStatement statement) throws SQLException{
        List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
        Map<String, Object> row = null;
        //nur vollstaendig erfolgte Transaktionen
        connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
        // Limit 1000 implicit - not relevant for our Selects
        ResultSet rs = statement.executeQuery();

        ResultSetMetaData metaData = rs.getMetaData();
        Integer columnCount = metaData.getColumnCount();

        // Do NOT return a ResultSet. Copy data! Attention for Memory with Big Data
        while (rs.next()) {
            row = new HashMap<String, Object>();
            for (int i = 1; i <= columnCount; i++) {
                row.put(metaData.getColumnName(i), rs.getObject(i));
            }
            resultList.add(row);
        }

        rs.close();

        return resultList;
    }

    private Integer getIdFromSelect(PreparedStatement statement, String row) throws SQLException{
        ResultSet rs = statement.executeQuery();
        Integer id = null;
        while rs.next(){
            id = rs.getInt("row");
        }
        rs.close();
	    return id;
    }
    /**
     * Funktioniert so nicht, weil zu viel Logik
     * @param preparedStatements
     * @return
     */
    private boolean doWriteXLock(ArrayList<PreparedStatement> preparedStatements){
        boolean success = true;
        //Ganz streng!
        try {
            connection.setAutoCommit(false);
            connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            preparedStatements.forEach(statement -> {
                try {
                    statement.executeUpdate();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            });
            connection.commit();
        }catch (SQLException e){
            e.printStackTrace();
            success = false;
            try {
                connection.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
        }
        return success;
    }

}
