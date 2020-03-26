package com.company;

import java.util.TreeSet;

public class Resident extends Asker{
    public Resident(String name) {
        super(name);
    }

    @Override
    public String toString() {
        return "Resident{" +
                "name='" + this.getName() + '\'' +
                '}';
    }
}
