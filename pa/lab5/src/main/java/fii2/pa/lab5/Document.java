package fii2.pa.lab5;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

public class Document implements Serializable {
    private String id;
    private String name;
    private String location;
    private List<Map<String, String>> tags;

    public Document(String id, String name, String location) {
        this.id = id;
        this.name = name;
        this.location = location;
    }

    public boolean addTag(Map<String, String> tag){
        this.tags.add(tag);
        return true;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getLocation() {
        return location;
    }

    public List<Map<String, String>> getTags() {
        return tags;
    }
}
