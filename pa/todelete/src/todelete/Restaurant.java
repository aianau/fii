package todelete;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Restaurant {


    public static void main(String[] args) {


    }

    static int[] getMin(int[] timpi, int timpPersoana) {
        int[] deR = new int[timpi.length];
        int[] specs = new int[timpi.length];
        for (int i = 0; i < timpi.length; i++){
            specs[i] = timpi[i];
        }
        sort(specs);
        for (int i = 0; i < specs.length; i++) {
            if (timpPersoana >= specs[i]) {
                timpPersoana = timpPersoana - specs[i];
                deR[i] = specs[i];
            }
        }
        return deR;
    }

    private static void sort(int[] elemente) {
        int n = elemente.length;
        boolean swap;
        for (int i = 0; i < n - 1; i++) {
            swap = false;
            for (int j = 0; j < n - i - 1; j++) {
                if (elemente[j + 1] < elemente[j]) {
                    int temp = elemente[j];
                    elemente[j] = elemente[j + 1];
                    elemente[j + 1] = temp;
                    swap = true;
                }
            }
            if (swap == false)
                break;
        }
    }
}