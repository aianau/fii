package sample;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Player implements Runnable {
    private static int idCount = 0;

    private String name;
    private int id;
    private Board board;
    private List<Token> selectionHistory;

    public Player(String name, Board board) {
        this.name = name;
        this.id = idCount;
        idCount++;
        this.board = board;
        this.selectionHistory = new ArrayList<>();
    }

    public List<Token> getSelectionHistory() {
        return selectionHistory;
    }

    public Board getBoard() {
        return board;
    }

    public String getName() {
        return name;
    }

    public int getId() {
        return id;
    }

    public static int getFirstPlayer() {
        return 0;
    }

    public static int getIdCount() {
        return idCount;
    }

    @Override
    public void run() {
        Scanner in = new Scanner(System.in);
        int row = 0, column = 0;
        String input;
        boolean good = true;
        boolean selected = false;

        do{


            try{
                selected = this.getBoard().getToken(row, column).isSelected();
            }catch (Exception e) {
                System.out.println("Input valid number, try again.");
            }
        }while (selected);

        Token token = this.getBoard().selectToken(this, row, column);
        if (token != null){
            this.getSelectionHistory().add(token);
        }
    }


    @Override
    public String toString() {
        return "Player{" +
                "name='" + name + '\'' +
                ", id=" + id +
                '}';
    }
}
