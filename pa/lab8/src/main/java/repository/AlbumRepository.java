package repository;

import entity.Album;
import entity.Artist;
import util.EntitiesManagement;

import javax.persistence.EntityManager;
import java.util.List;

public class AlbumRepository {
    private EntityManager entityManager;

    public AlbumRepository() {
        entityManager = EntitiesManagement.getEntityManagerFactory().createEntityManager();
    }

    public void create(Album album) {
        entityManager.getTransaction().begin();
        entityManager.persist(album);
        entityManager.getTransaction().commit();
    }

    public Album findById(int id) {
        return entityManager.find(Album.class, id);
    }

    public List<Album> findByName(String name) {
        List albumsList;
        entityManager.getTransaction().begin();
        albumsList = entityManager.createNamedQuery("Album.findByName").setParameter("name", name).getResultList();
        return albumsList;
    }

    public List<Album> findByArtist(Artist artist) {
        List albumsList;
        //entityManager.getTransaction().begin();
        albumsList = entityManager.createNamedQuery("Album.findByArtist").setParameter("artistId", artist.getId()).getResultList();
        entityManager.close();
        return albumsList;
    }

    public void close() {
        entityManager.close();
    }
}
