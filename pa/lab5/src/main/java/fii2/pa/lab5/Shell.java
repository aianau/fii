package fii2.pa.lab5;

import java.util.*;

public class Shell {
    private Map<String, ICommand> commands;
    private List listCommand;
    private Catalog catalog;
    private Exit exit;

    public Shell(fii2.pa.lab5.List listCommand, Catalog catalog) {
        commands = new HashMap<>();
        exit = new Exit();

        this.listCommand = listCommand;
        this.catalog = catalog;
        commands.put("exit", exit);
    }

    public void addCommand(String commandName, ICommand command) {
        this.commands.put(commandName, command);
    }

    public void setCatalog(Catalog catalog) {
        this.catalog = catalog;
    }

    public void listShellCommands() {
        listCommand.list(this.commands);
    }

    public void run() {
        Scanner in = new Scanner(System.in);
        String commandEntered;
        do {
            commandEntered = in.nextLine();
            commands.get(commandEntered.toLowerCase()).execute(catalog);
        } while (!commandEntered.equals("exit"));
    }
}

class Exit implements ICommand {

    @Override
    public void execute(Object object) {
        System.exit(0);
    }

    @Override
    public void unexecute(Object object) {

    }
}