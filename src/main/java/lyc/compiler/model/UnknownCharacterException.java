package lyc.compiler.model;

public class UnknownCharacterException extends CompilerException {

    private static final long serialVersionUID = -8839023592847976068L;

    public UnknownCharacterException(String unknownInput) {
        super("Unknown character « " + unknownInput + " »");
    }
}