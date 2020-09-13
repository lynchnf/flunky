package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName};
import org.springframework.data.domain.Page;

import java.util.ArrayList;
import java.util.List;

public class ${entityName}ListForm extends ListForm<${entityName}> {
    private List<${entityName}View> rows = new ArrayList<>();

    public ${entityName}ListForm(Page<${entityName}> innerPage) {
        super(innerPage);
        for (${entityName} entity : innerPage.getContent()) {
            ${entityName}View row = new ${entityName}View(entity);
            rows.add(row);
        }
    }

    public List<${entityName}View> getRows() {
        return rows;
    }
}
