package Controllers;

import Databases.DataBase;
import entity.Artist;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OracleArtistController implements ArtistController {
    private static PreparedStatement createStatement;
    private static PreparedStatement findByIdStatement;

    public OracleArtistController(DataBase dataBase) {
        if (createStatement == null) {
            Connection connection = dataBase.getConnection();
            try {
                createStatement = connection.prepareStatement("insert into ARTISTS(NAME, COUNTRY) values (?, ?)");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (findByIdStatement == null) {
            Connection connection = dataBase.getConnection();
            try {
                findByIdStatement = connection.prepareStatement("select * from ARTISTS where NAME=?");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void create(Artist artist) {
        try {
            createStatement.setObject(1, artist.getName(), Types.VARCHAR);
            createStatement.setObject(2, artist.getCountry(), Types.VARCHAR);

            createStatement.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Artist> findByName(String name) {
        ResultSet resultSet = null;
        try {
            findByIdStatement.setObject(1, name, Types.VARCHAR);
            findByIdStatement.execute();
            resultSet = findByIdStatement.getResultSet();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        List<Artist> artists = new ArrayList<>();

        try {
            while (resultSet.next()) {
                Artist artist = new Artist(
                        resultSet.getInt(1),
                        resultSet.getString(2),
                        resultSet.getString(3)
                );
                artists.add(artist);
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }

        return artists;
    }
}
