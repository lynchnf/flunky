package ${application.basePackage}.domain;

import org.apache.commons.lang3.StringUtils;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.NumberFormat;
import java.util.Date;

@Entity
public class ${entityName?cap_first} {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Version
    private Integer version = 0;
<#list fields as field>
<#assign myParms = [] />
<#if field.length??><#assign myParms = myParms + [ "length = ${field.length}" ] /></#if>
<#if field.precision??><#assign myParms = myParms + [ "precision = ${field.precision}" ] /></#if>
<#if field.scale??><#assign myParms = myParms + [ "scale = ${field.scale}" ] /></#if>
<#if field.nullable??><#assign myParms = myParms + [ "nullable = ${field.nullable}" ] /></#if>
<#if field.type == "BigDecimal">
<#list myParms>
    @Column(<#items as myParm>${myParm}<#sep>, </#sep></#items>)
</#list>
<#elseif field.type == "Boolean">
<#list myParms>
    @Column(<#items as myParm>${myParm}<#sep>, </#sep></#items>)
</#list>
<#elseif field.type == "Date">
    @Temporal(TemporalType.DATE)
<#list myParms>
    @Column(<#items as myParm>${myParm}<#sep>, </#sep></#items>)
</#list>
<#elseif field.type == "Integer">
<#list myParms>
    @Column(<#items as myParm>${myParm}<#sep>, </#sep></#items>)
</#list>
<#elseif field.type == "Long">
<#list myParms>
    @Column(<#items as myParm>${myParm}<#sep>, </#sep></#items>)
</#list>
<#elseif field.type == "String">
<#list myParms>
    @Column(<#items as myParm>${myParm}<#sep>, </#sep></#items>)
</#list>
<#else>
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "${field.joinColumn}"<#if field.nullable??>, nullable = ${field.nullable}</#if>)
</#if>
    private ${field.type} ${field.fieldName};
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

    public ${field.type} get${field.fieldName?cap_first}() {
        return ${field.fieldName};
    }

    public void set${field.fieldName?cap_first}(${field.type} ${field.fieldName}) {
        this.${field.fieldName} = ${field.fieldName};
    }
</#list>

    @Override
    public String toString() {
        return ${toString};
    }
}
