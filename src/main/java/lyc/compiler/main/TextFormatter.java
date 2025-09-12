package lyc.compiler.utils;

public class TextFormatter {

    private static int TOTAL_LEFT_SIDE_LENGTH = 13;

    private static final String ANSI_COLOR_GREEN = "\033[32m";
    private static final String ANSI_COLOR_YELLOW = "\033[33m";
    private static final String ANSI_COLOR_RESET = "\033[0m";

    private static boolean isAllUpperCase(String str) {
        if (str == null || str.isEmpty()) {
            return false;
        }

        for (int i = 0; i < str.length(); i++) {
            if (Character.isLetter(str.charAt(i)) && !Character.isUpperCase(str.charAt(i))) {
                return false;
            }
        }

        return true;
    }

    private static String colorizeString(String str) {

        if (str.contains(":"))
            return ANSI_COLOR_YELLOW + str.substring(0, str.indexOf(":") + 1) + ANSI_COLOR_RESET
                    + str.substring(str.indexOf(":") + 1, str.length());

        return isAllUpperCase(str) ? ANSI_COLOR_GREEN + str + ANSI_COLOR_RESET : str;
    }

    public static String formatText(String left, String right, String separator, char fillerChar, int fillerLength) {
        String outStr = left;

        if (fillerLength > 0)
            outStr += String.format("%" + (fillerLength - 1) + "c", fillerChar).replace(' ', fillerChar); // Add filler

        outStr += separator;

        String[] auxStr = right.split("[\\s\\t]+");

        for (String str : auxStr) {
            outStr += " " + colorizeString(str);
        }

        return outStr;
    }

    public static void formatAndPrintText(String left, String right) {
        System.out.println(formatText(left, right, "->", '.', TOTAL_LEFT_SIDE_LENGTH - left.length()));
    }
}
