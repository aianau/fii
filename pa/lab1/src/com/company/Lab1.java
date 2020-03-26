package com.company;

import javax.swing.*;
import java.util.Random;

public class Lab1 {
    private int sum(int n) {
        while (n > 9) {
            int x = n;
            int sum = 0;
            while (x != 0) {
                sum += x % 10;
                x /= 10;
            }
            n = sum;
        }
        return n;
    }

    private int createNumber() {
        int n = (int) (Math.random() * 1_000_000);
//        multiply n by 3;
//        add the binary number 10101 to the result;
//        add the hexadecimal number FF to the result;
//        multiply the result by 6;
        n = n * 3;
        n += (0b10101);
        n += (0xFF);
        n = n * 6;
        return n;
    }

    public void comp() {
        String[] languages = {"C", "C++", "C#", "Python", "Go", "Rust", "JavaScript", "PHP", "Swift", "Java"};
        int n = createNumber();
        int result = sum(n);
        System.out.println("Willy-nilly, this semester I will learn " + languages[result]);
    }

    public void opt1(String[] args) {
        Integer n = new Integer(0), k = new Integer(0);
        char[] alphabet = new char[args.length - 2];
        try {
            n = Integer.valueOf(args[0]);
            k = Integer.valueOf(args[1]);
        } catch (NumberFormatException e) {
            System.out.println("Unable to parse input. Wrong input.");
            System.out.println("Error" + e.toString());
        } finally {
            System.out.println("n: " + n.toString());
            System.out.println("k: " + k.toString());
        }
        for (int i = 2; i < args.length; ++i) {
            alphabet[i - 2] = args[i].charAt(0);
        }

        String[] words = new String[n];
        boolean[][] relation = new boolean[n][n];
        for (int i = 0; i < n; ++i) {
            words[i] = createRandomWord(k, alphabet);
            System.out.println("word[" + i + "]: " + words[i]);
        }

        for (int i = 0; i < words.length; ++i) {
            for (int j = 0; j < words.length; ++j) {
                relation[i][j] = areNeighbours(words[i], words[j]);
            }
        }

        int minNeighbours, maxNeighbours;
        int[] relationNeighbourNumber = new int[relation.length];
        relationNeighbourNumber[0] = minNeighbours = maxNeighbours = calculateNeighboursNumber(relation[0], relation.length);
        boolean equality = true;
        for (int i = 1; i < relation.length; ++i) {
            int neighboursNumber = calculateNeighboursNumber(relation[i], relation.length);
            if (minNeighbours > neighboursNumber) {
                minNeighbours = neighboursNumber;
            }
            if (maxNeighbours < neighboursNumber) {
                maxNeighbours = neighboursNumber;
            }
            relationNeighbourNumber[i] = neighboursNumber;
        }
        for (int i = 1; i < relation.length; ++i) {
            if (relationNeighbourNumber[0] != relationNeighbourNumber[i]) {
                equality = false;
                break;
            }
        }

        System.out.println("Most neighbours: " + maxNeighbours);
        System.out.println("Least neighbours: " + minNeighbours);
        if (equality) {
            System.out.println("Are all neighbours the same?: YES");
        } else {
            System.out.println("Are all neighbours the same?: NO");
        }
        System.out.println("Is conex?: " + isConex(relation));
    }

    private int calculateNeighboursNumber(boolean[] row, int len) {
        int sum = 0;
        for (int i = 0; i < len; ++i) {
            sum += i;
        }
        return sum;
    }

    private boolean areNeighbours(String str1, String str2) {
        for (int i = 0; i < str1.length(); i++) {
            for (int j = 0; j < str2.length(); j++) {
                if (str1.charAt(i) == str2.charAt(j)) {
                    return true;
                }
            }
        }
        return false;
    }

    private String createRandomWord(int len, char[] alphabet) {
        StringBuilder word = new StringBuilder();
        Random rand = new Random();
        for (int i = 0; i < len; i++) {
            int k = rand.nextInt(alphabet.length);
            word.append(alphabet[k]);
        }
        return word.toString();
    }

    private boolean isConex(boolean[][] relation) {
        boolean[] visited = new boolean[relation[0].length];
        dfs(0, relation, visited);
        for (int i = 0; i < relation[0].length; ++i) {
            if (!visited[i]) {
                return false;
            }
        }
        return true;
    }

    private void dfs(int currentNode, boolean[][] relation, boolean[] visited) {
        if (!visited[currentNode]) {
            visited[currentNode] = true;
            for (int i = 0; i < relation[currentNode].length; ++i) {
                if (relation[currentNode][i]) {
                    dfs(i, relation, visited);
                }
            }
        }
    }
}
