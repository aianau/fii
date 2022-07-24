package entity;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Objects;

@Entity
@Table(name="ARTISTS")
@NamedQueries({
        @NamedQuery(name = "Artist.findByName",
                query = "SELECT artist FROM Artist artist where artist.name=:name")
})
public class Artist implements Serializable {
    @Id
    @Basic(optional = false)
    @Column(name = "ID")
    private Integer id;
    @Column(name = "NAME")
    private String name;
    @Column(name = "COUNTRY")
    private String country;

    public Artist(){
    }

    public Artist(String name, String country) {
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

    public void setId(Integer id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    @Override
    public String toString() {
        return "Artist{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", country='" + country + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Artist that = (Artist) o;

        if (!id.equals(that.id)) return false;
        if (!Objects.equals(name, that.name)) return false;
        return Objects.equals(country, that.country);
    }

    @Override
    public int hashCode() {
        int result = id;
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (country != null ? country.hashCode() : 0);
        return result;
    }

}
