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

class ApplicationBeanTest {
    private static final Logger LOGGER = LoggerFactory.getLogger(ApplicationBeanTest.class);
    static File propsFile;
    ApplicationBean bean;

    @BeforeAll
    static void oneTimeSetUp() throws Exception {
        // Get temp directory.
        String tempDirPath = Files.createTempDirectory("flunky-main-test-data-").toFile().getAbsolutePath();

        // Write application properties file.
        Properties fakeAppProps = buildAppProps(tempDirPath);
        ApplicationBeanTest.propsFile = writeAppProps(tempDirPath, "fake-app.properties", fakeAppProps);

        // Write entities csv file. (2 entities)
        String[] entityLines = {"entityName", "Customer", "Order"};
        writeCsvFile(tempDirPath, "fake-app-entities.csv", entityLines);

        // Write fields csv file. (3 fields)
        String[] fieldLines = {"entityName,fieldName,label,type", "Customer,name,Customer Name,String",
                "Order,number,Order Number,Integer", "Order,status,Order Status,Status"};
        writeCsvFile(tempDirPath, "fake-app-fields.csv", fieldLines);

        // Write enums csv file. (1 enum)
        String[] enumsLines = {"enumName,values", "Status,NEW OLD"};
        writeCsvFile(tempDirPath, "fake-app-enums.csv", enumsLines);
        LOGGER.info("TEST Successfully completed one-time setup for ApplicationBeanTest.");
    }

    @BeforeEach
    void setUp() {
        String absolutePath = propsFile.getAbsolutePath();
        LOGGER.info(String.format("TEST Creating ApplicationBean from file %s.", absolutePath));
        bean = ApplicationBean.instance(absolutePath);
    }

    @AfterEach
    void tearDown() {
        bean = null;
    }

    @Test
    void getProjectType() throws Exception {
        ProjectType projectType = bean.getProjectType();
        assertEquals("norman.flunky.main.fake.FakeProjectType", projectType.getClass().getName());
    }

    @Test
    void getProjectDirectory() {
        File projectDirectory = bean.getProjectDirectory();
        String expected = propsFile.getParentFile().getAbsolutePath() + "/fake-app";
        assertEquals(expected, projectDirectory.getAbsolutePath());
    }

    @Test
    void getApplicationModel() {
        Map<String, Object> applicationModel = bean.getApplicationModel();
        assertEquals("com.mycompany.fake", applicationModel.get("groupId"));
        assertEquals("fake-app", applicationModel.get("artifactId"));
        assertEquals("1.2.3-SNAPSHOT", applicationModel.get("version"));
        assertEquals("com.mycompany.fake.app", applicationModel.get("basePackage"));
        assertEquals("Fake application.", applicationModel.get("description"));

        // application -> (customer & order)
        assertNotNull(applicationModel.get("entities"));
        List<Map<String, Object>> entityModels = (List<Map<String, Object>>) applicationModel.get("entities");
        assertEquals(2, entityModels.size());
        assertEquals("Customer", entityModels.get(0).get("entityName"));
        assertEquals("Order", entityModels.get(1).get("entityName"));

        // application -> customer -> fields
        assertNotNull(entityModels.get(0).get("fields"));
        List<Map<String, Object>> customerFieldModels = (List<Map<String, Object>>) entityModels.get(0).get("fields");
        assertEquals(1, customerFieldModels.size());
        assertEquals("name", customerFieldModels.get(0).get("fieldName"));
        assertEquals("Customer Name", customerFieldModels.get(0).get("label"));
        assertEquals("String", customerFieldModels.get(0).get("type"));

        // application -> order -> fields
        assertNotNull(entityModels.get(1).get("fields"));
        List<Map<String, Object>> orderFieldModels = (List<Map<String, Object>>) entityModels.get(1).get("fields");
        assertEquals(2, orderFieldModels.size());
        assertEquals("number", orderFieldModels.get(0).get("fieldName"));
        assertEquals("Order Number", orderFieldModels.get(0).get("label"));
        assertEquals("Integer", orderFieldModels.get(0).get("type"));
        assertEquals("status", orderFieldModels.get(1).get("fieldName"));
        assertEquals("Order Status", orderFieldModels.get(1).get("label"));
        assertEquals("Status", orderFieldModels.get(1).get("type"));

        // application -> enums
        assertNotNull(applicationModel.get("enums"));
        List<Map<String, Object>> enumModels = (List<Map<String, Object>>) applicationModel.get("enums");
        assertEquals(1, enumModels.size());
        assertEquals("Status", enumModels.get(0).get("enumName"));
        assertEquals("NEW OLD", enumModels.get(0).get("values"));
    }

