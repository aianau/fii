package com.company;


public class Drone extends Vehicle {
    public Drone(String name, Tour tour) {
        super(name, tour);
    }

    @Override
    public String toString() {
        return "Drone{" +
                "name='" + this.getName() + '\'' +
                ", tour=" + this.getTour() +
                '}';
    }
}
