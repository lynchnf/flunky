package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName};
<#list fields?filter(f -> f.enumType??) as field>
import ${application.basePackage}.domain.${field.type};
</#list>

import java.math.BigDecimal;
import java.util.Date;

public class ${entityName}ListRow {
    private Long id;
    private Integer version;
<#list fields?filter(f -> !f.listDisplay?? || f.listDisplay != "hide") as field>
    private ${field.type} ${field.fieldName};
</#list>

    public ${entityName}ListRow(${entityName} entity) {
        id = entity.getId();
        version = entity.getVersion();
<#list fields?filter(f -> !f.listDisplay?? || f.listDisplay != "hide") as field>
        ${field.fieldName} = entity.get${field.fieldName?cap_first}();
</#list>
    }

    public Long getId() {
        return id;
    }

    public Integer getVersion() {
        return version;
    }
<#list fields?filter(f -> !f.listDisplay?? || f.listDisplay != "hide") as field>

    public ${field.type} get${field.fieldName?cap_first}() {
        return ${field.fieldName};
    }
</#list>
}
