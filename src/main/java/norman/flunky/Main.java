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
import java.nio.file.Files;
import java.util.Map;

import static norman.flunky.TemplateType.COPY;

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
        File tmpDir = getTemplateDir(type);
        Configuration tmpCfg = createTemplateConfiguration(tmpDir);

        // Create project directory.
        File projDir = createProjDir(appBean.getProjectDirectory());
        LOGGER.info("Creating project in directory " + projDir + ".");

        // Create application source files.
        Map<String, Object> appModel = appBean.getApplicationModel();
        for (GenerationBean appGenBean : type.getApplicationGenerationProperties()) {
            createSourceFile(pthCfg, tmpDir, tmpCfg, projDir, appModel, appGenBean);
        }

        // Create entity source files.
        for (Map<String, Object> entModel : appBean.getEntityModels()) {
            for (GenerationBean entGenBean : type.getEntityGenerationProperties()) {
                createSourceFile(pthCfg, tmpDir, tmpCfg, projDir, entModel, entGenBean);
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

    private static File getTemplateDir(ProjectType type) {
        ClassLoader contextClassLoader = Thread.currentThread().getContextClassLoader();
        URL resource = contextClassLoader.getResource("templates/readme.txt");
        try {
            File readmeFile = new File(resource.toURI().getPath());
            return new File(readmeFile.getParentFile(), type.name());
        } catch (URISyntaxException e) {
            throw new LoggingException(LOGGER, "Unable to resolve template directory.", e);
        }
    }

    private static Configuration createTemplateConfiguration(File tmpDir) {
        Configuration cfg = new Configuration(Configuration.VERSION_2_3_30);
        try {
            cfg.setDirectoryForTemplateLoading(tmpDir);
            cfg.setDefaultEncoding("UTF-8");
            // TODO During web page *development* TemplateExceptionHandler.HTML_DEBUG_HANDLER is better.
            //cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
            cfg.setTemplateExceptionHandler(TemplateExceptionHandler.HTML_DEBUG_HANDLER);
            cfg.setLogTemplateExceptions(false);
            cfg.setWrapUncheckedExceptions(true);
            cfg.setFallbackOnNullLoopVariable(false);
            return cfg;
        } catch (IOException e) {
            throw new LoggingException(LOGGER, "Unable to set template loading directory " + tmpDir + ".", e);
        }
    }

    private static void createSourceFile(Configuration pthCfg, File tmpDir, Configuration tmpCfg, File projDir,
            Map<String, Object> dataModel, GenerationBean genBean) {
        String outPath = generatePath(pthCfg, genBean.getOutputFilePath(), dataModel);
        File outFile = createOutputFile(projDir, outPath);
        String templateName = genBean.getTemplateName();
        if (genBean.getTemplateType() == COPY) {
            copySourceFile(tmpDir, templateName, outFile);
        } else {
            generateSourceFile(tmpCfg, templateName, outFile, dataModel);
        }
        LOGGER.info("Created source file " + outFile + ".");
    }

    private static String generatePath(Configuration cfg, String tmpStr, Map<String, Object> dataModel) {
        Writer writer = new StringWriter();
        try {
            Template tmp = new Template("name", new StringReader(tmpStr), cfg);
            tmp.process(dataModel, writer);
            return writer.toString();
        } catch (IOException | TemplateException e) {
            throw new LoggingException(LOGGER, "Unable to process string " + tmpStr + ".", e);
        }
    }

    private static File createOutputFile(File projDir, String outPath) {
        File file = new File(projDir, outPath);
        File parentDir = file.getParentFile();
        if (!parentDir.exists() && !parentDir.mkdirs()) {
            throw new LoggingException(LOGGER, "Unable to create directory " + parentDir + ".");
        }
        return file;
    }

    private static void copySourceFile(File tmpDir, String tmpName, File outFile) {
        File templateFile = new File(tmpDir, tmpName);
        try {
            Files.copy(templateFile.toPath(), outFile.toPath());
        } catch (IOException e) {
            throw new LoggingException(LOGGER, "Unable to copy file " + templateFile + " to file " + outFile + ".", e);
        }
    }

    private static void generateSourceFile(Configuration cfg, String tmpName, File outFile,
            Map<String, Object> dataModel) {
        Writer writer = null;
        try {
            Template temp = cfg.getTemplate(tmpName);
            writer = new FileWriter(outFile);
            temp.process(dataModel, writer);
        } catch (IOException | TemplateException e) {
            throw new LoggingException(LOGGER, "Unable to process template " + tmpName + " to file " + outFile + ".",
                    e);
        } finally {
            if (writer != null) {
                try {
                    writer.close();
                } catch (IOException e) {
                    LOGGER.warn("Unable to close writer for file " + outFile + ".", e);
                }
            }
        }
    }
}
