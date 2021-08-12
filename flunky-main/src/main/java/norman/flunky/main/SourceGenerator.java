package norman.flunky.main;

import freemarker.core.ParseException;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import norman.flunky.api.GenerationBean;
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
import java.util.Map;

@Deprecated
public class SourceGenerator {
    private static final Logger LOGGER = LoggerFactory.getLogger(SourceGenerator.class);
    private Configuration cfg;
    private ClassLoader loader;

    public static SourceGenerator instance() {
        // Create Freemarker configuration.
        Configuration cfg = new Configuration(Configuration.VERSION_2_3_30);

        // Get context class loader so we can use it to get resources, i.e. template files that are in a jar file.
        ClassLoader loader = Thread.currentThread().getContextClassLoader();

        return new SourceGenerator(cfg, loader);
    }

    private SourceGenerator(Configuration cfg, ClassLoader loader) {
        this.cfg = cfg;
        this.loader = loader;
    }

    public File createProjDir(File dir) {
        if (!dir.mkdirs()) {
            throw new LoggingException(LOGGER, "Unable to create project directory " + dir + ".");
        }
        return dir;
    }

    public File createSourceFile(String tmpPrefix, File projDir, Map<String, Object> dataModel,
            GenerationBean genBean) {
        String outPath = generatePath(genBean.getOutputFilePath(), dataModel);
        File outFile = createOutputFile(projDir, outPath);
        String templateName = genBean.getTemplateName();
        if (genBean.getTemplateType() == TemplateType.COPY) {
            copySourceFile(tmpPrefix, templateName, outFile);
        } else {
            generateSourceFile(tmpPrefix, templateName, outFile, dataModel);
        }
        return outFile;
    }

    private String generatePath(String tmpStr, Map<String, Object> dataModel) {
        Writer writer = new StringWriter();
        try {
            Template tmp = new Template("name", new StringReader(tmpStr), cfg);
            tmp.process(dataModel, writer);
            return writer.toString();
        } catch (IOException | TemplateException e) {
            throw new LoggingException(LOGGER, "Unable to process string " + tmpStr + ".", e);
        }
    }

    private File createOutputFile(File projDir, String outPath) {
        File file = new File(projDir, outPath);
        File parentDir = file.getParentFile();
        if (!parentDir.exists() && !parentDir.mkdirs()) {
            throw new LoggingException(LOGGER, "Unable to create directory " + parentDir + ".");
        }
        return file;
    }

    private void copySourceFile(String tmpPrefix, String tmpName, File outFile) {
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

    private void generateSourceFile(String tmpPrefix, String tmpName, File outFile, Map<String, Object> dataModel) {
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
