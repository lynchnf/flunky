package ${application.basePackage}.web.view;

import com.mycompany.example.my.app.FakeDataUtil;
import ${application.basePackage}.domain.${entityName};
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import static org.junit.jupiter.api.Assertions.*;

public class ${entityName}EditFormTest {
    private static final DateFormat YYMD = new SimpleDateFormat("yyyy-MM-dd");
    private static final DateFormat HMS = new SimpleDateFormat("HH:mm:ss");
    private static final DateFormat YYMD_HMS = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    @Test
    public void gettersForExistingEntity() {
        FakeDataUtil fakeDataUtil = new FakeDataUtil();
        ${entityName} entity = fakeDataUtil.nextRandom${entityName}();
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
        assertEquals(YYMD.parse("${field.dftValue}"), editForm.get${field.fieldName?cap_first}());
            <#elseif field.temporalType?? && field.temporalType="TIME">
        assertEquals(HMS.parse("${field.dftValue}"), editForm.get${field.fieldName?cap_first}());
            <#elseif field.temporalType?? && field.temporalType="TIMESTAMP">
        assertEquals(YYMD_HMS.parse("${field.dftValue}"), editForm.get${field.fieldName?cap_first}());
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
        FakeDataUtil fakeDataUtil = new FakeDataUtil();
        ${entityName} entity1 = fakeDataUtil.nextRandom${entityName}();
        ${entityName}EditForm editForm = new ${entityName}EditForm(entity1);
        ${entityName} entity2 = editForm.toEntity();
<#list fields as field>
        assertEquals(entity1.get${field.fieldName?cap_first}(), entity2.get${field.fieldName?cap_first}());
</#list>
    }
}
