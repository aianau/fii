package company;


public abstract class Offerer implements Comparable<Offerer>{
    private String name;
    private Asker pair;

    public Offerer(String name) {
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

    public Asker getPair() {
        return pair;
    }

    public void setPair(Asker pair) {
        this.pair = pair;
        pair.setPair(this);
    }

    @Override
    public String toString() {
        return "Element{" +
                "name='" + name + '\'' +
                '}';
    }

    @Override
    public int compareTo(Offerer offerer) {
        return this.name.compareTo(offerer.getName());
    }
}

