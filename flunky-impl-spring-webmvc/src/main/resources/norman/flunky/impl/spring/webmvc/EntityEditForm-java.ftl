package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.exception.NotFoundException;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.NumberFormat;

import javax.validation.constraints.Digits;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ${entityName}EditForm {
    private static final Logger LOGGER = LoggerFactory.getLogger(${entityName}EditForm.class);
    private static final SimpleDateFormat YYMD = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat HMS = new SimpleDateFormat("HH:mm:ss");
    private static final SimpleDateFormat YYMD_HMS = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

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
    <#elseif field.type == "Date">
        <#if field.temporalType?? && field.temporalType="DATE">
    @DateTimeFormat(pattern = "M/d/yyyy")
        <#elseif field.temporalType?? && field.temporalType="TIME">
    @DateTimeFormat(pattern = "h:m a")
        <#elseif field.temporalType?? && field.temporalType="TIMESTAMP">
    @DateTimeFormat(pattern = "M/d/yyyy h:m a")
        </#if>
    </#if>
    private ${field.type} ${field.fieldName};
</#list>

    public ${entityName}EditForm() {
        try {
<#list fields?filter(f -> f.dftValue??) as field>
    <#if field.type == "BigDecimal">
            ${field.fieldName} = new BigDecimal("${field.dftValue}");
    <#elseif field.type == "Boolean">
            ${field.fieldName} = Boolean.valueOf(${field.dftValue});
    <#elseif field.type == "Byte">
            ${field.fieldName} = Byte.valueOf((byte) ${field.dftValue});
    <#elseif field.type == "Short">
            ${field.fieldName} = Short.valueOf((short) ${field.dftValue});
    <#elseif field.type == "Integer">
            ${field.fieldName} = Integer.valueOf(${field.dftValue});
    <#elseif field.type == "Long">
            ${field.fieldName} = Long.valueOf((long) ${field.dftValue});
    <#elseif field.type == "Date">
        <#if field.temporalType?? && field.temporalType="DATE">
            ${field.fieldName} = YYMD.parse("${field.dftValue}");
        <#elseif field.temporalType?? && field.temporalType="TIME">
            ${field.fieldName} = HMS.parse("${field.dftValue}");
        <#elseif field.temporalType?? && field.temporalType="TIMESTAMP">
            ${field.fieldName} = YYMD_HMS.parse("${field.dftValue}");
        </#if>
    <#else>
            ${field.fieldName} = "${field.dftValue}";
    </#if>
</#list>
        } catch (ParseException e) {
            LOGGER.warn(String.format("Unable to populate %s with initial values.", this.getClass().getSimpleName()), e);
        }
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
