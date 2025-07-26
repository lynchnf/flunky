package ${application.basePackage}.service;

import ${application.basePackage}.domain.${entityName};
import org.apache.commons.lang3.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.List;
import java.util.Random;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class ${entityName}ServiceTest {
    private Random rand = new Random();
    private Long id;
<#list fields as field>
    private String ${field.fieldName};
</#list>

    @Before
    public void setUp() throws Exception {
        id = rand.nextLong();
<#list fields as field>
        ${field.fieldName} = RandomStringUtils.randomAlphabetic(10);
</#list>

        ${entityName} entity = new ${entityName}();
        entity.setId(id);
<#list fields as field>
        entity.set${field.fieldName?cap_first}(${field.fieldName});
</#list>
        ${entityName}Service.entities.put(id, entity);
    }

    @After
    public void tearDown() throws Exception {
        ${entityName}Service.entities.clear();
    }

    @Test
    public void testGetAllEntities() {
        List<${entityName}> entities = ${entityName}Service.getAllEntities();

        assertEquals(1, entities.size());
        assertEquals(id, entities.get(0).getId());
<#list fields as field>
        assertEquals(${field.fieldName}, entities.get(0).get${field.fieldName?cap_first}());
</#list>
    }

    @Test
    public void testGetEntity() {
        ${entityName} entity = ${entityName}Service.getEntity(id);

<#list fields as field>
        assertEquals(${field.fieldName}, entity.get${field.fieldName?cap_first}());
</#list>
    }

    @Test
    public void testSaveEntity() {
<#list fields as field>
        String new${field.fieldName?cap_first} = RandomStringUtils.randomAlphabetic(10);
</#list>

        ${entityName} newEntity = new ${entityName}();
<#list fields as field>
        newEntity.set${field.fieldName?cap_first}(new${field.fieldName?cap_first});
</#list>

        ${entityName} savedEntity = ${entityName}Service.saveEntity(newEntity);

<#list fields as field>
        assertEquals(new${field.fieldName?cap_first}, savedEntity.get${field.fieldName?cap_first}());
</#list>

        Long savedId = savedEntity.getId();
<#list fields as field>
        assertEquals(new${field.fieldName?cap_first}, ${entityName}Service.entities.get(savedId).get${field.fieldName?cap_first}());
</#list>
    }

    @Test
    public void testDeleteEntity() {
        assertTrue(${entityName}Service.entities.containsKey(id));

        ${entityName} entityToDelete = new ${entityName}();
        entityToDelete.setId(id);

        ${entityName}Service.deleteEntity(entityToDelete);

        assertFalse(${entityName}Service.entities.containsKey(id));
    }
}
