package main;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Artist {
    private Integer id;
    private String name;
    private String country;

    public Artist(String name, String country) {
        this.id = -1;
        this.name = name;
        this.country = country;
    }

    public Artist(Integer id, String name, String country) {
        this.id = id;
        this.name = name;
        this.country = country;
    }

    public Artist(ResultSet resultSet) {
        try {
            this.id = resultSet.getInt(1);
            this.name = resultSet.getString(2);
            this.country = resultSet.getString(3);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Integer getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getCountry() {
        return country;
    }

    @Override
    public String toString() {
        return "Artist{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", country='" + country + '\'' +
                '}';
    }
}
