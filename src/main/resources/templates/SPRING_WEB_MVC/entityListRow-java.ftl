package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName?cap_first};

import java.math.BigDecimal;
import java.util.Date;

public class ${entityName?cap_first}ListRow {
    private Long id;
<#list fields?filter(f -> f.onList?? && f.onList == "true") as field>
    private ${field.type} ${field.fieldName};
</#list>

    public ${entityName?cap_first}ListRow(${entityName?cap_first} entity) {
        id = entity.getId();
<#list fields?filter(f -> f.onList?? && f.onList == "true") as field>
        ${field.fieldName} = entity.get${field.fieldName?cap_first}();
</#list>
    }

    public Long getId() {
        return id;
    }
<#list fields?filter(f -> f.onList?? && f.onList == "true") as field>

    public ${field.type} get${field.fieldName?cap_first}() {
        return ${field.fieldName};
    }
</#list>
}