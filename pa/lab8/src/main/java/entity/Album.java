package entity;

import javax.persistence.*;
import java.sql.ResultSet;
import java.sql.SQLException;

@Entity
@Table(name = "ALBUMS")
@NamedQueries({
        @NamedQuery(name = "Album.findByName",
                query = "SELECT album FROM Album album where album.name=:name"),
        @NamedQuery(name = "Album.findByArtist",
                query = "SELECT album FROM Album album where album.artistId=:artistId")
})
public class Album {
    @Id
    @Basic(optional = false)
    @Column(name = "ID")
    private Integer id;
    @Column(name = "NAME")
    private String name;
    @Column(name = "ARTIST_ID")
    private Integer artistId;
    @Column(name = "RELEASE_YEAR")
    private Integer releaseYear;

    public Album(){
    }

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

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getArtistId() {
        return artistId;
    }

    public void setArtistId(Integer artistId) {
        this.artistId = artistId;
    }

    public Integer getReleaseYear() {
        return releaseYear;
    }

    public void setReleaseYear(Integer releaseYear) {
        this.releaseYear = releaseYear;
    }

    @Override
    public String toString() {
        return "Album{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", artistId=" + artistId +
                ", releaseYear=" + releaseYear +
                '}';
    }
}
