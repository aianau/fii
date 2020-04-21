package main;

/*
* Compulsory (1p)
Create a persistence unit with the name "MusicAlbumsPU" (use EclipseLink or Hibernate or other JPA implementation).
Verify the presence of the persistence.xml file in your project. Make sure that the driver for EclipseLink or Hibernate was added to to your project classpath (or add it yourself).
Create the package entity in your project and define the entity classes Artist and Album. You may use the IDE support in order to generate entity classes from database tables.
Create the package util containing a class called PersistenceUtil. This class must contain a method for creating/returning an EntityManagerFactory object. Implement the Singleton desing pattern.
Create the package repo in your project and define the classes ArtistRepository and AlbumRepository. Both classes must have the methods:
create that receives an entity and saves it into the database;
findById that returns an entity based on its primary key;
findByName that returns a list of entities that match a given name pattern. Use a named query in order to implement this method.
The AlbumRepository class must also have the method findByArtist, that returns the list of albums of a given artist. Use a named query in order to implement this method.
Create the package app and the main class AlbumManager in order to test your application.

* Optional (1p)
Add support for charts.
Create a generic AbstractRepository using generics in order to simplify the creation of the repository classes. You may take a look at the CrudRepository interface from Spring Framework.
Create both the JDBC and JPA implementations and use an AbstractFactory in order to create the DAO objects (the repositories). The application will use JDBC or JPA depending on a parameter given in an initialization file. (At least for one entity!)

* Bonus
Create support for specifying music genres (rock, electronic, classical, etc). Each album will be included in a single genre.
Generate fake data in order to populate your database with a large number of albums.
Implement an efficient algorithm that returns the largest set of albums such that no two albums have the same artist or belong to the same genre.
Create test units for your algorithm using JUnit or other framework.

 */


import entity.Artist;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class Lab9 {
    public static void main(String[] args) {
        EntityManagerFactory emf =
                Persistence.createEntityManagerFactory("Artist");
        EntityManager em = emf.createEntityManager();

        em.getTransaction().begin();
        Artist artist1 = new Artist(13, "gigi", "Vaslui");
        em.persist(artist1);
        em.getTransaction().commit();


        em.close();
        emf.close();
    }
}
