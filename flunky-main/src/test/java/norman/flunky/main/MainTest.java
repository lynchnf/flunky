package norman.flunky.main;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;
import java.nio.file.Files;
import java.util.Properties;

import org.junit.Test;

public class MainTest {
    @Test
    public void testMain() throws Exception {
        // Create temporary directory to hold test files.
        File tempDir = Files.createTempDirectory("main-test-").toFile();
        File dataDir = new File(tempDir, "data");
        dataDir.mkdirs();

        // Create project properties test file.
        Properties props = new Properties();
        props.setProperty("project.type", "norman.flunky.main.fake.FakeProjectType");
        File outputDir = new File(tempDir, "output");
        props.setProperty("project.directory", outputDir.getAbsolutePath());
        props.setProperty("group.id", "com.mycompany.test");
        props.setProperty("artifact.id", "test-app");
        props.setProperty("version", "0.1.0-SNAPSHOT");
        props.setProperty("base.package", "com.mycompany.test.app");
        props.setProperty("description", "My test application.");
        props.setProperty("entities.file", "test-app-entities.csv");
        props.setProperty("fields.file", "test-app-fields.csv");
        File propsFile = new File(dataDir, "test-app.properties");
        Writer propsWriter = new FileWriter(propsFile);
        props.store(propsWriter, "Main Test Properties");
        propsWriter.close();

        // Create entities CSV test file.
        File entitiesFile = new File(dataDir, "test-app-entities.csv");
        PrintWriter entitiesWriter = new PrintWriter(new FileWriter(entitiesFile));
        entitiesWriter.println("entityName,otherEntProp");
        entitiesWriter.println("Foo,ant");
        entitiesWriter.println("Bar,bee");
        entitiesWriter.close();

        // Create fields CSV test file.
        File fieldsFile = new File(dataDir, "test-app-fields.csv");
        PrintWriter fieldsWriter = new PrintWriter(new FileWriter(fieldsFile));
        fieldsWriter.println("entityName,fieldName,otherFieldProp");
        fieldsWriter.println("Foo,one,alfalfa");
        fieldsWriter.println("Bar,two,barley");
        fieldsWriter.println("Bar,three,corn");
        fieldsWriter.close();

        // Run Flunky.
        Main.main(new String[] { propsFile.getAbsolutePath() });

        // Validate all the output files were created correctly.
        validateOutputFile(outputDir, "copy-test.txt", new String[] { "This is a test.", "This is only a test." });
        validateOutputFile(outputDir, "src/proj-gen.txt",
                new String[] { "Title is Test App", "Entity is Foo ant", "Entity is Bar bee" });
        validateOutputFile(outputDir, "src/com/mycompany/test/app/Foo-gen.txt",
                new String[] { "Base Package is com.mycompany.test.app", "Entity is Foo", "Field is one alfalfa" });
        validateOutputFile(outputDir, "src/com/mycompany/test/app/Bar-gen.txt",
                new String[] { "Base Package is com.mycompany.test.app", "Entity is Bar", "Field is two barley",
                        "Field is three corn" });
    }

    private void validateOutputFile(File outputDir, String outputFilePath, String[] expectedLines)
            throws FileNotFoundException, IOException {
        BufferedReader reader = new BufferedReader(new FileReader(new File(outputDir, outputFilePath)));
        String line = reader.readLine();
        int lineNbr = 0;
        while (line != null) {
            String message = "Line " + lineNbr + " of file " + outputFilePath + " not match expected value.";
            if (lineNbr < expectedLines.length) {
                assertEquals(message, expectedLines[lineNbr], line);
            } else {
                fail("Too many lines in file " + outputFilePath + ".");
            }
            line = reader.readLine();
            lineNbr++;
        }
        if (lineNbr < expectedLines.length) {
            fail("Not enought lines in file " + outputFilePath + ".");
        }
        reader.close();
    }
}
