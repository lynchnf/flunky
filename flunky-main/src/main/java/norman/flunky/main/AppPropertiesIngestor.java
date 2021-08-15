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
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import static norman.flunky.main.MessageConstants.ARG_FILE_NOT_FILE;
import static norman.flunky.main.MessageConstants.ARG_FILE_NOT_FOUND;
import static norman.flunky.main.MessageConstants.ARTIFACT_ID_REQUIRED;
import static norman.flunky.main.MessageConstants.BASE_PACKAGE_REQUIRED;
import static norman.flunky.main.MessageConstants.ENTITIES_FILE_NOT_FILE;
import static norman.flunky.main.MessageConstants.ENTITIES_FILE_NOT_FOUND;
import static norman.flunky.main.MessageConstants.ENUMS_FILE_NOT_FILE;
import static norman.flunky.main.MessageConstants.ENUMS_FILE_NOT_FOUND;
import static norman.flunky.main.MessageConstants.FIELDS_FILE_NOT_FILE;
import static norman.flunky.main.MessageConstants.FIELDS_FILE_NOT_FOUND;
import static norman.flunky.main.MessageConstants.GROUP_ID_REQUIRED;
import static norman.flunky.main.MessageConstants.PROJECT_DIRECTORY_REQUIRED;
import static norman.flunky.main.MessageConstants.PROJECT_TYPE_NOT_FOUND;
import static norman.flunky.main.MessageConstants.PROJECT_TYPE_REQUIRED;
import static norman.flunky.main.MessageConstants.VERSION_REQUIRED;

public class AppPropertiesIngestor {
    private static final Logger LOGGER = LoggerFactory.getLogger(AppPropertiesIngestor.class);
    private ProjectType projectType;
    private String projectDirectoryPath;
    private Map<String, String> applicationData;
    private List<Map<String, String>> entitiesData;
    private List<Map<String, String>> fieldsData;
    private List<Map<String, String>> enumsData;

    public static AppPropertiesIngestor instance(String applicationPropertiesPath) {
        return new AppPropertiesIngestor(applicationPropertiesPath);
    }

    private AppPropertiesIngestor(String appPropsPath) {
        File appPropsFile = new File(appPropsPath);
        if (!appPropsFile.exists()) {
            throw new LoggingException(LOGGER, ARG_FILE_NOT_FOUND);
        }
        if (!appPropsFile.isFile()) {
            throw new LoggingException(LOGGER, ARG_FILE_NOT_FILE);
        }
        File appPropsDir = appPropsFile.getParentFile();
        Properties properties = new Properties();
        Reader reader = null;
        try {
            reader = new FileReader(appPropsFile);
            properties.load(reader);

            String propertyTypeName = properties.getProperty("project.type");
            if (propertyTypeName == null) {
                throw new LoggingException(LOGGER, PROJECT_TYPE_REQUIRED);
            }
            Class<?> propertyTypeClass;
            try {
                propertyTypeClass = Class.forName(propertyTypeName);
            } catch (ClassNotFoundException e) {
                throw new LoggingException(LOGGER, PROJECT_TYPE_NOT_FOUND);
            }
            Constructor<?> propertyTypeConstructor = propertyTypeClass.getDeclaredConstructor();
            projectType = (ProjectType) propertyTypeConstructor.newInstance();
            projectDirectoryPath = properties.getProperty("project.directory");
            if (projectDirectoryPath == null) {
                throw new LoggingException(LOGGER, PROJECT_DIRECTORY_REQUIRED);
            }

            // Get application map.
            applicationData = new LinkedHashMap<>();
            String groupId = properties.getProperty("group.id");
            if (groupId == null) {
                throw new LoggingException(LOGGER, GROUP_ID_REQUIRED);
            }
            applicationData.put("groupId", groupId);

            String artifactId = properties.getProperty("artifact.id");
            if (artifactId == null) {
                throw new LoggingException(LOGGER, ARTIFACT_ID_REQUIRED);
            }
            applicationData.put("artifactId", artifactId);

            String version = properties.getProperty("version");
            if (version == null) {
                throw new LoggingException(LOGGER, VERSION_REQUIRED);
            }
            applicationData.put("version", version);

            String basePackage = properties.getProperty("base.package");
            if (basePackage == null) {
                throw new LoggingException(LOGGER, BASE_PACKAGE_REQUIRED);
            }
            applicationData.put("basePackage", basePackage);

            applicationData.put("description", properties.getProperty("description"));

            // Get entity rows.
            String entitiesFileName = properties.getProperty("entities.file");
            if (entitiesFileName == null) {
                entitiesData = new ArrayList<>();
            } else {
                File entitiesFile = new File(appPropsDir, entitiesFileName);
                if (!entitiesFile.exists()) {
                    throw new LoggingException(LOGGER, ENTITIES_FILE_NOT_FOUND);
                }
                if (!entitiesFile.isFile()) {
                    throw new LoggingException(LOGGER, ENTITIES_FILE_NOT_FILE);
                }
                entitiesData = buildListOfMapsFromCsvFile(entitiesFile);
            }

            // Get field rows.
            String fieldsFileName = properties.getProperty("fields.file");
            if (fieldsFileName == null) {
                fieldsData = new ArrayList<>();
            } else {
                File fieldsFile = new File(appPropsDir, fieldsFileName);
                if (!fieldsFile.exists()) {
                    throw new LoggingException(LOGGER, FIELDS_FILE_NOT_FOUND);
                }
                if (!fieldsFile.isFile()) {
                    throw new LoggingException(LOGGER, FIELDS_FILE_NOT_FILE);
                }
                fieldsData = buildListOfMapsFromCsvFile(fieldsFile);
            }

            // Get enum rows.
            String enumsFileName = properties.getProperty("enums.file");
            if (enumsFileName == null) {
                enumsData = new ArrayList<>();
            } else {
                File enumsFile = new File(appPropsDir, enumsFileName);
                if (!enumsFile.exists()) {
                    throw new LoggingException(LOGGER, ENUMS_FILE_NOT_FOUND);
                }
                if (!enumsFile.isFile()) {
                    throw new LoggingException(LOGGER, ENUMS_FILE_NOT_FILE);
                }
                enumsData = buildListOfMapsFromCsvFile(enumsFile);
            }
        } catch (IOException | InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
            throw new LoggingException(LOGGER, String.format("Unable to load properties from file %s.", appPropsPath),
                    e);
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                    LOGGER.info(String.format("Successfully loaded properties from file %s.", appPropsPath));
                } catch (IOException e) {
                    LOGGER.warn(String.format("Unable to close reader for file %s.", appPropsPath), e);
                }
            }
        }
    }

    private List<Map<String, String>> buildListOfMapsFromCsvFile(File file) {
        List<Map<String, String>> dataMaps = new ArrayList<>();
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
            throw new LoggingException(LOGGER,
                    String.format("Unable to read CVS data from file %s.", file.getAbsolutePath()), e);
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    LOGGER.warn(String.format("Unable to close CVS reader for file %s.", file.getAbsolutePath()), e);
                }
            }
        }
        return dataMaps;
    }

    public ProjectType getProjectType() {
        return projectType;
    }

    public String getProjectDirectoryPath() {
        return projectDirectoryPath;
    }

    public Map<String, String> getApplicationData() {
        return applicationData;
    }

    public List<Map<String, String>> getEntitiesData() {
        return entitiesData;
    }

    public List<Map<String, String>> getFieldsData() {
        return fieldsData;
    }

    public List<Map<String, String>> getEnumsData() {
        return enumsData;
    }
}
