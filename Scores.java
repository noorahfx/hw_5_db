package db;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Average SOL scores for specific division and school.
 */
public class Scores {

    public int year;
    public int engr;
    public int engw;
    public int hist;
    public int math;
    public int sci;

    public Scores(ResultSet rs) throws SQLException {
        this.year = rs.getInt(1);
        this.engr = rs.getInt(3);
        rs.next();
        this.engw = rs.getInt(3);
        rs.next();
        this.hist = rs.getInt(3);
        rs.next();
        this.math = rs.getInt(3);
        rs.next();
        this.sci = rs.getInt(3);
    }

}
