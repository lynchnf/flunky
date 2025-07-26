package ${application.basePackage}.form;

import ${application.basePackage}.domain.${entityName};
import org.apache.commons.lang3.RandomStringUtils;
import org.junit.Test;

import java.util.Random;

import static org.junit.Assert.assertEquals;

public class ${entityName}FormTest {
    private Random rand = new Random();

    @Test
    public void test${entityName}Form() {
        ${entityName}Form form = new ${entityName}Form();

        assertEquals("", form.getId());
<#list fields as field>
        assertEquals("", form.get${field.fieldName?cap_first}());
</#list>
    }

    @Test
    public void test${entityName}Form${entityName}() {
        Long id = rand.nextLong();
<#list fields as field>
        String ${field.fieldName} = RandomStringUtils.randomAlphabetic(10);
</#list>

        ${entityName} entity = new ${entityName}();
        entity.setId(id);
<#list fields as field>
        entity.set${field.fieldName?cap_first}(${field.fieldName});
</#list>

        ${entityName}Form form = new ${entityName}Form(entity);

        assertEquals(String.valueOf(id), form.getId());
<#list fields as field>
        assertEquals(${field.fieldName}, form.get${field.fieldName?cap_first}());
</#list>
    }

    @Test
    public void testToEntity() {
        Long id = rand.nextLong();
<#list fields as field>
        String ${field.fieldName} = RandomStringUtils.randomAlphabetic(10);
</#list>

        ${entityName}Form form = new ${entityName}Form();
        form.setId(String.valueOf(id));
<#list fields as field>
        form.set${field.fieldName?cap_first}(${field.fieldName});
</#list>

        ${entityName} entity = form.toEntity();

        assertEquals(id, entity.getId());
<#list fields as field>
        assertEquals(${field.fieldName}, entity.get${field.fieldName?cap_first}());
</#list>
    }
}
