package norman.flunky.main;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class DataModelDigestorTest {
    private DataModelDigestor digestor;

    @BeforeEach
    void setUp() {
        Map<String, String> applicationData = new LinkedHashMap<>();
        applicationData.put("group.id", "com.mycompany.fake");
        applicationData.put("artifact.id", "fake-app");
        applicationData.put("version", "1.2.3-SNAPSHOT");
        applicationData.put("base.package", "com.mycompany.fake.app");
        applicationData.put("description", "Fake application.");

        List<Map<String, String>> entitiesData = new ArrayList<>();
        entitiesData.add(new LinkedHashMap<>());
        entitiesData.add(new LinkedHashMap<>());
        entitiesData.get(0).put("entityName", "Customer");
        entitiesData.get(1).put("entityName", "Order");

        List<Map<String, String>> fieldsData = new ArrayList<>();
        fieldsData.add(new LinkedHashMap<>());
        fieldsData.add(new LinkedHashMap<>());
        fieldsData.add(new LinkedHashMap<>());
        fieldsData.get(0).put("entityName", "Customer");
        fieldsData.get(0).put("fieldName", "name");
        fieldsData.get(0).put("label", "Customer Name");
        fieldsData.get(0).put("type", "String");
        fieldsData.get(1).put("entityName", "Order");
        fieldsData.get(1).put("fieldName", "number");
        fieldsData.get(1).put("label", "Order Number");
        fieldsData.get(1).put("type", "Integer");
        fieldsData.get(2).put("entityName", "Order");
        fieldsData.get(2).put("fieldName", "status");
        fieldsData.get(2).put("label", "Order Status");
        fieldsData.get(2).put("type", "Status");

        List<Map<String, String>> enumsData = new ArrayList<>();
        enumsData.add(new LinkedHashMap<>());
        enumsData.get(0).put("enumName", "Status");
        enumsData.get(0).put("values", "NEW OLD");

        digestor = DataModelDigestor.instance(applicationData, entitiesData, fieldsData, enumsData);
    }

    @AfterEach
    void tearDown() {
        digestor = null;
    }

    @Test
    void getApplicationModel() {
        Map<String, Object> applicationModel = digestor.getApplicationModel();
        assertEquals("com.mycompany.fake", applicationModel.get("groupId"));
        assertEquals("fake-app", applicationModel.get("artifactId"));
        assertEquals("1.2.3-SNAPSHOT", applicationModel.get("version"));
        assertEquals("com.mycompany.fake.app", applicationModel.get("basePackage"));
        assertEquals("Fake application.", applicationModel.get("description"));

        // application -> (customer & order)
        assertNotNull(applicationModel.get("entities"));
        List<Map<String, Object>> entityModels = (List<Map<String, Object>>) applicationModel.get("entities");
        assertEquals(2, entityModels.size());
        assertEquals("Customer", entityModels.get(0).get("entityName"));
        assertEquals("Order", entityModels.get(1).get("entityName"));

        // application -> customer -> fields
        assertNotNull(entityModels.get(0).get("fields"));
        List<Map<String, Object>> customerFieldModels = (List<Map<String, Object>>) entityModels.get(0).get("fields");
        assertEquals(1, customerFieldModels.size());
        assertEquals("name", customerFieldModels.get(0).get("fieldName"));
        assertEquals("Customer Name", customerFieldModels.get(0).get("label"));
        assertEquals("String", customerFieldModels.get(0).get("type"));

        // application -> order -> fields
        assertNotNull(entityModels.get(1).get("fields"));
        List<Map<String, Object>> orderFieldModels = (List<Map<String, Object>>) entityModels.get(1).get("fields");
        assertEquals(2, orderFieldModels.size());
        assertEquals("number", orderFieldModels.get(0).get("fieldName"));
        assertEquals("Order Number", orderFieldModels.get(0).get("label"));
        assertEquals("Integer", orderFieldModels.get(0).get("type"));
        assertEquals("status", orderFieldModels.get(1).get("fieldName"));
        assertEquals("Order Status", orderFieldModels.get(1).get("label"));
        assertEquals("Status", orderFieldModels.get(1).get("type"));

        // application -> enums
        assertNotNull(applicationModel.get("enums"));
        List<Map<String, Object>> enumModels = (List<Map<String, Object>>) applicationModel.get("enums");
        assertEquals(1, enumModels.size());
        assertEquals("Status", enumModels.get(0).get("enumName"));
        assertEquals("NEW OLD", enumModels.get(0).get("values"));
    }

    @Test
    void getEnumModels() {
        List<Map<String, Object>> enumModels = digestor.getEnumModels();
        assertEquals(1, enumModels.size());
        assertEquals("Status", enumModels.get(0).get("enumName"));
        assertEquals("NEW OLD", enumModels.get(0).get("values"));

        // enum -> application
        assertNotNull(enumModels.get(0).get("application"));
        Map<String, Object> applicationModel = (Map<String, Object>) enumModels.get(0).get("application");
        assertEquals("com.mycompany.fake", applicationModel.get("groupId"));
        assertEquals("fake-app", applicationModel.get("artifactId"));
        assertEquals("1.2.3-SNAPSHOT", applicationModel.get("version"));
        assertEquals("com.mycompany.fake.app", applicationModel.get("basePackage"));
        assertEquals("Fake application.", applicationModel.get("description"));

        // enum -> application -> (customer & order)
        assertNotNull(applicationModel.get("entities"));
        List<Map<String, Object>> entityModels = (List<Map<String, Object>>) applicationModel.get("entities");
        assertEquals(2, entityModels.size());
        assertEquals("Customer", entityModels.get(0).get("entityName"));
        assertEquals("Order", entityModels.get(1).get("entityName"));

        // enum -> application -> customer -> fields
        assertNotNull(entityModels.get(0).get("fields"));
        List<Map<String, Object>> customerFieldModels = (List<Map<String, Object>>) entityModels.get(0).get("fields");
        assertEquals(1, customerFieldModels.size());
        assertEquals("name", customerFieldModels.get(0).get("fieldName"));
        assertEquals("Customer Name", customerFieldModels.get(0).get("label"));
        assertEquals("String", customerFieldModels.get(0).get("type"));

        // enum -> application -> customer -> fields
        assertNotNull(entityModels.get(1).get("fields"));
        List<Map<String, Object>> orderFieldModels = (List<Map<String, Object>>) entityModels.get(1).get("fields");
        assertEquals(2, orderFieldModels.size());
        assertEquals("number", orderFieldModels.get(0).get("fieldName"));
        assertEquals("Order Number", orderFieldModels.get(0).get("label"));
        assertEquals("Integer", orderFieldModels.get(0).get("type"));
        assertEquals("status", orderFieldModels.get(1).get("fieldName"));
        assertEquals("Order Status", orderFieldModels.get(1).get("label"));
        assertEquals("Status", orderFieldModels.get(1).get("type"));
    }

    @Test
    void getEntityModels() {
        List<Map<String, Object>> entityModels = digestor.getEntityModels();
        assertEquals(2, entityModels.size());
        assertEquals("Customer", entityModels.get(0).get("entityName"));
        assertEquals("Order", entityModels.get(1).get("entityName"));

        // customer -> fields
        assertNotNull(entityModels.get(0).get("fields"));
        List<Map<String, Object>> customerFieldModels = (List<Map<String, Object>>) entityModels.get(0).get("fields");
        assertEquals(1, customerFieldModels.size());
        assertEquals("name", customerFieldModels.get(0).get("fieldName"));
        assertEquals("Customer Name", customerFieldModels.get(0).get("label"));
        assertEquals("String", customerFieldModels.get(0).get("type"));

        // order -> fields
        assertNotNull(entityModels.get(1).get("fields"));
        List<Map<String, Object>> orderFieldModels = (List<Map<String, Object>>) entityModels.get(1).get("fields");
        assertEquals(2, orderFieldModels.size());
        assertEquals("number", orderFieldModels.get(0).get("fieldName"));
        assertEquals("Order Number", orderFieldModels.get(0).get("label"));
        assertEquals("Integer", orderFieldModels.get(0).get("type"));
        assertEquals("status", orderFieldModels.get(1).get("fieldName"));
        assertEquals("Order Status", orderFieldModels.get(1).get("label"));
        assertEquals("Status", orderFieldModels.get(1).get("type"));

        // customer -> application
        assertNotNull(entityModels.get(0).get("application"));
        Map<String, Object> custAppModel = (Map<String, Object>) entityModels.get(0).get("application");
        assertEquals("com.mycompany.fake", custAppModel.get("groupId"));
        assertEquals("fake-app", custAppModel.get("artifactId"));
        assertEquals("1.2.3-SNAPSHOT", custAppModel.get("version"));
        assertEquals("com.mycompany.fake.app", custAppModel.get("basePackage"));
        assertEquals("Fake application.", custAppModel.get("description"));

        // order -> application
        assertNotNull(entityModels.get(1).get("application"));
        Map<String, Object> ordrAppModel = (Map<String, Object>) entityModels.get(1).get("application");
        assertEquals("com.mycompany.fake", ordrAppModel.get("groupId"));
        assertEquals("fake-app", ordrAppModel.get("artifactId"));
        assertEquals("1.2.3-SNAPSHOT", ordrAppModel.get("version"));
        assertEquals("com.mycompany.fake.app", ordrAppModel.get("basePackage"));
        assertEquals("Fake application.", ordrAppModel.get("description"));

        // customer -> application -> order
        assertNotNull(custAppModel.get("entities"));
        List<Map<String, Object>> custAppEntModels = (List<Map<String, Object>>) custAppModel.get("entities");
        assertEquals(1, custAppEntModels.size());
        assertEquals("Order", custAppEntModels.get(0).get("entityName"));

        // order -> application -> customer
        assertNotNull(ordrAppModel.get("entities"));
        List<Map<String, Object>> ordrAppEntModels = (List<Map<String, Object>>) ordrAppModel.get("entities");
        assertEquals(1, ordrAppEntModels.size());
        assertEquals("Customer", ordrAppEntModels.get(0).get("entityName"));

        // customer -> application -> order -> fields
        assertNotNull(custAppEntModels.get(0).get("fields"));
        List<Map<String, Object>> custAppEntFieldsModels =
                (List<Map<String, Object>>) custAppEntModels.get(0).get("fields");
        assertEquals("number", custAppEntFieldsModels.get(0).get("fieldName"));
        assertEquals("Order Number", custAppEntFieldsModels.get(0).get("label"));
        assertEquals("Integer", custAppEntFieldsModels.get(0).get("type"));
        assertEquals("status", custAppEntFieldsModels.get(1).get("fieldName"));
        assertEquals("Order Status", custAppEntFieldsModels.get(1).get("label"));
        assertEquals("Status", custAppEntFieldsModels.get(1).get("type"));

        // order -> application -> customer -> fields
        assertNotNull(ordrAppEntModels.get(0).get("fields"));
        List<Map<String, Object>> ordrAppEntFieldsModels =
                (List<Map<String, Object>>) ordrAppEntModels.get(0).get("fields");
        assertEquals("name", ordrAppEntFieldsModels.get(0).get("fieldName"));
        assertEquals("Customer Name", ordrAppEntFieldsModels.get(0).get("label"));
        assertEquals("String", ordrAppEntFieldsModels.get(0).get("type"));

        // customer -> application -> enums
        assertNotNull(custAppModel.get("enums"));
        List<Map<String, Object>> custAppEnumModel = (List<Map<String, Object>>) custAppModel.get("enums");
        assertEquals(1, custAppEnumModel.size());
        assertEquals("Status", custAppEnumModel.get(0).get("enumName"));
        assertEquals("NEW OLD", custAppEnumModel.get(0).get("values"));

        // order -> application -> enums
        assertNotNull(ordrAppModel.get("enums"));
        List<Map<String, Object>> ordrAppEnumModel = (List<Map<String, Object>>) ordrAppModel.get("enums");
        assertEquals(1, ordrAppEnumModel.size());
        assertEquals("Status", ordrAppEnumModel.get(0).get("enumName"));
        assertEquals("NEW OLD", ordrAppEnumModel.get(0).get("values"));
    }
}
