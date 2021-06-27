package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.exception.NotFoundException;
import org.apache.commons.lang3.StringUtils;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

public class ${entityName}EditForm {
    private Long id;
    private Integer version = 0;
<#list fields as field>
    <#if field.nullable?? && field.nullable == "false">
    @NotBlank(message = "${field.label} may not be blank.")
    </#if>
    <#if field.length??>
    @Size(max = ${field.length}, message = "${field.label} may not be over {max} characters long.")
    </#if>
    private ${field.type} ${field.fieldName}<#if field.dftValue??> = ${field.dftValue}</#if>;
</#list>

    public ${entityName}EditForm() {
    }

    public ${entityName}EditForm(${entityName} entity) {
        id = entity.getId();
        version = entity.getVersion();
<#list fields as field>
        ${field.fieldName} = entity.get${field.fieldName?cap_first}();
</#list>
    }

    public ${entityName} toEntity() throws NotFoundException {
        ${entityName} entity = new ${entityName}();
        entity.setId(id);
        entity.setVersion(version);
<#list fields as field>
        entity.set${field.fieldName?cap_first}(StringUtils.trimToNull(${field.fieldName}));
</#list>
        return entity;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Integer getVersion() {
        return version;
    }

    public void setVersion(Integer version) {
        this.version = version;
    }
<#list fields as field>

    public ${field.type} get${field.fieldName?cap_first}() {
        return ${field.fieldName};
    }

    public void set${field.fieldName?cap_first}(${field.type} ${field.fieldName}) {
        this.${field.fieldName} = ${field.fieldName};
    }
</#list>
}
