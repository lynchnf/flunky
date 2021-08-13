package norman.flunky.main;

import norman.flunky.api.ProjectType;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import static org.junit.jupiter.api.Assertions.*;

class AppPropertiesIngestorTest {
    private static final Logger LOGGER = LoggerFactory.getLogger(AppPropertiesIngestorTest.class);
    static File propertiesFile;
    AppPropertiesIngestor ingestor;

    @BeforeAll
    static void oneTimeSetUp() throws Exception {
        // Get temp directory.
        String tempDirectoryPath = Files.createTempDirectory("flunky-main-test-data-").toFile().getAbsolutePath();

        // Write application properties file.
        Properties fakeApplicationProperties = buildApplicationProperties(tempDirectoryPath);
        AppPropertiesIngestorTest.propertiesFile =
                writeApplicationProperties(tempDirectoryPath, "fake-app.properties", fakeApplicationProperties);

        // Write entities csv file. (2 entities)
        String[] entityLines = {"entityName", "Customer", "Order"};
        writeCsvFile(tempDirectoryPath, "fake-app-entities.csv", entityLines);

        // Write fields csv file. (3 fields)
        String[] fieldLines = {"entityName,fieldName,label,type", "Customer,name,Customer Name,String",
                "Order,number,Order Number,Integer", "Order,status,Order Status,Status"};
        writeCsvFile(tempDirectoryPath, "fake-app-fields.csv", fieldLines);

        // Write enums csv file. (1 enum)
        String[] enumsLines = {"enumName,values", "Status,NEW OLD"};
        writeCsvFile(tempDirectoryPath, "fake-app-enums.csv", enumsLines);
        LOGGER.info("TEST Successfully completed one-time setup for ApplicationPropertiesIngestorTest.");
    }

    @BeforeEach
    void setUp() {
        String propertiesFilePath = propertiesFile.getAbsolutePath();
        LOGGER.info(String.format("TEST Creating ApplicationBean from file %s.", propertiesFilePath));
        ingestor = AppPropertiesIngestor.instance(propertiesFilePath);
    }

    @AfterEach
    void tearDown() {
        ingestor = null;
    }

    @Test
    void getProjectType() {
        ProjectType projectType = ingestor.getProjectType();
        assertEquals("norman.flunky.main.fake.FakeProjectType", projectType.getClass().getName());
    }

    @Test
    void getProjectDirectory() {
        File projectDirectory = ingestor.getProjectDirectory();
        String expected = propertiesFile.getParentFile().getAbsolutePath() + "/fake-app";
        assertEquals(expected, projectDirectory.getAbsolutePath());
    }

    @Test
    void getApplicationData() {
        Map<String, String> applicationData = ingestor.getApplicationData();
        assertEquals("com.mycompany.fake", applicationData.get("groupId"));
        assertEquals("fake-app", applicationData.get("artifactId"));
        assertEquals("1.2.3-SNAPSHOT", applicationData.get("version"));
        assertEquals("com.mycompany.fake.app", applicationData.get("basePackage"));
        assertEquals("Fake application.", applicationData.get("description"));
    }

    @Test
    void getEntitiesData() {
        List<Map<String, String>> entitiesData = ingestor.getEntitiesData();
        assertEquals(2, entitiesData.size());
        assertEquals("Customer", entitiesData.get(0).get("entityName"));
        assertEquals("Order", entitiesData.get(1).get("entityName"));
    }

    @Test
    void getFieldsData() {
        List<Map<String, String>> fieldsData = ingestor.getFieldsData();
        assertEquals(3, fieldsData.size());
        assertEquals("Customer", fieldsData.get(0).get("entityName"));
        assertEquals("name", fieldsData.get(0).get("fieldName"));
        assertEquals("Customer Name", fieldsData.get(0).get("label"));
        assertEquals("String", fieldsData.get(0).get("type"));
        assertEquals("Order", fieldsData.get(1).get("entityName"));
        assertEquals("number", fieldsData.get(1).get("fieldName"));
        assertEquals("Order Number", fieldsData.get(1).get("label"));
        assertEquals("Integer", fieldsData.get(1).get("type"));
        assertEquals("Order", fieldsData.get(2).get("entityName"));
        assertEquals("status", fieldsData.get(2).get("fieldName"));
        assertEquals("Order Status", fieldsData.get(2).get("label"));
        assertEquals("Status", fieldsData.get(2).get("type"));
    }

    @Test
    void getEnumsData() {
        List<Map<String, String>> enumsData = ingestor.getEnumsData();
        assertEquals(1, enumsData.size());
        assertEquals("Status", enumsData.get(0).get("enumName"));
        assertEquals("NEW OLD", enumsData.get(0).get("values"));
    }

    private static Properties buildApplicationProperties(String directoryPath) {
        Properties applicationProperties = new Properties();
        applicationProperties.setProperty("project.type", "norman.flunky.main.fake.FakeProjectType");
        applicationProperties.setProperty("project.directory", directoryPath + "/fake-app");
        applicationProperties.setProperty("group.id", "com.mycompany.fake");
        applicationProperties.setProperty("artifact.id", "fake-app");
        applicationProperties.setProperty("version", "1.2.3-SNAPSHOT");
        applicationProperties.setProperty("base.package", "com.mycompany.fake.app");
        applicationProperties.setProperty("description", "Fake application.");
        applicationProperties.setProperty("entities.file", "fake-app-entities.csv");
        applicationProperties.setProperty("fields.file", "fake-app-fields.csv");
        applicationProperties.setProperty("enums.file", "fake-app-enums.csv");
        return applicationProperties;
    }

    private static File writeApplicationProperties(String directoryPath, String fileName,
            Properties applicationProperties) throws Exception {
        File propertiesFile = new File(directoryPath, fileName);
        FileOutputStream outputStream = null;
        try {
            outputStream = new FileOutputStream(propertiesFile);
            applicationProperties.store(outputStream, "data for unit tests");
        } catch (IOException e) {
            throw new Exception(String.format("Unable to write to file %s in directory %s.", fileName, directoryPath),
                    e);
        } finally {
            if (outputStream != null) {
                try {
                    outputStream.close();
                    LOGGER.info(
                            String.format("TEST: Successfully wrote properties to file %s in directory %s.", fileName,
                                    directoryPath));
                } catch (IOException e) {
                    LOGGER.warn(String.format("Unable to close file %s in directory %s.", fileName, directoryPath), e);
                }
            }
        }
        return propertiesFile;
    }

    private static void writeCsvFile(String directoryPath, String fileName, String[] lines) throws Exception {
        File csvFile = new File(directoryPath, fileName);
        PrintWriter writer = null;
        try {
            writer = new PrintWriter(csvFile);
            for (String line : lines) {
                writer.println(line);
            }
            writer.flush();
        } catch (FileNotFoundException e) {
            throw new Exception("Unable to write to file " + fileName + " in directory " + directoryPath + ".", e);
        } finally {
            if (writer != null) {
                writer.close();
                LOGGER.info(String.format("TEST: Successfully wrote CSV data to file %s in directory %s.", fileName,
                        directoryPath));
            }
        }
    }
}
