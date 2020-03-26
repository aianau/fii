package com.company;

public class Weapon extends Item {
    public enum WeaponType {
        SWORD("Sword"), KNIFE("Knife"), BOW("Bow");
        private String name;
        private WeaponType(String name) {
            this.name = name;
        }

        @Override
        public String toString(){
            return name;
        }
    }

    //    The name of a weapon is actually its type, described by an enum.
    public Weapon(WeaponType name, int weight, double value) {
        super(name.toString());
        this.weight = weight;
        this.value = value;
    }

    @Override
    public String toString() {
        return "Weapon{" +
                "name='" + name + '\'' +
                ", weight=" + weight +
                ", value=" + value +
                '}';
    }
}
