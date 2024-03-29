package ${application.basePackage}.web.view;

import ${application.basePackage}.FakeDataFactory;
import ${application.basePackage}.domain.${entityName};
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ${entityName}ListRowTest {
    @Test
    public void getters() {
        FakeDataFactory factory = new FakeDataFactory();
        ${entityName} entity = factory.nextRandom${entityName}();
        ${entityName}ListRow row = new ${entityName}ListRow(entity);
<#list fields?filter(f -> !f.listDisplay?? || f.listDisplay != "hide") as field>
        assertEquals(entity.get${field.fieldName?cap_first}(), row.get${field.fieldName?cap_first}());
</#list>
    }
}
