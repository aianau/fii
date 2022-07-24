package fii2.pa.lab5;

import java.io.Serializable;

public class Main implements Serializable {

    // Ce am facut:
    // compulsory : tot
    // optional:
    //   - Create a shell that allows reading commands from the keyboard, together with their arguments and implement the commands load, list, view.
    //   - Represent the commands using classes instead of methods (create the classes LoadCommand, ListCommand, etc.). Use an interface or an abstract class in order to desribe a generic command.
    //   - Implement the command report html: create an HTML report representing the content of the catalog.
    //   - The application will signal invalid data (duplicate names, invalid paths or URLs, etc.) or invalid commands using custom exceptions.
    //   - am facut si jar-ul.
    // Bonus:
    //   - info: display the metadata of a specific file: (you may want to use Apache Tika or something similar).

    public static void main(String[] args) {
        testParser();

//        testViewSaveReport();

//        testShell();
    }

    public static void testParser(){
        Document google = new Document(
                "1",
                "Google",
                "www.google.com"
        );

        Document carte = new Document(
                "2",
                "cartea",
                "D:\\fii2\\pa\\lab5\\test.txt"
        );

        Save save = new Save();
        Load load = new Load();
        View view = new View();
        Report report = new Report();
        List list = new List();

        MyParser.parseDoc(carte);
    }

    public static void testViewSaveReport(){
        Document google = new Document(
                "1",
                "Google",
                "www.google.com"
        );

        Document carte = new Document(
                "2",
                "cartea",
                "D:\\fii2\\pa\\lab5\\test.txt"
        );

        Save save = new Save();
        Load load = new Load();
        View view = new View();
        Report report = new Report();
        List list = new List();


        Catalog catalog = new Catalog(save, load, view, report);
        catalog.addDocument(carte);
        catalog.addDocument(google);
        catalog.view("cartea");
        catalog.save();
        catalog.report();
    }

    public static void testShell(){
        Document google = new Document(
                "1",
                "Google",
                "www.google.com"
        );

        Document carte = new Document(
                "2",
                "cartea",
                "D:\\fii2\\pa\\lab5\\test.txt"
        );

        Save save = new Save();
        Load load = new Load();
        View view = new View();
        Report report = new Report();
        List list = new List();


        Catalog catalog = new Catalog(save, load, view, report);
        catalog.addDocument(carte);
        catalog.addDocument(google);
        catalog.report();
        Shell shell = new Shell(list, catalog);
        shell.addCommand(view.getClass().getSimpleName().toLowerCase(), view);
        shell.addCommand(save.getClass().getSimpleName().toLowerCase(), save);
        shell.run();
    }
}