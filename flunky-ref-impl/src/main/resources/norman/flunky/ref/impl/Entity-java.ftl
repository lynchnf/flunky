package ${application.basePackage}.domain;

public class ${entityName} {
    private Long id;
<#list fields as field>
    private String ${field.fieldName};
</#list>

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
<#list fields as field>

    public String get${field.fieldName?cap_first}() {
        return ${field.fieldName};
    }

    public void set${field.fieldName?cap_first}(String ${field.fieldName}) {
        this.${field.fieldName} = ${field.fieldName};
    }
</#list>
}
