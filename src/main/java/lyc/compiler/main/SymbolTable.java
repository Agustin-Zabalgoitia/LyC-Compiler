package lyc.compiler.main;

import lyc.compiler.ParserSym;
import lyc.compiler.model.CompilerException;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

public class SymbolTable {

    private static SymbolTable INSTANCE;

    private List<String[]> data;

    public static final int COL_NAME = 0; // Column NAME index
    public static final int COL_DATA_TYPE = 1; // Column DATA_TYPE index
    public static final int COL_VALUE = 2; // Column VALUE index
    public static final int COL_LENGTH = 3; // Column LENGTH index

    public static SymbolTable getSymbolTable() {

        if(INSTANCE == null) {
            INSTANCE = new SymbolTable();
        }

        return INSTANCE;
    }

    private SymbolTable() {

        data = new ArrayList<>();

    }

    public void addType(String name, String type) {
        Optional<String[]> optionalRow = data.stream()
                .filter(row -> name.equals(row[COL_NAME]))
                .findFirst();

        if (optionalRow.isPresent()) {
            String[] row = optionalRow.get();
            row[COL_DATA_TYPE] = type;
        } else {
            System.out.println("No se encontró una fila con el nombre: " + name);
        }
    }

    public void addSymbol(String value, int type) {

        String[] row = {"" , "" , "" , ""};

        switch (type) {

            case ParserSym.IDENTIFIER:

                row[COL_NAME] = value;
                row[COL_DATA_TYPE] = "-";
                row[COL_VALUE] = "-";
                row[COL_LENGTH] = "-";
                break;

            case ParserSym.INTEGER_CONSTANT:

                row[COL_NAME] = "_" + value;
                row[COL_DATA_TYPE] = "CTE_INTEGER";
                row[COL_VALUE] = value;
                row[COL_LENGTH] = "-";
                break;

            case ParserSym.FLOAT_CONSTANT:

                row[COL_NAME] = "_" + value;
                row[COL_DATA_TYPE] = "CTE_FLOAT";
                row[COL_VALUE] = value;
                row[COL_LENGTH] = "-";
                break;

            case ParserSym.NEGATIVE_CONSTANT:

                row[COL_NAME] = "_" + value;
                row[COL_DATA_TYPE] = "CTE_NEGATIVE_CONSTANT";
                row[COL_VALUE] = value;
                row[COL_LENGTH] = "-";
                break;

            case ParserSym.CTE_S:

                row[COL_NAME] = "_" + value;
                row[COL_DATA_TYPE] = "CTE_STRING";
                row[COL_VALUE] = value;
                row[COL_LENGTH] = "" + value.length();
                break;
        }


        if(isRowDuplicated(row[COL_NAME])) {
            return;
        }

        data.add(row);

    }

    public List<String[]> getData() {
        return data;
    }

    public boolean isRowDuplicated(String col_name) {

        for (String[] row : data) {

            if(row[COL_NAME].equals(col_name)) {
                return true;
            }
        }
        return false;
    }

    public void checkDuplicatedVariable(String id) {

        boolean declared = false;

        for(String[] row : data) {
            if(row[COL_NAME].equals(id) && !(row[COL_DATA_TYPE].equals("-"))) {
                declared = true;
                break;
            }
        }

        if(declared) {
            throw new RuntimeException("La variable \"" + id + "\" ya se encuentra declarada.");
        }
    }

    public void checkUndeclaredVariable(String id) {

        boolean declared = false;

        for(String[] row : data) {
            if(row[COL_NAME].equals(id) && !(row[COL_DATA_TYPE].equals("-"))) {
                declared = true;
                break;
            }
        }

        if(!declared) {
            throw new RuntimeException("La variable \"" + id + "\" no esta declarada y esta siendo usada.");
        }
    }

    public void checkStringAssig(String id) {

        for(String[] row : data) {
            if(row[COL_NAME].equals(id)) {
                if(row[COL_DATA_TYPE].compareTo("String") != 0) {
                    throw new RuntimeException("La variable \"" + id + "\" no es de tipo String");
                }
            }
        }

    }

    public String getDataType(String id) {

        for(String[] row : data) {
            if(row[COL_NAME].equals(id)) {
                return row[COL_DATA_TYPE];
            }
        }

        return null;
    }
}
