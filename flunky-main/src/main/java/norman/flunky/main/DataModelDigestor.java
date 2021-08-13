package norman.flunky.main;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DataModelDigestor {
    private Map<String, Object> applicationModel;
    private List<Map<String, Object>> enumModels;
    private List<Map<String, Object>> entityModels;

    public static DataModelDigestor instance(Map<String, String> applicationData,
            List<Map<String, String>> entitiesData, List<Map<String, String>> fieldsData,
            List<Map<String, String>> enumsData) {
        return new DataModelDigestor(applicationData, entitiesData, fieldsData, enumsData);
    }

    private DataModelDigestor(Map<String, String> applicationData, List<Map<String, String>> entitiesData,
            List<Map<String, String>> fieldsData, List<Map<String, String>> enumsData) {

        // Build application model.
        applicationModel = buildApplicationModel(applicationData, entitiesData, fieldsData, enumsData);

        // Build entity models.
        entityModels = buildEntityModels(applicationData, entitiesData, fieldsData, enumsData);

        // Build enum models.
        enumModels = buildEnumModels(applicationData, entitiesData, fieldsData, enumsData);
    }

    private Map<String, Object> buildApplicationModel(Map<String, String> applicationData,
            List<Map<String, String>> entitiesData, List<Map<String, String>> fieldsData,
            List<Map<String, String>> enumsData) {

        // Create application model.
        Map<String, Object> applicationModel = new LinkedHashMap<>();
        applicationModel.put("groupId", applicationData.get("group.id"));
        applicationModel.put("artifactId", applicationData.get("artifact.id"));
        applicationModel.put("version", applicationData.get("version"));
        applicationModel.put("basePackage", applicationData.get("base.package"));
        applicationModel.put("description", applicationData.get("description"));

        // Add entity models to the application.
        List<Map<String, Object>> entityModels = new ArrayList<>();
        applicationModel.put("entities", entityModels);
        for (Map<String, String> entityRow : entitiesData) {
            Map<String, Object> entityModel = new LinkedHashMap<>(entityRow);
            entityModels.add(entityModel);

            // Add field models to the entities.
            List<Map<String, Object>> fieldModels = new ArrayList<>();
            entityModel.put("fields", fieldModels);
            for (Map<String, String> fieldRow : fieldsData) {
                if (entityRow.get("entityName").equals(fieldRow.get("entityName"))) {
                    Map<String, Object> fieldModel = new LinkedHashMap<>(fieldRow);
                    fieldModels.add(fieldModel);
                }
            }
        }

        // Add enum models to the application.
        List<Map<String, Object>> enumModels = new ArrayList<>();
        applicationModel.put("enums", enumModels);
        for (Map<String, String> enumRow : enumsData) {
            Map<String, Object> enumModel = new LinkedHashMap<>(enumRow);
            enumModels.add(enumModel);
        }

        return applicationModel;
    }

    private List<Map<String, Object>> buildEntityModels(Map<String, String> applicationData,
            List<Map<String, String>> entitiesData, List<Map<String, String>> fieldsData,
            List<Map<String, String>> enumsData) {

        // Create entity models.
        List<Map<String, Object>> entityModels = new ArrayList<>();
        for (Map<String, String> entityRow : entitiesData) {
            Map<String, Object> entityModel = new LinkedHashMap<>(entityRow);
            entityModels.add(entityModel);

            // Add field models to the entities.
            List<Map<String, Object>> fieldModels = new ArrayList<>();
            entityModel.put("fields", fieldModels);
            for (Map<String, String> fieldRow : fieldsData) {
                if (entityRow.get("entityName").equals(fieldRow.get("entityName"))) {
                    Map<String, Object> fieldModel = new LinkedHashMap<>(fieldRow);
                    fieldModels.add(fieldModel);
                }
            }

            // Add application mode to the entities.
            Map<String, Object> applicationModel = new LinkedHashMap<>();
            entityModel.put("application", applicationModel);
            applicationModel.put("groupId", applicationData.get("group.id"));
            applicationModel.put("artifactId", applicationData.get("artifact.id"));
            applicationModel.put("version", applicationData.get("version"));
            applicationModel.put("basePackage", applicationData.get("base.package"));
            applicationModel.put("description", applicationData.get("description"));

            // Add other entity models to the application.
            List<Map<String, Object>> otherEntityModels = new ArrayList<>();
            applicationModel.put("entities", otherEntityModels);
            for (Map<String, String> otherEntityRow : entitiesData) {
                if (!entityRow.get("entityName").equals(otherEntityRow.get("entityName"))) {
                    Map<String, Object> otherEntityModel = new LinkedHashMap<>(otherEntityRow);
                    otherEntityModels.add(otherEntityModel);

                    // Add other field models to the other entities.
                    List<Map<String, Object>> otherFieldModels = new ArrayList<>();
                    otherEntityModel.put("fields", otherFieldModels);
                    for (Map<String, String> otherFieldRow : fieldsData) {
                        if (otherEntityRow.get("entityName").equals(otherFieldRow.get("entityName"))) {
                            Map<String, Object> otherFieldModel = new LinkedHashMap<>(otherFieldRow);
                            otherFieldModels.add(otherFieldModel);
                        }
                    }
                }
            }

            // Add enum models to the application.
            List<Map<String, Object>> enumModels = new ArrayList<>();
            applicationModel.put("enums", enumModels);
            for (Map<String, String> enumRow : enumsData) {
                Map<String, Object> enumModel = new LinkedHashMap<>(enumRow);
                enumModels.add(enumModel);
            }
        }
        return entityModels;
    }

    private List<Map<String, Object>> buildEnumModels(Map<String, String> applicationData,
            List<Map<String, String>> entitiesData, List<Map<String, String>> fieldsData,
            List<Map<String, String>> enumsData) {

        // Create enum models.
        List<Map<String, Object>> enumModels = new ArrayList<>();
        for (Map<String, String> enumRow : enumsData) {
            Map<String, Object> enumModel = new LinkedHashMap<>(enumRow);
            enumModels.add(enumModel);

            Map<String, Object> applicationModel = new LinkedHashMap<>();
            enumModel.put("application", applicationModel);
            applicationModel.put("groupId", applicationData.get("group.id"));
            applicationModel.put("artifactId", applicationData.get("artifact.id"));
            applicationModel.put("version", applicationData.get("version"));
            applicationModel.put("basePackage", applicationData.get("base.package"));
            applicationModel.put("description", applicationData.get("description"));

            // Add entity models to the application.
            List<Map<String, Object>> entityModels = new ArrayList<>();
            applicationModel.put("entities", entityModels);
            for (Map<String, String> entityRow : entitiesData) {
                Map<String, Object> entityModel = new LinkedHashMap<>(entityRow);
                entityModels.add(entityModel);

                // Add field models to the entities.
                List<Map<String, Object>> fieldModels = new ArrayList<>();
                entityModel.put("fields", fieldModels);
                for (Map<String, String> fieldRow : fieldsData) {
                    if (entityRow.get("entityName").equals(fieldRow.get("entityName"))) {
                        Map<String, Object> fieldModel = new LinkedHashMap<>(fieldRow);
                        fieldModels.add(fieldModel);
                    }
                }
            }
        }
        return enumModels;
    }

    public Map<String, Object> getApplicationModel() {
        return applicationModel;
    }

    public List<Map<String, Object>> getEnumModels() {
        return enumModels;
    }

    public List<Map<String, Object>> getEntityModels() {
        return entityModels;
    }
}
