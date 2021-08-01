package norman.flunky.main;

import norman.flunky.api.ProjectType;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

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
    static File propsFile;
    ApplicationBean bean;

    @BeforeAll
    static void oneTimeSetUp() throws Exception {
        // Get temp directory.
        String tempDirPath = Files.createTempDirectory("flunky-main-test-data").toFile().getAbsolutePath();

        // Write application properties file.
        Properties fakeAppProps = buildAppProps(tempDirPath);
        File propsFile = writeAppProps(tempDirPath, "fake-app.properties", fakeAppProps);
        ApplicationBeanTest.propsFile = propsFile;

        // Write enums csv file.
        String[] enumsLines = {"enumName, values", "Status, NEW OLD"};
        writeCsvFile(tempDirPath, "fake-app-enums.csv", enumsLines);

        // Write entities csv file.
        String[] entityLines = {"entityName", "Customer", "Order"};
        writeCsvFile(tempDirPath, "fake-app-entities.csv", entityLines);

        // Write fields csv file.
        String[] fielcLines = {"entityName,fieldName,label,type", "Customer,name,Customer Name,String",
                "Order,number,Order Number,Integer", "Order,status,Order Status,Status"};
        writeCsvFile(tempDirPath, "fake-app-fields.csv", fielcLines);
    }

    @BeforeEach
    void setUp() {
        bean = ApplicationBean.instance(propsFile.getAbsolutePath());
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
        assertNotNull(applicationModel.get("enums"));
        assertNotNull(applicationModel.get("entities"));
        // TODO 8/1/2021 Check for elephants all the way down.
    }

    @Test
    void getEntityModels() {
        List<Map<String, Object>> entityModels = bean.getEntityModels();
        System.out.println(entityModels);
        assertEquals(2, entityModels.size());
        assertEquals("Customer", entityModels.get(0).get("entityName"));
        assertEquals("Order", entityModels.get(1).get("entityName"));
        // TODO 8/1/2021 Check for elephants all the way down.
    }

    @Test
    void getEnumModels() {
        List<Map<String, Object>> enumModels = bean.getEnumModels();
        System.out.println(enumModels);
        assertEquals(1, enumModels.size());
        assertEquals("Status", enumModels.get(0).get("enumName"));
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
            throw new Exception("Unable to write to file " + fileName + " in directory " + dirPath + ".", e);
        } finally {
            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (IOException ignored) {
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
            }
        }
    }
}
