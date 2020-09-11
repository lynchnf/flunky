package norman.flunky;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Map;

public class Main {
    private static final Logger LOGGER = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) {
        // Validate arguments.
        validateArgs(args);

        // Convert applications properties file to a bean.
        ApplicationBean appBean = new ApplicationBean(args[0]);
        ProjectType type = appBean.getProjectType();

        // Create Freemarker configuration for paths.
        Configuration pthCfg = new Configuration(Configuration.VERSION_2_3_30);

        // Create Freemarker configuration for templates.
        Configuration tmpCfg = createTemplateConfiguration(type);

        // Create project directory.
        File projDir = createProjDir(appBean.getProjectDirectory());
        LOGGER.info("Creating project in directory " + projDir + ".");

        Map<String, Object> appModel = appBean.getApplicationModel();
        for (GenerationBean appGenBean : type.getApplicationGenerationProperties()) {
            String outputPath = generatePath(pthCfg, appGenBean.getOutputFilePath(), appModel);
            File outputFile = createOutputFile(projDir, outputPath);
            generateSourceFile(tmpCfg, appGenBean.getTemplateName(), outputFile, appModel);
            LOGGER.info("Created source file " + outputFile + ".");
        }

        for (Map<String, Object> entModel : appBean.getEntityModels()) {
            for (GenerationBean entGenBean : type.getEntityGenerationProperties()) {
                String outputPath = generatePath(pthCfg, entGenBean.getOutputFilePath(), entModel);
                File outputFile = createOutputFile(projDir, outputPath);
                generateSourceFile(tmpCfg, entGenBean.getTemplateName(), outputFile, entModel);
                LOGGER.info("Created source file " + outputFile + ".");
            }
        }
        LOGGER.info("Project created successfully!");
    }

    private static void validateArgs(String[] args) {
        if (args == null || args.length < 1) {
            throw new LoggingException(LOGGER, "Missing program argument.");
        }
    }

    private static File createProjDir(File dir) {
        if (!dir.mkdirs()) {
            throw new LoggingException(LOGGER, "Unable to create project directory " + dir + ".");
        }
        return dir;
    }

    private static Configuration createTemplateConfiguration(ProjectType type) {
        Configuration cfg = new Configuration(Configuration.VERSION_2_3_30);

        ClassLoader contextClassLoader = Thread.currentThread().getContextClassLoader();
        URL resource = contextClassLoader.getResource("templates/readme.txt");
        try {
            File readmeFile = new File(resource.toURI().getPath());
            File dir = new File(readmeFile.getParentFile(), type.name());
            cfg.setDirectoryForTemplateLoading(dir);

            cfg.setDefaultEncoding("UTF-8");
            // TODO During web page *development* TemplateExceptionHandler.HTML_DEBUG_HANDLER is better.
            //cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
            cfg.setTemplateExceptionHandler(TemplateExceptionHandler.HTML_DEBUG_HANDLER);
            cfg.setLogTemplateExceptions(false);
            cfg.setWrapUncheckedExceptions(true);
            cfg.setFallbackOnNullLoopVariable(false);
            return cfg;
        } catch (URISyntaxException | IOException e) {
            throw new LoggingException(LOGGER,
                    "Unable to set template loading directory templates/" + type.name() + ".", e);
        }
    }

    private static String generatePath(Configuration cfg, String templateString, Map<String, Object> dataModel) {
        Writer writer = new StringWriter();
        try {
            Template temp = new Template("name", new StringReader(templateString), cfg);
            temp.process(dataModel, writer);
            return writer.toString();
        } catch (IOException | TemplateException e) {
            throw new LoggingException(LOGGER, "Unable to process string " + templateString + ".", e);
        }
    }

    private static File createOutputFile(File projDir, String outputFilePath) {
        File file = new File(projDir, outputFilePath);
        File parentDir = file.getParentFile();
        if (!parentDir.exists() && !parentDir.mkdirs()) {
            throw new LoggingException(LOGGER, "Unable to create directory " + parentDir + ".");
        }
        return file;
    }

    private static void generateSourceFile(Configuration cfg, String templateName, File outputFile,
            Map<String, Object> dataModel) {
        Writer writer = null;
        try {
            Template temp = cfg.getTemplate(templateName);
            writer = new FileWriter(outputFile);
            temp.process(dataModel, writer);
        } catch (IOException | TemplateException e) {
            throw new LoggingException(LOGGER,
                    "Unable to process template " + templateName + " to file " + outputFile + ".", e);
        } finally {
            if (writer != null) {
                try {
                    writer.close();
                } catch (IOException e) {
                    LOGGER.warn("Unable to close writer for file " + outputFile + ".", e);
                }
            }
        }
    }
}
