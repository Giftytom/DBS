package ch.ffhs.dbs.jdbc;


import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

/**
 * Created by Thomas Andre on 04.06.17.
 */
public class JdbcGelbTest {
    static JdbcGelb jdbcGelb;

    @BeforeEach
    public setupObject(){
        jdbcGelb = new JdbcGelb();
    }

    @Test
    public void testSelectFreieDoppelZimmer(){
        jdbcGelb.setAnUndAbreiseDatum("2017-01-01", "2017-10-15");
    }
}
