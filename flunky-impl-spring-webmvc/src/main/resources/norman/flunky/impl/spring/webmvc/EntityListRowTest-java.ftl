package ${application.basePackage}.web.view;

import com.mycompany.example.my.app.FakeDataUtil;
import ${application.basePackage}.domain.${entityName};
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ${entityName}ListRowTest {
    @Test
    public void getters() {
        FakeDataUtil fakeDataUtil = new FakeDataUtil();
        ${entityName} entity = fakeDataUtil.nextRandom${entityName}();
        ${entityName}ListRow row = new ${entityName}ListRow(entity);
<#list fields?filter(f -> !f.listDisplay?? || f.listDisplay != "hide") as field>
        assertEquals(entity.get${field.fieldName?cap_first}(), row.get${field.fieldName?cap_first}());
</#list>
    }
}
