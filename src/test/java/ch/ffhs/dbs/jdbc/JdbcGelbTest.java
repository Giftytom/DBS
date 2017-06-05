package ch.ffhs.dbs.jdbc;

import org.junit.*;

/**
 * Created by Thomas Andre on 04.06.17.
 */
public class JdbcGelbTest {
    static JdbcGelb jdbcGelb;

    @Before
    public void setupObject(){
        jdbcGelb = new JdbcGelb();
    }

    /*@Test
    public void testSelectFreieDoppelZimmer(){
        jdbcGelb.setAnUndAbreiseDatum("2017-01-01", "2017-10-15");
    }*/

    @Test
    public void testGetSQLFromFile(){
        String filecontent = jdbcGelb.getSQLFromFile("sqls/listFreieDoppelZimmer.sql");
        System.out.println(filecontent);
        Assert.assertTrue(filecontent.startsWith("SELECT "));
    }
}
