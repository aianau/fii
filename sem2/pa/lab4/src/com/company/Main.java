package com.company;

import com.sun.source.tree.Tree;
import org.w3c.dom.ls.LSOutput;
import java.security.interfaces.ECKey;
import java.sql.ResultSet;
import java.sql.SQLOutput;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collector;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class Main {

    public static void main(String[] args) throws CloneNotSupportedException {

//        Faker faker = new Faker();
//        System.out.println(faker.name());
//        System.out.println(faker.name());
//        System.out.println(faker.name());
//        System.out.println(faker.name());
//        System.out.println(faker.name());
//        System.out.println(faker.name());
//        System.out.println(faker.name());
        Resident andrei = new Resident("andrei");
        Resident ana = new Resident("ana");
        Resident cosmin = new Resident("cosmin");
        Resident gigi = new Resident("gigi");

        Hospital spital0 = new Hospital("spital0", 1);
        Hospital spital1 = new Hospital("spital1", 2);
        Hospital spital2 = new Hospital("spital2", 2);

        List<Asker> residents =
                Stream.of(andrei, ana, cosmin, gigi)
                .sorted()
                .collect(Collectors.toList());

        List<Offerer> hospitals =
                Stream.of(spital0, spital1, spital2)
                .collect(Collectors.toList());

//        System.out.println(residents);
//        System.out.println(hospitals);

        Map<Asker, List<Offerer>> residentPreferences = new HashMap<>();
        residentPreferences.put(andrei, Stream.of(spital0, spital1, spital2)
                .collect(Collectors.toList()));
        residentPreferences.put(ana, Stream.of(spital0, spital1, spital2)
                .collect(Collectors.toList()));
        residentPreferences.put(cosmin, Stream.of(spital0, spital1)
                .collect(Collectors.toList()));
        residentPreferences.put(gigi, Stream.of(spital0, spital2)
                .collect(Collectors.toList()));

        Map<Offerer, List<Asker>> hospitalPrefferences = new TreeMap<>();
        hospitalPrefferences.put(spital0, Stream.of(gigi, andrei, ana, cosmin)
                .collect(Collectors.toList()));
        hospitalPrefferences.put(spital1, Stream.of(andrei, cosmin, ana)
                .collect(Collectors.toList()));
        hospitalPrefferences.put(spital2, Stream.of(andrei, ana, gigi)
                .collect(Collectors.toList()));

//        System.out.println(residentPreferences);
//        System.out.println(hospitalPrefferences);

//        residentPreferences.keySet()
//                .stream()
//                .filter(x -> {return residentPreferences.get(x).contains(spital1) && residentPreferences.get(x).contains(spital2);})
//                .forEach(System.out::println);
//
//        hospitalPrefferences.keySet()
//                .stream()
//                .filter(x -> {return hospitalPrefferences.get(x).get(0).compareTo(andrei) == 0;})
//                .forEach(System.out::println);

        Problem problem = new Problem(hospitalPrefferences, residentPreferences);
        Matching matching = new Matching(problem);
        matching.solve();
        matching.showSolution();
        System.out.println("Is stable?: " + matching.isStable());


    }
}
