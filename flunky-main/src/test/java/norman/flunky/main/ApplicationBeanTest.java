package norman.flunky.main;

import norman.flunky.api.ProjectType;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.io.File;
import java.net.URL;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

public class ApplicationBeanTest {
    private ApplicationBean bean;

    @Before
    public void setUp() throws Exception {
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        URL resource = loader.getResource("testdata/test-app.properties");
        String path = resource.toURI().getPath();

        bean = new ApplicationBean(path);
    }

    @After
    public void tearDown() throws Exception {
        bean = null;
    }

    @Test
    public void testGetProjectType() {
        Object projectType = bean.getProjectType();
        assertTrue(projectType instanceof ProjectType);
    }

    @Test
    public void testGetProjectDirectory() {
        File directory = bean.getProjectDirectory();
        assertEquals("test-dir", directory.getPath());
    }

    @Test
    public void testGetApplicationModel() {
        Map<String, Object> applicationModel = bean.getApplicationModel();
        assertApplicationModel(applicationModel, null, null);

        // The application model should have a list of entity models.
        List<Map<String, Object>> entityModels = (List<Map<String, Object>>) applicationModel.get("entities");
        assertNotNull(entityModels);
        for (Map<String, Object> entityModel : entityModels) {
            assertEntityModel(entityModel);
        }

        // Each entity model should have a list of field models.
        for (Map<String, Object> entityModel : entityModels) {
            List<Map<String, Object>> fieldModels = (List<Map<String, Object>>) entityModel.get("fields");
            assertNotNull(fieldModels);
            for (Map<String, Object> fieldModel : fieldModels) {
                String entityName = (String) entityModel.get("entityName");
                assertFieldModel(fieldModel, entityName);
            }
        }

        // The application model should have a list of enum models.
        List<Map<String, Object>> enumModels = (List<Map<String, Object>>) applicationModel.get("enums");
        assertNotNull(enumModels);
        for (Map<String, Object> enumModel : enumModels) {
            assertEnumModel(enumModel);
        }
    }

    @Test
    public void testGetEntityModels() {
        List<Map<String, Object>> entityModels = bean.getEntityModels();
        assertNotNull(entityModels);
        for (Map<String, Object> entityModel : entityModels) {
            assertEntityModel(entityModel);
        }

        // Each entity model should have an application.
        for (Map<String, Object> entityModel : entityModels) {
            Map<String, Object> applicationModel = (Map<String, Object>) entityModel.get("application");
            String entityName = (String) entityModel.get("entityName");
            assertApplicationModel(applicationModel, entityName, null);
        }

        // Each entity model should have a list of field models.
        for (Map<String, Object> entityModel : entityModels) {
            List<Map<String, Object>> fieldModels = (List<Map<String, Object>>) entityModel.get("fields");
            assertNotNull(fieldModels);
            for (Map<String, Object> fieldModel : fieldModels) {
                String entityName = (String) entityModel.get("entityName");
                assertFieldModel(fieldModel, entityName);
            }
        }
    }

    @Test
    public void testGetEnumModels() {
        List<Map<String, Object>> enumModels = bean.getEnumModels();
        assertNotNull(enumModels);
        for (Map<String, Object> enumModel : enumModels) {
            assertEnumModel(enumModel);
        }

        // Each enum should have an application.
        for (Map<String, Object> enumModel : enumModels) {
            Map<String, Object> applicationModel = (Map<String, Object>) enumModel.get("application");
            assertNotNull(applicationModel);
            String enumName = (String) enumModel.get("enumName");
            assertApplicationModel(applicationModel, null, enumName);
        }
    }

