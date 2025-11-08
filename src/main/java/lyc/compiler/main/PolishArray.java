package lyc.compiler.main;

public class PolishArray {
    // Singleton
    private static final PolishArray instance = new PolishArray();

    private PolishArray() {}

    public static PolishArray getInstance() {
        return instance;
    }


}
