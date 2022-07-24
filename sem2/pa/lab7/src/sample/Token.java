package sample;

import javafx.scene.paint.Paint;
import javafx.scene.shape.Circle;

public class Token extends Circle {

    private static final Paint notSelectedPaint = Paint.valueOf("#9ac47a");
    private static final Paint selectedPaint = Paint.valueOf("#aa4bcc");

    private final int row;
    private final int column;

    private boolean selected;

    public Token(int row, int column) {
        super(row, column, 20, notSelectedPaint);

        this.setOnMouseClicked(e->{
            this.setFill(selectedPaint);
        });

        this.row = row;
        this.column = column;
        this.selected = false;
    }

    public int getRow() {
        return row;
    }

    public int getColumn() {
        return column;
    }

    public boolean isSelected() {
        return selected;
    }

    public void setSelected(boolean selected) {
        this.selected = selected;
    }

    @Override
    public String toString() {
        return "Token{" +
                "row=" + row +
                ", column=" + column +
                ", selected=" + selected +
                '}';
    }
}
