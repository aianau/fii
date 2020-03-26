package com.company;

import javafx.util.Pair;

import java.util.ArrayList;
import java.util.List;

public class Partition {
    private List<Pair<Offerer, Asker>> pairs;

    public Partition() {
        this.pairs = new ArrayList<>();
    }

    public List<Pair<Offerer, Asker>> getPairs() {
        return pairs;
    }

    public void setPairs(List<Pair<Offerer, Asker>> pairs) {
        this.pairs = pairs;
    }

    public void addPair(Pair<Offerer, Asker> pair){
        this.pairs.add(pair);
    }
}