    @Test
    void getEntityModels() {
        List<Map<String, Object>> entityModels = bean.getEntityModels();
        assertEquals(2, entityModels.size());
        assertEquals("Customer", entityModels.get(0).get("entityName"));
        assertEquals("Order", entityModels.get(1).get("entityName"));

        // customer -> fields
        assertNotNull(entityModels.get(0).get("fields"));
        List<Map<String, Object>> customerFieldModels = (List<Map<String, Object>>) entityModels.get(0).get("fields");
        assertEquals(1, customerFieldModels.size());
        assertEquals("name", customerFieldModels.get(0).get("fieldName"));
        assertEquals("Customer Name", customerFieldModels.get(0).get("label"));
        assertEquals("String", customerFieldModels.get(0).get("type"));

        // order -> fields
        assertNotNull(entityModels.get(1).get("fields"));
        List<Map<String, Object>> orderFieldModels = (List<Map<String, Object>>) entityModels.get(1).get("fields");
        assertEquals(2, orderFieldModels.size());
        assertEquals("number", orderFieldModels.get(0).get("fieldName"));
        assertEquals("Order Number", orderFieldModels.get(0).get("label"));
        assertEquals("Integer", orderFieldModels.get(0).get("type"));
        assertEquals("status", orderFieldModels.get(1).get("fieldName"));
        assertEquals("Order Status", orderFieldModels.get(1).get("label"));
        assertEquals("Status", orderFieldModels.get(1).get("type"));

        // customer -> application
        assertNotNull(entityModels.get(0).get("application"));
        Map<String, Object> custAppModel = (Map<String, Object>) entityModels.get(0).get("application");
        assertEquals("com.mycompany.fake", custAppModel.get("groupId"));
        assertEquals("fake-app", custAppModel.get("artifactId"));
        assertEquals("1.2.3-SNAPSHOT", custAppModel.get("version"));
        assertEquals("com.mycompany.fake.app", custAppModel.get("basePackage"));
        assertEquals("Fake application.", custAppModel.get("description"));

        // order -> application
        assertNotNull(entityModels.get(1).get("application"));
        Map<String, Object> ordrAppModel = (Map<String, Object>) entityModels.get(1).get("application");
        assertEquals("com.mycompany.fake", ordrAppModel.get("groupId"));
        assertEquals("fake-app", ordrAppModel.get("artifactId"));
        assertEquals("1.2.3-SNAPSHOT", ordrAppModel.get("version"));
        assertEquals("com.mycompany.fake.app", ordrAppModel.get("basePackage"));
        assertEquals("Fake application.", ordrAppModel.get("description"));

        // customer -> application -> order
        assertNotNull(custAppModel.get("entities"));
        List<Map<String, Object>> custAppEntModels = (List<Map<String, Object>>) custAppModel.get("entities");
        assertEquals(1, custAppEntModels.size());
        assertEquals("Order", custAppEntModels.get(0).get("entityName"));

        // order -> application -> customer
        assertNotNull(ordrAppModel.get("entities"));
        List<Map<String, Object>> ordrAppEntModels = (List<Map<String, Object>>) ordrAppModel.get("entities");
        assertEquals(1, ordrAppEntModels.size());
        assertEquals("Customer", ordrAppEntModels.get(0).get("entityName"));

        // customer -> application -> order -> fields
        assertNotNull(custAppEntModels.get(0).get("fields"));
        List<Map<String, Object>> custAppEntFieldsModels =
                (List<Map<String, Object>>) custAppEntModels.get(0).get("fields");
        assertEquals("number", custAppEntFieldsModels.get(0).get("fieldName"));
        assertEquals("Order Number", custAppEntFieldsModels.get(0).get("label"));
        assertEquals("Integer", custAppEntFieldsModels.get(0).get("type"));
        assertEquals("status", custAppEntFieldsModels.get(1).get("fieldName"));
        assertEquals("Order Status", custAppEntFieldsModels.get(1).get("label"));
        assertEquals("Status", custAppEntFieldsModels.get(1).get("type"));

        // order -> application -> customer -> fields
        assertNotNull(ordrAppEntModels.get(0).get("fields"));
        List<Map<String, Object>> ordrAppEntFieldsModels =
                (List<Map<String, Object>>) ordrAppEntModels.get(0).get("fields");
        assertEquals("name", ordrAppEntFieldsModels.get(0).get("fieldName"));
        assertEquals("Customer Name", ordrAppEntFieldsModels.get(0).get("label"));
        assertEquals("String", ordrAppEntFieldsModels.get(0).get("type"));

        // customer -> application -> enums
        assertNotNull(custAppModel.get("enums"));
        List<Map<String, Object>> custAppEnumModel = (List<Map<String, Object>>) custAppModel.get("enums");
        assertEquals(1, custAppEnumModel.size());
        assertEquals("Status", custAppEnumModel.get(0).get("enumName"));
        assertEquals("NEW OLD", custAppEnumModel.get(0).get("values"));

        // order -> application -> enums
        assertNotNull(ordrAppModel.get("enums"));
        List<Map<String, Object>> ordrAppEnumModel = (List<Map<String, Object>>) ordrAppModel.get("enums");
        assertEquals(1, ordrAppEnumModel.size());
        assertEquals("Status", ordrAppEnumModel.get(0).get("enumName"));
        assertEquals("NEW OLD", ordrAppEnumModel.get(0).get("values"));
    }

