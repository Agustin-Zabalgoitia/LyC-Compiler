package lyc.compiler.main;

import java.util.ArrayList;
import java.io.FileWriter;
import java.io.IOException;

public class PolishArray {

    // Singleton
    private static PolishArray INSTANCE;

    private int actualPosition;
    private ArrayList<String> pa;

    private PolishArray() {
        pa = new ArrayList<String>();
        actualPosition=0;
    }

    public static PolishArray getInstance() {
        if(INSTANCE == null) {
            INSTANCE = new PolishArray();
        }

        return INSTANCE;
    }

    public void insertar(String value) {
        pa.add(value);
        actualPosition++;
    }

    public void insertarEnPos(int pos , String value) {
        pa.set(pos, value);
    }

    public int getActualPosition() {
        return actualPosition;
    }

    public void avanzar() {
        pa.add("");
        actualPosition++;
    }

    public void exportToFile() {
        try (FileWriter writer = new FileWriter(".\\examples\\GCI.txt")) {

            int cellWidth = 12; // ancho máximo para cada celda

            // Encabezado superior
            writer.write("┌" + "─".repeat(cellWidth));
            for (int i = 1; i < pa.size(); i++) writer.write("┬" + "─".repeat(cellWidth));
            writer.write("┐\n");

            // Índices
            for (int i = 0; i < pa.size(); i++) {
                writer.write(String.format("│%-" + cellWidth + "d", i));
            }
            writer.write("│\n");

            // Separador
            writer.write("├" + "─".repeat(cellWidth));
            for (int i = 1; i < pa.size(); i++) writer.write("┼" + "─".repeat(cellWidth));
            writer.write("┤\n");

            // Valores
            for (String value : pa) {
                // recorto si excede los 12 caracteres
                String v = value.length() > cellWidth ? value.substring(0, cellWidth) : value;
                writer.write(String.format("│%-" + cellWidth + "s", v));
            }
            writer.write("│\n");

            // Línea inferior
            writer.write("└" + "─".repeat(cellWidth));
            for (int i = 1; i < pa.size(); i++) writer.write("┴" + "─".repeat(cellWidth));
            writer.write("┘\n");

            System.out.println("✅ Tabla Polaca generada en: .\\examples\\GCI.txt");

        } catch (IOException e) {
            System.err.println("❌ Error al generar archivo: " + e.getMessage());
        }
    }

    public void exportToAssemblerFile() {
        String filePath = ".\\examples\\GCI_Assembler.txt";

        try (FileWriter writer = new FileWriter(filePath)) {
            for (String value : pa) {
                if (value != null && !value.trim().isEmpty()) {
                    // cada símbolo en su propia línea
                    writer.write(value.trim());
                    writer.write(System.lineSeparator());
                }
            }

            writer.flush();
            System.out.println("✅ Archivo Polaca exportado en formato lineal (listo para traducción ASM): " + filePath);
        } catch (IOException e) {
            System.err.println("❌ Error al exportar archivo ASM: " + e.getMessage());
        }
    }




}

