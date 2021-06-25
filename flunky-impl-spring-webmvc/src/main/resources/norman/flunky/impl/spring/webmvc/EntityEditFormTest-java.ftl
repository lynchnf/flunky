package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.exception.NotFoundException;
import org.junit.jupiter.api.Test;

import static ${application.basePackage}.FakeDataUtil.nextRandom${entityName};
import static org.junit.jupiter.api.Assertions.*;

public class ${entityName}EditFormTest {
    @Test
    public void gettersForExistingEntity() {
        ${entityName} entity = nextRandom${entityName}();
        ${entityName}EditForm editForm = new ${entityName}EditForm(entity);
<#list fields as field>
        assertEquals(entity.get${field.fieldName?cap_first}(), editForm.get${field.fieldName?cap_first}());
</#list>
    }

    @Test
    public void gettersForNewEntity() {
        ${entityName}EditForm editForm = new ${entityName}EditForm();
<#list fields as field>
    <#if field.dftValue??>
        assertEquals(${field.dftValue}, editForm.get${field.fieldName?cap_first}());
    <#else>
        assertNull(editForm.get${field.fieldName?cap_first}());
    </#if>
</#list>
    }

    @Test
    public void toEntity() throws NotFoundException {
        ${entityName} entity1 = nextRandom${entityName}();
        ${entityName}EditForm editForm = new ${entityName}EditForm(entity1);
        ${entityName} entity2 = editForm.toEntity();
<#list fields as field>
        assertEquals(entity1.get${field.fieldName?cap_first}(), entity2.get${field.fieldName?cap_first}());
</#list>
    }
}
