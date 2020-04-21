package Controllers;

import entity.Album;

import java.util.List;

public interface AlbumController {
    void create(Album album);
    List<Album> findByArtist(int artistId);
}
