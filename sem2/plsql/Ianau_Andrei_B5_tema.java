package com.company;

import java.sql.*;

public class Tema5 {
    public Tema5() {

        Connection conn = null;
        try {
            conn = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE",
                    "STUDENT", "STUDENT");
            Statement statement = conn.createStatement();
            CallableStatement callableStatement = conn.prepareCall("begin ? := lab5.calcul_medie(?, ?); end;");
            callableStatement.registerOutParameter(1, Types.FLOAT);
            callableStatement.setString(2,"Ianau");
            callableStatement.setString(3,"Andrei");
            callableStatement.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
