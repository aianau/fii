package todelete;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<Integer> test = new ArrayList<>();
        for (int i = 0; i < 10; ++i) {
            test.add(i);
        }
        Collections.sort(test);
        test.forEach(System.out::println);
    }
}
