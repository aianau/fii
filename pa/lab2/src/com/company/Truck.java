package com.company;


public class Truck extends Vehicle {
    public Truck(String name, Tour tour) {
        super(name, tour);
    }

    @Override
    public String toString() {
        return "Truck{" +
                "name='" + this.getName() + '\'' +
                ", tour=" + this.getTour() +
                '}';
    }
}
