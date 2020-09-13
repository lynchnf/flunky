package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName};

import java.math.BigDecimal;
import java.util.Date;

public class ${entityName}View {
    private Long id;
<#list fields as field>
    private ${field.type} ${field.fieldName};
</#list>

    public ${entityName}View(${entityName} entity) {
        id = entity.getId();
<#list fields as field>
        ${field.fieldName} = entity.get${field.fieldName?cap_first}();
</#list>
    }

    public Long getId() {
        return id;
    }
<#list fields as field>

    public ${field.type} get${field.fieldName?cap_first}() {
        return ${field.fieldName};
    }
</#list>
}