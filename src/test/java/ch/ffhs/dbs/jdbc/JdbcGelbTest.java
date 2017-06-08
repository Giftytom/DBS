package ch.ffhs.dbs.jdbc;

import org.junit.*;

import java.io.File;
import java.io.FilenameFilter;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * Created by Thomas Andre on 04.06.17.
 */
public class JdbcGelbTest {
    static JdbcGelb jdbcGelb;

    @Before
    public void setupObject(){
        jdbcGelb = new JdbcGelb();
    }

    @Test
    public void testSelectFreieDoppelZimmer(){
        jdbcGelb.setAnUndAbreiseDatum("2017-10-01", "2017-10-15");

        List<Map<String, Object>> data = null;
        try {
            data = jdbcGelb.getFreieDoppelZimmer();
            JdbcGelb.printSelectReturn(data);
        } catch (SQLException e){
            e.printStackTrace();
        }
        Assert.assertNotNull(data);
    }

    @Test
    public void testGetSQLFromFile(){
        String filecontent = jdbcGelb.getContentFromFile("src/main/resources/sqls/listFreieDoppelZimmer.sql");
        //System.out.println(filecontent);
        Assert.assertTrue(filecontent.startsWith("SELECT "));
    }

    @Test
    public void testGetIdFromSelect(){
        String select = jdbcGelb.getContentFromFile("src/main/resources/sqls/erhalteBuchungId.sql");
        Integer buchungId = null;
        try {
            jdbcGelb.buildUpConnection();
            PreparedStatement ps = jdbcGelb.getConnection().prepareStatement(select);
            buchungId = jdbcGelb.getIdFromSelect(ps);
            jdbcGelb.closeConnection();
        }catch (SQLException e){
            e.printStackTrace();
        }
        //System.out.println(buchungId);
        Assert.assertNotNull(buchungId);
    }

    @Test
    public void testBuchungEinZimmer(){
        boolean suc = true;
        jdbcGelb.setAnUndAbreiseDatum("2017-10-01", "2017-10-15");
        suc = jdbcGelb.bookARoom(4920);
        Assert.assertTrue(suc);
    }
}
