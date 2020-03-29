package sample;

import javax.swing.*;
import java.util.List;
import java.util.TimerTask;

public class Game {
    private List<Player> players;
    private Board board;
    private int timeRemained;

    public Game(List<Player> players) {
        if (players.size() < 2) {
            System.out.println("Provide more than 2 players.");
            System.exit(1);
        }
        this.board = players.get(0).getBoard();
        for (Player player :
                players) {
            if (this.board != player.getBoard()) {
                System.out.println("All players must play on the same board.");
                System.exit(1);
            }
        }

        this.players = players;
        timeRemained = 10;
    }


    //    @Override
    public void run() {
        runTimer();

        int index = Player.getFirstPlayer();
        while (!this.gameEnded()) {
            System.out.println(players.get(index));
            players.get(index).run();
            index = (index + 1) % Player.getIdCount();
        }
        StringBuilder stringBuilder = new StringBuilder();
        Player winner = calculateWinner();
        stringBuilder.append("AAAAnd the winner is: ").append(winner.getName()).append('\n');
        stringBuilder.append("Congrats ").append(winner.getName()).append(" you deserve a cookie.");
        System.out.println(stringBuilder.toString());
    }

    private void runTimer() {
        TimerTask task = new TimerTask() {
            public void run() {

            }
        };
        Timer timer = new Timer(5000, e -> {
            if (timeRemained > 0){
                System.out.println("\nYou have " + timeRemained + " seconds! \n");
                timeRemained -= 5;
            }
            if (timeRemained == 0){
                System.out.println("Game finished. Please input the last move.");
                timeRemained -= 5;
            }
        });
        timer.start();
    }


    private boolean gameEnded() {
        if (timeRemained < 0){
            return true;
        }
        for (Token token :
                board.getTokens()) {
            if (!token.isSelected()) {
                return false;
            }
        }
        return true;
    }

    private Player calculateWinner() {
        Player winner = null;
        int maxPoints = 0;
        int points;
        for (Player player :
                players) {
            points = player.getSelectionHistory().size();
            if (maxPoints < points) {
                winner = player;
                maxPoints = points;
            }
        }
        return winner;
    }
}

