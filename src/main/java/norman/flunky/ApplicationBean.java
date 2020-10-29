package norman.flunky;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvException;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

public class ApplicationBean {
    private static final Logger LOGGER = LoggerFactory.getLogger(ApplicationBean.class);
    private ProjectType projectType;
    private File projectDirectory;
    private Map<String, Object> applicationModel = new LinkedHashMap<>();
    private List<Map<String, Object>> entityModels = new ArrayList<>();
    private List<Map<String, Object>> enumModels = new ArrayList<>();

    public ApplicationBean(String path) {
        File file = new File(path);
        Reader reader = null;
        try {
            reader = new FileReader(file);
            Properties properties = new Properties();
            properties.load(reader);
            projectType = ProjectType.valueOf(properties.getProperty("project.type"));
            projectDirectory = new File(properties.getProperty("project.directory"));

            // Get field rows and group them by entity names.
            String fieldsFilePath = properties.getProperty("fields.file");
            List<Map<String, String>> fieldRowList = buildListOfMapsFromCsvFile(fieldsFilePath);
            Map<String, List<Map<String, String>>> entityFieldListMap = buildEntityFieldListMap(fieldRowList);

            // Get entity rows.
            String entitiesFilePath = properties.getProperty("entities.file");
            List<Map<String, String>> entityRowList = buildListOfMapsFromCsvFile(entitiesFilePath);

            // Get enum rows.
            String enumsFilePath = properties.getProperty("enums.file");
            List<Map<String, String>> enumRowList = buildListOfMapsFromCsvFile(enumsFilePath);

            // Use enum rows to create enums models.
            for (Map<String, String> enumRow : enumRowList) {
                Map<String, Object> enumModel = new LinkedHashMap<>(enumRow);
                enumModels.add(enumModel);

                // Add application properties to enum models.
                Map<String, Object> applicationModel1 = new LinkedHashMap<>();
                enumModel.put("application", applicationModel1);
                applicationModel1.put("groupId", properties.getProperty("group.id"));
                applicationModel1.put("artifactId", properties.getProperty("artifact.id"));
                applicationModel1.put("version", properties.getProperty("version"));
                applicationModel1.put("basePackage", properties.getProperty("base.package"));
                applicationModel1.put("description", properties.getProperty("description"));
            }

            // Use entity rows to create standalone entity models and application entity models.
            List<Map<String, Object>> applicationEntities = new ArrayList<>();
            applicationModel.put("entities", applicationEntities);
            for (Map<String, String> entityRow : entityRowList) {
                Map<String, Object> entityModel1 = new LinkedHashMap<>(entityRow);
                Map<String, Object> entityModel2 = new LinkedHashMap<>(entityRow);
                entityModels.add(entityModel1);
                applicationEntities.add(entityModel2);

                // Get field rows for this entity and use them to create field models for standalone entity models and application models.
                List<Map<String, Object>> entityFields1 = new ArrayList<>();
                List<Map<String, Object>> entityFields2 = new ArrayList<>();
                entityModel1.put("fields", entityFields1);
                entityModel2.put("fields", entityFields2);
                for (Map<String, String> fieldRow : entityFieldListMap.get(entityRow.get("entityName"))) {
                    Map<String, Object> fieldModel1 = new LinkedHashMap<>(fieldRow);
                    Map<String, Object> fieldModel2 = new LinkedHashMap<>(fieldRow);
                    entityFields1.add(fieldModel1);
                    entityFields2.add(fieldModel2);
                }

                // Add application properties to standalone entity models.
                Map<String, Object> applicationModel1 = new LinkedHashMap<>();
                entityModel1.put("application", applicationModel1);
                applicationModel1.put("groupId", properties.getProperty("group.id"));
                applicationModel1.put("artifactId", properties.getProperty("artifact.id"));
                applicationModel1.put("version", properties.getProperty("version"));
                applicationModel1.put("basePackage", properties.getProperty("base.package"));
                applicationModel1.put("description", properties.getProperty("description"));
            }

            // Add application properties to application model.
            applicationModel.put("groupId", properties.getProperty("group.id"));
            applicationModel.put("artifactId", properties.getProperty("artifact.id"));
            applicationModel.put("version", properties.getProperty("version"));
            applicationModel.put("basePackage", properties.getProperty("base.package"));
            applicationModel.put("description", properties.getProperty("description"));
        } catch (IOException e) {
            throw new LoggingException(LOGGER, "Unable to load properties from file " + path + ".", e);
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    LOGGER.warn("Unable to close reader for file " + path + ".", e);
                }
            }
        }
    }

    private List<Map<String, String>> buildListOfMapsFromCsvFile(String path) {
        List<Map<String, String>> dataMaps = new ArrayList<>();
        File file = new File(path);
        CSVReader reader = null;
        try {
            reader = new CSVReader(new FileReader(file));
            List<String[]> rows = reader.readAll();
            String headingRow[] = null;
            for (String[] row : rows) {
                if (headingRow == null) {
                    headingRow = row;
                } else {
                    Map<String, String> dataRow = new LinkedHashMap<>();
                    for (int i = 0; i < headingRow.length; i++) {
                        if (i < row.length) {
                            dataRow.put(StringUtils.trimToNull(headingRow[i]), StringUtils.trimToNull(row[i]));
                        } else {
                            dataRow.put(StringUtils.trimToNull(headingRow[i]), null);
                        }
                    }
                    dataMaps.add(dataRow);
                }
            }
        } catch (IOException | CsvException e) {
            throw new LoggingException(LOGGER, "Unable to read CVS data from file " + path + ".", e);
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    LOGGER.warn("Unable to close CVS reader for file " + path + ".", e);
                }
            }
        }
        return dataMaps;
    }

    private Map<String, List<Map<String, String>>> buildEntityFieldListMap(List<Map<String, String>> fieldRowList) {
        Map<String, List<Map<String, String>>> entityFieldListMap = new LinkedHashMap<>();
        for (Map<String, String> fieldRow : fieldRowList) {
            String entityName = fieldRow.get("entityName");
            List<Map<String, String>> entityFieldList = entityFieldListMap.get(entityName);
            if (entityFieldList == null) {
                entityFieldList = new ArrayList<>();
                entityFieldListMap.put(entityName, entityFieldList);
            }
            entityFieldList.add(fieldRow);
        }
        return entityFieldListMap;
    }

    public ProjectType getProjectType() {
        return projectType;
    }

    public File getProjectDirectory() {
        return projectDirectory;
    }

    public Map<String, Object> getApplicationModel() {
        return applicationModel;
    }

    public List<Map<String, Object>> getEntityModels() {
        return entityModels;
    }

    public List<Map<String, Object>> getEnumModels() {
        return enumModels;
    }
}
