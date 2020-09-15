package ${application.basePackage}.web.view;

import ${application.basePackage}.domain.${entityName?cap_first};
import org.springframework.data.domain.Page;

import java.util.ArrayList;
import java.util.List;

public class ${entityName?cap_first}ListForm extends ListForm<${entityName?cap_first}> {
    private List<${entityName?cap_first}View> rows = new ArrayList<>();

    public ${entityName?cap_first}ListForm(Page<${entityName?cap_first}> innerPage) {
        super(innerPage);
        for (${entityName?cap_first} entity : innerPage.getContent()) {
            ${entityName?cap_first}View row = new ${entityName?cap_first}View(entity);
            rows.add(row);
        }
    }

    public List<${entityName?cap_first}View> getRows() {
        return rows;
    }
}
