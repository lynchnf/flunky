package ${application.basePackage}.web;

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.service.${entityName}Service;
import ${application.basePackage}.web.view.${entityName}ListForm;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Arrays;

@Controller
public class ${entityName}Controller {
    private static final Logger LOGGER = LoggerFactory.getLogger(${entityName}Controller.class);
    private static final String defaultSortColumn = "id";
    private static final String[] sortableColumns = {<#list fields as field>"${field.fieldName}"<#sep>, </#sep></#list>};
    @Autowired
    private ${entityName}Service service;

    @GetMapping("/${entityName?uncap_first}List")
    public String load${entityName}List(@RequestParam(value = "pageNumber", required = false, defaultValue = "0") int pageNumber,
            @RequestParam(value = "pageSize", required = false, defaultValue = "${pageSize}") int pageSize,
            @RequestParam(value = "sortColumn", required = false, defaultValue = "${sortColumn}") String sortColumn,
            @RequestParam(value = "sortDirection", required = false, defaultValue = "${sortDirection}") Sort.Direction sortDirection,
            Model model) {

        // Convert sort column from string to an array of strings.
        String[] sortColumns = {defaultSortColumn};
        if (Arrays.asList(sortableColumns).contains(sortColumn)) {
            sortColumns = new String[]{sortColumn, defaultSortColumn};
        }

        // Get a page of records.
        PageRequest pageable = PageRequest.of(pageNumber, pageSize, sortDirection, sortColumns);
        Page<${entityName}> page = service.findAll(pageable);

        ${entityName}ListForm listForm = new ${entityName}ListForm(page);
        model.addAttribute("listForm", listForm);
        return "${entityName?uncap_first}List";
    }
}
