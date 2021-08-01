package norman.flunky.main;

import freemarker.core.ParseException;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import norman.flunky.api.GenerationBean;
import norman.flunky.api.ProjectType;
import norman.flunky.api.TemplateType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.nio.file.Files;
import java.util.List;
import java.util.Map;

public class Main {
    private static final Logger LOGGER = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) {
        // Validate arguments.
        validateArgs(args);

        // Convert applications properties file to a bean.
        //ApplicationBean appBean = new ApplicationBean(args[0]);
        ApplicationBean appBean = ApplicationBean.instance(args[0]);
        ProjectType type = appBean.getProjectType();
        String tmpPrefix = type.getTemplatePrefix();

        // Create Freemarker configuration.
        Configuration cfg = new Configuration(Configuration.VERSION_2_3_30);

        // Get context class loader so we can use it to get resources, i.e. template files that are in a jar file.
        ClassLoader loader = Thread.currentThread().getContextClassLoader();

        // Create project directory.
        File projDir = createProjDir(appBean.getProjectDirectory());
        LOGGER.info("Creating project in directory " + projDir + ".");

        // Create application source files.
        Map<String, Object> appModel = appBean.getApplicationModel();
        for (GenerationBean appGenBean : type.getApplicationGenerationProperties()) {
            createSourceFile(cfg, loader, tmpPrefix, projDir, appModel, appGenBean);
        }

        // Create enum source files.
        List<Map<String, Object>> enumModels = appBean.getEnumModels();
        for (Map<String, Object> enumModel : enumModels) {
            for (GenerationBean enumGenBean : type.getEnumGenerationProperties()) {
                createSourceFile(cfg, loader, tmpPrefix, projDir, enumModel, enumGenBean);
            }
        }

        // Create entity source files.
        for (Map<String, Object> entModel : appBean.getEntityModels()) {
            for (GenerationBean entGenBean : type.getEntityGenerationProperties()) {
                createSourceFile(cfg, loader, tmpPrefix, projDir, entModel, entGenBean);
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

    private static void createSourceFile(Configuration cfg, ClassLoader loader, String tmpPrefix, File projDir,
            Map<String, Object> dataModel, GenerationBean genBean) {
        String outPath = generatePath(cfg, genBean.getOutputFilePath(), dataModel);
        File outFile = createOutputFile(projDir, outPath);
        String templateName = genBean.getTemplateName();
        if (genBean.getTemplateType() == TemplateType.COPY) {
            copySourceFile(loader, tmpPrefix, templateName, outFile);
        } else {
            generateSourceFile(cfg, loader, tmpPrefix, templateName, outFile, dataModel);
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

    private static void copySourceFile(ClassLoader loader, String tmpPrefix, String tmpName, File outFile) {
        InputStream template = null;
        try {
            template = loader.getResourceAsStream(tmpPrefix + "/" + tmpName);
            Files.copy(template, outFile.toPath());
        } catch (IOException e) {
            throw new LoggingException(LOGGER, "Unable to copy template " + tmpName + " to file " + outFile + ".", e);
        } finally {
            if (template != null) {
                try {
                    template.close();
                } catch (IOException e) {
                    LOGGER.warn("Unable to close input stream for template " + tmpName + ".");
                }
            }
        }
    }

    private static void generateSourceFile(Configuration cfg, ClassLoader loader, String tmpPrefix, String tmpName,
            File outFile, Map<String, Object> dataModel) {
        InputStream template = loader.getResourceAsStream(tmpPrefix + "/" + tmpName);
        Writer writer = null;
        try {
            if (template == null) {
                throw new LoggingException(LOGGER, "Unable to find template " + tmpName);
            }
            try {
                writer = new FileWriter(outFile);
            } catch (IOException e) {
                throw new LoggingException(LOGGER, "Unable to open writer for file " + outFile, e);
            }
            try {
                Template tmp = new Template("name", new InputStreamReader(template), cfg);
                tmp.process(dataModel, writer);
            } catch (ParseException | TemplateException e) {
                throw new LoggingException(LOGGER, "Unable to process template " + tmpName, e);
            } catch (IOException e) {
                throw new LoggingException(LOGGER, "Unable to open input stream for template " + tmpName, e);
            }
        } finally {
            if (template != null) {
                try {
                    template.close();
                } catch (IOException e) {
                    LOGGER.warn("Unable to close input stream for template " + tmpName + ".");
                }
            }
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
