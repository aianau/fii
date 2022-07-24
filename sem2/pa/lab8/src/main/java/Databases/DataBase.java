package Databases;

import java.sql.Connection;

public interface DataBase {
    Connection getConnection();
    void closeConnection();
}
