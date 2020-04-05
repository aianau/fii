package main;

import java.util.List;

public interface ArtistController {
    void create(Artist artist);
    List<Artist> findByName(String name);
}
