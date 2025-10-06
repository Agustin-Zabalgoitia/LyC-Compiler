package lyc.compiler.files;

import lyc.compiler.SymbolTable;
import lyc.compiler.main.PolishArray;

import java.io.FileWriter;
import java.io.IOException;

public class IntermediateCodeGenerator implements FileGenerator {

    @Override
    public void generate(FileWriter fileWriter) throws IOException {
        PolishArray pa = PolishArray.getPolishArray();
        for (String str : pa.getArray()) {
            fileWriter.write(String.format("%s\n", str));
        }
    }
}
