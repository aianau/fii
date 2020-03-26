package com.company;

import java.util.List;

public class Dynamic extends Solution implements Algorithm {
    public Dynamic(Knapsack knapsack, List<Item> items) throws CloneNotSupportedException {
        super(knapsack, items);
    }

    @Override
    public boolean solve() {
        int i, w;
        int n = items.size(), W = knapsack.getCapacity();
        System.out.println();
        int[][] K = new int[n + 1][W + 1];

        for (i = 0; i <= n; i++) {
            for (w = 0; w <= W; w++) {
                if (i == 0 || w == 0)
                    K[i][w] = 0;
                else if (items.get(i - 1).weight <= w)
                    K[i][w] = (int) Math.max(items.get(i - 1).value + K[i - 1][w - items.get(i - 1).weight], K[i - 1][w]);
                else
                    K[i][w] = K[i - 1][w];
            }
        }

        System.out.println("The maximum value that can be put in a knapsack of capacity " + W + " is: " + (K[n][W] - 1));
        return true;
    }
}
