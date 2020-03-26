package com.company;

public class Sectie extends Firma{
    Sectie(String nume, int numar_angajati, Regiune regiune){
        this.nume = nume;
    }
    String nume;
    int numar_angajati;
    Regiune regiune;
    Angajat[] angajati;
    Vehicul[] vehicule;
}

