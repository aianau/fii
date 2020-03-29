package sample;

import javafx.scene.layout.GridPane;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class Board extends GridPane {
    private List<Token> tokens;
    private int playersTurn;

    public Board(List<Token> tokens) {
        this.playersTurn = Player.getFirstPlayer();
        this.tokens = tokens;
    }

    public List<Token> getTokens() {
        return tokens;
    }

    public Token getToken(int row, int column) {
        for (Token token:
                tokens) {
            if (row == token.getRow() && column == token.getColumn()){
                return token;
            }
        }
        return null;
    }

    public synchronized Token selectToken(Player player, int row, int column){
        Token selected = null;
        while (this.playersTurn != player.getId()){
            try{
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        for (Token token:
             tokens) {
            if (row == token.getRow() && column == token.getColumn()){
                token.setSelected(true);
                selected = token;
                break;
            }
        }

        this.playersTurn = (this.playersTurn + 1) % Player.getIdCount();
        notifyAll();
        return selected;
    }
}
