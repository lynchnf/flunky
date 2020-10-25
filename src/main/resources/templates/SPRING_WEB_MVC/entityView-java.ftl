package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName?cap_first};
<#list fields?filter(f -> f.type != "BigDecimal" && f.type != "Boolean" && f.type != "Date" && f.type != "Integer" && f.type != "Long" && f.type != "String") as field>
import ${application.basePackage}.domain.${field.type};
</#list>

import java.math.BigDecimal;
import java.util.Date;

public class ${entityName?cap_first}View {
    private Long id;
<#list fields?filter(f -> f.onEdit?? && f.onEdit == "true") as field>
    private ${field.type} ${field.fieldName};
</#list>

    public ${entityName?cap_first}View(${entityName?cap_first} entity) {
        id = entity.getId();
<#list fields?filter(f -> f.onEdit?? && f.onEdit == "true") as field>
        ${field.fieldName} = entity.get${field.fieldName?cap_first}();
</#list>
    }

    public Long getId() {
        return id;
    }
<#list fields?filter(f -> f.onEdit?? && f.onEdit == "true") as field>

    public ${field.type} get${field.fieldName?cap_first}() {
        return ${field.fieldName};
    }
</#list>
}
