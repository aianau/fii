package com.company;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public abstract class Solution {
    Knapsack knapsack;
    List<Item> items;

    public Solution(Knapsack knapsack, List<Item> items) throws CloneNotSupportedException {
        this.knapsack = (Knapsack)knapsack.clone();
        this.items =  new ArrayList<>(items);
        Collections.sort(this.items);
    }
}
