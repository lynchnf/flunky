package ${application.basePackage}.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Version;

@Entity
public class ${entityName} {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Version
    private Integer version = 0;
<#list fields as field>
    <#assign myParms = [] />
    <#if field.length??><#assign myParms = myParms + [ "length = ${field.length}" ] /></#if>
    <#if field.nullable?? && field.nullable == "false"><#assign myParms = myParms + [ "nullable = false" ] /></#if>
    <#list myParms>
    @Column(<#items as myParm>${myParm}<#sep>, </#sep></#items>)
    </#list>
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
