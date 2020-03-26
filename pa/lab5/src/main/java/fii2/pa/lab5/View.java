package fii2.pa.lab5;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.awt.Desktop;



public class View implements ICommand {
    @Override
    public void execute(Object object) { // TODO aici vezi ca nu ai facut bine checkul.
        try {
            if(object.getClass() != Catalog.class){
                throw new ClassCastException();
            }
        }catch (ClassCastException e){
            e.printStackTrace();
        }
        Catalog catalog = (Catalog) object;


        File file = null;
        URI uri = null;
        Desktop desktop = Desktop.getDesktop();

        for (Document document :
                catalog.getDocuments()) {
            if (document.getLocation().startsWith("http") |
                document.getLocation().startsWith("www")){
                try {
                    uri = new URI(document.getLocation());
                    desktop.browse(uri);
                }
                catch (SecurityException|UnsupportedOperationException | URISyntaxException | IOException exception){
                    System.out.println(exception);
                }
            }
            else {
                try {
                    file = new File(document.getLocation());
                    desktop.open(file);
                }
                catch (IllegalArgumentException | UnsupportedOperationException | SecurityException | IOException e){
                    System.out.println(e);
                }
            }
        }
    }

    @Override
    public void unexecute(Object object) {


    }
}
