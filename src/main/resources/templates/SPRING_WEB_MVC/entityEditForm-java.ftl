package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName?cap_first};
<#list fields?filter(f -> f.type != "BigDecimal" && f.type != "Boolean" && f.type != "Date" && f.type != "Integer" && f.type != "Long" && f.type != "String") as field>
import ${application.basePackage}.domain.${field.type};
</#list>
import ${application.basePackage}.exception.NotFoundException;
<#list fields?filter(f -> f.type != "BigDecimal" && f.type != "Boolean" && f.type != "Date" && f.type != "Integer" && f.type != "Long" && f.type != "String") as field>
import ${application.basePackage}.service.${field.type}Service;
</#list>
import org.apache.commons.lang3.StringUtils;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.NumberFormat;

import javax.validation.constraints.Digits;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.math.BigDecimal;
import java.util.Date;

public class ${entityName?cap_first}EditForm {
<#list fields?filter(f -> f.type != "BigDecimal" && f.type != "Boolean" && f.type != "Date" && f.type != "Integer" && f.type != "Long" && f.type != "String") as field>
    private ${field.type}Service ${field.fieldName}Service;
</#list>
    private Long id;
    private Integer version = 0;
<#list fields as field>
<#if field.nullable?? && field.nullable == "false">
<#if field.type == "String">
    @NotBlank(message = "${field.label?capitalize} may not be blank.")
<#else>
    @NotNull(message = "${field.label?capitalize} may not be blank.")
</#if>
</#if>
<#if field.length??>
    @Size(max = ${field.length}, message = "${field.label?capitalize} may not be over {max} characters long.")
</#if>
<#if field.precision?? && field.scale??>
    @Digits(integer = ${field.precision}, fraction = ${field.scale}, message = "${field.label?capitalize} value out of bounds. (<{integer} digits>.<{fraction} digits> expected)")
</#if>
<#if field.type == "BigDecimal">
    @NumberFormat(style = NumberFormat.Style.CURRENCY)
    private ${field.type} ${field.fieldName};
<#elseif field.type == "Boolean">
    private ${field.type} ${field.fieldName};
<#elseif field.type == "Date">
<#if field.temporal?? && field.temporal="DATE">
    @DateTimeFormat(pattern = "M/d/yyyy")
<#elseif field.temporal?? && field.temporal="TIME">
    @DateTimeFormat(pattern = "H:m:s")
<#elseif field.temporal?? && field.temporal="TIMESTAMP">
    @DateTimeFormat(pattern = "M/d/yyyy H:m:s")
</#if>
    private ${field.type} ${field.fieldName};
<#elseif field.type == "Integer">
    @NumberFormat(style = NumberFormat.Style.NUMBER)
    private ${field.type} ${field.fieldName};
<#elseif field.type == "Long">
    @NumberFormat(style = NumberFormat.Style.NUMBER)
    private ${field.type} ${field.fieldName};
<#elseif field.type == "String">
    private ${field.type} ${field.fieldName};
<#else>
    private Long ${field.fieldName}Id;
</#if>
</#list>

    public ${entityName?cap_first}EditForm() {
    }

    public ${entityName?cap_first}EditForm(${entityName?cap_first} entity) {
        id = entity.getId();
        version = entity.getVersion();
<#list fields as field>
<#if field.type == "BigDecimal" || field.type == "Boolean" || field.type == "Date" || field.type == "Integer" || field.type == "Long" || field.type == "String">
        ${field.fieldName} = entity.get${field.fieldName?cap_first}();
<#else>
        if (entity.get${field.fieldName?cap_first}() != null) {
            ${field.fieldName}Id = entity.get${field.fieldName?cap_first}().getId();
        }
</#if>
</#list>
    }

    public ${entityName?cap_first} toEntity() throws NotFoundException {
        ${entityName?cap_first} entity = new ${entityName?cap_first}();
        entity.setId(id);
        entity.setVersion(version);
<#list fields as field>
<#if field.type == "BigDecimal">
        entity.set${field.fieldName?cap_first}(${field.fieldName});
<#elseif field.type == "Boolean">
        entity.set${field.fieldName?cap_first}(${field.fieldName});
<#elseif field.type == "Date">
        entity.set${field.fieldName?cap_first}(${field.fieldName});
<#elseif field.type == "Integer">
        entity.set${field.fieldName?cap_first}(${field.fieldName});
<#elseif field.type == "Long">
        entity.set${field.fieldName?cap_first}(${field.fieldName});
<#elseif field.type == "String">
        entity.set${field.fieldName?cap_first}(StringUtils.trimToNull(${field.fieldName}));
<#else>
        if (${field.fieldName}Id != null) {
            ${field.type} ${field.fieldName} = ${field.fieldName}Service.findById(${field.fieldName}Id);
            entity.set${field.fieldName?cap_first}(${field.fieldName});
        }
</#if>
</#list>
        return entity;
    }
<#list fields?filter(f -> f.type != "BigDecimal" && f.type != "Boolean" && f.type != "Date" && f.type != "Integer" && f.type != "Long" && f.type != "String") as field>

    public void set${field.fieldName?cap_first}Service(${field.type}Service ${field.fieldName}Service) {
        this.${field.fieldName}Service = ${field.fieldName}Service;
    }
</#list>

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

<#if field.type == "BigDecimal" || field.type == "Boolean" || field.type == "Date" || field.type == "Integer" || field.type == "Long" || field.type == "String">
    public ${field.type} get${field.fieldName?cap_first}() {
        return ${field.fieldName};
    }

    public void set${field.fieldName?cap_first}(${field.type} ${field.fieldName}) {
        this.${field.fieldName} = ${field.fieldName};
    }
<#else>
    public Long get${field.fieldName?cap_first}Id() {
        return ${field.fieldName}Id;
    }

    public void set${field.fieldName?cap_first}Id(Long ${field.fieldName}Id) {
        this.${field.fieldName}Id = ${field.fieldName}Id;
    }
</#if>
</#list>
}
