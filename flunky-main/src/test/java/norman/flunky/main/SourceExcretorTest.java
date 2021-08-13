package norman.flunky.main;

import norman.flunky.api.GenerationBean;
import norman.flunky.api.TemplateType;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class SourceExcretorTest {
    private static final Logger LOGGER = LoggerFactory.getLogger(SourceExcretorTest.class);
    String projectDirectoryPath;
    SourceExcretor excretor;

    @BeforeEach
    void setUp() throws IOException {
        String tempDirectory = Files.createTempDirectory("flunky-main-test-data-").toFile().getAbsolutePath();
        projectDirectoryPath =
                tempDirectory + File.separator + RandomStringUtils.randomAlphabetic(10) + File.separator +
                        RandomStringUtils.randomAlphabetic(10);
        String templatePrefix = "flunky/main/test/templates";
        excretor = SourceExcretor.instance(projectDirectoryPath, templatePrefix);
    }

    @AfterEach
    void tearDown() {
        excretor = null;
        projectDirectoryPath = null;
    }

    @Test
    void createProjectDirectory() throws IOException {
        // Verify project directory does not exist.
        assertFalse(new File(projectDirectoryPath).exists());
        LOGGER.info(String.format("TEST Verifying file %s does not already exist.", projectDirectoryPath));

        // Execute test.
        File projectDirectory = excretor.createProjectDirectory();

        // Verify directory was created.
        assertTrue(projectDirectory.exists());
        assertTrue(projectDirectory.isDirectory());
        assertSame(projectDirectoryPath, projectDirectory.getAbsolutePath());
    }

    @Test
    void generateSourceFileCopy() throws IOException {
        Map<String, Object> dataModel = new HashMap<>();
        String templateName = "test-copy-template.txt";
        String outputFilePath = "copy/test/path/outfile.txt";
        TemplateType templateType = TemplateType.COPY;
        GenerationBean genBean = new GenerationBean(templateName, outputFilePath, templateType);

        // Execute test.
        File sourceFile = excretor.generateSourceFile(dataModel, genBean);
        LOGGER.info(String.format("TEST Created source file %s.", sourceFile.getAbsolutePath()));

        // Verify results.
        assertTrue(sourceFile.exists());
        assertTrue(sourceFile.isFile());
        assertEquals("outfile.txt", sourceFile.getName());
        // @formatter:off
        assertTrue(StringUtils.endsWith(sourceFile.getParent(),
                "copy" + File.separator +
                        "test" + File.separator +
                        "path"));
        // @formatter:on
        BufferedReader reader = new BufferedReader(new FileReader(sourceFile));
        assertEquals("This is a test.", reader.readLine());
        assertEquals("This is only a test.", reader.readLine());
        assertNull(reader.readLine());
    }

    @Test
    void generateSourceFileGenerate() throws IOException {
        Map<String, Object> dataModel = new HashMap<>();
        dataModel.put("package", "my.test.package");
        dataModel.put("clazz", "Hello");
        dataModel.put("name", "Testy McTester");
        String templateName = "test-generate-template.ftl";
        String outputFilePath = "/src/main/java/${package?replace(\".\", \"/\")}/${clazz}.java";
        TemplateType templateType = TemplateType.GENERATE;
        GenerationBean genBean = new GenerationBean(templateName, outputFilePath, templateType);

        // Execute test.
        File sourceFile = excretor.generateSourceFile(dataModel, genBean);
        LOGGER.info(String.format("TEST Created source file %s.", sourceFile.getAbsolutePath()));

        // Verify results.
        assertTrue(sourceFile.exists());
        assertTrue(sourceFile.isFile());
        assertEquals("Hello.java", sourceFile.getName());
        // @formatter:off
        assertTrue(StringUtils.endsWith(sourceFile.getParent(),
                "src" + File.separator +
                        "main" + File.separator +
                        "java" + File.separator +
                        "my" + File.separator +
                        "test" + File.separator +
                        "package"));
        // @formatter:on
        BufferedReader reader = new BufferedReader(new FileReader(sourceFile));
        assertEquals("package my.test.package;", reader.readLine());
        assertEquals("", reader.readLine());
        assertEquals("public class Hello {", reader.readLine());
        assertEquals("    public static void main(String[] args) {", reader.readLine());
        assertEquals("        System.out.println(\"Hello Testy McTester!\");", reader.readLine());
        assertEquals("    }", reader.readLine());
        assertEquals("}", reader.readLine());
        assertNull(reader.readLine());
    }
}
