package main;

import java.sql.Connection;

public interface DataBase {
    Connection getConnection();
}
