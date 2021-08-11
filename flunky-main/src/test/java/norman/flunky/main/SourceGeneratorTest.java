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

class SourceGeneratorTest {
    private static final Logger LOGGER = LoggerFactory.getLogger(SourceGeneratorTest.class);
    SourceGenerator generator;

    @BeforeEach
    void setUp() {
        generator = SourceGenerator.instance();
    }

    @AfterEach
    void tearDown() {
        generator = null;
    }

    @Test
    void createProjDir() throws IOException {
        // Create a non-existent directory object.
        String tempDirPath = Files.createTempDirectory("flunky-main-test-data-").toFile().getAbsolutePath();
        String dir1 = RandomStringUtils.randomAlphabetic(10);
        String dir2 = RandomStringUtils.randomAlphabetic(10);
        File projDir1 = new File(tempDirPath + File.separator + dir1 + File.separator + dir2);
        LOGGER.info(String.format("TEST Creating file object %s.", projDir1.getAbsolutePath()));
        assertFalse(projDir1.exists());

        // Execute test.
        File projDir2 = generator.createProjDir(projDir1);

        // Verify directory was created.
        assertTrue(projDir2.exists());
        assertTrue(projDir2.isDirectory());
        assertSame(projDir1, projDir2);
    }

    @Test
    void createSourceFileCopy() throws IOException {
        String tmpPrefix = "flunky/main/test/templates";
        File projDir = Files.createTempDirectory("flunky-main-test-data-").toFile();
        Map<String, Object> dataModel = new HashMap<>();
        String templateName = "test-copy-template.txt";
        String outputFilePath = "copy/test/path/outfile.txt";
        TemplateType templateType = TemplateType.COPY;
        GenerationBean genBean = new GenerationBean(templateName, outputFilePath, templateType);

        // Execute test.
        File sourceFile = generator.createSourceFile(tmpPrefix, projDir, dataModel, genBean);
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
        BufferedReader reader = new BufferedReader(new FileReader(sourceFile));
        assertEquals("This is a test.", reader.readLine());
        assertEquals("This is only a test.", reader.readLine());
        assertNull(reader.readLine());
    }

    @Test
    void createSourceFileGenerate() throws IOException {
        String tmpPrefix = "flunky/main/test/templates";
        File projDir = Files.createTempDirectory("flunky-main-test-data-").toFile();
        Map<String, Object> dataModel = new HashMap<>();
        dataModel.put("package", "my.test.package");
        dataModel.put("clazz", "Hello");
        dataModel.put("name", "Testy McTester");
        String templateName = "test-generate-template.ftl";
        String outputFilePath = "/src/main/java/${package?replace(\".\", \"/\")}/${clazz}.java";
        TemplateType templateType = TemplateType.GENERATE;
        GenerationBean genBean = new GenerationBean(templateName, outputFilePath, templateType);

        // Execute test.
        File sourceFile = generator.createSourceFile(tmpPrefix, projDir, dataModel, genBean);
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
