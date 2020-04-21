package repository;

import entity.Artist;
import util.EntitiesManagement;

import javax.persistence.EntityManager;
import java.util.List;

public class ArtistRepository {
    private EntityManager entityManager;

    public ArtistRepository() {
        entityManager = EntitiesManagement.getEntityManagerFactory().createEntityManager();
    }

    public void create(Artist artist) {
        entityManager.getTransaction().begin();
        entityManager.persist(artist);
        entityManager.getTransaction().commit();
    }

    public Artist findById(int id) {
        return entityManager.find(Artist.class, id);
    }

    public List<Artist> findByName(String name) {
        List artistsList;
        entityManager.getTransaction().begin();
        artistsList = entityManager.createNamedQuery("Artist.findByName").setParameter("name", name).getResultList();
        return artistsList;
    }

    public void close() {
        entityManager.close();
    }
}
