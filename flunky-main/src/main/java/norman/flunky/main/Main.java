package norman.flunky.main;

import norman.flunky.api.GenerationBean;
import norman.flunky.api.ProjectType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.Map;

public class Main {
    private static final Logger LOGGER = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) {
        // Validate arguments.
        validateArgs(args);

        // Convert applications properties file to a bean.
        ApplicationBean appBean = ApplicationBean.instance(args[0]);
        ProjectType type = appBean.getProjectType();
        String tmpPrefix = type.getTemplatePrefix();

        // Create project directory.
        SourceGenerator generator = SourceGenerator.instance();
        File projDir = generator.createProjDir(appBean.getProjectDirectory());
        LOGGER.info("Creating project in directory " + projDir + ".");

        // Create application source files.
        Map<String, Object> appModel = appBean.getApplicationModel();
        for (GenerationBean appGenBean : type.getApplicationGenerationProperties()) {
            File outFile = generator.createSourceFile(tmpPrefix, projDir, appModel, appGenBean);
            LOGGER.info("Created source file " + outFile + ".");
        }

        // Create enum source files.
        for (Map<String, Object> enumModel : appBean.getEnumModels()) {
            for (GenerationBean enumGenBean : type.getEnumGenerationProperties()) {
                File outFile = generator.createSourceFile(tmpPrefix, projDir, enumModel, enumGenBean);
                LOGGER.info("Created source file " + outFile + ".");
            }
        }

        // Create entity source files.
        for (Map<String, Object> entModel : appBean.getEntityModels()) {
            for (GenerationBean entGenBean : type.getEntityGenerationProperties()) {
                File outFile = generator.createSourceFile(tmpPrefix, projDir, entModel, entGenBean);
                LOGGER.info("Created source file " + outFile + ".");
            }
        }
        LOGGER.info("Project created successfully!");
    }

    private static void validateArgs(String[] args) {
        if (args == null || args.length < 1) {
            throw new LoggingException(LOGGER, "Missing program argument.");
        }
    }
}
