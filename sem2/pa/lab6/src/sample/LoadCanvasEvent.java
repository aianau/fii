package sample;

import javafx.embed.swing.SwingFXUtils;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.image.Image;
import javafx.scene.image.WritableImage;
import javafx.stage.FileChooser;
import javafx.stage.Stage;

import javax.imageio.ImageIO;
import java.awt.image.RenderedImage;
import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LoadCanvasEvent implements EventHandler<ActionEvent> {
    private Stage window;
    private Canvas canvas;
    private GraphicsContext gc;

    public LoadCanvasEvent(Stage window, Canvas canvas, GraphicsContext gc) {
        this.window = window;
        this.canvas = canvas;
        this.gc = gc;
    }

    @Override
    public void handle(ActionEvent actionEvent) {
        FileChooser fileChooser = new FileChooser();

        FileChooser.ExtensionFilter extFilter =
                new FileChooser.ExtensionFilter("png files (*.png)", "*.png");
        fileChooser.getExtensionFilters().add(extFilter);

        File file = fileChooser.showOpenDialog(window);
        if (file != null) {
            Image image = new Image("file:\\" + file.getPath());
            gc.drawImage(image, 0, 0, canvas.getWidth(), canvas.getHeight());
        }
    }
}
