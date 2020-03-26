package com.company;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Knapsack implements Cloneable {
    private List<Item> items;
    private int capacity;

    public Knapsack(int capacity) {
        this.items = new ArrayList<>();
        this.capacity = capacity;
    }

    public Knapsack(List<Item> items, int capacity) {
        this.items = items;
        this.capacity = capacity;
    }

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }

    public boolean addItem(Item item){
        if (items.contains(item)){
            return false;
        }
        if( capacity < item.weight){
            return false;
        }
        items.add(item);
        capacity -= item.weight;
        return true;
    }

    public List<Item> getItems() {
        return items;
    }

    public void setItems(List<Item> items) {
        this.items = items;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    @Override
    public String toString() {
        List<Item> itemsToPrint = new ArrayList<>(items);
        Collections.sort(itemsToPrint);
        String retString = "Knapsack{\n" +
                            "items=\n";
        for (Item item :
                itemsToPrint) {
            retString +=  "\t" + item.toString() + " " + item.calculateProfitFactor() + '\n';
        }
        return  retString +
                ", capacity=" + capacity +
                '}';
    }
}
