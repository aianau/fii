package com.company;

import java.util.Objects;


public class Client {
    private String name;
    private int time;
    private boolean assigned;

    public boolean isAssigned() {
        return assigned;
    }

    public void setAssigned(boolean assigned) {
        this.assigned = assigned;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getTime() {
        return time;
    }

    public void setTime(int time) {
        this.time = time;
    }

    public Client(String name, int time, boolean assigned) {
        this.name = name;
        this.time = time;
        this.assigned = assigned;
    }

    @Override
    public String toString() {
        return "my Client{" +
                "name='" + name + '\'' +
                ", time=" + time +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Client client = (Client) o;
        return Objects.equals(name, client.name) &&
                Objects.equals(time, client.time);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, time);
    }
}
