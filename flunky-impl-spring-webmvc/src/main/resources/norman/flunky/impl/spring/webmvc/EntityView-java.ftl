package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName?cap_first};

import java.math.BigDecimal;

public class ${entityName?cap_first}View {
    private Long id;
    private Integer version;
<#list fields?filter(f -> !f.viewDisplay?? || f.viewDisplay != "hide") as field>
    private ${field.type} ${field.fieldName};
</#list>

    public ${entityName?cap_first}View(${entityName?cap_first} entity) {
        id = entity.getId();
        version = entity.getVersion();
<#list fields?filter(f -> !f.viewDisplay?? || f.viewDisplay != "hide") as field>
        ${field.fieldName} = entity.get${field.fieldName?cap_first}();
</#list>
    }

    public Long getId() {
        return id;
    }

    public Integer getVersion() {
        return version;
    }
<#list fields?filter(f -> !f.viewDisplay?? || f.viewDisplay != "hide") as field>

    public ${field.type} get${field.fieldName?cap_first}() {
        return ${field.fieldName};
    }
</#list>
}
