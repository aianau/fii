package Controllers;

import Databases.DataBase;
import entity.Album;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OracleAlbumController implements AlbumController {
    private static PreparedStatement createStatement;
    private static PreparedStatement findByIdStatement;

    public OracleAlbumController(DataBase dataBase) {
        if (createStatement == null) {
            Connection connection = dataBase.getConnection();
            try {
                createStatement = connection.prepareStatement("insert into ALBUMS(NAME, RELEASE_YEAR, ARTIST_ID) values (?, ?, ?)");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (findByIdStatement == null) {
            Connection connection = dataBase.getConnection();
            try {
                findByIdStatement = connection.prepareStatement("select * from ALBUMS where ARTIST_ID=?");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void create(Album album) {
        try {
            createStatement.setObject(1, album.getName(), Types.VARCHAR);
            createStatement.setInt(2, album.getReleaseYear());
            createStatement.setInt(3, album.getArtistId());

            createStatement.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Album> findByArtist(int artistId) {
        ResultSet resultSet = null;
        try {
            findByIdStatement.setInt(1, artistId);
            findByIdStatement.execute();
            resultSet = findByIdStatement.getResultSet();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        List<Album> albums = new ArrayList<>();

        try {
            while (resultSet.next()) {
                Album album = new Album(resultSet);
                albums.add(album);
            }
        } catch (NullPointerException| SQLException e) {
            System.err.println(e.getMessage());
        }

        return albums;
    }
}
