package com.company;

abstract class Item implements IItem, Comparable<Item>{
    String name;
    int weight;
    double value;

    public Item(String name) {
        this.name = name;
    }

    @Override
    public double calculateProfitFactor() {
        return value/weight;
    }

    @Override
    public int compareTo(Item item) {
//        return this.name.compareTo(item.name);
        return -Double.compare(this.calculateProfitFactor(), item.calculateProfitFactor());
    }
}