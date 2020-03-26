package com.company;

import javafx.util.Pair;

public class Regiune {
    Regiune(Punct p1, Punct p2){
        this.coordonate = new Pair<Punct, Punct>(p1, p2);
    }
    private Pair<Punct, Punct> coordonate;
}

