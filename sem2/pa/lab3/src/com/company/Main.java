package com.company;
//    The (Elder) Knapsack Problem
//    Write an application that can model and solve the knapsack problem.
//    Consider a knapsack of a given capacity and a set of items that could be added in the knapsack, for example books,
//    food, weapons, etc. Each item has at least the following properties: a name, a weight and a value.
//
////    The profit factor of an item is defined as value / weight.
//    The problem is to determine what items to include in the knapsack such that:
//
//    the total weight of the selected items is less than or equal to the capacity and
//    the total value is as large as possible.
//    Example:
//    capacity of the knapsack = 10
//    available items:
//    book1: Dragon Rising, weight = 3, value = 5 (profit factor = 1.66)
//    book2: A Blade in the Dark, weight = 3, value = 5
//    food1: Cabbage, weight = 2, value = 4 (profit factor = 2)
//    food2: Rabbit, weight = 2, value = 4
//    weapon: Sword, weight = 5, value = 10 (profit factor = 2)
//    selected items: weapon, book1, food1 (total weight=10, total value=19)
//    The main specifications of the application are:

//  Create an object-oriented model of the problem. You should have at least the following: the interface Item, and the classes Book, Food,
// Weapon, Knapsack.
//  The classes Book, Food and Weapon should implement the interface Item. The interface should have at least one default method, for example
// profitFactor.
//  Create and print on the screen the instance of the problem described in the previous example. When printing the content of the knapsack,
// the items must be ordered according to their name (the natural order).

import java.util.*;
import java.util.logging.SimpleFormatter;



public class Main {
//    capacity of the knapsack = 10
    //    available items:
//    book1: Dragon Rising, weight = 3, value = 5 (profit factor = 1.66)
//    book2: A Blade in the Dark, weight = 3, value = 5
//    food1: Cabbage, weight = 2, value = 4 (profit factor = 2)
//    food2: Rabbit, weight = 2, value = 4
//    weapon: Sword, weight = 5, value = 10 (profit factor = 2)
//    selected items: weapon, book1, food1 (total weight=10, total value=19)
    public static void main(String[] args) throws CloneNotSupportedException {
        Knapsack knapsack = new Knapsack(10);
        List<Item> items = new ArrayList<>();
        Book dragon_rising = new Book("Dragon Rising", 5.0, 300);
        items.add(dragon_rising);
        items.add(new Book("A Blade in the Dark", 5.0, 300));
        items.add(new Food("Cabbage", 2));
        items.add(new Food("Rabbit", 5));
        items.add(new Weapon(Weapon.WeaponType.SWORD, 5, 10.0));

//        knapsack.addItem(new Book("Dragon Rising", 5.0, 300));
//        knapsack.addItem(new Book("A Blade in the Dark", 5.0, 300));
//        knapsack.addItem(new Food("Cabbage", 2));
//        knapsack.addItem(new Food("Rabbit", 5));
//        knapsack.addItem(new Weapon(Weapon.WeaponType.SWORD, 5, 10.0));

//        System.out.println(knapsack);

//        for (int i = 0; i < 10_000; ++i){
//            items.add()
//        }

        Greedy greedySol = new Greedy(knapsack, items);
        greedySol.solve();
        Dynamic dynamicSol = new Dynamic(knapsack, items);
        dynamicSol.solve();
    }
}