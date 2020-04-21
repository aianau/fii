package util;

import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class EntitiesManagement {
    private static EntityManagerFactory entityManagerFactory = null;

    public static EntityManagerFactory getEntityManagerFactory() {
        if (entityManagerFactory == null) {
            entityManagerFactory = Persistence.createEntityManagerFactory("MusicAlbumsPU");
        }
        return entityManagerFactory;
    }
}
