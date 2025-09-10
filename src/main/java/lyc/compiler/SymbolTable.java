package lyc.compiler;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class SymbolTable {
    private static SymbolTable INSTANCE;

    private List<String[]> data;

    public static final int COL_NAME = 0; // Column NAME index
    public static final int COL_DATA_TYPE = 1; // Column DATA_TYPE index
    public static final int COL_VALUE = 2; // Column VALUE index
    public static final int COL_LENGTH = 3; // Column LENGTH index

    /*
     * Prevent initialization of other instances by forcing the use of
     * getSymbolTable instead of SymbolTable()
     * 
     * @return the only instance of the SymbolTable class
     */
    public static SymbolTable getSymbolTable() {
        if (INSTANCE == null)
            INSTANCE = new SymbolTable();

        return INSTANCE;
    }

    private SymbolTable() {
        data = new ArrayList<>();
    }

    public boolean isRowInTable(String[] newRow) {

        for (String[] row : data) {
            if (Arrays.equals(row, newRow))
                return true;
        }

        return false;
    }

    public void add(String value, int type) {
        String row[] = { "", "", "", "" };
        switch (type) {
            case ParserSym.ID:
                row[COL_NAME] = value;
                row[COL_VALUE] = "—";
                break;
            case ParserSym.CTE_E:
                row[COL_NAME] = "_0x" + Integer.toHexString(Integer.parseInt(value));
                row[COL_VALUE] = value;
                break;
            case ParserSym.CTE_S:
                row[COL_LENGTH] = "" + value.length();
            case ParserSym.CTE_F:
                row[COL_NAME] = "_" + value;
                row[COL_VALUE] = value;
            default:
                break;
        }
        if (isRowInTable(row))
            return;

        data.add(row);
    }

    public List<String[]> getTable() {
        return data;
    }

}