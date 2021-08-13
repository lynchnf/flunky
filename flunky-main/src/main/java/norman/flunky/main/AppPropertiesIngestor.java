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
        File appPropsDir = appPropsFile.getParentFile();
        Properties properties = new Properties();
        Reader reader = null;
        try {
            reader = new FileReader(appPropsFile);
            properties.load(reader);

            projectType = (ProjectType) Class.forName(properties.getProperty("project.type")).getDeclaredConstructor()
                    .newInstance();
            projectDirectoryPath = properties.getProperty("project.directory");

            // Get application map.
            applicationData = new LinkedHashMap<>();
            applicationData.put("groupId", properties.getProperty("group.id"));
            applicationData.put("artifactId", properties.getProperty("artifact.id"));
            applicationData.put("version", properties.getProperty("version"));
            applicationData.put("basePackage", properties.getProperty("base.package"));
            applicationData.put("description", properties.getProperty("description"));

            // Get entity rows.
            String entitiesFileName = properties.getProperty("entities.file");
            entitiesData = buildListOfMapsFromCsvFile(entitiesFileName, appPropsDir);

            // Get field rows.
            String fieldsFileName = properties.getProperty("fields.file");
            fieldsData = buildListOfMapsFromCsvFile(fieldsFileName, appPropsDir);

            // Get enum rows.
            String enumsFileName = properties.getProperty("enums.file");
            enumsData = buildListOfMapsFromCsvFile(enumsFileName, appPropsDir);
        } catch (IOException | InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException | ClassNotFoundException e) {
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
                throw new LoggingException(LOGGER, String.format("Unable to read CVS data from file %s.", fileName), e);
            } finally {
                if (reader != null) {
                    try {
                        reader.close();
                    } catch (IOException e) {
                        LOGGER.warn(String.format("Unable to close CVS reader for file %s.", fileName), e);
                    }
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
