package com.company;

public class Food extends Item {
    //    The value of a food is computed as its weight multiplied by 2.
    public Food(String name, int weight) {
        super(name);
        this.weight = weight;
        this.value = weight * 2;
    }

    @Override
    public String toString() {
        return "Food{" +
                "name='" + name + '\'' +
                ", weight=" + weight +
                ", value=" + value +
                '}';
    }
}
