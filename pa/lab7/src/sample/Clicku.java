package sample;

import javafx.scene.paint.Paint;
import javafx.scene.shape.Circle;

public class Clicku extends Circle {
    private static final Paint notSelected = Paint.valueOf("#9ac47a");
    private static final Paint selected = Paint.valueOf("#aa4bcc");

    private Token token;

    public Clicku(double x, double y, Token token) {
        super(x, y, 20, notSelected);
        this.token = token;
        this.setOnMouseClicked(e->{
            this.setFill(selected);
        });
    }
}
