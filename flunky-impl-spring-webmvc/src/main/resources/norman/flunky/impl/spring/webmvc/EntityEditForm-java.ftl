package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.exception.NotFoundException;
import org.apache.commons.lang3.StringUtils;
import org.springframework.format.annotation.NumberFormat;

import javax.validation.constraints.Digits;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.math.BigDecimal;

public class ${entityName}EditForm {
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
    @Digits(integer = ${field.precision?number-field.scale?number}, fraction = ${field.scale}, message = "${field.label} value out of bounds. (<{integer} digits>.<{fraction} digits> expected)")
    </#if>
    <#if field.type == "BigDecimal">
    @NumberFormat(style = NumberFormat.Style.CURRENCY)
    <#elseif field.type == "Byte" || field.type == "Short" || field.type == "Integer" || field.type == "Long">
    @NumberFormat(style = NumberFormat.Style.NUMBER)
    </#if>
    <#if field.dftValue??>
        <#if field.type == "BigDecimal">
    private ${field.type} ${field.fieldName} = new BigDecimal("${field.dftValue}");
        <#elseif field.type == "Boolean">
    private ${field.type} ${field.fieldName} = Boolean.valueOf(${field.dftValue});
        <#elseif field.type == "Byte">
    private ${field.type} ${field.fieldName} = Byte.valueOf((byte) ${field.dftValue});
        <#elseif field.type == "Short">
    private ${field.type} ${field.fieldName} = Short.valueOf((short) ${field.dftValue});
        <#elseif field.type == "Integer">
    private ${field.type} ${field.fieldName} = Integer.valueOf(${field.dftValue});
        <#elseif field.type == "Long">
    private ${field.type} ${field.fieldName} = Long.valueOf((long) ${field.dftValue});
        <#else>
    private ${field.type} ${field.fieldName} = ${field.dftValue};
        </#if>
    <#else>
    private ${field.type} ${field.fieldName};
    </#if>
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
    <#if field.type == "String">
        entity.set${field.fieldName?cap_first}(StringUtils.trimToNull(${field.fieldName}));
    <#else>
        entity.set${field.fieldName?cap_first}(${field.fieldName});
    </#if>
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
