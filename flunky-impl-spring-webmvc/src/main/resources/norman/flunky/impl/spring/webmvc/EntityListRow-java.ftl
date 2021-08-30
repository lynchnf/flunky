package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName};
<#list fields?filter(f -> f.enumType?? || f.joinColumn??) as field>
import ${application.basePackage}.domain.${field.type};
</#list>

import java.math.BigDecimal;
import java.util.Date;

public class ${entityName}ListRow {
    private Long id;
    private Integer version;
<#list fields?filter(f -> !f.listDisplay?? || f.listDisplay != "hide") as field>
    <#if field.joinColumn??>
    private String ${field.fieldName};
    <#else>
    private ${field.type} ${field.fieldName};
    </#if>
</#list>

    public ${entityName}ListRow(${entityName} entity) {
        id = entity.getId();
        version = entity.getVersion();
<#list fields?filter(f -> !f.listDisplay?? || f.listDisplay != "hide") as field>
    <#if field.joinColumn??>
        ${field.fieldName} = entity.get${field.fieldName?cap_first}() == null ? null : entity.get${field.fieldName?cap_first}().toString();
    <#else>
        ${field.fieldName} = entity.get${field.fieldName?cap_first}();
    </#if>
</#list>
    }

    public Long getId() {
        return id;
    }

    public Integer getVersion() {
        return version;
    }
<#list fields?filter(f -> !f.listDisplay?? || f.listDisplay != "hide") as field>

    <#if field.joinColumn??>
    public String get${field.fieldName?cap_first}() {
    <#else>
    public ${field.type} get${field.fieldName?cap_first}() {
    </#if>
        return ${field.fieldName};
    }
</#list>
}
