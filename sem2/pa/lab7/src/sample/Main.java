package sample;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.geometry.Insets;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/*
* * Compulsory (1p)
* * Create the class Token. An instance of this class will hold a number from 1 to m. Consider the case when a token may be blank, meaning that it can take the place of any number.
* * Create the class Board. An instance of this class will contain n tokens (you may consider the numbers from 1 to n).
* * Create the class Player. Each player will have a name. This class will implement the Runnable interface. In the run method the player will repeatedly extract one token from the board.
* * Create the Game class. Simulate the game using a thread for each player.
* * Pay attention to the synchronization of the threads when extracting tokens from the board.

* * Optional (1p)
* * Make sure that players wait their turns, using a wait-notify approach.
* * Implement a timekeeper thread that runs concurrently with the player threads, as a daemon. This thread will display the running time of the game and it will stop the game if it exceeds a certain time limit. Try it using larger values for n.
* Consider the situation when each player might have a different strategy for extracting a number: automated (random or smart) or manual.
* Player should be an abstract class having as subclasses: RandomPlayer, SmartPlayer, ManualPlayer.
* A "smart" player should try to extend its largest arithmetic progression, while not allowing others to extend theirs. A manual player will use the keyboard. Implement all three strategies.

* Bonus
* Create a simple graphical user interface for the game, using JavaFX.


 */

public class Main extends Application {

    @Override
    public void start(Stage primaryStage) throws Exception{
        Board board = new Board(Stream.of(
                new Token(0, 0),
                new Token(0, 1),
                new Token(0, 2)
        )
                .collect(Collectors.toList()));
        List<Player> players = Stream.of(
                new Player("Andrei", board),
                new Player("Maria", board)
        ).collect(Collectors.toList());

        board.setPadding(new Insets(10, 10, 10, 10));
        board.setVgap(8);
        board.setHgap(10);

        Game game = new Game(players);
        Parent root = FXMLLoader.load(getClass().getResource("sample.fxml"));
        primaryStage.setTitle("lab7");
        primaryStage.setScene(new Scene(root, 600, 675));
        primaryStage.show();

        game.run();

    }


    public static void main(String[] args) {
        launch(args);
    }
}
