package ${application.basePackage}.form;

import ${application.basePackage}.domain.${entityName};
import org.apache.commons.lang3.StringUtils;

public class ${entityName}Form {
    private String id = StringUtils.EMPTY;
<#list fields as field>
    private String ${field.fieldName} = StringUtils.EMPTY;
</#list>

    public ${entityName}Form() {
    }

    public ${entityName}Form(${entityName} entity) {
        if (entity.getId() != null) {
            id = String.valueOf(entity.getId());
        }
<#list fields as field>
        ${field.fieldName} = StringUtils.trimToEmpty(entity.get${field.fieldName?cap_first}());
</#list>
    }

    public ${entityName} toEntity() {
        ${entityName} entity = new ${entityName}();
        String idStr = StringUtils.trimToNull(id);
        if (idStr != null) {
            entity.setId(Long.parseLong(idStr));
        }
<#list fields as field>
        entity.set${field.fieldName?cap_first}(StringUtils.trimToNull(${field.fieldName}));
</#list>
        return entity;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
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
