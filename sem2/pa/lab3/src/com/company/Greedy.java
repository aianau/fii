package com.company;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Greedy extends Solution implements Algorithm{
    public Greedy(Knapsack knapsack, List<Item> items) throws CloneNotSupportedException {
        super(knapsack, items);
    }

    @Override
    public boolean solve() {
        for (Item item :
                items) {
            if(knapsack.addItem(item)){
                System.out.println(item);
            }
        }
        return true;
    }
}
