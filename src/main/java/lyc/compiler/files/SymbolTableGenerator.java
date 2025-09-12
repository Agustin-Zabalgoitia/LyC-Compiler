package lyc.compiler.files;

import java.io.FileWriter;
import java.io.IOException;

import lyc.compiler.SymbolTable;

public class SymbolTableGenerator implements FileGenerator {

    @Override
    public void generate(FileWriter fileWriter) throws IOException {
        SymbolTable st = SymbolTable.getSymbolTable();
        fileWriter.write("Nombre, TipoDato, Valor, Longitud\n");
        for (String[] row : st.getTable()) {
            for (int i = 0; i < row.length; i++)
                fileWriter.write(String.format("%s, ", row[i]));
            fileWriter.write("\n");
        }
    }
}