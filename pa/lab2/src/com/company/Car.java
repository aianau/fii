package com.company;

public class Car extends Vehicle {


    public Car(String name, Tour tour) {
        super(name, tour);
    }

    @Override
    public String toString() {
        return "Car{" +
                "name='" + this.getName() + '\'' +
                ", tour=" + this.getTour() +
                '}';
    }
}
