package main;

import java.sql.ResultSet;

public interface AlbumController {
    void create(Album album);
    ResultSet findByArtist(int artistId);
}
