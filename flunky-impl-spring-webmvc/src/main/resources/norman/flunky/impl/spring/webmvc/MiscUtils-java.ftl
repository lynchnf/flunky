package ${basePackage}.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class MiscUtils {
    private static final Logger LOGGER = LoggerFactory.getLogger(MiscUtils.class);
    public static final DateFormat YYMD = new SimpleDateFormat("yyyy-MM-dd");
    public static final DateFormat HMS = new SimpleDateFormat("HH:mm:ss");
    public static final DateFormat YYMD_HMS = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public static Date parseDate(String source) {
        try {
            return YYMD.parse(source);
        } catch (ParseException e) {
            LOGGER.warn(String.format("Unable to parse \"%s\" using format %s.", source, String.valueOf(YYMD)), e);
            return null;
        }
    }

    public static Date parseTime(String source) {
        try {
            return HMS.parse(source);
        } catch (ParseException e) {
            LOGGER.warn(String.format("Unable to parse \"%s\" using format %s.", source, String.valueOf(HMS)), e);
            return null;
        }
    }

    public static Date parseDateTime(String source) {
        try {
            return YYMD_HMS.parse(source);
        } catch (ParseException e) {
            LOGGER.warn(String.format("Unable to parse \"%s\" using format %s.", source, String.valueOf(YYMD_HMS)), e);
            return null;
        }
    }

    public static String camelToSnake(String camelStr) {
        String ret = camelStr.replaceAll("([A-Z]+)([A-Z][a-z])", "$1_$2").replaceAll("([a-z])([A-Z])", "$1_$2");
        return ret.toLowerCase();
    }
}
