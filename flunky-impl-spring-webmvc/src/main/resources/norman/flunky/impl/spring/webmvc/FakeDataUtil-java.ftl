package ${basePackage};

<#list entities as entity>
import ${basePackage}.domain.${entity.entityName};
</#list>
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
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

    public static class ReturnTypeAndValue {
        private Class<?> returnType;
        private Object value;

        public ReturnTypeAndValue(Class<?> returnType, Object value) {
            this.returnType = returnType;
            this.value = value;
        }

        public Class<?> getReturnType() {
            return returnType;
        }

        public Object getValue() {
            return value;
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
            String tableName = null;
<#list entities as entity>

            for (${entity.entityName} record : ${entity.entityName?uncap_first}List) {
                tableName = camelToSnake(record.getClass().getSimpleName());
                printInsert(record, mainFieldMap, writer);
            }
            if (!${entity.entityName?uncap_first}List.isEmpty()) {
                String msg =
                        String.format("Successfully wrote %d insert statements for table %s.", ${entity.entityName?uncap_first}List.size(),
                                tableName);
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
        <#elseif field.type == "String">
            <#if field.fakeStringType??>
        entity.set${field.fieldName?cap_first}(nextRandomString(${field.fakeStringType}, ${(field.fakeStringModifier)!"null"}, ${field.length}));
            <#elseif field.dftValue??>
        entity.set${field.fieldName?cap_first}(${field.dftValue});
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

    private static String camelToSnake(String camelStr) {
        String ret = camelStr.replaceAll("([A-Z]+)([A-Z][a-z])", "$1_$2").replaceAll("([a-z])([A-Z])", "$1_$2");
        return ret.toLowerCase();
    }

    private static void printInsert(Object bean, Map<String, String> mainFieldMap, PrintWriter writer) {
        String beanName = bean.getClass().getSimpleName();
        //List<Class<?>> simpleTypes = Arrays.asList(BigDecimal.class, Boolean.class, Date.class, Integer.class, Long.class, String.class);
        List<String> simpleGetterNames = new ArrayList<>();
        //List<String> otherGetterNames = new ArrayList<>();
        for (Method method : bean.getClass().getDeclaredMethods()) {
            String methodName = method.getName();
            if (method.getParameterCount() == 0 && !methodName.equals("getId") &&
                    (methodName.startsWith("is") || methodName.startsWith("get"))) {
                //Class<?> returnType = method.getReturnType();
                //if (simpleTypes.contains(returnType) || returnType.isEnum()) {
                simpleGetterNames.add(methodName);
                //} else if (!List.class.isAssignableFrom(returnType)) {
                //otherGetterNames.add(methodName);
                //}
            }
        }

        String tableName = "`" + camelToSnake(beanName) + "`";
        StringBuilder columnNames = null;
        StringBuilder columnValues = null;

        Collections.sort(simpleGetterNames);
        for (String methodName : simpleGetterNames) {
            columnNames = buildColumnNames(columnNames, methodName);
            columnValues = buildSimpleColumnValues(columnValues, methodName, bean);
        }

        //Collections.sort(otherGetterNames);
        //for (String methodName : otherGetterNames) {
        //columnNames = buildColumnNames(columnNames, methodName + "Id");
        //columnValues = buildOtherColumnValues(columnValues, methodName, bean, mainFieldMap);
        //}
        writer.printf("INSERT INTO %s (%s)  VALUES (%s);%n", tableName, columnNames.toString(),
                columnValues.toString());
    }

    private static StringBuilder buildColumnNames(StringBuilder columnNames, String methodName) {
        String fieldName;
        if (methodName.startsWith("is")) {
            fieldName = methodName.substring(2);
        } else {
            fieldName = methodName.substring(3);
        }

        String columnName = "`" + camelToSnake(fieldName) + "`";
        columnNames = appendToColumnValues(columnNames, columnName);
        return columnNames;
    }

    private static StringBuilder appendToColumnValues(StringBuilder columnValues, String columnValue) {
        if (columnValues == null) {
            columnValues = new StringBuilder(columnValue);
        } else {
            columnValues.append(",").append(columnValue);
        }
        return columnValues;
    }

    private static StringBuilder buildSimpleColumnValues(StringBuilder columnValues, String methodName, Object bean) {
        ReturnTypeAndValue returnTypeAndValue = getReturnTypeAndValue(methodName, bean);
        String columnValue = getSimpleColumnValue(returnTypeAndValue.getReturnType(), returnTypeAndValue.getValue());
        return appendToColumnValues(columnValues, columnValue);
    }

    private static ReturnTypeAndValue getReturnTypeAndValue(String methodName, Object bean) {
        Class<?> returnType = null;
        Object value = null;
        try {
            Method method = bean.getClass().getDeclaredMethod(methodName);
            returnType = method.getReturnType();
            value = method.invoke(bean);
        } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException ignored) {
        }
        return new ReturnTypeAndValue(returnType, value);
    }

    private static String getSimpleColumnValue(Class<?> returnType, Object value) {
        String columnValue;
        if (value == null) {
            columnValue = "NULL";
        } else {
            columnValue = "'" + value + "'";
        }
        return columnValue;
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //    private static BigDecimal nextRandomBigDecimal(int unscaledLow, int unscaledHigh, int scale) {
    //        return BigDecimal.valueOf(RANDOM.nextInt(unscaledHigh - unscaledLow + 1) + unscaledLow, scale);
    //    }
    //
    //    private static Boolean nextRandomBoolean() {
    //        return RANDOM.nextInt(2) == 0;
    //    }
    //
    //    private static Date nextRandomDate(int daysLow, int daysHigh) {
    //        Calendar cal = Calendar.getInstance();
    //        cal.set(Calendar.MILLISECOND, 0);
    //        cal.set(Calendar.SECOND, 0);
    //        cal.set(Calendar.MINUTE, 0);
    //        cal.set(Calendar.HOUR_OF_DAY, 0);
    //        int days = RANDOM.nextInt(daysHigh - daysLow + 1) + daysLow;
    //        cal.add(Calendar.DATE, days);
    //        return cal.getTime();
    //    }
    //
    //    private static Date nextRandomTime(int hoursLow, int hoursHigh) {
    //        Calendar cal = Calendar.getInstance();
    //        cal.set(Calendar.MILLISECOND, 0);
    //        cal.set(Calendar.SECOND, RANDOM.nextInt(60));
    //        cal.set(Calendar.MINUTE, RANDOM.nextInt(60));
    //        int hours = RANDOM.nextInt(hoursHigh - hoursLow + 1) + hoursLow;
    //        cal.set(Calendar.HOUR_OF_DAY, hours);
    //        cal.set(Calendar.DAY_OF_MONTH, 1);
    //        cal.set(Calendar.MONTH, Calendar.JANUARY);
    //        cal.set(Calendar.YEAR, 1970);
    //        return cal.getTime();
    //    }
    //
    //    private static Date nextRandomTimestamp(int daysLow, int daysHigh) {
    //        Calendar cal = Calendar.getInstance();
    //        cal.set(Calendar.MILLISECOND, 0);
    //        cal.set(Calendar.SECOND, RANDOM.nextInt(60));
    //        cal.set(Calendar.MINUTE, RANDOM.nextInt(60));
    //        cal.set(Calendar.HOUR_OF_DAY, RANDOM.nextInt(24));
    //        int days = RANDOM.nextInt(daysHigh - daysLow + 1) + daysLow;
    //        cal.add(Calendar.DATE, days);
    //        return cal.getTime();
    //    }
    //
    //    private static int nextRandomInteger(int low, int high) {
    //        return RANDOM.nextInt(high - low + 1) + low;
    //    }
    //
    //
    //    private static <T> T nextRandomEnum(T[] values) {
    //        return values[RANDOM.nextInt(values.length)];
    //    }
    //
    //    private static <T> T nextRandomEntity(List<T> entityList) {
    //        return entityList.get(RANDOM.nextInt(entityList.size()));
    //    }
    //
    //
    //
    //
    //    private static StringBuilder buildOtherColumnValues(StringBuilder columnValues, String methodName, Object bean,
    //            Map<String, String> mainFieldMap) {
    //        ReturnTypeAndValue returnTypeAndValue = getReturnTypeAndValue(methodName, bean);
    //        Class<?> returnType = returnTypeAndValue.getReturnType();
    //        Object value = returnTypeAndValue.getValue();
    //
    //        String columnValue;
    //        if (value == null) {
    //            columnValue = "NULL";
    //        } else {
    //            String entityName = returnType.getSimpleName();
    //            String tableName = camelToSnake(entityName);
    //            String mainField = mainFieldMap.get(entityName);
    //            String mainColumn = camelToSnake(mainField);
    //            String mainMethodName = "get" + StringUtils.capitalize(mainField);
    //            ReturnTypeAndValue mainReturnTypeAndValue = getReturnTypeAndValue(mainMethodName, value);
    //            String mainValue =
    //                    getSimpleColumnValue(mainReturnTypeAndValue.getReturnType(), mainReturnTypeAndValue.getValue());
    //            columnValue = "(SELECT `id` FROM `" + tableName + "` WHERE `" + mainColumn + "`=" + mainValue + ")";
    //        }
    //
    //        return appendToColumnValues(columnValues, columnValue);
    //    }
    //
    //    private static ReturnTypeAndValue getReturnTypeAndValue(String methodName, Object bean) {
    //        Class<?> returnType = null;
    //        Object value = null;
    //        try {
    //            Method method = bean.getClass().getDeclaredMethod(methodName);
    //            returnType = method.getReturnType();
    //            value = method.invoke(bean);
    //        } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException ignored) {
    //        }
    //        return new ReturnTypeAndValue(returnType, value);
    //    }
    //
    //
    //
}
