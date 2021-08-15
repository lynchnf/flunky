package norman.flunky.main;

import norman.flunky.api.ProjectType;
import org.apache.commons.lang3.RandomStringUtils;
import org.junit.jupiter.api.BeforeAll;
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
import static org.junit.jupiter.api.Assertions.*;

class AppPropertiesIngestorTest {
    private static final Logger LOGGER = LoggerFactory.getLogger(AppPropertiesIngestorTest.class);
    static String tempDirectoryPath;
    static File appPropertiesFile;

    @BeforeAll
    static void oneTimeSetUp() throws Exception {
        // Get temp directory.
        AppPropertiesIngestorTest.tempDirectoryPath =
                Files.createTempDirectory("flunky-main-test-data-").toFile().getAbsolutePath();

        // Write application properties file.
        Properties fakeAppProperties = buildApplicationProperties(tempDirectoryPath);
        AppPropertiesIngestorTest.appPropertiesFile =
                writeApplicationProperties(tempDirectoryPath, "fake-app.properties", fakeAppProperties);

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

    @Test
    void getProjectType() {
        AppPropertiesIngestor ingestor = AppPropertiesIngestor.instance(appPropertiesFile.getAbsolutePath());
        ProjectType projectType = ingestor.getProjectType();

        assertEquals("norman.flunky.main.fake.FakeProjectType", projectType.getClass().getName());
    }

    @Test
    void getProjectDirectory() {
        AppPropertiesIngestor ingestor = AppPropertiesIngestor.instance(appPropertiesFile.getAbsolutePath());
        String projectDirectoryPath = ingestor.getProjectDirectoryPath();

        String expected = appPropertiesFile.getParentFile().getAbsolutePath() + "/fake-app";
        assertEquals(expected, projectDirectoryPath);
    }

    @Test
    void getApplicationData() {
        AppPropertiesIngestor ingestor = AppPropertiesIngestor.instance(appPropertiesFile.getAbsolutePath());
        Map<String, String> applicationData = ingestor.getApplicationData();

        assertEquals("com.mycompany.fake", applicationData.get("groupId"));
        assertEquals("fake-app", applicationData.get("artifactId"));
        assertEquals("1.2.3-SNAPSHOT", applicationData.get("version"));
        assertEquals("com.mycompany.fake.app", applicationData.get("basePackage"));
        assertEquals("Fake application.", applicationData.get("description"));
    }

    @Test
    void getEntitiesData() {
        AppPropertiesIngestor ingestor = AppPropertiesIngestor.instance(appPropertiesFile.getAbsolutePath());
        List<Map<String, String>> entitiesData = ingestor.getEntitiesData();

        assertEquals(2, entitiesData.size());
        assertEquals("Customer", entitiesData.get(0).get("entityName"));
        assertEquals("Order", entitiesData.get(1).get("entityName"));
    }

    @Test
    void getFieldsData() {
        AppPropertiesIngestor ingestor = AppPropertiesIngestor.instance(appPropertiesFile.getAbsolutePath());
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
        AppPropertiesIngestor ingestor = AppPropertiesIngestor.instance(appPropertiesFile.getAbsolutePath());
        List<Map<String, String>> enumsData = ingestor.getEnumsData();

        assertEquals(1, enumsData.size());
        assertEquals("Status", enumsData.get(0).get("enumName"));
        assertEquals("NEW OLD", enumsData.get(0).get("values"));
    }

    @Test
    void argFileIsNotFound() {
        String fakePropertiesPath =
                tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10) + File.separator +
                        RandomStringUtils.randomAlphabetic(10) + ".properties";

        LoggingException exception =
                assertThrows(LoggingException.class, () -> AppPropertiesIngestor.instance(fakePropertiesPath));

        assertEquals(ARG_FILE_NOT_FOUND, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void argFileIsNotFile() {
        String fakeDirectoryPath =
                tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10) + File.separator +
                        RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }

        LoggingException exception =
                assertThrows(LoggingException.class, () -> AppPropertiesIngestor.instance(fakeDirectoryPath));

        assertEquals(ARG_FILE_NOT_FILE, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void projectTypeNull() throws Exception {
        String fakeDirectoryPath = tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        Properties fakeProperties = buildApplicationProperties(fakeDirectoryPath);
        fakeProperties.remove("project.type");
        File fakePropertiesFile =
                writeApplicationProperties(fakeDirectoryPath, RandomStringUtils.randomAlphabetic(10) + ".properties",
                        fakeProperties);

        LoggingException exception = assertThrows(LoggingException.class,
                () -> AppPropertiesIngestor.instance(fakePropertiesFile.getAbsolutePath()));

        assertEquals(PROJECT_TYPE_REQUIRED, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void projectTypeClassNotFound() throws Exception {
        String fakeDirectoryPath = tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        Properties fakeProperties = buildApplicationProperties(fakeDirectoryPath);
        fakeProperties.setProperty("project.type", "norman.flunky.main.fake.ProjectTypeClassNotFound");
        File fakePropertiesFile =
                writeApplicationProperties(fakeDirectoryPath, RandomStringUtils.randomAlphabetic(10) + ".properties",
                        fakeProperties);

        LoggingException exception = assertThrows(LoggingException.class,
                () -> AppPropertiesIngestor.instance(fakePropertiesFile.getAbsolutePath()));

        assertEquals(PROJECT_TYPE_NOT_FOUND, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void projectDirectoryNull() throws Exception {
        String fakeDirectoryPath = tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        Properties fakeProperties = buildApplicationProperties(fakeDirectoryPath);
        fakeProperties.remove("project.directory");
        File fakePropertiesFile =
                writeApplicationProperties(fakeDirectoryPath, RandomStringUtils.randomAlphabetic(10) + ".properties",
                        fakeProperties);

        LoggingException exception = assertThrows(LoggingException.class,
                () -> AppPropertiesIngestor.instance(fakePropertiesFile.getAbsolutePath()));

        assertEquals(PROJECT_DIRECTORY_REQUIRED, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void groupIdNull() throws Exception {
        String fakeDirectoryPath = tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        Properties fakeProperties = buildApplicationProperties(fakeDirectoryPath);
        fakeProperties.remove("group.id");
        File fakePropertiesFile =
                writeApplicationProperties(fakeDirectoryPath, RandomStringUtils.randomAlphabetic(10) + ".properties",
                        fakeProperties);

        LoggingException exception = assertThrows(LoggingException.class,
                () -> AppPropertiesIngestor.instance(fakePropertiesFile.getAbsolutePath()));

        assertEquals(GROUP_ID_REQUIRED, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void artifactIdNull() throws Exception {
        String fakeDirectoryPath = tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        Properties fakeProperties = buildApplicationProperties(fakeDirectoryPath);
        fakeProperties.remove("artifact.id");
        File fakePropertiesFile =
                writeApplicationProperties(fakeDirectoryPath, RandomStringUtils.randomAlphabetic(10) + ".properties",
                        fakeProperties);

        LoggingException exception = assertThrows(LoggingException.class,
                () -> AppPropertiesIngestor.instance(fakePropertiesFile.getAbsolutePath()));

        assertEquals(ARTIFACT_ID_REQUIRED, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void versionNull() throws Exception {
        String fakeDirectoryPath = tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        Properties fakeProperties = buildApplicationProperties(fakeDirectoryPath);
        fakeProperties.remove("version");
        File fakePropertiesFile =
                writeApplicationProperties(fakeDirectoryPath, RandomStringUtils.randomAlphabetic(10) + ".properties",
                        fakeProperties);

        LoggingException exception = assertThrows(LoggingException.class,
                () -> AppPropertiesIngestor.instance(fakePropertiesFile.getAbsolutePath()));

        assertEquals(VERSION_REQUIRED, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void basePackageNull() throws Exception {
        String fakeDirectoryPath = tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        Properties fakeProperties = buildApplicationProperties(fakeDirectoryPath);
        fakeProperties.remove("base.package");
        File fakePropertiesFile =
                writeApplicationProperties(fakeDirectoryPath, RandomStringUtils.randomAlphabetic(10) + ".properties",
                        fakeProperties);

        LoggingException exception = assertThrows(LoggingException.class,
                () -> AppPropertiesIngestor.instance(fakePropertiesFile.getAbsolutePath()));

        assertEquals(BASE_PACKAGE_REQUIRED, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void entitiesFileIsNotFound() throws Exception {
        String fakeDirectoryPath = tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        Properties fakeProperties = buildApplicationProperties(fakeDirectoryPath);
        fakeProperties.setProperty("entities.file", RandomStringUtils.randomAlphabetic(10) + ".csv");
        fakeProperties.remove("fields.file");
        fakeProperties.remove("enums.file");
        File fakePropertiesFile =
                writeApplicationProperties(fakeDirectoryPath, RandomStringUtils.randomAlphabetic(10) + ".properties",
                        fakeProperties);

        LoggingException exception = assertThrows(LoggingException.class,
                () -> AppPropertiesIngestor.instance(fakePropertiesFile.getAbsolutePath()));

        assertEquals(ENTITIES_FILE_NOT_FOUND, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void entitiesFileIsNotFile() throws Exception {
        String fakeDirectoryPath = tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        Properties fakeProperties = buildApplicationProperties(fakeDirectoryPath);
        String notAFileName = RandomStringUtils.randomAlphabetic(10);
        File notAFile = new File(fakeDirectoryPath, notAFileName);
        if (!notAFile.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        fakeProperties.setProperty("entities.file", notAFileName);
        fakeProperties.remove("fields.file");
        fakeProperties.remove("enums.file");
        File fakePropertiesFile =
                writeApplicationProperties(fakeDirectoryPath, RandomStringUtils.randomAlphabetic(10) + ".properties",
                        fakeProperties);

        LoggingException exception = assertThrows(LoggingException.class,
                () -> AppPropertiesIngestor.instance(fakePropertiesFile.getAbsolutePath()));

        assertEquals(ENTITIES_FILE_NOT_FILE, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void filesFileIsNotFound() throws Exception {
        String fakeDirectoryPath = tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        Properties fakeProperties = buildApplicationProperties(fakeDirectoryPath);
        fakeProperties.remove("entities.file");
        fakeProperties.setProperty("fields.file", RandomStringUtils.randomAlphabetic(10) + ".csv");
        fakeProperties.remove("enums.file");
        File fakePropertiesFile =
                writeApplicationProperties(fakeDirectoryPath, RandomStringUtils.randomAlphabetic(10) + ".properties",
                        fakeProperties);

        LoggingException exception = assertThrows(LoggingException.class,
                () -> AppPropertiesIngestor.instance(fakePropertiesFile.getAbsolutePath()));

        assertEquals(FIELDS_FILE_NOT_FOUND, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void fieldsFileIsNotFile() throws Exception {
        String fakeDirectoryPath = tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        Properties fakeProperties = buildApplicationProperties(fakeDirectoryPath);
        String notAFileName = RandomStringUtils.randomAlphabetic(10);
        File notAFile = new File(fakeDirectoryPath, notAFileName);
        if (!notAFile.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        fakeProperties.remove("entities.file");
        fakeProperties.setProperty("fields.file", notAFileName);
        fakeProperties.remove("enums.file");
        File fakePropertiesFile =
                writeApplicationProperties(fakeDirectoryPath, RandomStringUtils.randomAlphabetic(10) + ".properties",
                        fakeProperties);

        LoggingException exception = assertThrows(LoggingException.class,
                () -> AppPropertiesIngestor.instance(fakePropertiesFile.getAbsolutePath()));

        assertEquals(FIELDS_FILE_NOT_FILE, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void enumsFileIsNotFound() throws Exception {
        String fakeDirectoryPath = tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        Properties fakeProperties = buildApplicationProperties(fakeDirectoryPath);
        fakeProperties.remove("entities.file");
        fakeProperties.remove("fields.file");
        fakeProperties.setProperty("enums.file", RandomStringUtils.randomAlphabetic(10) + ".csv");
        File fakePropertiesFile =
                writeApplicationProperties(fakeDirectoryPath, RandomStringUtils.randomAlphabetic(10) + ".properties",
                        fakeProperties);

        LoggingException exception = assertThrows(LoggingException.class,
                () -> AppPropertiesIngestor.instance(fakePropertiesFile.getAbsolutePath()));

        assertEquals(ENUMS_FILE_NOT_FOUND, exception.getMessage());
        assertNull(exception.getCause());
    }

    @Test
    void enumsFileIsNotFile() throws Exception {
        String fakeDirectoryPath = tempDirectoryPath + File.separator + RandomStringUtils.randomAlphabetic(10);
        File fakeDirectory = new File(fakeDirectoryPath);
        if (!fakeDirectory.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        Properties fakeProperties = buildApplicationProperties(fakeDirectoryPath);
        String notAFileName = RandomStringUtils.randomAlphabetic(10);
        File notAFile = new File(fakeDirectoryPath, notAFileName);
        if (!notAFile.mkdirs()) {
            fail("Unable to create temporary directory for testing.");
        }
        fakeProperties.remove("entities.file");
        fakeProperties.remove("fields.file");
        fakeProperties.setProperty("enums.file", notAFileName);
        File fakePropertiesFile =
                writeApplicationProperties(fakeDirectoryPath, RandomStringUtils.randomAlphabetic(10) + ".properties",
                        fakeProperties);

        LoggingException exception = assertThrows(LoggingException.class,
                () -> AppPropertiesIngestor.instance(fakePropertiesFile.getAbsolutePath()));

        assertEquals(ENUMS_FILE_NOT_FILE, exception.getMessage());
        assertNull(exception.getCause());
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
