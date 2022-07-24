package com.company;


public abstract class Vehicul implements IVehicul{
    protected String id;
    public String culoare;
    protected int numar_roti;
    protected int numar_scaune;

    @Override
    public void Merge() {
        //print "VRUM VRUM"
    }
}
