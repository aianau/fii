package com.company;

import java.util.List;
import java.util.Objects;

public class Depot {
    private String name;
    private List<Vehicle> vehicles;

    public Depot(String name, List<Vehicle> vehicles) {
        this.name = name;
        this.vehicles = vehicles;
    }

    public List<Vehicle> getVehicles() {
        return vehicles;
    }

    public void setVehicles(List<Vehicle> vehicles) {
        this.vehicles = vehicles;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Depot depot = (Depot) o;
        return Objects.equals(name, depot.name) &&
                Objects.equals(vehicles, depot.vehicles);
    }

    @Override
    public int hashCode() {
        return 0;
    }

    public boolean addVehicle(Vehicle vehicle) {
        if (vehicles.contains(vehicle)) {
            return false;
        }
        vehicles.add(vehicle);
        return true;
    }
}
