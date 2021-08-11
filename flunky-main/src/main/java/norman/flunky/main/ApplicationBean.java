package norman.flunky.main;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvException;
import norman.flunky.api.ProjectType;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

public class ApplicationBean {
    private static final Logger LOGGER = LoggerFactory.getLogger(ApplicationBean.class);
    private ProjectType projectType;
    private File projectDirectory;
    private Map<String, Object> applicationModel;
    private List<Map<String, Object>> entityModels;
    private List<Map<String, Object>> enumModels;

    public static ApplicationBean instance(String appPropsPath) {
        return new ApplicationBean(appPropsPath);
    }

    private ApplicationBean(String appPropsPath) {
        Reader reader = null;
        try {
            File appPropsFile = new File(appPropsPath);
            File appPropsDir = appPropsFile.getParentFile();
            reader = new FileReader(appPropsFile);
            Properties properties = new Properties();
            properties.load(reader);

            projectType = (ProjectType) Class.forName(properties.getProperty("project.type")).getDeclaredConstructor()
                    .newInstance();
            projectDirectory = new File(properties.getProperty("project.directory"));

            // Get entity rows.
            String entitiesFileName = properties.getProperty("entities.file");
            List<Map<String, String>> entityRowList = buildListOfMapsFromCsvFile(entitiesFileName, appPropsDir);

            // Get field rows.
            String fieldsFileName = properties.getProperty("fields.file");
            List<Map<String, String>> fieldRowList = buildListOfMapsFromCsvFile(fieldsFileName, appPropsDir);

            // Get enum rows.
            String enumsFileName = properties.getProperty("enums.file");
            List<Map<String, String>> enumRowList = buildListOfMapsFromCsvFile(enumsFileName, appPropsDir);

            // Build application model.
            applicationModel = buildApplicationModel(properties, entityRowList, fieldRowList, enumRowList);

            // Build entity models.
            entityModels = buildEntityModels(properties, entityRowList, fieldRowList, enumRowList);

            // Build enum models.
            enumModels = buildEnumModels(properties, entityRowList, fieldRowList, enumRowList);
        } catch (ClassNotFoundException | IllegalAccessException | InstantiationException | IOException | NoSuchMethodException | InvocationTargetException e) {
            throw new LoggingException(LOGGER, "Unable to load properties from file " + appPropsPath + ".", e);
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                    LOGGER.info("Successfully loaded properties from file " + appPropsPath + ".");
                } catch (IOException e) {
                    LOGGER.warn("Unable to close reader for file " + appPropsPath + ".", e);
                }
            }
        }
    }

    private List<Map<String, String>> buildListOfMapsFromCsvFile(String fileName, File dir) {
        List<Map<String, String>> dataMaps = new ArrayList<>();
        // If file name is null or blank, return an empty list.
        if (StringUtils.isNotBlank(fileName)) {
            File file = new File(dir, fileName);
            CSVReader reader = null;
            try {
                reader = new CSVReader(new FileReader(file));
                List<String[]> rows = reader.readAll();
                String[] headingRow = null;
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
                throw new LoggingException(LOGGER, "Unable to read CVS data from file " + fileName + ".", e);
            } finally {
                if (reader != null) {
                    try {
                        reader.close();
                    } catch (IOException e) {
                        LOGGER.warn("Unable to close CVS reader for file " + fileName + ".", e);
                    }
                }
            }
        }
        return dataMaps;
    }

    private Map<String, Object> buildApplicationModel(Properties properties, List<Map<String, String>> entityRowList,
            List<Map<String, String>> fieldRowList, List<Map<String, String>> enumRowList) {
        // Create application model.
        Map<String, Object> applicationModel = new LinkedHashMap<>();
        applicationModel.put("groupId", properties.getProperty("group.id"));
        applicationModel.put("artifactId", properties.getProperty("artifact.id"));
        applicationModel.put("version", properties.getProperty("version"));
        applicationModel.put("basePackage", properties.getProperty("base.package"));
        applicationModel.put("description", properties.getProperty("description"));

        // Add entity models to the application.
        List<Map<String, Object>> entityModels = new ArrayList<>();
        applicationModel.put("entities", entityModels);
        for (Map<String, String> entityRow : entityRowList) {
            Map<String, Object> entityModel = new LinkedHashMap<>(entityRow);
            entityModels.add(entityModel);

            // Add field models to the entities.
            List<Map<String, Object>> fieldModels = new ArrayList<>();
            entityModel.put("fields", fieldModels);
            for (Map<String, String> fieldRow : fieldRowList) {
                if (entityRow.get("entityName").equals(fieldRow.get("entityName"))) {
                    Map<String, Object> fieldModel = new LinkedHashMap<>(fieldRow);
                    fieldModels.add(fieldModel);
                }
            }
        }

        // Add enum models to the application.
        List<Map<String, Object>> enumModels = new ArrayList<>();
        applicationModel.put("enums", enumModels);
        for (Map<String, String> enumRow : enumRowList) {
            Map<String, Object> enumModel = new LinkedHashMap<>(enumRow);
            enumModels.add(enumModel);
        }

        return applicationModel;
    }

    private List<Map<String, Object>> buildEntityModels(Properties properties, List<Map<String, String>> entityRowList,
            List<Map<String, String>> fieldRowList, List<Map<String, String>> enumRowList) {
        // Create entity models.
        List<Map<String, Object>> entityModels = new ArrayList<>();
        for (Map<String, String> entityRow : entityRowList) {
            Map<String, Object> entityModel = new LinkedHashMap<>(entityRow);
            entityModels.add(entityModel);

            // Add field models to the entities.
            List<Map<String, Object>> fieldModels = new ArrayList<>();
            entityModel.put("fields", fieldModels);
            for (Map<String, String> fieldRow : fieldRowList) {
                if (entityRow.get("entityName").equals(fieldRow.get("entityName"))) {
                    Map<String, Object> fieldModel = new LinkedHashMap<>(fieldRow);
                    fieldModels.add(fieldModel);
                }
            }

            // Add application mode to the entities.
            Map<String, Object> applicationModel = new LinkedHashMap<>();
            entityModel.put("application", applicationModel);
            applicationModel.put("groupId", properties.getProperty("group.id"));
            applicationModel.put("artifactId", properties.getProperty("artifact.id"));
            applicationModel.put("version", properties.getProperty("version"));
            applicationModel.put("basePackage", properties.getProperty("base.package"));
            applicationModel.put("description", properties.getProperty("description"));

            // Add other entity models to the application.
            List<Map<String, Object>> otherEntityModels = new ArrayList<>();
            applicationModel.put("entities", otherEntityModels);
            for (Map<String, String> otherEntityRow : entityRowList) {
                if (!entityRow.get("entityName").equals(otherEntityRow.get("entityName"))) {
                    Map<String, Object> otherEntityModel = new LinkedHashMap<>(otherEntityRow);
                    otherEntityModels.add(otherEntityModel);

                    // Add other field models to the other entities.
                    List<Map<String, Object>> otherFieldModels = new ArrayList<>();
                    otherEntityModel.put("fields", otherFieldModels);
                    for (Map<String, String> otherFieldRow : fieldRowList) {
                        if (otherEntityRow.get("entityName").equals(otherFieldRow.get("entityName"))) {
                            Map<String, Object> otherFieldModel = new LinkedHashMap<>(otherFieldRow);
                            otherFieldModels.add(otherFieldModel);
                        }
                    }
                }
            }

            // Add enum models to the application.
            List<Map<String, Object>> enumModels = new ArrayList<>();
            applicationModel.put("enums", enumModels);
            for (Map<String, String> enumRow : enumRowList) {
                Map<String, Object> enumModel = new LinkedHashMap<>(enumRow);
                enumModels.add(enumModel);
            }
        }
        return entityModels;
    }

    private List<Map<String, Object>> buildEnumModels(Properties properties, List<Map<String, String>> entityRowList,
            List<Map<String, String>> fieldRowList, List<Map<String, String>> enumRowList) {
        // Create enum models.
        List<Map<String, Object>> enumModels = new ArrayList<>();
        for (Map<String, String> enumRow : enumRowList) {
            Map<String, Object> enumModel = new LinkedHashMap<>(enumRow);
            enumModels.add(enumModel);

            Map<String, Object> applicationModel = new LinkedHashMap<>();
            enumModel.put("application", applicationModel);
            applicationModel.put("groupId", properties.getProperty("group.id"));
            applicationModel.put("artifactId", properties.getProperty("artifact.id"));
            applicationModel.put("version", properties.getProperty("version"));
            applicationModel.put("basePackage", properties.getProperty("base.package"));
            applicationModel.put("description", properties.getProperty("description"));

            // Add entity models to the application.
            List<Map<String, Object>> entityModels = new ArrayList<>();
            applicationModel.put("entities", entityModels);
            for (Map<String, String> entityRow : entityRowList) {
                Map<String, Object> entityModel = new LinkedHashMap<>(entityRow);
                entityModels.add(entityModel);

                // Add field models to the entities.
                List<Map<String, Object>> fieldModels = new ArrayList<>();
                entityModel.put("fields", fieldModels);
                for (Map<String, String> fieldRow : fieldRowList) {
                    if (entityRow.get("entityName").equals(fieldRow.get("entityName"))) {
                        Map<String, Object> fieldModel = new LinkedHashMap<>(fieldRow);
                        fieldModels.add(fieldModel);
                    }
                }
            }
        }
        return enumModels;
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
