package com.company;

public class Secretar extends Angajat {
    Secretar(String nume, String rol, float salariu, int copii_acasa){
        super(nume, rol, salariu, copii_acasa);
    }
    public void Ordoneaza_acte(){
        System.out.println("Mai ce frumos e sa ordonez acte");
    }
}
