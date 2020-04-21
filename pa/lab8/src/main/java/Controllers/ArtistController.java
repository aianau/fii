package Controllers;

import entity.Artist;

import java.util.List;

public interface ArtistController {
    void create(Artist artist);
    List<Artist> findByName(String name);
}
