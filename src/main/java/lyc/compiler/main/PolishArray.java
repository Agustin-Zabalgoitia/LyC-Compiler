package lyc.compiler.main;

import java.util.ArrayList;

public class PolishArray {
    private static PolishArray INSTANCE;

    private ArrayList<String> data;

    //Another Singleton cause why not?
    public static PolishArray getPolishArray() {
        if (INSTANCE == null) {
            INSTANCE = new PolishArray();
        }
        return INSTANCE;
    }

    private PolishArray()  {
        data = new ArrayList<>();
    }

    public ArrayList<String> getArray() {
        return data;
    }

    public void add(String str){
        data.add(str);
    }
}