    @Test
    void getEnumModels() {
        List<Map<String, Object>> enumModels = bean.getEnumModels();
        assertEquals(1, enumModels.size());
        assertEquals("Status", enumModels.get(0).get("enumName"));
        assertEquals("NEW OLD", enumModels.get(0).get("values"));

        // enum -> application
        assertNotNull(enumModels.get(0).get("application"));
        Map<String, Object> applicationModel = (Map<String, Object>) enumModels.get(0).get("application");
        assertEquals("com.mycompany.fake", applicationModel.get("groupId"));
        assertEquals("fake-app", applicationModel.get("artifactId"));
        assertEquals("1.2.3-SNAPSHOT", applicationModel.get("version"));
        assertEquals("com.mycompany.fake.app", applicationModel.get("basePackage"));
        assertEquals("Fake application.", applicationModel.get("description"));

        // enum -> application -> (customer & order)
        assertNotNull(applicationModel.get("entities"));
        List<Map<String, Object>> entityModels = (List<Map<String, Object>>) applicationModel.get("entities");
        assertEquals(2, entityModels.size());
        assertEquals("Customer", entityModels.get(0).get("entityName"));
        assertEquals("Order", entityModels.get(1).get("entityName"));

        // enum -> application -> customer -> fields
        assertNotNull(entityModels.get(0).get("fields"));
        List<Map<String, Object>> customerFieldModels = (List<Map<String, Object>>) entityModels.get(0).get("fields");
        assertEquals(1, customerFieldModels.size());
        assertEquals("name", customerFieldModels.get(0).get("fieldName"));
        assertEquals("Customer Name", customerFieldModels.get(0).get("label"));
        assertEquals("String", customerFieldModels.get(0).get("type"));

        // enum -> application -> customer -> fields
        assertNotNull(entityModels.get(1).get("fields"));
        List<Map<String, Object>> orderFieldModels = (List<Map<String, Object>>) entityModels.get(1).get("fields");
        assertEquals(2, orderFieldModels.size());
        assertEquals("number", orderFieldModels.get(0).get("fieldName"));
        assertEquals("Order Number", orderFieldModels.get(0).get("label"));
        assertEquals("Integer", orderFieldModels.get(0).get("type"));
        assertEquals("status", orderFieldModels.get(1).get("fieldName"));
        assertEquals("Order Status", orderFieldModels.get(1).get("label"));
        assertEquals("Status", orderFieldModels.get(1).get("type"));
    }

    private static Properties buildAppProps(String tempDirPath) {
        Properties fakeAppProps = new Properties();
        fakeAppProps.setProperty("project.type", "norman.flunky.main.fake.FakeProjectType");
        fakeAppProps.setProperty("project.directory", tempDirPath + "/fake-app");
        fakeAppProps.setProperty("group.id", "com.mycompany.fake");
        fakeAppProps.setProperty("artifact.id", "fake-app");
        fakeAppProps.setProperty("version", "1.2.3-SNAPSHOT");
        fakeAppProps.setProperty("base.package", "com.mycompany.fake.app");
        fakeAppProps.setProperty("description", "Fake application.");
        fakeAppProps.setProperty("entities.file", "fake-app-entities.csv");
        fakeAppProps.setProperty("fields.file", "fake-app-fields.csv");
        fakeAppProps.setProperty("enums.file", "fake-app-enums.csv");
        return fakeAppProps;
    }

    private static File writeAppProps(String dirPath, String fileName, Properties fakeAppProps) throws Exception {
        File propsFile = new File(dirPath, fileName);
        FileOutputStream outputStream = null;
        try {
            outputStream = new FileOutputStream(propsFile);
            fakeAppProps.store(outputStream, "data for unit tests");
        } catch (IOException e) {
            throw new Exception(String.format("Unable to write to file %s in directory %s.", fileName, dirPath), e);
        } finally {
            if (outputStream != null) {
                try {
                    outputStream.close();
                    LOGGER.info(
                            String.format("TEST: Successfully wrote properties to file %s in directory %s.", fileName,
                                    dirPath));
                } catch (IOException e) {
                    LOGGER.warn(String.format("Unable to close file %s in directory %s.", fileName, dirPath), e);
                }
            }
        }
        return propsFile;
    }

    private static void writeCsvFile(String dirPath, String fileName, String[] lines) throws Exception {
        File entitiesCsvFile = new File(dirPath, fileName);
        PrintWriter writer = null;
        try {
            writer = new PrintWriter(entitiesCsvFile);
            for (String line : lines) {
                writer.println(line);
            }
            writer.flush();
        } catch (FileNotFoundException e) {
            throw new Exception("Unable to write to file " + fileName + " in directory " + dirPath + ".", e);
        } finally {
            if (writer != null) {
                writer.close();
                LOGGER.info(String.format("TEST: Successfully wrote CSV data to file %s in directory %s.", fileName,
                        dirPath));
            }
        }
    }
}
