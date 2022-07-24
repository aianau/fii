package fii2.pa.lab5;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.Files;


public class Report implements ICommand {
    private String newHtmlCatalog(Catalog catalog){
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append("<html lang=\"en\">\n" +
                "\n" +
                "<body>");
        stringBuilder.append("\n" +
                "<ul>");
        for (Document document:
                catalog.getDocuments()) {
            stringBuilder.append(newHtmlListItem(document.getName()));
        }
        stringBuilder.append("</ul>");
        stringBuilder.append("</body>");
        stringBuilder.append("</html>");
        return stringBuilder.toString();
    }


    private String newHtmlListItem(String insideItem){
        return "<li>" +
                insideItem +
                "</li>";
    }

    @Override
    public void execute(Object catalog) {
        try {
            if(catalog.getClass() != Catalog.class){
                throw new ClassCastException();
            }
        }catch (ClassCastException e){
            e.printStackTrace();
        }

        String html = newHtmlCatalog((Catalog) catalog);

        try {
            String fileName = "catalog_"+ catalog.toString()+".html";
            Files.deleteIfExists(Paths.get(fileName));
            Path reportPath = Files.createFile(Paths.get(fileName));
            Files.write(reportPath, html.toString().getBytes());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void unexecute(Object object) {

    }
}