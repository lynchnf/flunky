package norman.flunky.main;

import norman.flunky.api.GenerationBean;
import norman.flunky.api.ProjectType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.List;
import java.util.Map;

import static norman.flunky.main.MessageConstants.MISSING_PROGRAM_ARGUMENT;
import static norman.flunky.main.MessageConstants.VALIDATION_ERRORS_FOUND;

public class Main {
    private static final Logger LOGGER = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) {
        // Simple argument validation.
        if (args == null || args.length < 1) {
            throw new LoggingException(LOGGER, MISSING_PROGRAM_ARGUMENT);
        }

        // Ingest app specification data.
        AppPropertiesIngestor ingestor = AppPropertiesIngestor.instance(args[0]);
        ProjectType projectType = ingestor.getProjectType();
        Map<String, String> applicationData = ingestor.getApplicationData();
        List<Map<String, String>> entitiesData = ingestor.getEntitiesData();
        List<Map<String, String>> fieldsData = ingestor.getFieldsData();
        List<Map<String, String>> enumsData = ingestor.getEnumsData();

        // Validate app specification data.
        List<String> validationErrors = projectType.validate(applicationData, entitiesData, fieldsData, enumsData);
        if (!validationErrors.isEmpty()) {
            for (String validationError : validationErrors) {
                LOGGER.error(validationError);
            }
            throw new LoggingException(LOGGER, VALIDATION_ERRORS_FOUND);
        }

        // Create directory to generate project into.
        String projectDirectoryPath = ingestor.getProjectDirectoryPath();
        String templatePrefix = projectType.getTemplatePrefix();
        SourceExcretor excretor = SourceExcretor.instance(projectDirectoryPath, templatePrefix);
        File projectDirectory = excretor.createProjectDirectory();
        LOGGER.info(String.format("Creating project in directory %s.", projectDirectory.getAbsolutePath()));

        // Convert the specification data into data models for FreeMarker.
        DataModelDigestor digestor = DataModelDigestor.instance(applicationData, entitiesData, fieldsData, enumsData);

        // Create application source files.
        Map<String, Object> applicationModel = digestor.getApplicationModel();
        for (GenerationBean appGenBean : projectType.getApplicationGenerationProperties()) {
            File outFile = excretor.generateSourceFile(applicationModel, appGenBean);
            LOGGER.info("Created source file " + outFile + ".");
        }

        // Create enum source files.
        for (Map<String, Object> enumModel : digestor.getEnumModels()) {
            for (GenerationBean enumGenBean : projectType.getEnumGenerationProperties()) {
                File outFile = excretor.generateSourceFile(enumModel, enumGenBean);
                LOGGER.info("Created source file " + outFile + ".");
            }
        }

        // Create entity source files.
        for (Map<String, Object> entityModel : digestor.getEntityModels()) {
            for (GenerationBean entityGenBean : projectType.getEntityGenerationProperties()) {
                File outFile = excretor.generateSourceFile(entityModel, entityGenBean);
                LOGGER.info("Created source file " + outFile + ".");
            }
        }
        LOGGER.info("Project created successfully!");
    }
}
