package com.company;

public class Book extends Item{
    int numberPages;

    public Book(String name, double value, int numberPages) {
        super(name);
        this.numberPages = numberPages;
        this.weight = numberPages / 100;
        this.value = value;
    }

    @Override
    public String toString() {
        return "Book{" +
                "name='" + name + '\'' +
                ", weight=" + weight +
                ", value=" + value +
                ", numberPages=" + numberPages +
                '}';
    }
}