    private void assertApplicationModel(Map<String, Object> applicationModel, String entityNameFromEntity,
            String enumName) {
        String message = "Application properties not match.";
        if (entityNameFromEntity != null) {
            message = "Application properties not match for entity name" + entityNameFromEntity + ".";
        } else if (enumName != null) {
            message = "Application properties not match for enum name" + enumName + ".";
        }

        assertNotNull(message, applicationModel);
        assertEquals(message, "com.mycompany.test", applicationModel.get("groupId"));
        assertEquals(message, "test-app", applicationModel.get("artifactId"));
        assertEquals(message, "0.1.0-SNAPSHOT", applicationModel.get("version"));
        assertEquals(message, "com.mycompany.test.app", applicationModel.get("basePackage"));
        assertEquals(message, "My test application.", applicationModel.get("description"));
    }

    private void assertEntityModel(Map<String, Object> entityModel) {

        // Each entity model should have a name and some other properties.
        Object entityNameObj = entityModel.get("entityName");
        assertNotNull(entityNameObj);
        String entityName = (String) entityNameObj;

        // The values of the other properties should depend upon the name.
        String actualSingular = null;
        String actualPlural = null;
        if (entityName.equals("Individual")) {
            actualSingular = "Person";
            actualPlural = "People";
        } else if (entityName.equals("Location")) {
            actualSingular = "Home Address";
            actualPlural = "Home Addresses";
        }
        String message = "Entity properties not match for entity name" + entityName + ".";
        assertEquals(message, actualSingular, entityModel.get("singular"));
        assertEquals(message, actualPlural, entityModel.get("plural"));
    }

    private void assertFieldModel(Map<String, Object> fieldModel, String entityNameFromEntity) {

        // Each field model should have an entity name, a field name, and some other properties.
        Object entityNameObj = fieldModel.get("entityName");
        assertNotNull(entityNameObj);
        String entityName = (String) entityNameObj;
        Object fieldNameObj = fieldModel.get("fieldName");
        assertNotNull(fieldNameObj);
        String fieldName = (String) fieldNameObj;

        // If we have an entity name from the entity model, then the entity name of the field model should match the
        // entity name of the entity model.
        if (entityNameFromEntity != null) {
            assertEquals(entityNameFromEntity, entityName);
        }

        // The values of the other properties should depend upon the names.
        String actualLabel = null;
        String actualType = null;
        String actualLength = null;
        String actualTemporalType = null;
        String actualEnumType = null;
        if (entityName.equals("Individual") && fieldName.equals("name")) {
            actualLabel = "Full Name";
            actualType = "String";
            actualLength = "100";
        } else if (entityName.equals("Individual") && fieldName.equals("dob")) {
            actualLabel = "Date of Birth";
            actualType = "Date";
            actualTemporalType = "DATE";
        } else if (entityName.equals("Location") && fieldName.equals("addressLine")) {
            actualLabel = "Street Address";
            actualType = "String";
            actualLength = "50";
        } else if (entityName.equals("Location") && fieldName.equals("name")) {
            actualLabel = "City Name";
            actualType = "String";
            actualLength = "50";
        } else if (entityName.equals("Location") && fieldName.equals("stateCode")) {
            actualLabel = "State Code";
            actualType = "StateCode";
            actualEnumType = "STRING";
        }
        String message = "Field properties not match for entity name " + entityName + " and field name " + fieldName
                + ".";
        assertEquals(message, actualLabel, fieldModel.get("label"));
        assertEquals(message, actualType, fieldModel.get("type"));
        assertEquals(message, actualLength, fieldModel.get("length"));
        assertEquals(message, actualTemporalType, fieldModel.get("temporalType"));
        assertEquals(message, actualEnumType, fieldModel.get("enumType"));
    }

    private void assertEnumModel(Map<String, Object> enumModel) {

        // Each enum model should have a name and some other properties.
        Object enumNameObj = enumModel.get("enumName");
        assertNotNull(enumNameObj);
        String enumName = (String) enumNameObj;

        // The values of the other properties should depend upon the name.
        String actualValues = null;
        if (enumName.equals("StateCode")) {
            actualValues = "IA IL IN KY MI MO WI";
        }
        String message = "Enum properties not match for enum name" + enumName + ".";
        assertEquals(message, actualValues, enumModel.get("values"));
    }
}
