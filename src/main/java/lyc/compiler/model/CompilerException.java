package lyc.compiler.model;

public abstract class CompilerException extends Exception {

    private static final long serialVersionUID = -3138875452688305726L;

    public CompilerException(String message) {
        super(message);
    }
}