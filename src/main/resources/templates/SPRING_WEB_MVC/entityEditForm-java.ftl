package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName?cap_first};

import javax.validation.constraints.Digits;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.math.BigDecimal;
import java.util.Date;

public class ${entityName?cap_first}EditForm {
    private Long id;
    private Integer version = 0;
<#list fields as field>
<#if field.nullable?? && field.nullable == "false">
<#if field.type == "String">
    @NotBlank(message = "${field.label} may not be blank.")
<#else>
    @NotNull(message = "${field.label} may not be blank.")
</#if>
</#if>
<#if field.length??>
    @Size(max = ${field.length}, message = "${field.label} may not be over {max} characters long.")
</#if>
<#if field.precision?? && field.scale??>
    @Digits(integer = ${field.precision}, fraction = ${field.scale}, message = "${field.label} value out of bounds. (<{integer} digits>.<{fraction} digits> expected)")
</#if>
    private ${field.type} ${field.fieldName};
</#list>

    public ${entityName?cap_first}EditForm() {
    }

    public ${entityName?cap_first}EditForm(${entityName?cap_first} entity) {
        id = entity.getId();
        version = entity.getVersion();
<#list fields as field>
        ${field.fieldName} = entity.get${field.fieldName?cap_first}();
</#list>
    }

    public ${entityName?cap_first} toEntity() {
        ${entityName?cap_first} entity = new ${entityName?cap_first}();
        entity.setId(id);
        entity.setVersion(version);
<#list fields as field>
        entity.set${field.fieldName?cap_first}(${field.fieldName});
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
