package company;
import java.util.List;

public abstract class Asker implements Comparable<Asker>{
    private String name;
    private Offerer pair;

    public Asker(String name) {
        this.name = name;
    }

    public Asker(String name, List<Asker> preferredAskers) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isUnpaired() {
        return pair == null;
    }

    public Offerer getPair() {
        return pair;
    }

    public void setPair(Offerer pair) {
        this.pair = pair;
    }

    @Override
    public String toString() {
        return "Element{" +
                "name='" + name + '\'' +
                '}';
    }

    @Override
    public int compareTo(Asker asker) {
        return this.name.compareTo(asker.getName());
    }
}

