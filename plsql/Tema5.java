package com.company;

import java.sql.*;

public class Tema5 {
    public Tema5() {

        Connection conn = null;
        try {
            conn = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE",
                    "STUDENT", "STUDENT");

            Statement stmt = conn.createStatement();

            CallableStatement cstmt = conn.prepareCall("begin ? := manager_exceptii.calcul_medie(?, ?); end;");
            cstmt.registerOutParameter(1, Types.FLOAT);
            cstmt.setString(2,"Romaniuchh");
            cstmt.setString(3,"Laurentiu");
            cstmt.executeUpdate();


        } catch (SQLException e) {
            System.out.println("am prins exceptia");
            System.out.println(e);
            System.out.println("si am afisat exceptia");
        }




    }
}
