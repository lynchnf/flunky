package ${application.basePackage}.web.view;

import ${application.basePackage}.FakeDataFactory;
import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.util.MiscUtils;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import static org.junit.jupiter.api.Assertions.*;

public class ${entityName}EditFormTest {
    @Test
    public void gettersForExistingEntity() {
        FakeDataFactory factory = new FakeDataFactory();
        ${entityName} entity = factory.nextRandom${entityName}();
        ${entityName}EditForm editForm = new ${entityName}EditForm(entity);
<#list fields as field>
        assertEquals(entity.get${field.fieldName?cap_first}(), editForm.get${field.fieldName?cap_first}());
</#list>
    }

    @Test
    public void gettersForNewEntity() throws Exception {
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
        <#elseif field.type == "Date">
            <#if field.temporalType?? && field.temporalType="DATE">
        assertEquals(MiscUtils.parseDate("${field.dftValue}"), editForm.get${field.fieldName?cap_first}());
            <#elseif field.temporalType?? && field.temporalType="TIME">
        assertEquals(MiscUtils.parseTime("${field.dftValue}"), editForm.get${field.fieldName?cap_first}());
            <#elseif field.temporalType?? && field.temporalType="TIMESTAMP">
        assertEquals(MiscUtils.parseDateTime("${field.dftValue}"), editForm.get${field.fieldName?cap_first}());
            </#if>
        <#else>
        assertEquals("${field.dftValue}", editForm.get${field.fieldName?cap_first}());
        </#if>
    <#else>
        assertNull(editForm.get${field.fieldName?cap_first}());
    </#if>
</#list>
    }

    @Test
    public void toEntity() throws Exception {
        FakeDataFactory factory = new FakeDataFactory();
        ${entityName} entity1 = factory.nextRandom${entityName}();
        ${entityName}EditForm editForm = new ${entityName}EditForm(entity1);
        ${entityName} entity2 = editForm.toEntity();
<#list fields as field>
        assertEquals(entity1.get${field.fieldName?cap_first}(), entity2.get${field.fieldName?cap_first}());
</#list>
    }
}
