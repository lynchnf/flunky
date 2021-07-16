package ${basePackage};

<#list entities as entity>
import ${basePackage}.domain.${entity.entityName};
</#list>
<#list enums as enum>
import ${basePackage}.domain.${enum.enumName};
</#list>
import com.mycompany.example.my.app.exception.LoggingException;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.TemporalType;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import static com.mycompany.example.my.app.FakeDataUtil.RandomStringModifier.CAPITALIZE;
import static com.mycompany.example.my.app.FakeDataUtil.RandomStringModifier.LOWER_CASE;
import static com.mycompany.example.my.app.FakeDataUtil.RandomStringModifier.UPPER_CASE;
import static com.mycompany.example.my.app.FakeDataUtil.RandomStringType.ALPHABETIC;
import static com.mycompany.example.my.app.FakeDataUtil.RandomStringType.ALPHANUMERIC;
import static com.mycompany.example.my.app.FakeDataUtil.RandomStringType.NUMERIC;
import static com.mycompany.example.my.app.FakeDataUtil.RandomStringType.WORDS;
import static com.mycompany.example.my.app.util.MiscUtils.HMS;
import static com.mycompany.example.my.app.util.MiscUtils.YYMD;
import static javax.persistence.TemporalType.DATE;
import static javax.persistence.TemporalType.TIME;
import static javax.persistence.TemporalType.TIMESTAMP;

public class FakeDataUtil {
    private static final Logger LOGGER = LoggerFactory.getLogger(FakeDataUtil.class);
    private static final Random RANDOM = new Random();
    private static final String[] NONSENSE_WORDS =
            {"abra", "brok", "cuzze", "dryxa", "edrat", "frato", "grupo", "heon", "ikyss", "jiezz", "kryim", "loymo",
                    "mauk", "nossu", "ojyg", "pryig", "quiek", "rohi", "soymm", "trege", "ugge", "voehy", "waawa",
                    "xeemu", "yvaw", "zummu"};

    public enum RandomStringType {
        WORDS, ALPHABETIC, ALPHANUMERIC, NUMERIC
    }

    public enum RandomStringModifier {
        LOWER_CASE, UPPER_CASE, CAPITALIZE
    }

    public static class FieldValueInfo {
        private String methodName;
        private String fieldName;
        private Class<?> returnType;
        private Object value;
        private boolean ordinalEnum = false;

        public FieldValueInfo(String methodName, Object bean) {
            this.methodName = methodName;
            if (methodName.startsWith("is")) {
                fieldName = methodName.substring(2);
            } else {
                fieldName = methodName.substring(3);
            }
            fieldName = StringUtils.uncapitalize(fieldName);
            Class<?> beanClass = bean.getClass();
            try {
                Method method = beanClass.getDeclaredMethod(methodName);
                returnType = method.getReturnType();
                value = method.invoke(bean);
                Field field = beanClass.getDeclaredField(fieldName);
                if (field.isAnnotationPresent(Enumerated.class)) {
                    Enumerated annotation = field.getAnnotation(Enumerated.class);
                    EnumType enumType = annotation.value();
                    if (enumType == EnumType.ORDINAL) {
                        ordinalEnum = true;
                    }
                }
            } catch (NoSuchMethodException | IllegalAccessException | InvocationTargetException | NoSuchFieldException e) {
                throw new LoggingException(LOGGER,
                        String.format("Unable to get field value info for method %s in class %s.", methodName,
                                beanClass.getName()), e);
            }
        }

        public String getMethodName() {
            return methodName;
        }

        public String getFieldName() {
            return fieldName;
        }

        public Class<?> getReturnType() {
            return returnType;
        }

        public Object getValue() {
            return value;
        }

        public boolean isOrdinalEnum() {
            return ordinalEnum;
        }
    }

