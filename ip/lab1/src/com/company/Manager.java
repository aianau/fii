package com.company;

public class Manager extends Angajat{
    Manager(String nume, String rol, float salariu, int copii_acasa){
        super(nume, rol, salariu, copii_acasa);
    }
    public void Da_ordine(){
        System.out.println("TU fa aia. TU fa cealalta!");
    }
}
