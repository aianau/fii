package sample;

public class Token {
    private final int row;
    private final int column;
    private boolean selected;


    public Token(int row, int column) {
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