    public static void main(String[] args) {
        Map<String, String> mainFieldMap = new HashMap<>();
<#list entities as entity>

        mainFieldMap.put("${entity.entityName}", "${entity.mainField}");
        List<${entity.entityName}> ${entity.entityName?uncap_first}List = new ArrayList<>();
        for (int i = 0; i < ${entity.nbrOfFakeRecords}; i++) {
            ${entity.entityName} entity = nextRandom${entity.entityName}();
            ${entity.entityName?uncap_first}List.add(entity);
        }
</#list>

        File file = new File(System.getProperty("user.dir") + "/src/main/resources/import.sql");
        if (file.exists()) {
            String msg = String.format("File %s already exists.", file.getAbsolutePath());
            LOGGER.error(msg);
            throw new RuntimeException(msg);
        }
        try (PrintWriter writer = new PrintWriter(file)) {
<#list entities as entity>

            for (${entity.entityName} record : ${entity.entityName?uncap_first}List) {
                printInsert(record, mainFieldMap, writer);
            }
            if (!${entity.entityName?uncap_first}List.isEmpty()) {
                String msg =
                        String.format("Successfully wrote %d insert statements for table %s.", ${entity.entityName?uncap_first}List.size(),
                                camelToSnake(${entity.entityName}.class.getSimpleName()));
                LOGGER.info(msg);
            }
</#list>

            if (writer.checkError()) {
                String msg = String.format("Error occurred while writing to file %s", file.getAbsolutePath());
                LOGGER.error(msg);
                throw new RuntimeException(msg);
            }
        } catch (FileNotFoundException e) {
            String msg = String.format("Error occurred while writing to file %s", file.getAbsolutePath());
            LOGGER.error(msg, e);
            throw new RuntimeException(msg, e);
        }
    }
<#list entities as entity>

    public static ${entity.entityName} nextRandom${entity.entityName}() {
        ${entity.entityName} entity = new ${entity.entityName}();
    <#list entity.fields as field>
        <#if field.type == "BigDecimal">
            <#if field.fakeLowValue?? && field.fakeHighValue??>
        entity.set${field.fieldName?cap_first}(nextRandomBigDecimal("${field.fakeLowValue}", "${field.fakeHighValue}", ${field.scale}));
            <#elseif field.dftValue??>
        entity.set${field.fieldName?cap_first}(new BigDecimal("${field.dftValue}"));
            </#if>
        <#elseif field.type == "Boolean">
            <#if field.fakeRandomBoolean?? && field.fakeRandomBoolean == "true">
        entity.set${field.fieldName?cap_first}(Boolean.valueOf(nextRandomBoolean()));
            <#elseif field.dftValue??>
        entity.set${field.fieldName?cap_first}(Boolean.valueOf(${field.dftValue}));
            </#if>
        <#elseif field.type == "Byte">
            <#if field.fakeLowValue?? && field.fakeHighValue??>
        entity.set${field.fieldName?cap_first}(Byte.valueOf((byte) nextRandomInteger(${field.fakeLowValue}, ${field.fakeHighValue})));
            <#elseif field.dftValue??>
        entity.set${field.fieldName?cap_first}(Byte.valueOf((byte) ${field.dftValue}));
            </#if>
        <#elseif field.type == "Short">
            <#if field.fakeLowValue?? && field.fakeHighValue??>
        entity.set${field.fieldName?cap_first}(Short.valueOf((short) nextRandomInteger(${field.fakeLowValue}, ${field.fakeHighValue})));
            <#elseif field.dftValue??>
        entity.set${field.fieldName?cap_first}(Short.valueOf((short) ${field.dftValue}));
            </#if>
        <#elseif field.type == "Integer">
            <#if field.fakeLowValue?? && field.fakeHighValue??>
        entity.set${field.fieldName?cap_first}(Integer.valueOf(nextRandomInteger(${field.fakeLowValue}, ${field.fakeHighValue})));
            <#elseif field.dftValue??>
        entity.set${field.fieldName?cap_first}(Integer.valueOf(${field.dftValue}));
            </#if>
        <#elseif field.type == "Long">
            <#if field.fakeLowValue?? && field.fakeHighValue??>
        entity.set${field.fieldName?cap_first}(Long.valueOf((long) nextRandomInteger(${field.fakeLowValue}, ${field.fakeHighValue})));
            <#elseif field.dftValue??>
        entity.set${field.fieldName?cap_first}(Long.valueOf((long) ${field.dftValue}));
            </#if>
        <#elseif field.type == "Date">
            <#if field.fakeLowValue?? && field.fakeHighValue??>
        entity.set${field.fieldName?cap_first}(nextRandomDateTime(${field.temporalType}, ${field.fakeLowValue}, ${field.fakeHighValue}));
            <#elseif field.dftValue??>
        entity.set${field.fieldName?cap_first}(${field.dftValue});
            </#if>
        <#elseif field.type == "String">
            <#if field.fakeStringType??>
        entity.set${field.fieldName?cap_first}(nextRandomString(${field.fakeStringType}, ${(field.fakeStringModifier)!"null"}, ${field.length}));
            <#elseif field.dftValue??>
        entity.set${field.fieldName?cap_first}(${field.dftValue});
            </#if>
        <#elseif field.enumType??>
            <#if field.fakeRandomEnum?? && field.fakeRandomEnum == "true">
        entity.set${field.fieldName?cap_first}(nextRandomEnum(${field.type}.values()));
            <#elseif field.dftValue??>
        entity.set${field.fieldName?cap_first}(${field.type}.${field.dftValue});
            </#if>
        </#if>
    </#list>
        return entity;
    }
</#list>

