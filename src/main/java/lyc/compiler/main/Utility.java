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
    //TODO: En desarrollo: Implementacion de pila para asegurar compatibilidad de tipos en expresiones aritmeticas
    private Stack<String> intTypeStack = new Stack<>();
    private Stack<String> floatTypeStack = new Stack<>();

    // apilar
    public void apilarId(String id) {
        idStack.push(id);
    }
    public void apilarType(String type) { typeStack.push(type); }
    public void apilarIntType(String type) { intTypeStack.push(type); }
    public void apilarFloatType(String type) { floatTypeStack.push(type); }

    // desapilar
    public String desapilarId() { return idStack.pop(); }
    public String desapilarType() { return typeStack.pop(); }

    // vaciar
    public void vaciarIntType() { intTypeStack = new Stack<>(); }
    public void vaciarFloatType() { floatTypeStack = new Stack<>(); }

    // getters
    public Stack<String> getIdStack () { return idStack; }
    public Stack<String> getIntTypeStack () { return intTypeStack; }
    public Stack<String> getFloatTypeStack() { return floatTypeStack; }

    public boolean notEmptyTypeStacks() {

        if(!intTypeStack.empty() && !floatTypeStack.empty()) {
            return true;
        }
        return false;
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
}