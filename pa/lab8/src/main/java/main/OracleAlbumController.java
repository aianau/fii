package main;

import java.sql.*;

public class OracleAlbumController implements AlbumController {
    private static PreparedStatement createStatement;
    private static PreparedStatement findByIdStatement;

    public OracleAlbumController(DataBase dataBase) {
        if (createStatement == null) {
            Connection connection = dataBase.getConnection();
            try {
                createStatement = connection.prepareStatement("insert into ALBUMS(NAME, RELEASE_YEAR) values (?, ?)");
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

            createStatement.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public ResultSet findByArtist(int artistId) {
        ResultSet resultSet = null;
        try {
            createStatement.setInt(1, artistId);
            createStatement.execute();
            resultSet = createStatement.getResultSet();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultSet;
    }
}
