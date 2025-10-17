package lyc.compiler.files;

import lyc.compiler.SymbolTable;
import lyc.compiler.main.PolishArray;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

public class IntermediateCodeGenerator implements FileGenerator {

    @Override
    public void generate(FileWriter fileWriter) throws IOException {
        PolishArray pa = PolishArray.getPolishArray();
        PrintWriter writer = new PrintWriter(fileWriter);

        writer.printf("%-5s | %-10s%n", "LINEA", "INSTRUCCIÓN");
        writer.println("-----------------------");

        int i = 0;
        for (String str : pa.getArray()) {
            writer.printf("%-5d | %-10s%n", i++, str);
        }

        writer.flush();
    }
}
