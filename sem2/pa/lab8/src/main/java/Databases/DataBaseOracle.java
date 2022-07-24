package Databases;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DataBaseOracle implements DataBase{
    private static Connection connection = null;

    public DataBaseOracle() {
        if (connection == null){
            try {
                connection = DriverManager.getConnection(
                        "jdbc:oracle:thin:@localhost:1522:orcl",
                        "STUDENT", "STUDENT");
            } catch (SQLException e) {
                System.out.println("Unable to connect to Db" + e.getMessage());
            }
        }
    }

    @Override
    public Connection getConnection() {
        return connection;
    }

    @Override
    public void closeConnection() {
        if (connection != null){
            try {
                connection.close();
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
    }
}
