package com.company;

import java.util.ArrayList;
import java.util.List;

public class Hospital extends Offerer{
    private int capacity;

    public Hospital(String name, int capacity) {
        super(name);
        this.capacity = capacity;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    @Override
    public String toString() {
        return "Hospital{" +
                "name=" + this.getName() +
                ", capacity=" + capacity +
                '}';
    }
}
