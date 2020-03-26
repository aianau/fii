package fii2.pa.lab5;

import java.io.Serializable;

public interface ICommand extends Serializable {
    public void execute(Object object);

    public void unexecute(Object object);
}
