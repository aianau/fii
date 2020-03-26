package company;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Main {

    public static void main(String[] args) throws CloneNotSupportedException {


        Resident andrei = new Resident("andrei");
        Resident ana = new Resident("ana");
        Resident cosmin = new Resident("cosmin");
        Resident gigi = new Resident("gigi");

        Hospital spital1 = new Hospital("spital1", 1);
        Hospital spital2 = new Hospital("spital2", 2);
        Hospital spital3 = new Hospital("spital3", 2);

        List<Asker> residents =
                Stream.of(andrei, ana, cosmin, gigi)
                .sorted()
                .collect(Collectors.toList());

        List<Offerer> hospitals =
                Stream.of(spital1, spital2, spital3)
                .collect(Collectors.toList());

//        System.out.println(residents);
//        System.out.println(hospitals);

        Map<Asker, List<Offerer>> residentPreferences = new HashMap<>();
        residentPreferences.put(andrei, Stream.of(spital1, spital2, spital3)
                .collect(Collectors.toList()));
        residentPreferences.put(ana, Stream.of(spital1, spital2, spital3)
                .collect(Collectors.toList()));
        residentPreferences.put(cosmin, Stream.of(spital1, spital2)
                .collect(Collectors.toList()));
        residentPreferences.put(gigi, Stream.of(spital1, spital3)
                .collect(Collectors.toList()));

        Map<Offerer, List<Asker>> hospitalPrefferences = new TreeMap<>();
        hospitalPrefferences.put(spital1, Stream.of(gigi, andrei, ana, cosmin)
                .collect(Collectors.toList()));
        hospitalPrefferences.put(spital2, Stream.of(andrei, cosmin, ana)
                .collect(Collectors.toList()));
        hospitalPrefferences.put(spital3, Stream.of(andrei, ana, gigi)
                .collect(Collectors.toList()));

//        System.out.println(residentPreferences);
//        System.out.println(hospitalPrefferences);

//        residentPreferences.keySet()
//                .stream()
//                .filter(x -> {return residentPreferences.get(x).contains(spital1) && residentPreferences.get(x).contains(spital3);})
//                .forEach(System.out::println);
//
//        hospitalPrefferences.keySet()
//                .stream()
//                .filter(x -> {return hospitalPrefferences.get(x).get(0).compareTo(andrei) == 0;})
//                .forEach(System.out::println);

        Problem problem = new Problem(hospitalPrefferences, residentPreferences);
        Matching matching = new Matching(problem);
        matching.solve();
        System.out.println(matching.isStable());


    }
}
