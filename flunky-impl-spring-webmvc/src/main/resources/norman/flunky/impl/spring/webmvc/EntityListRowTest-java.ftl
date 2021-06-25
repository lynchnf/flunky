package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName};
import org.junit.jupiter.api.Test;

import static ${application.basePackage}.FakeDataUtil.nextRandom${entityName};
import static org.junit.jupiter.api.Assertions.*;

public class ${entityName}ListRowTest {
    @Test
    public void getters() {
        ${entityName} entity = nextRandom${entityName}();
        ${entityName}ListRow row = new ${entityName}ListRow(entity);
<#list fields?filter(f -> !f.listDisplay?? || f.listDisplay != "hide") as field>
        assertEquals(entity.get${field.fieldName}(), row.get${field.fieldName}());
</#list>
    }
}
