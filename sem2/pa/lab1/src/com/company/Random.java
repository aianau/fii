package com.company;

public class Random {
    Random(double min, double max){
        value = Math.random() * (max - min + 1) + min;
    }
    public double getValue(){
        return value;
    }
    private double value;

}
