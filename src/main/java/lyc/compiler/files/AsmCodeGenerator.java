package lyc.compiler.files;

import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

import lyc.compiler.main.SymbolTable;
import lyc.compiler.main.Utility;

public class AsmCodeGenerator implements FileGenerator {

    SymbolTable st = SymbolTable.getSymbolTable();
    Utility ut = Utility.getInstance();

    String var;
    String type;
    String numET;

    ArrayList<Integer> listaEtiquetas = new ArrayList<>();
    Stack<String> coProStack = new Stack<>();
    int contPA = 0;

    int COL_NAME = 0;
    int COL_DATA_TYPE = 1;
    int COL_VALUE = 2;
    int COL_LENGTH = 3;

    String op2;
    String op1;
    boolean flagExp = false;

    @Override
    public void generate(FileWriter fileWriter) throws IOException {

        fileWriter.write(".MODEL LARGE\n");
        fileWriter.write(".386\n");
        fileWriter.write(".STACK 200h\n\n");

        fileWriter.write(".DATA\n");

        List<String[]> symbolTable = st.getData();

        for(String[] row :  symbolTable) {

            if(row[COL_DATA_TYPE].equals("Int") || row[COL_DATA_TYPE].equals("String") || row[COL_DATA_TYPE].equals("Float")) {
                fileWriter.write(row[COL_NAME] + "\t" + "dd" + "\t" + "?\n");
            }

            if(row[COL_DATA_TYPE].equals("CTE_INTEGER")) {
                fileWriter.write(row[COL_NAME] + "\t" + "dd" + "\t" + row[COL_VALUE] + ".0" + "\n");
            }

            if(row[COL_DATA_TYPE].equals("CTE_FLOAT")) {
                fileWriter.write(row[COL_NAME] + "\t" + "dd" + "\t" + row[COL_VALUE] + "\n");
            }

            if(row[COL_DATA_TYPE].equals("CTE_STRING")) {
                fileWriter.write(row[COL_NAME] + "\t" + "db" + "\t" + row[COL_VALUE] + "\t" + "$" + row[COL_LENGTH] + "\t" + "dup(?)\n" );
            }

        }

        fileWriter.write("\n\n\n");

        fileWriter.write("\n.CODE\n\n");
        fileWriter.write("MOV AX, @DATA\n");
        fileWriter.write("MOV DS, AX\n");
        fileWriter.write("MOV ES, AX\n\n");

        // Todo : Pasar toda la symbol-table a asm | Revisar los tipos de datos de las variables

        List<String> tokens = Files.readAllLines(Paths.get(".\\examples\\GCI_Assembler.txt"));

        for(String token : tokens) {

            if(listaEtiquetas.contains(contPA))
            {
                fileWriter.write("[et_" + contPA + "]:\n");
            }

            switch(token) {

                case("+"):
                case("-"):
                case("*"):
                case("/"):

                    if(coProStack.size() > 1) {

                        op2 = coProStack.pop();

                        if(op2.matches("[0-9].*")) {
                            op2 = cteIntoVar(op2);
                        }

                        op1 = coProStack.pop();

                        if(op1.matches("[0-9].*")) {
                            op1 = cteIntoVar(op1);
                        }

                        fileWriter.write("fld " + op1 + " \n");
                        fileWriter.write("fld " + op2 + " \n");
                    }
                    else if (coProStack.size() == 1) {

                        var = coProStack.pop();

                        if(var.matches("[0-9].*")) {
                            var = cteIntoVar(var);
                        }

                        fileWriter.write("fld " + var + " \n");

                    }

                    switch(token) {

                        case("+"): fileWriter.write("fadd\n");
                                   break;
                        case("-"): fileWriter.write("fsub\n");
                                   break;
                        case("*"): fileWriter.write("fmul\n");
                                   break;
                        case("/"): fileWriter.write("fdiv\n");
                                   break;
                    }

                    fileWriter.write("ffree 0\n");

                    flagExp = true;

                    break;

                case("="):

                    if(flagExp) {

                        var = coProStack.pop();
                        fileWriter.write("fstp " + var + " \n");
                        flagExp = false;
                    }

                    else {

                        op2 = coProStack.pop();

                        if(op2.matches("[0-9].*")) {
                            op2 = cteIntoVar(op2);
                        }

                        op1 = coProStack.pop();

                        if(op1.matches("[0-9].*")) {
                            op1 = cteIntoVar(op1);
                        }

                        if(op1.charAt(0) == '"' && st.getDataType("_" + op1).equals("CTE_STRING")) {

                            String label = ut.getLabel();
                            fileWriter.write("lea si, " + label + "\n");
                            fileWriter.write("lea si, " + op2 + "\n");
                            fileWriter.write("mov cx, " + op1.length() + "\n");
                            fileWriter.write("rep movsb\n");
                            fileWriter.write("mov al, 0\n");
                            fileWriter.write("stosb\n\n");
                            break;

                        }

                        fileWriter.write("fld " + op1 + " \n");
                        fileWriter.write("fstp " + op2 + " \n\n");
                    }

                    break;

                case("write"):

                    var = coProStack.pop();
                    if(var.indexOf('"') != -1) {
                        var = "_" + var;
                    }

                    type = st.getDataType(var);

                    switch (type) {

                        case "Int":
                        case "Float":
                                 fileWriter.write("DisplayFloat " +  var + "\n");
                                 break;

                        case "String":
                        case "CTE_STRING":
                                  fileWriter.write("displayString " +  var + "\n");
                                  break;
                    }
                    break;

                case("read"):

                    var = coProStack.pop();
                    type = st.getDataType(var);

                    switch (type) {

                        case "Int":
                        case "Float":
                            fileWriter.write("GetFloat " +   var + "\n");

                        case "String":
                            fileWriter.write("getString " +  var + "\n");

                    }

                    break;
                
                case("CMP"):

                    op2 = coProStack.pop();
                    op1 = coProStack.pop();

                    fileWriter.write("fld " + op1 + "\n");
                    fileWriter.write("fld " + op2 + "\n");
                    fileWriter.write("fxch\n");
                    fileWriter.write("fcom\n");
                    fileWriter.write("fstsw ax\n");
                    fileWriter.write("sahf\n");
                    break;

                case("BGE"):
                    numET = tokens.get(contPA + 1);
                    fileWriter.write("jae [et_" + numET + "]");
                    listaEtiquetas.add(Integer.parseInt(numET));
                    break;

                case("BLE"):
                    numET = tokens.get(contPA + 1);
                    fileWriter.write("jna [et_" + numET + "]\n");
                    listaEtiquetas.add(Integer.parseInt(numET));
                    break;

                case("BGT"):
                    numET = tokens.get(contPA + 1);
                    fileWriter.write("ja [et_" + numET + "]\n");
                    listaEtiquetas.add(Integer.parseInt(numET));
                    break;

                case("BLT"):
                    numET = tokens.get(contPA + 1);
                    fileWriter.write("jb [et_" + numET + "]\n");
                    listaEtiquetas.add(Integer.parseInt(numET));
                    break;

                case("BNE"):
                    numET = tokens.get(contPA + 1);
                    fileWriter.write("jne [et_" + numET + "]\n");
                    listaEtiquetas.add(Integer.parseInt(numET));
                    break;

                case("BEQ"):
                    numET = tokens.get(contPA + 1);
                    fileWriter.write("je [et_" + numET + "]\n");
                    listaEtiquetas.add(Integer.parseInt(numET));
                    break;

                case("BI"):
                    numET = tokens.get(contPA + 1);
                    if(Integer.parseInt(numET) < contPA) {
                        fileWriter.write("jmp [INI]\n");

                    }
                    else {
                        fileWriter.write("jmp [et_" + numET + "]\n");
                        listaEtiquetas.add(Integer.parseInt(numET));
                    }

                    break;

                case("INI"):
                    fileWriter.write("[INI]:\n");

                default:
                    coProStack.push(token);

            }

            contPA++;
        }

        if(listaEtiquetas.contains(contPA))
        {
            fileWriter.write("[et_" + contPA + "]:\n");
        }

    }

    public String cteIntoVar(String cte) {
        return "_" + cte;
    }
}


