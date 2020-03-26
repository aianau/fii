package fii2.pa.lab5;

import fii2.pa.lab5.ICommand;

import java.util.Map;

public class List implements ICommand {
    public void list(Map<String, fii2.pa.lab5.ICommand> commands){

    }

    @Override
    public void execute(Object object) {
        Map<String, fii2.pa.lab5.ICommand> commands = null;
        try {
             commands = (Map<String, fii2.pa.lab5.ICommand> ) object;

        }catch (ClassCastException e){
            e.printStackTrace();
        }

        commands.forEach((k,v) -> {
            System.out.println(k);
        });
    }

    @Override
    public void unexecute(Object object) {

    }
}
