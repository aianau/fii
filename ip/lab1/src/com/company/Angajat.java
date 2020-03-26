package com.company;

public abstract class Angajat implements IOm{
    Angajat(String nume, String rol, float salariu, int copii_acasa){
        this.nume = nume ;
        this.rol= rol;
        this.salariu=salariu ;
        this.copii_acasa =copii_acasa ;
    }
    private String nume;
    private String rol;
    private float salariu;
    private int copii_acasa;

    @Override
    public void Tipa() {
        System.out.println("AAAAAAA");
    }

    @Override
    public void Mananca() {
        System.out.println("Monh mnon monon");

    }

    @Override
    public void Lucreaza() {
        System.out.println("Of ce grea e viata");

    }

    @Override
    public void Moare() {
        System.out.println("Game over");

    }
}

interface IOm {
    public void Tipa();
    public void Mananca();
    public void Lucreaza();
    public void Moare();
}