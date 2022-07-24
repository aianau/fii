package sample;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.control.Button;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.paint.Color;
import javafx.stage.Stage;

import java.util.HashMap;
import java.util.Map;
/*

done - Compulsory (1p)
Create the following components:
* The main frame of the application.
* A configuration panel for introducing parameters regarding the shapes that will be drawn: the size, the number of sides, the stroke, etc.
* The panel must be placed at the top part of the frame. The panel must contain at least one label and one input component for specifying the size of the component.
* A canvas (drawing panel) for drawing various types of shapes: circles, squares, regular polygons, snow flakes, etc. You must implement at least one shape type. This panel must be placed in the center part of the frame.
* When the users executes mouse pressed operation, a shape must be drawn at the mouse location. You must use the properties defined in the configuration panel (at least one) and generate random values for others (color, etc.).
* A  control panel for managing the image being created. This panel will contains the buttons: Load, Save, Reset, Exit and it will be placed at the bottom part of the frame.
done - Optional (1p)
* Add support for drawing multiple types of components. Consider creating a new panel, containing a list of available shapes. The configuration panel must adapt according to the type of the selected shape. Implement at least two types of shapes.
* Use a file chooser in order to specify the file where the image will be saved (or load).
* Implement the retained mode drawing and add support for deleting shapes.

NOT done yet - Bonus
* Add support for drawing graphs: nodes and edges.
* Implement a layout algorithm for "pretty" drawing of a graph. The algorithm will take as input the graph you have defined in the interface and will redraw it in a "pretty" format. For example, you may implement a force directed graph drawing algorithm or other approaches. You may also take a look at graphdrawing.org.
 */


public class Main extends Application {

    public enum Shapes {
        CIRCLE("circle"),
        RECTANGLE("rectangle");

        public final String label;
        private static final Map<String, Shapes> BY_LABEL = new HashMap<>();

        Shapes(String label) {
            this.label = label;
        }

        static {
            for (Shapes e : values()) {
                BY_LABEL.put(e.label, e);
            }
        }

        public static Shapes valueOfLabel(String label) {
            return BY_LABEL.get(label);
        }

        @Override
        public String toString() {
            return this.label;
        }
    }

    @Override
    public void start(Stage window) throws Exception {
//        Parent root = FXMLLoader.load(getClass().getResource("sample.fxml"));
        window.setTitle("Lab6 PA");
        window.setMinWidth(500);
        window.setMinHeight(500);

        BorderPane borderPane = new BorderPane();
        Scene scene = new Scene(borderPane);

        HBox topMenu = new HBox();
        topMenu.setPadding(new Insets(10));
        Label sizeLabel = new Label("size");
        TextField sizeField = new TextField("10");

        ChoiceBox<String> shapeChoiceBox = new ChoiceBox<>();
        Shapes.BY_LABEL.forEach((k, v) -> {
            shapeChoiceBox.getItems().add(k);
        });
        shapeChoiceBox.setValue(Shapes.CIRCLE.label);
        ChoiceBox<String> colourChoiceBox = new ChoiceBox<>();
        colourChoiceBox.getItems().addAll("red", "blue", "black", "background");
        colourChoiceBox.setValue("black");
        topMenu.getChildren().addAll(sizeLabel, sizeField, shapeChoiceBox, colourChoiceBox);

        HBox bottomMenu = new HBox();
        bottomMenu.setPadding(new Insets(10));
        Button saveButton = new Button("save");
        Button loadButton = new Button("load");
        Button exitButton = new Button("exit");
        Button resetButton = new Button("reset");

        // TODO cum fac ca fiecare butin sa aiba o anumita proprietate? Un fel de decarator pattern.
        bottomMenu.getChildren().addAll(saveButton, loadButton, resetButton, exitButton);

        Canvas canvas = new Canvas();
        // TODO cum iau marimea parintelui sau cel putin vreu sa fac cat de mare se poate automat?
        canvas.setWidth(400);
        canvas.setHeight(400);

        GraphicsContext gc = canvas.getGraphicsContext2D();
        canvas.setOnMouseClicked(e -> {
            try {
                Color color;
                int size = Integer.parseInt(sizeField.getText());
                if (colourChoiceBox.getValue().equals("background")) {
                    color = Color.valueOf("F4F4F4");
                } else {
                    color = Color.valueOf(colourChoiceBox.getValue());

                }
                gc.setFill(color);

                if (Shapes.valueOfLabel(shapeChoiceBox.getValue()) == Shapes.CIRCLE) {
                    gc.fillOval(e.getX() - 4, e.getY() - 4, size, size);

                }
                if (Shapes.valueOfLabel(shapeChoiceBox.getValue()) == Shapes.RECTANGLE) {
                    gc.fillRect(e.getX() - 4, e.getY() - 4, size, size);
                }
            } catch (NumberFormatException exception) {
                exception.printStackTrace();
            }
        });

        resetButton.setOnAction(e -> {
            gc.clearRect(0, 0, canvas.getWidth(), canvas.getHeight());
        });
        exitButton.setOnAction(e -> {
            window.close();
        });
        loadButton.setOnAction(new LoadCanvasEvent(window, canvas, gc));
        saveButton.setOnAction(new SaveCanvasEvent(window, canvas));


        borderPane.setTop(topMenu);
        borderPane.setBottom(bottomMenu);
        borderPane.setCenter(canvas);
        window.setScene(scene);
        window.show();
    }

    public static void main(String[] args) {
        launch(args);
    }
}
