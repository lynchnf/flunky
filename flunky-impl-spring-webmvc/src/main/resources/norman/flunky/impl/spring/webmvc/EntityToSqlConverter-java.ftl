package ${basePackage};

import ${basePackage}.exception.LoggingException;
import ${basePackage}.util.MiscUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.JoinColumn;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import static ${basePackage}.util.MiscUtils.HMS;
import static ${basePackage}.util.MiscUtils.YYMD;

public class EntityToSqlConverter {
    private static final Logger LOGGER = LoggerFactory.getLogger(EntityToSqlConverter.class);
    private Map<String, String> mainFieldMap;
    private String tableName;
    private SortedMap<String, String> simpleColumns = new TreeMap<>();
    private SortedMap<String, String> joinColumns = new TreeMap<>();

    public EntityToSqlConverter(Object entity, Map<String, String> mainFieldMap) {
        this.mainFieldMap = mainFieldMap;
        Class<?> entityClass = entity.getClass();
        tableName = MiscUtils.camelToSnake(entityClass.getSimpleName());

        // Chug through all the methods on the entity bean, selecting only the getters (except for getId).
        for (Method entityMethod : entityClass.getDeclaredMethods()) {
            String entityMethodName = entityMethod.getName();
            if (entityMethod.getParameterCount() == 0 && !entityMethodName.equals("getId") &&
                    (entityMethodName.startsWith("is") || entityMethodName.startsWith("get"))) {

                // TODO Do I really need all of these?
                Class<?> entityMethodReturnType = entityMethod.getReturnType();
                try {
                    Object entityMethodValue = entityMethod.invoke(entity);
                    String entityFieldName;
                    if (entityMethodName.startsWith("is")) {
                        entityFieldName = entityMethodName.substring(2);
                    } else {
                        entityFieldName = entityMethodName.substring(3);
                    }
                    entityFieldName = StringUtils.uncapitalize(entityFieldName);
                    Field entityField = entityClass.getDeclaredField(entityFieldName);

                    // If this property is a related entity, get the join column name ...
                    if (entityField.isAnnotationPresent(JoinColumn.class)) {
                        String columnName = getJoinColumnName(entityField);
                        String columnValue = getJoinColumnExpression(entityMethodReturnType, entityMethodValue);
                        joinColumns.put(columnName, columnValue);
                    } else {
                        String columnName = getSimpleColumnName(entityFieldName);
                        String columnValue =
                                getSimpleColumnValue(entityField, entityMethodReturnType, entityMethodValue);
                        simpleColumns.put(columnName, columnValue);
                    }
                } catch (IllegalAccessException | InvocationTargetException | NoSuchFieldException e) {
                    throw new LoggingException(LOGGER,
                            String.format("Unable to get field value info for method %s in class %s.", entityMethodName,
                                    entityClass.getName()), e);
                }
            }
        }
    }

    public String getTableName() {
        return tableName;
    }

    public List<String> getColumnNames() {
        List<String> columnNames = new ArrayList<>(simpleColumns.keySet());
        columnNames.addAll(joinColumns.keySet());
        return columnNames;
    }

    public List<String> getColumnValues() {
        List<String> columnValues = new ArrayList<>(simpleColumns.values());
        columnValues.addAll(joinColumns.values());
        return columnValues;
    }

    private String getJoinColumnName(Field field) {
        JoinColumn annotation = field.getAnnotation(JoinColumn.class);
        return annotation.name();
    }

    private String getJoinColumnExpression(Class<?> relatedClass, Object relatedEntity) {
        String relatedClassName = relatedClass.getSimpleName();
        String relatedTableName = MiscUtils.camelToSnake(relatedClassName);
        String relatedMainFieldName = mainFieldMap.get(relatedClassName);
        String relatedMainColumn = MiscUtils.camelToSnake(relatedMainFieldName);
        try {
            Field relatedMainField = relatedClass.getDeclaredField(relatedMainFieldName);
            String relatedMainMethodName = "get" + StringUtils.capitalize(relatedMainFieldName);
            Method relatedMainMethod = relatedClass.getDeclaredMethod(relatedMainMethodName);
            Class<?> relatedMainMethodReturnType = relatedMainMethod.getReturnType();
            Object relatedMainMethodValue = relatedMainMethod.invoke(relatedEntity);
            String relatedMainColumnValue =
                    getSimpleColumnValue(relatedMainField, relatedMainMethodReturnType, relatedMainMethodValue);
            return String.format("(SELECT `id` FROM `%s` WHERE `%s`=%s)", relatedTableName, relatedMainColumn,
                    relatedMainColumnValue);
        } catch (NoSuchFieldException | NoSuchMethodException | IllegalAccessException | InvocationTargetException e) {
            throw new LoggingException(LOGGER,
                    String.format("Unable to get join field info for class %s.", relatedClass.getName()), e);
        }
    }

    private String getSimpleColumnName(String fieldName) {
        return MiscUtils.camelToSnake(fieldName);
    }

    private String getSimpleColumnValue(Field field, Class<?> returnType, Object value) {
        String columnValue;
        if (value == null) {
            columnValue = "NULL";
        } else {
            boolean ordinalEnum = false;
            if (field.isAnnotationPresent(Enumerated.class)) {
                Enumerated annotation = field.getAnnotation(Enumerated.class);
                EnumType enumType = annotation.value();
                if (enumType == EnumType.ORDINAL) {
                    ordinalEnum = true;
                }
            }
            if (ordinalEnum) {
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
        }
        return columnValue;
    }
}
