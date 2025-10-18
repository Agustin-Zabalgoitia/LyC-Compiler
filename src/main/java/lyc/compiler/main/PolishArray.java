package lyc.compiler.main;

import java.util.ArrayList;
import java.util.Stack;

public class PolishArray {
    private static PolishArray INSTANCE;

    private ArrayList<String> data;

    private Stack<Integer> stack;
    private Stack<String> operatorStack;

    //Another Singleton cause why not?
    public static PolishArray getPolishArray() {
        if (INSTANCE == null) {
            INSTANCE = new PolishArray();
        }
        return INSTANCE;
    }

    private PolishArray()  {
        data = new ArrayList<>();
        stack = new Stack<>();
        operatorStack = new Stack<>();
    }

    public ArrayList<String> getArray() {
        return data;
    }

    public void add(String str){
        data.add(str);
    }

    public void advance() {
        data.add("");
        stack.push(data.size()-1);
    }

    public void stackPosition(){
        stack.push(data.size()-1);
    }

    public void writePosition() {
        data.set(stack.pop(), ""+(data.size()));
    }

    public void writeNextPosition(){
        data.set(stack.pop(), ""+(data.size()+1));
    }

    public void stackOperator(String operator) {
        operatorStack.push(operator);
    }

    public void writeOperator() {
        String operator = operatorStack.pop();
        if(!operatorStack.isEmpty()) {
            String aux = operatorStack.pop();
            if( aux.equals(Labels.NOT))
                operator = negateLogicalOperator(operator);
            else
                operatorStack.push(aux);
        }

        data.add(operator);
    }

    public void writeNegatedOperator(){
        data.add(negateLogicalOperator(operatorStack.pop()));
    }

    public void writePositionOnAllBlanks(){
        while(!stack.isEmpty())
        {
            writePosition();
        }
    }

    public void writeStackIntoPosition(){
        data.add(""+stack.pop());
    }

    private String negateLogicalOperator(String operator){
        switch (operator) {
            case Labels.BLT:
                return Labels.BGE;
            case Labels.BLE:
                return Labels.BGT;
            case Labels.BGT:
                return Labels.BLE;
            case Labels.BGE:
                return Labels.BLT;
            case Labels.BEQ:
                return Labels.BNE;
            case Labels.BNE:
                return Labels.BEQ;
        }
        return "";
    }

}