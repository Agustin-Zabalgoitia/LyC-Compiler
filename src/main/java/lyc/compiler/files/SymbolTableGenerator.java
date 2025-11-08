package lyc.compiler.files;

import java_cup.runtime.Symbol;
import lyc.compiler.main.SymbolTable;

import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

public class SymbolTableGenerator implements FileGenerator{

    @Override
    public void generate(FileWriter fileWriter) throws IOException {

        int widthName = 25;
        int widthType = 25;
        int widthValue = 25;
        int widthLength = 25;

        SymbolTable st = SymbolTable.getSymbolTable();
        List<String[]> data = st.getData();

        fileWriter.write(buildLine(widthName, widthType, widthValue, widthLength) + "\n");

        fileWriter.write(String.format("| %-"+widthName+"s | %-"+widthType+"s | %-"+widthValue+"s | %-"+widthLength+"s |%n",
                "NOMBRE", "TIPODATO", "VALOR", "LONGITUD"));

        fileWriter.write(buildLine(widthName, widthType, widthValue, widthLength) + "\n");

        for (String[] row : data) {
            fileWriter.write(String.format("| %-"+widthName+"s | %-"+widthType+"s | %-"+widthValue+"s | %-"+widthLength+"s |%n",
                    row[st.COL_NAME], row[st.COL_DATA_TYPE], row[st.COL_VALUE], row[st.COL_LENGTH]));
        }

        fileWriter.write(buildLine(widthName, widthType, widthValue, widthLength) + "\n");

        fileWriter.flush();
    }

    private String buildLine(int... widths) {
        StringBuilder sb = new StringBuilder();
        sb.append("+");
        for (int w : widths) {
            for (int i = 0; i < w + 2; i++) {
                sb.append("-");
            }
            sb.append("+");
        }
        return sb.toString();
    }

}
