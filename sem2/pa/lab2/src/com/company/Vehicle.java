package com.company;

public abstract class Vehicle {
    private String name;
    private Tour tour;

    public Vehicle(String name, Tour tour) {
        this.name = name;
        this.tour = tour;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Tour getTour() {
        return tour;
    }

    public void setTour(Tour tour) {
        this.tour = tour;
    }

    @Override
    public String toString() {
        return "Vehicle{" +
                "name='" + name + '\'' +
                ", tour=" + tour +
                '}';
    }

}
