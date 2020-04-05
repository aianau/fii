package main;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Album {
    private Integer id;
    private String name;
    private Integer artistId;
    private Integer releaseYear;

    public Album(Integer id, String name, Integer artistId, Integer releaseYear) {
        this.id = id;
        this.name = name;
        this.artistId = artistId;
        this.releaseYear = releaseYear;
    }

    public Album(String name, Integer artistId, Integer releaseYear) {
        this.id = -1;
        this.name = name;
        this.artistId = artistId;
        this.releaseYear = releaseYear;
    }

    public Album(ResultSet resultSet) {
        try {
            this.id = resultSet.getInt(1);
            this.name = resultSet.getString(2);
            this.artistId = resultSet.getInt(3);
            this.releaseYear = resultSet.getInt(4);
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

    public Integer getArtistId() {
        return artistId;
    }

    public Integer getReleaseYear() {
        return releaseYear;
    }
}
