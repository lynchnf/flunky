package ${basePackage};

<#list entities as entity>
import ${basePackage}.domain.${entity.entityName?cap_first};
</#list>
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class FakeDataUtil {
    private static final Logger LOGGER = LoggerFactory.getLogger(FakeDataUtil.class);
    private static final Random RANDOM = new Random();
    private static final DateFormat YYMD = new SimpleDateFormat("yyyy-MM-dd");
    private static final String[] NONSENSE_WORDS =
            {"acaer", "ahalty", "aquents", "aturned", "baxtoy", "bilkons", "boycher", "carlds", "corrot", "corsarm",
                "cortmum", "defas", "deferts", "dialks", "dignate", "distard", "diveher", "expuls", "famongs",
                "fierer", "gogogox", "griled", "heddies", "hoddlen", "holize", "houshia", "ifringe", "immegap",
                "lammour", "liledge", "marsons", "merint", "mistial", "morior", "mouruge", "nekmit", "novaly",
                "oclate", "onama", "partia", "posion", "pricall", "qiameth", "rention", "sementa", "skimat",
                "skizzle", "specons", "stally", "stictic", "sweeds", "sweeds", "twenbat", "walrie", "winfirn",
                "yoffa"};

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
        mainFieldMap.put("${entity.entityName?cap_first}", "${entity.mainField}");
</#list>
<#list entities as entity>
        List<${entity.entityName?cap_first}> ${entity.entityName}List = new ArrayList<>();
        for (int i = 0; i < ${entity.nbrOfFakeRecords}; i++) {
            ${entity.entityName?cap_first} record = new ${entity.entityName?cap_first}();
<#list entity.fields as field>
<#if field.type == "BigDecimal">
            record.set${field.fieldName?cap_first}(nextRandomBigDecimal(${field.lowFakeValue}, ${field.highFakeValue}, ${field.scale}));
<#elseif field.type == "Boolean">
            record.set${field.fieldName?cap_first}(nextRandomBoolean());
<#elseif field.type == "Date">
            record.set${field.fieldName?cap_first}(nextRandomDate(${field.lowFakeValue}, ${field.highFakeValue}));
<#elseif field.type == "Integer">
            record.set${field.fieldName?cap_first}(nextRandomInteger(${field.lowFakeValue}, ${field.highFakeValue}));
<#elseif field.type == "Long">
            record.set${field.fieldName?cap_first}((long) nextRandomInteger(${field.lowFakeValue}, ${field.highFakeValue}));
<#elseif field.type == "String">
            record.set${field.fieldName?cap_first}(nextRandomString(${field.length}));
<#else>
            record.set${field.fieldName?cap_first}(nextRandomEntity(${field.type?uncap_first}List));
</#if>
</#list>
            ${entity.entityName}List.add(record);
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
            for (${entity.entityName?cap_first} record : ${entity.entityName}List) {
                tableName = camelToSnake(record.getClass().getSimpleName());
                printInsert(record, mainFieldMap, writer);
            }
            if (!${entity.entityName}List.isEmpty()) {
                String msg = String.format("Successfully wrote %d insert statements for table %s.", ${entity.entityName}List.size(),
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

    private static BigDecimal nextRandomBigDecimal(int unscaledLow, int unscaledHigh, int scale) {
        return BigDecimal.valueOf(RANDOM.nextInt(unscaledHigh - unscaledLow + 1) + unscaledLow, scale);
    }

    private static Boolean nextRandomBoolean() {
        return RANDOM.nextInt(2) == 0;
    }

    private static Date nextRandomDate(int daysLow, int daysHigh) {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.MILLISECOND, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.HOUR, 0);
        int days = RANDOM.nextInt(daysHigh - daysLow + 1) + daysLow;
        cal.add(Calendar.DATE, days);
        return cal.getTime();
    }

    private static int nextRandomInteger(int low, int high) {
        return RANDOM.nextInt(high - low + 1) + low;
    }

    private static String nextRandomString(int limit) {
        StringBuilder randomString = null;
        boolean done = false;
        do {
            String randomWord = NONSENSE_WORDS[RANDOM.nextInt(NONSENSE_WORDS.length)];
            if (randomString == null) {
                if (randomWord.length() > limit) {
                    randomString = new StringBuilder(randomWord.substring(0, limit));
                } else {
                    randomString = new StringBuilder(randomWord);
                }
            } else if (randomString.length() + randomWord.length() + 1 <= limit) {
                randomString.append(" ").append(randomWord);
            } else {
                done = true;
            }
        } while (!done);
        return StringUtils.capitalize(randomString.toString());
    }

    private static <T> T nextRandomEntity(List<T> entityList) {
        return entityList.get(RANDOM.nextInt(entityList.size()));
    }

    private static void printInsert(Object bean, Map<String, String> mainFieldMap, PrintWriter writer) {
        String beanName = bean.getClass().getSimpleName();
        List<Class<?>> simpleTypes =
                Arrays.asList(BigDecimal.class, Boolean.class, Date.class, Integer.class, Long.class, String.class);
        List<String> simpleGetterNames = new ArrayList<>();
        List<String> otherGetterNames = new ArrayList<>();
        for (Method method : bean.getClass().getDeclaredMethods()) {
            String methodName = method.getName();
            if (method.getParameterCount() == 0 && !methodName.equals("getId") &&
                    (methodName.startsWith("is") || methodName.startsWith("get"))) {
                Class<?> returnType = method.getReturnType();
                if (simpleTypes.contains(returnType) || returnType.isEnum()) {
                    simpleGetterNames.add(methodName);
                } else if (!List.class.isAssignableFrom(returnType)) {
                    otherGetterNames.add(methodName);
                }
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

        Collections.sort(otherGetterNames);
        for (String methodName : otherGetterNames) {
            columnNames = buildColumnNames(columnNames, methodName + "Id");
            columnValues = buildOtherColumnValues(columnValues, methodName, bean, mainFieldMap);
        }
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

    private static StringBuilder buildSimpleColumnValues(StringBuilder columnValues, String methodName, Object bean) {
        ReturnTypeAndValue returnTypeAndValue = getReturnTypeAndValue(methodName, bean);
        String columnValue = getSimpleColumnValue(returnTypeAndValue.getReturnType(), returnTypeAndValue.getValue());
        return appendToColumnValues(columnValues, columnValue);
    }

    private static StringBuilder buildOtherColumnValues(StringBuilder columnValues, String methodName, Object bean,
            Map<String, String> mainFieldMap) {
        ReturnTypeAndValue returnTypeAndValue = getReturnTypeAndValue(methodName, bean);
        Class<?> returnType = returnTypeAndValue.getReturnType();
        Object value = returnTypeAndValue.getValue();

        String columnValue;
        if (value == null) {
            columnValue = "NULL";
        } else {
            String entityName = returnType.getSimpleName();
            String tableName = camelToSnake(entityName);
            String mainField = mainFieldMap.get(entityName);
            String mainColumn = camelToSnake(mainField);
            String mainMethodName = "get" + StringUtils.capitalize(mainField);
            ReturnTypeAndValue mainReturnTypeAndValue = getReturnTypeAndValue(mainMethodName, value);
            String mainValue =
                    getSimpleColumnValue(mainReturnTypeAndValue.getReturnType(), mainReturnTypeAndValue.getValue());
            columnValue = "(SELECT `id` FROM `" + tableName + "` WHERE `" + mainColumn + "`=" + mainValue + ")";
        }

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
        } else if (BigDecimal.class.isAssignableFrom(returnType)) {
            columnValue = String.valueOf(value);
        } else if (Boolean.class.isAssignableFrom(returnType)) {
            columnValue = String.valueOf(value).toUpperCase();
        } else if (Date.class.isAssignableFrom(returnType)) {
            columnValue = "'" + YYMD.format((Date) value) + "'";
        } else if (Integer.class.isAssignableFrom(returnType)) {
            columnValue = String.valueOf(value);
        } else if (Long.class.isAssignableFrom(returnType)) {
            columnValue = String.valueOf(value);
        } else {
            columnValue = "'" + value + "'";
        }
        return columnValue;
    }

    private static StringBuilder appendToColumnValues(StringBuilder columnValues, String columnValue) {
        if (columnValues == null) {
            columnValues = new StringBuilder(columnValue);
        } else {
            columnValues.append(",").append(columnValue);
        }
        return columnValues;
    }

    private static String camelToSnake(String camelStr) {
        String ret = camelStr.replaceAll("([A-Z]+)([A-Z][a-z])", "$1_$2").replaceAll("([a-z])([A-Z])", "$1_$2");
        return ret.toLowerCase();
    }
}
