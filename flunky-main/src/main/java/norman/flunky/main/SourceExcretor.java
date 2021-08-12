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

public class SourceExcretor {
    private static final Logger LOGGER = LoggerFactory.getLogger(SourceExcretor.class);
    private File projectDirectory;
    private String templatePrefix;
    private Configuration configuration;
    private ClassLoader loader;

    public static SourceExcretor instance(File projectDirectory, String templatePrefix) {
        // Create Freemarker configuration.
        Configuration configuration = new Configuration(Configuration.VERSION_2_3_30);

        // Get context class loader so we can use it to get resources, i.e. template files that are in a jar file.
        ClassLoader loader = Thread.currentThread().getContextClassLoader();

        return new SourceExcretor(projectDirectory, templatePrefix, configuration, loader);
    }

    private SourceExcretor(File projectDirectory, String templatePrefix, Configuration configuration,
            ClassLoader loader) {
        this.projectDirectory = projectDirectory;
        this.templatePrefix = templatePrefix;
        this.configuration = configuration;
        this.loader = loader;
    }

    public File generateSourceFile(Map<String, Object> dataModel, GenerationBean genBean) {
        String outPath = buildPath(genBean.getOutputFilePath(), dataModel);
        File outFile = createOutputFileAndDirectory(outPath);
        String templateName = genBean.getTemplateName();
        if (genBean.getTemplateType() == TemplateType.COPY) {
            copySourceFile(templateName, outFile);
        } else {
            buildSourceFile(templateName, outFile, dataModel);
        }
        return outFile;
    }

    private String buildPath(String templateString, Map<String, Object> dataModel) {
        Writer writer = new StringWriter();
        try {
            Template template = new Template("name", new StringReader(templateString), configuration);
            template.process(dataModel, writer);
            return writer.toString();
        } catch (IOException | TemplateException e) {
            throw new LoggingException(LOGGER, String.format("Unable to process string %s.", templateString), e);
        }
    }

    private File createOutputFileAndDirectory(String outPath) {
        File file = new File(projectDirectory, outPath);
        File parentDir = file.getParentFile();
        if (!parentDir.exists() && !parentDir.mkdirs()) {
            throw new LoggingException(LOGGER,
                    String.format("Unable to create directory %s.", parentDir.getAbsolutePath()));
        }
        return file;
    }

    private void copySourceFile(String templateName, File outFile) {
        InputStream templateStream = null;
        try {
            templateStream = loader.getResourceAsStream(templatePrefix + "/" + templateName);
            Files.copy(templateStream, outFile.toPath());
        } catch (IOException e) {
            throw new LoggingException(LOGGER,
                    String.format("Unable to copy template %s to file %s.", templateName, outFile.getAbsolutePath()),
                    e);
        } finally {
            if (templateStream != null) {
                try {
                    templateStream.close();
                } catch (IOException e) {
                    LOGGER.warn(String.format("Unable to close input stream for template %s.", templateName));
                }
            }
        }
    }

    private void buildSourceFile(String templateName, File outFile, Map<String, Object> dataModel) {
        InputStream templateStream = loader.getResourceAsStream(templatePrefix + "/" + templateName);
        Writer writer = null;
        try {
            if (templateStream == null) {
                throw new LoggingException(LOGGER, String.format("Unable to find template %s.", templateName));
            }
            try {
                writer = new FileWriter(outFile);
            } catch (IOException e) {
                throw new LoggingException(LOGGER,
                        String.format("Unable to open writer for file %s.", outFile.getAbsolutePath()), e);
            }
            try {
                Template template = new Template("name", new InputStreamReader(templateStream), configuration);
                template.process(dataModel, writer);
            } catch (ParseException | TemplateException e) {
                throw new LoggingException(LOGGER, String.format("Unable to process template %s.", templateName), e);
            } catch (IOException e) {
                throw new LoggingException(LOGGER,
                        String.format("Unable to open input stream for template %s.", templateName), e);
            }
        } finally {
            if (templateStream != null) {
                try {
                    templateStream.close();
                } catch (IOException e) {
                    LOGGER.warn(String.format("Unable to close input stream for template %s.", templateName));
                }
            }
            if (writer != null) {
                try {
                    writer.close();
                } catch (IOException e) {
                    LOGGER.warn(String.format("Unable to close writer for file %s.", outFile.getAbsolutePath()), e);
                }
            }
        }
    }
}
