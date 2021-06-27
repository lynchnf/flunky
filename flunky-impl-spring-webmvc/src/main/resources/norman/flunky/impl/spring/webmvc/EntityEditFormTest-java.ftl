package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.exception.NotFoundException;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

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
        <#if field.type == "BigDecimal">
        assertTrue(editForm.get${field.fieldName?cap_first}().compareTo(new BigDecimal("${field.dftValue}")) == 0);
        <#elseif field.type == "Boolean">
        assertEquals(Boolean.valueOf(${field.dftValue}), editForm.get${field.fieldName?cap_first}());
        <#elseif field.type == "Byte">
        assertEquals(Byte.valueOf((byte) ${field.dftValue}), editForm.get${field.fieldName?cap_first}());
        <#elseif field.type == "Short">
        assertEquals(Short.valueOf((short) ${field.dftValue}), editForm.get${field.fieldName?cap_first}());
        <#elseif field.type == "Integer">
        assertEquals(Integer.valueOf(${field.dftValue}), editForm.get${field.fieldName?cap_first}());
        <#elseif field.type == "Long">
        assertEquals(Long.valueOf((long) ${field.dftValue}), editForm.get${field.fieldName?cap_first}());
        <#else>
        assertEquals(${field.dftValue}, editForm.get${field.fieldName?cap_first}());
        </#if>
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
