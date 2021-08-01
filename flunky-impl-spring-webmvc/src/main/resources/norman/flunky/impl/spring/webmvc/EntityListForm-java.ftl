package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName};
import org.springframework.data.domain.Page;

import java.util.ArrayList;
import java.util.List;

public class ${entityName}ListForm extends ListForm<${entityName}> {
    private List<${entityName}ListRow> rows = new ArrayList<>();
<#if parentField??>
    private Long parentId;
</#if>

    public ${entityName}ListForm(Page<${entityName}> innerPage) {
        super(innerPage);
        for (${entityName} entity : innerPage.getContent()) {
            ${entityName}ListRow row = new ${entityName}ListRow(entity);
            rows.add(row);
        }
    }

    public List<${entityName}ListRow> getRows() {
        return rows;
    }
<#if parentField??>

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }
</#if>
}
