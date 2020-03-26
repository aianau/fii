
package fii2.pa.lab5;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class SaveAsText implements ICommand {
    @Override
    public void execute(Object object) {
        try {
            if(object.getClass() != Catalog.class){
                throw new ClassCastException();
            }
        }catch (ClassCastException e){
            e.printStackTrace();
        }

        try {
            String fileName = object.toString();
            Files.deleteIfExists(Paths.get(fileName));
            Path reportPath = Files.createFile(Paths.get(fileName));

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void unexecute(Object object) {

    }
}