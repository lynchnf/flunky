package ${basePackage};

<#list entities as entity>
import ${basePackage}.domain.${entity.entityName};
</#list>
<#list enums as enum>
import ${basePackage}.domain.${enum.enumName};
</#list>
import ${basePackage}.exception.LoggingException;
import ${basePackage}.util.MiscUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.persistence.TemporalType;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import static ${basePackage}.FakeDataFactory.RandomStringModifier.CAPITALIZE;
import static ${basePackage}.FakeDataFactory.RandomStringModifier.LOWER_CASE;
import static ${basePackage}.FakeDataFactory.RandomStringModifier.UPPER_CASE;
import static ${basePackage}.FakeDataFactory.RandomStringType.ALPHABETIC;
import static ${basePackage}.FakeDataFactory.RandomStringType.ALPHANUMERIC;
import static ${basePackage}.FakeDataFactory.RandomStringType.NUMERIC;
import static ${basePackage}.FakeDataFactory.RandomStringType.WORDS;
import static javax.persistence.TemporalType.DATE;
import static javax.persistence.TemporalType.TIME;
import static javax.persistence.TemporalType.TIMESTAMP;

public class FakeDataFactory {
    private static final Logger LOGGER = LoggerFactory.getLogger(FakeDataFactory.class);
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

<#list entities as entity>
    <#list entity.fields?filter(f -> f.fieldName == entity.dftSortField) as field>
    private Map<${field.type}, ${entity.entityName}> ${entity.entityName?uncap_first}Map = new HashMap<>();
    </#list>
</#list>

    public static void main(String[] args) {
        FakeDataFactory me = new FakeDataFactory();
        me.doIt();
    }

    public void doIt() {
        Map<String, String> dftSortFieldMap = new HashMap<>();
<#list entities as entity>

        dftSortFieldMap.put("${entity.entityName}", "${entity.dftSortField}");
        for (int i = 0; i < ${entity.nbrOfFakeRecords}; i++) {
            ${entity.entityName} entity = nextRandom${entity.entityName}();
            ${entity.entityName?uncap_first}Map.put(entity.get${entity.dftSortField?cap_first}(), entity);
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

            for (${entity.entityName} record : ${entity.entityName?uncap_first}Map.values()) {
                printInsert(record, dftSortFieldMap, writer);
            }
            if (!${entity.entityName?uncap_first}Map.isEmpty()) {
                LOGGER.info(String.format("Successfully wrote %d insert statements for table %s.", ${entity.entityName?uncap_first}Map.size(),
                        MiscUtils.camelToSnake(${entity.entityName}.class.getSimpleName())));
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

    public ${entity.entityName} nextRandom${entity.entityName}() {
        ${entity.entityName} entity = new ${entity.entityName}();
    <#list entity.fields as field>
        <#if field.fakeData?? && field.fakeData == "true">
        if (RANDOM.nextInt(100) >= ${field.fakeNullPercent!0}) {
            <#if field.joinColumn??>
            entity.set${field.fieldName?cap_first}(nextRandomEntity(${field.type?uncap_first}Map.values()));
            <#elseif field.type == "BigDecimal">
            entity.set${field.fieldName?cap_first}(nextRandomBigDecimal("${field.fakeLowValue}", "${field.fakeHighValue}", ${field.scale}));
            <#elseif field.type == "Boolean">
            entity.set${field.fieldName?cap_first}(Boolean.valueOf(nextRandomBoolean()));
            <#elseif field.type == "Byte">
            entity.set${field.fieldName?cap_first}(Byte.valueOf((byte) nextRandomInteger(${field.fakeLowValue}, ${field.fakeHighValue})));
            <#elseif field.type == "Short">
            entity.set${field.fieldName?cap_first}(Short.valueOf((short) nextRandomInteger(${field.fakeLowValue}, ${field.fakeHighValue})));
            <#elseif field.type == "Integer">
            entity.set${field.fieldName?cap_first}(Integer.valueOf(nextRandomInteger(${field.fakeLowValue}, ${field.fakeHighValue})));
            <#elseif field.type == "Long">
            entity.set${field.fieldName?cap_first}(Long.valueOf((long) nextRandomInteger(${field.fakeLowValue}, ${field.fakeHighValue})));
            <#elseif field.type == "Date">
            entity.set${field.fieldName?cap_first}(nextRandomDateTime(${field.temporalType}, ${field.fakeLowValue}, ${field.fakeHighValue}));
            <#elseif field.type == "String">
            entity.set${field.fieldName?cap_first}(nextRandomString(${field.fakeStringType}, ${(field.fakeStringModifier)!"null"}, ${field.length}));
            <#elseif field.enumType??>
            entity.set${field.fieldName?cap_first}(nextRandomEnum(${field.type}.values()));
            </#if>
        }
        <#elseif field.dftValue??>
        entity.set${field.fieldName?cap_first}(${field.dftValue});
        </#if>
    </#list>
        return entity;
    }
</#list>

    private BigDecimal nextRandomBigDecimal(String lowValue, String highValue, int scale) {
        BigDecimal low = new BigDecimal(lowValue);
        BigDecimal high = new BigDecimal(highValue);
        int lowInt = low.movePointRight(scale).intValueExact();
        int highInt = high.movePointRight(scale).intValueExact();
        long unscaledVal = nextRandomInteger(lowInt, highInt);
        return BigDecimal.valueOf(unscaledVal, scale);
    }

    private boolean nextRandomBoolean() {
        return RANDOM.nextInt(2) == 1;
    }

    private int nextRandomInteger(int lowValue, int highValue) {
        return RANDOM.nextInt(highValue - lowValue + 1) + lowValue;
    }

    private String nextRandomString(RandomStringType type, RandomStringModifier modifier, int limit) {
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

    private String nextRandomWords(int limit) {
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

    private Date nextRandomDateTime(TemporalType temporalType, int lowValue, int highValue) {
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

    private <T> T nextRandomEnum(T[] values) {
        return values[RANDOM.nextInt(values.length)];
    }

    private <T> T nextRandomEntity(Collection<T> entities) {
        List<T> list = new ArrayList<>(entities);
        return list.get(RANDOM.nextInt(entities.size()));
    }

    private void printInsert(Object bean, Map<String, String> dftSortFieldMap, PrintWriter writer) {
        EntityToSqlConverter converter = new EntityToSqlConverter(bean, dftSortFieldMap);
        String tableName = converter.getTableName();
        String columnNames = "`" + StringUtils.join(converter.getColumnNames(), "`,`") + "`";
        String columnValues = StringUtils.join(converter.getColumnValues(), ",");

        writer.printf("INSERT INTO `%s` (%s)  VALUES (%s);%n", tableName, columnNames, columnValues);
    }
}
