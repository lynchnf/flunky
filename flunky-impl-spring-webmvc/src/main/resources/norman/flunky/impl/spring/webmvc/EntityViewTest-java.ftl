package ${application.basePackage}.web.view;

import com.mycompany.example.my.app.FakeDataUtil;
import ${application.basePackage}.domain.${entityName};
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ${entityName}ViewTest {
    @Test
    public void getters() {
        FakeDataUtil fakeDataUtil = new FakeDataUtil();
        ${entityName} entity = fakeDataUtil.nextRandom${entityName}();
        ${entityName}View view = new ${entityName}View(entity);
<#list fields?filter(f -> !f.viewDisplay?? || f.viewDisplay != "hide") as field>
        assertEquals(entity.get${field.fieldName?cap_first}(), view.get${field.fieldName?cap_first}());
</#list>
    }
}