    private static BigDecimal nextRandomBigDecimal(String lowValue, String highValue, int scale) {
        BigDecimal low = new BigDecimal(lowValue);
        BigDecimal high = new BigDecimal(highValue);
        int lowInt = low.movePointRight(scale).intValueExact();
        int highInt = high.movePointRight(scale).intValueExact();
        long unscaledVal = nextRandomInteger(lowInt, highInt);
        return BigDecimal.valueOf(unscaledVal, scale);
    }

    private static boolean nextRandomBoolean() {
        return RANDOM.nextInt(2) == 1;
    }

    private static int nextRandomInteger(int lowValue, int highValue) {
        return RANDOM.nextInt(highValue - lowValue + 1) + lowValue;
    }

    private static String nextRandomString(RandomStringType type, RandomStringModifier modifier, int limit) {
        String randomString = null;
        if (type == ALPHABETIC) {
            randomString = RandomStringUtils.randomAlphabetic(limit);
        } else if (type == ALPHANUMERIC) {
            randomString = RandomStringUtils.randomAlphanumeric(limit);
        } else if (type == NUMERIC) {
            randomString = RandomStringUtils.randomNumeric(limit);
        } else if (type == WORDS) {
            randomString = nextRandomWords(limit);
        }

        if (modifier == CAPITALIZE) {
            randomString = StringUtils.capitalize(randomString);
        } else if (modifier == LOWER_CASE) {
            randomString = StringUtils.lowerCase(randomString);
        } else if (modifier == UPPER_CASE) {
            randomString = StringUtils.upperCase(randomString);
        }
        return randomString;
    }

    private static String nextRandomWords(int limit) {
        StringBuilder randomWords = null;
        boolean done = false;
        do {
            String randomWord = NONSENSE_WORDS[RANDOM.nextInt(NONSENSE_WORDS.length)];
            if (randomWords == null) {
                if (randomWord.length() > limit) {
                    randomWords = new StringBuilder(randomWord.substring(0, limit));
                } else {
                    randomWords = new StringBuilder(randomWord);
                }
            } else if (randomWords.length() + randomWord.length() + 1 <= limit) {
                randomWords.append(" ").append(randomWord);
            } else {
                done = true;
            }
        } while (!done);
        return randomWords.toString();
    }

