package com.company;

class Person  implements Comparable<Person>{
    private int code;
    private String name;
    public Person (int code, String name ) {
        this.code = code;
        this.name = name ;
    }
    public String toString () {
        return code + " \t " + name;
    }

    @Override
    public int compareTo(Person o) {
        if (o == null){
            throw new NullPointerException();
        }
        return this.name.compareTo(o.name);
    }
}
class Sorting {
    public static void main (String[] args) {
        Person[] persons = new Person[4];
        persons[0] = new Person (3, " Ionescu ");
        persons[1] = new Person (1, " Vasilescu ");
        persons[2] = new Person (2, " Georgescu ");
        persons[3] = new Person (4, " Popescu ");
        java.util.Arrays.sort(persons);
        System.out.println ("The persons were sorted...");
        for (Person person : persons)
            System.out.println(person);
    }
}