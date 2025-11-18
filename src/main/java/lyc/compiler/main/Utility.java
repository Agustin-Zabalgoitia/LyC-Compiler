package lyc.compiler.main;

import java.util.Stack;

public class Utility {

    // Singleton
    private static Utility INSTANCE;

    private Utility() {}

    public static Utility getInstance() {

        if (INSTANCE == null) {
            INSTANCE = new Utility();
        }

        return INSTANCE;
    }

    private Stack<String> idStack = new Stack<>();
    private Stack<String> typeStack = new Stack<>();
    private Stack<String> intTypeStack = new Stack<>();
    private Stack<String> floatTypeStack = new Stack<>();
    private Stack<String> paStack = new Stack<>();
    private Stack<String> auxStack = new Stack<>();
    private Stack<Integer> conditionStack = new Stack<>();
    private Stack<String> whileStack = new Stack<>();
    private String auxCmp;
    private int lbl = 1;
    private int lbl_2 = 1;
    
    //TODO: Experimentacion de EqualExpressions, totalmente debatible implementacion de GCI
    private int EE_cont = 0;
    public int getEECont() { return EE_cont; }
    public void increaseEECont() { EE_cont++; }
    
    // apilar
    public void apilarId(String id) {
        idStack.push(id);
    }
    public void apilarType(String type) { typeStack.push(type); }
    public void apilarIntType(String type) { intTypeStack.push(type); }
    public void apilarFloatType(String type) { floatTypeStack.push(type); }
    public void apilarPa(String pa) { paStack.push(pa); }
    public void apilarAux(String aux) { auxStack.push(aux); }
    public void apilarConditionStack(int pos) { conditionStack.push(pos); }
    public void apilarWhileStack(String etq) { whileStack.push(etq); }

    // desapilar
    public String desapilarId() { return idStack.pop(); }
    public String desapilarType() { return typeStack.pop(); }
    public String desapilarPa() { return paStack.pop(); }
    public String desapilarAux() { return auxStack.pop(); }
    public Integer desapilarConditionStack() { return  conditionStack.pop(); }
    public String desapilarWhileStack() { return whileStack.pop(); }

    // vaciar
    public void vaciarIntType() { intTypeStack = new Stack<>(); }
    public void vaciarFloatType() { floatTypeStack = new Stack<>(); }

    // getters
    public Stack<String> getIdStack () { return idStack; }
    public Stack<String> getIntTypeStack () { return intTypeStack; }
    public Stack<String> getFloatTypeStack() { return floatTypeStack; }
    public Stack<String> getPaStack () { return paStack; }
    public Stack<String> getAuxStack () { return auxStack; }
    public Stack<Integer> getConditionStack () { return conditionStack; }

    public boolean notEmptyTypeStacks() {

        if(!intTypeStack.empty() && !floatTypeStack.empty()) {
            return true;
        }
        return false;
    }

    public boolean notEmptyIntStack() {
        return !intTypeStack.empty();
    }

    public boolean notEmptyFloatStack() {
        return !floatTypeStack.empty();
    }

    public void pushDataTypeId(String dataType, String id) {

        switch(dataType) {

            case "Int": apilarIntType(dataType);
                break;

            case "Float": apilarFloatType(dataType);
                break;

            case "String": throw new RuntimeException("La variable \"" + id + "\" es de tipo String, no puede utilizarse en una expresion aritmetica.");

            default: throw new RuntimeException("Tipo de Dato no soportado.");

        }
    }

    public void checkExpressionAssig(String dataType, String id) {

        if(!intTypeStack.empty() && !dataType.equals("Int")) {

            throw new RuntimeException("Asignacion Invalida: " +
                    "La variable \"" + id + "\" es de tipo " + dataType + " y la expresion es de tipo Int");

        }

        if(!floatTypeStack.empty() && !dataType.equals("Float")) {

            throw new RuntimeException("Asignacion Invalida: " +
                      "La variable \"" + id + "\" es de tipo " + dataType + " y la expresion es de tipo Float");
        }

    }

    public void checkConditionType() {

        if(!intTypeStack.empty() && !floatTypeStack.empty()) {
            throw new RuntimeException("Error en la condicion: Las expresiones a comparar deben ser del mismo tipo.");
        }

        vaciarFloatType();
        vaciarIntType();
    }

    public void setAuxCmp(String auxCmp) { this.auxCmp = auxCmp; }

    public String getAuxCmp() { return this.auxCmp; }

    public String getCmpETQ(String opCmp) {

        return switch (opCmp) {
            case ">=" -> "BLT";
            case "<=" -> "BGT";
            case ">" -> "BLE";
            case "<" -> "BGE";
            case "==" -> "BNE";
            case "!=" -> "BE";
            default -> throw new RuntimeException("Operador de comparacion no existente.");
        };
    }

    public String getOppositeCmpETQ(String opCmp) {

        return switch (opCmp) {
            case ">=" -> "BGE";
            case "<=" -> "BLE";
            case ">" -> "BGT";
            case "<" -> "BLT";
            case "==" -> "BE";
            case "!=" -> "BNE";
            default -> throw new RuntimeException("Operador de comparacion no existente.");
        };
    }

    public String getLabel() {

        String label = "msj_" + lbl;
        lbl++;

        return label;
    }

    public String getLabel2() {
        String label2 = "cte_" + lbl_2;
        lbl_2++;

        return label2;
    }

    public String normalizeStringLabel(String value) {
        if (value == null) return "_";

        value = value.replaceAll("^\"|\"$", "");

        value = value.replaceAll("[^a-zA-Z0-9]", "_");

        value = value.replaceAll("_+", "_");

        if (!value.startsWith("_"))
            value = "_" + value;

        if (value.length() > 30)
            value = value.substring(0, 30);

        return value;
    }


}