package ${application.basePackage}.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;
import java.math.BigDecimal;
import java.util.Date;

@Entity
public class ${entityName} {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Version
    private Integer version = 0;
<#list fields as field>
<#if temporal??>   @Temporal(TemporalType.${temporal})</#if>
    @Column(length = ${length}, precision = ${precision}, scale = ${scale}, nullable = ${nullable})
    private ${field.type} ${field.fieldName};
</#list>
<#list fields as field>

    public ${field.type} get${field.fieldName?cap_first}() {
    return ${field.fieldName};
    }

    public void set${field.fieldName?cap_first}(${field.type} ${field.fieldName}) {
    this.${field.fieldName} = ${field.fieldName};
    }
</#list>
}
