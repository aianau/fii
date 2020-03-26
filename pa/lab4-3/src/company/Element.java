package company;

import java.util.ArrayList;
import java.util.List;

public abstract class Element implements Comparable<Element>{
    private String name;
    private Element pair;
    private List<Element> preferredElements;
    private List<Element> offerers;

    public Element(String name) {
        this.name = name;
        this.offerers = new ArrayList<>();
        this.preferredElements = new ArrayList<>();
    }

    public Element(String name, List<Element> preferredElements) {
        this.name = name;
        this.offerers = new ArrayList<>();
        this.preferredElements = new ArrayList<>(preferredElements);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Element getPair() {
        return pair;
    }

    public void setPair(Element pair) {
        // Only set pair if there is a change.
        if (this.pair != pair) {
            // Remove old mates pair.
            if (this.pair != null)
                this.pair.pair = null;

            // Set the new pair.
            this.pair = pair;

            // If new pair is someone, update their pair.
            if (pair != null)
                pair.pair = this;
        }
    }

    public List<Element> getPreferredElements() {
        return preferredElements;
    }

    public void setPreferredElements(List<Element> preferredElements) {
        this.preferredElements = new ArrayList<>(preferredElements);
    }

    public boolean isUnpaired() {
        return pair == null;
    }

    public void propose() {
        if (!preferredElements.isEmpty()) {
            Element pair =  preferredElements.remove(0);
            pair.recieveProposal(this);
        }
    }

    public void recieveProposal(Element offerer) {
        offerers.add(offerer);
    }

    public void chooseMate() {
        for (Element mostDesired : preferredElements) {
            if (mostDesired == pair || offerers.contains(mostDesired)) {
                setPair(mostDesired);
                break;
            }
        }
    }

    @Override
    public String toString() {
        return "Element{" +
                "name='" + name + '\'' +
                ", pair=" + pair.getName() +
                '}';
    }

    @Override
    public int compareTo(Element element) {
        return this.name.compareTo(element.getName());
    }
}

