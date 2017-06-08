/**
 * 
 */
package ch.ffhs.dbs.jdbc;

import java.io.*;
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
	private Integer buchungId;
	private Integer kundeId;

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

	public int getMitarbeiterID() {return mitarbeiterID; }

	public Date getAnreiseDatum() {return anreiseDatum;}

	public Date getAbreiseDatum() {return abreiseDatum;}

	void setBuchungId(Integer id){
	    buchungId = id;
    }
    public Integer getBuchungId(){
	    return buchungId;
    }

    void setKundeId(Integer id){
        kundeId = id;
    }
    public Integer getKundeId(){
        return kundeId;
    }

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
			anreiseDatum = new Date(df.parse(anreise).getTime());
			abreiseDatum = new Date(df.parse(abreise).getTime());
		}catch (ParseException e){
			System.out.println("Could not parse Anreise- und Abreise Datum Strings");
			e.printStackTrace();
		}
		// man koente noch pruefen, ob AnreiseDatum aelter als das AbreiseSatum ist
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
	public void closeConnection(){
		if (connection != null) try {
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
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

	/**
	 * Macht eine SQL-Abfrage und returniert eine Liste freier Doppelzimmer
	 * @return
	 * @throws SQLException
	 */
	public List<Map<String, Object>> getFreieDoppelZimmer() throws SQLException {
        List<Map<String, Object>> data = null;
	    buildUpConnection();
	    String freieZimmer = getContentFromFile("src/main/resources/sqls/listFreieDoppelZimmer.sql");
        PreparedStatement stmt = getConnection().prepareStatement(freieZimmer);
        stmt.setDate(1, abreiseDatum);
        stmt.setDate(2, anreiseDatum);
        data = doSelectRLock(stmt);
        closeConnection();
        return data;

    }

    /**
     * Summary der Hotelbuchung
     * @return
     * @throws SQLException
     */
    public List<Map<String, Object>> getSummary() throws SQLException {
        List<Map<String, Object>> data = null;
        buildUpConnection();
        String selSummary = getContentFromFile("src/main/resources/sqls/ZusammenfassungBuchung.sql");
        PreparedStatement stmt = getConnection().prepareStatement(selSummary);
        stmt.setInt(1, buchungId);
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

    /**
     * Erhalte die naechste iD
     * @param statement
     * @return
     * @throws SQLException
     */
    public Integer getIdFromSelect(PreparedStatement statement) throws SQLException{
	    ResultSet rs = statement.executeQuery();
        Integer id = null;
        while (rs.next()){
            id = rs.getInt(1);
        }
        rs.close();
	    return id;
    }

    /**
     * books the room and sets the bookingId
     * @param zimId
     * @return
     */
    public boolean bookARoom(Integer zimId){
        boolean success = true;
        try {
            buildUpConnection();
            // special settings, for lock netweder geht die ganze Buchung oder nichts
            connection.setAutoCommit(false);
            connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            //Here the sequence of SQLs which have to happen or completely rolled back
            String pruefeZimmer = getContentFromFile("src/main/resources/sqls/pruefeZimmernochFrei.sql");
            PreparedStatement psPruefe = connection.prepareStatement(pruefeZimmer);
            psPruefe.setInt(1, zimId);
            Integer zimmerId = getIdFromSelect(psPruefe);
            //vorzeitiger Abbruch, Zimmer nicht mehr frei
            if (zimmerId == null)
                return false;

            // get Selects
            String selBuchungId = getContentFromFile("src/main/resources/sqls/erhalteBuchungId.sql");
            String selZimBelId = getContentFromFile("src/main/resources/sqls/erhalteZimmerBelegungId.sql");
            String buchung = getContentFromFile("src/main/resources/sqls/Buchung.sql");
            String zimmerBel = getContentFromFile("src/main/resources/sqls/Buchung.sql");

            // get further info
            PreparedStatement psBuchungId = connection.prepareStatement(selBuchungId);
            Integer buchungId = getIdFromSelect(psBuchungId);
            PreparedStatement psZimBelId = connection.prepareStatement(selZimBelId);
            Integer zimBelId = getIdFromSelect(psZimBelId);

            // Do the Buchung
            PreparedStatement psBuchung = connection.prepareStatement(buchung);
            psBuchung.setInt(1, buchungId);
            psBuchung.setDate(2, getAnreiseDatum());
            psBuchung.setDate(3, getAbreiseDatum());
            psBuchung.executeUpdate();

            PreparedStatement psZimBel = connection.prepareStatement(zimmerBel);
            psZimBel.setInt(1, zimBelId);
            psZimBel.setInt(2, buchungId);
            psZimBel.setInt(3, zimmerId);
            connection.commit();
            // keep the buchungId after success
            setBuchungId(buchungId);

        } catch (SQLException e){
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
            success = false;
        }finally {
            closeConnection();
        }


        return success;
    }

    /**
     * Loesche Buchung anhand von BuchungId
     */
    public void deleteBooking(){

        try {
            buildUpConnection();
            connection.setAutoCommit(false);
            connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            String delZimBel = getContentFromFile("src/main/resources/sqls/deleteZimmerBelegung.sql");
            String delBuchung = getContentFromFile("src/main/resources/sqls/deleteBuchung.sql");

            PreparedStatement psDelZimBel = connection.prepareStatement(delZimBel);
            psDelZimBel.setInt(1, getBuchungId());
            psDelZimBel.executeUpdate();

            PreparedStatement psBuchung = connection.prepareStatement(delBuchung);
            psBuchung.setInt(1, getBuchungId());
            psBuchung.executeUpdate();

            connection.commit();
            setBuchungId(null);
        }catch (SQLException e){
            e.printStackTrace();
        }finally {
            closeConnection();
        }

    }


    /**
     * Suche alle Kunden anhand vom Nachnamen
     * @param Name
     * @return
     */
    public List<Map<String, Object>> getKundeIds(String Name){
        List<Map<String, Object>> data = null;
        try{
            buildUpConnection();
            String selKundeId = getContentFromFile("src/main/resources/sqls/sucheKundeMitNachname.sql");
            PreparedStatement psSelKunden = connection.prepareStatement(selKundeId);
            data = doSelectRLock(psSelKunden);
        } catch (SQLException e){
            e.printStackTrace();
        }finally {
            closeConnection();
        }
        return data;
    }

    /**
     * Erfasse Kunden mit Angaben
     * @param vorname
     * @param nachname
     * @param gebDatum
     * @param geschlecht
     * @param email
     * @return KundeId
     */
    public Integer erfasseKunde(String vorname, String nachname, String gebDatum, String geschlecht, String email){
        DateFormat df  = new SimpleDateFormat("yyyy-MM-dd");
        Date geburtsDatum = null;
        Integer kundeId = null;
        try {
            geburtsDatum = new Date(df.parse(gebDatum).getTime());
        }catch (ParseException e){
            System.out.println("Could not parse gebDatum String");
            e.printStackTrace();
            return null;
        }

        try{
            buildUpConnection();
            connection.setAutoCommit(false);
            connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            String selKundeId = getContentFromFile("src/main/resources/sqls/getKundeId.sql");
            String selEmailId = getContentFromFile("src/main/resources/sqls/getEmailId.sql");
            String selPersonId = getContentFromFile("src/main/resources/sqls/getPersonId.sql");

            PreparedStatement psPersonid = connection.prepareStatement(selPersonId);
            Integer personId = getIdFromSelect(psPersonid);

            PreparedStatement psEmailId = connection.prepareStatement(selEmailId);
            Integer emailId = getIdFromSelect(psEmailId);

            PreparedStatement psKundeId = connection.prepareStatement(selKundeId);
            kundeId = getIdFromSelect(psKundeId);

            String insPerson = getContentFromFile("src/main/resources/sqls/erfassePerson.sql");
            String insEmail = getContentFromFile("src/main/resources/sqls/erfasseEmail.sql");
            String insKunde = getContentFromFile("src/main/resources/sqls/erfasseKunde.sql");

            PreparedStatement psInsPerson = connection.prepareStatement(insPerson);
            psInsPerson.setInt(1, personId);
            psInsPerson.setString(2, vorname);
            psInsPerson.setString(3, nachname);
            psInsPerson.setDate(4, geburtsDatum);
            psInsPerson.setString(5, geschlecht.substring(0,1));
            psInsPerson.executeUpdate();

            PreparedStatement psInsEmail = connection.prepareStatement(insEmail);
            psInsEmail.setInt(1, emailId);
            psInsEmail.setString(2, email);
            psInsEmail.setInt(3, personId);
            psInsEmail.executeUpdate();

            PreparedStatement psInsKunde = connection.prepareStatement(insKunde);
            psInsKunde.setInt(1, kundeId);
            psInsKunde.setInt(2, personId);
            psInsKunde.executeUpdate();

            connection.commit();
        } catch (SQLException e){
            e.printStackTrace();
            kundeId = null;
            try {
                connection.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
        }finally {
            closeConnection();
        }
        return kundeId;
    }

    /**
     * Update Buchung mit KundeId
     * @param kundeId
     */
    public void updateBuchungWithKundeId(Integer kundeId){
        try{
            buildUpConnection();
            connection.setAutoCommit(false);
            connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            String updBuchung = getContentFromFile("src/main/resources/sqls/updateBuchungMitKundeId.sql");
            PreparedStatement psUpdateBuchung = connection.prepareStatement(updBuchung);
            psUpdateBuchung.setInt(1, kundeId);
            psUpdateBuchung.setInt(2, buchungId);
            psUpdateBuchung.executeUpdate();

            connection.commit();
        } catch (SQLException e){
            e.printStackTrace();
        }finally {
            closeConnection();
        }

    }
	/**
	 * Get the Content of the file, the SQL
	 * @param file
	 * @return SQL String
	 */
	static String getContentFromFile(String file){
        BufferedReader reader = null;
        String         line = null;
        StringBuilder  stringBuilder = new StringBuilder();
        String         ls = System.getProperty("line.separator");

        try {
            reader = new BufferedReader(new FileReader(file));
            while((line = reader.readLine()) != null) {
                stringBuilder.append(line);
                stringBuilder.append(ls);
            }


        } catch (IOException e){
            e.printStackTrace();
        } finally {
            try {
                reader.close();
            } catch (IOException e){
                e.printStackTrace();
            }
        }
        return stringBuilder.toString();
	}

}