    private static Date nextRandomDateTime(TemporalType temporalType, int lowValue, int highValue) {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.MILLISECOND, 0);
        cal.set(Calendar.SECOND, 0);
        if (temporalType == DATE) {
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            int days = RANDOM.nextInt(highValue - lowValue + 1) + lowValue;
            cal.add(Calendar.DATE, days);
        } else if (temporalType == TIME) {
            int minutes = RANDOM.nextInt(highValue - lowValue + 1) + lowValue;
            cal.add(Calendar.MINUTE, minutes);
            cal.set(Calendar.DAY_OF_MONTH, 1);
            cal.set(Calendar.MONTH, Calendar.JANUARY);
            cal.set(Calendar.YEAR, 1970);
        } else if (temporalType == TIMESTAMP) {
            cal.set(Calendar.MINUTE, RANDOM.nextInt(60));
            cal.set(Calendar.HOUR_OF_DAY, RANDOM.nextInt(24));
            int days = RANDOM.nextInt(highValue - lowValue + 1) + lowValue;
            cal.add(Calendar.DATE, days);
        }
        return cal.getTime();
    }

    private static <T> T nextRandomEnum(T[] values) {
        return values[RANDOM.nextInt(values.length)];
    }

    private static String camelToSnake(String camelStr) {
        String ret = camelStr.replaceAll("([A-Z]+)([A-Z][a-z])", "$1_$2").replaceAll("([a-z])([A-Z])", "$1_$2");
        return ret.toLowerCase();
    }

    private static void printInsert(Object bean, Map<String, String> mainFieldMap, PrintWriter writer) {
        String beanName = bean.getClass().getSimpleName();
        List<String> simpleGetterNames = new ArrayList<>();
        for (Method method : bean.getClass().getDeclaredMethods()) {
            String methodName = method.getName();
            if (method.getParameterCount() == 0 && !methodName.equals("getId") &&
                    (methodName.startsWith("is") || methodName.startsWith("get"))) {
                simpleGetterNames.add(methodName);
            }
        }

        String tableName = "`" + camelToSnake(beanName) + "`";
        StringBuilder columnNames = null;
        StringBuilder columnValues = null;

        Collections.sort(simpleGetterNames);
        for (String methodName : simpleGetterNames) {
            FieldValueInfo info = new FieldValueInfo(methodName, bean);
            String columnName = "`" + camelToSnake(info.getFieldName()) + "`";
            columnNames = appendToStringBuilder(columnNames, columnName);
            String columnValue = getSimpleColumnValue(info);
            columnValues = appendToStringBuilder(columnValues, columnValue);
        }

        writer.printf("INSERT INTO %s (%s)  VALUES (%s);%n", tableName, columnNames.toString(),
                columnValues.toString());
    }

    private static StringBuilder appendToStringBuilder(StringBuilder stringBuilder, String value) {
        if (stringBuilder == null) {
            stringBuilder = new StringBuilder(value);
        } else {
            stringBuilder.append(",").append(value);
        }
        return stringBuilder;
    }

    private static String getSimpleColumnValue(FieldValueInfo info) {
        String columnValue;
        Class<?> returnType = info.getReturnType();
        Object value = info.getValue();
        if (value == null) {
            columnValue = "NULL";
        } else if (info.isOrdinalEnum()) {
            Enum enumValue = (Enum) value;
            columnValue = String.valueOf(enumValue.ordinal());
        } else if (Boolean.class.isAssignableFrom(returnType)) {
            columnValue = String.valueOf(value).toUpperCase();
        } else if (BigDecimal.class.isAssignableFrom(returnType) || Byte.class.isAssignableFrom(returnType) ||
                Short.class.isAssignableFrom(returnType) || Integer.class.isAssignableFrom(returnType) ||
                Long.class.isAssignableFrom(returnType)) {
            columnValue = String.valueOf(value);
        } else if (Date.class.isAssignableFrom(returnType)) {
            String datePart = YYMD.format((Date) value);
            String timePart = HMS.format((Date) value);
            if (!datePart.equals("1970-01-01") && !timePart.equals("00:00:00")) {
                columnValue = "'" + datePart + " " + timePart + "'";
            } else if (!datePart.equals("1970-01-01") && timePart.equals("00:00:00")) {
                columnValue = "'" + datePart + "'";
            } else if (datePart.equals("1970-01-01") && !timePart.equals("00:00:00")) {
                columnValue = "'" + timePart + "'";
            } else {
                columnValue = "NULL";
            }
        } else {
            columnValue = "'" + value + "'";
        }
        return columnValue;
    }
}
