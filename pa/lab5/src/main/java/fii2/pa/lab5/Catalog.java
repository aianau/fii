package fii2.pa.lab5;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class Catalog implements Serializable {
    private List<Document> documents;

    private fii2.pa.lab5.ICommand save;
    private fii2.pa.lab5.ICommand load;
    private fii2.pa.lab5.ICommand view;
    private fii2.pa.lab5.ICommand report;

    public Catalog(ICommand save, fii2.pa.lab5.ICommand load, fii2.pa.lab5.ICommand view, fii2.pa.lab5.ICommand report) {
        this.save = save;
        this.load = load;
        this.view = view;
        this.report = report;
        this.documents = new ArrayList<>();
    }
    public Catalog(Catalog other) {
        this.save = other.save;
        this.load = other.load;
        this.view = other.view;
        this.report = other.report;
        this.documents = new ArrayList<>(other.documents);
    }

    public void save(){
        this.save.execute(this);
    }

    public Catalog load(String toLoad){
        Catalog loaded = null;
        try{
            FileInputStream fos = new FileInputStream(toLoad);
            ObjectInputStream o = new ObjectInputStream(fos);
            loaded = new Catalog((Catalog) o.readObject());
            o.close();
        } catch (NullPointerException | IOException | ClassNotFoundException e){
            e.printStackTrace();
        }
        //        this.load.execute(this);
        return loaded;
    }

    public void view(String documentName){
        Catalog catalogToView = new Catalog(this.save, this.load, this.view, this.report);

        try {
            boolean found = false;
            for (Document document :
                    this.documents) {
                if (document.getName().equals(documentName)){
                    catalogToView.addDocument(document);
                    found = true;
                }
            }
            if (!found){
                throw new DocumentNameNotFound("Not found document with name" + documentName);
            }
        } catch (DocumentNameNotFound e){
            e.printStackTrace();
        }


        this.view.execute(catalogToView);
    }

    public void report(){
        this.report.execute(this);
    }

    public void addDocument(Document document){
        this.documents.add(document);
    }

    public List<Document> getDocuments() {
        return documents;
    }

    public void removeDocument(Document document){
        this.documents.remove(document);
    }


}