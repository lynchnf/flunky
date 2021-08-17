package norman.flunky.api;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public abstract class AbstractProjectType implements ProjectType {
    @Override
    public List<String> validate(Map<String, String> applicationData, List<Map<String, String>> entitiesData,
            List<Map<String, String>> fieldsData, List<Map<String, String>> enumsData) {
        List<String> validationErrors = new ArrayList<>();
        List<String> entityNameList = new ArrayList<>();
        for (Map<String, String> entityRow : entitiesData) {
            String entityName = entityRow.get("entityName");
            if (entityName == null) {
                validationErrors.add("Entity Name is required in the entities CSV file.");
            }
            if (entityNameList.contains(entityName)) {
                validationErrors.add(String
                        .format("Entity Name must be unique in the entities CSV file. Entity Name %s appears more than once.",
                                entityName));
            }
            entityNameList.add(entityName);
        }

        Map<String, List<String>> entityFieldMap = new HashMap<>();
        for (Map<String, String> fieldRow : fieldsData) {
            String entityName = fieldRow.get("entityName");
            String fieldName = fieldRow.get("fieldName");
            if (entityName == null) {
                validationErrors.add("Entity Name is required in the fields CSV file.");
            }
            if (fieldName == null) {
                validationErrors.add("Field Name is required in the fields CSV file.");
            }
            if (!entityNameList.contains(entityName)) {
                validationErrors.add(String
                        .format("Entity Name in the fields CSV file must appear in the entities CSV file. Entity name %s appears in the fields CSV file, but not the entities CSV file.",
                                entityName));
            }
            List<String> fieldNameList = entityFieldMap.get(entityName);
            if (fieldNameList == null) {
                fieldNameList = new ArrayList<>();
                entityFieldMap.put(entityName, fieldNameList);
            }
            if (fieldNameList.contains(fieldName)) {
                validationErrors.add(String
                        .format("Field Name must be unique for a given Entity Name in the fields CSV file. Field Name %s appears more than once for Entity Name %s.",
                                fieldName, entityName));
            }
            fieldNameList.add(fieldName);
        }

        return validationErrors;
    }
}
