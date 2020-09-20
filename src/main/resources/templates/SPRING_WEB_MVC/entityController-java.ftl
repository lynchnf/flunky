package ${application.basePackage}.web;

import ${application.basePackage}.domain.${entityName?cap_first};
import ${application.basePackage}.exception.NotFoundException;
import ${application.basePackage}.service.${entityName?cap_first}Service;
import ${application.basePackage}.web.view.${entityName?cap_first}ListForm;
import ${application.basePackage}.web.view.${entityName?cap_first}View;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Arrays;

@Controller
public class ${entityName?cap_first}Controller {
    private static final Logger LOGGER = LoggerFactory.getLogger(${entityName?cap_first}Controller.class);
    private static final String defaultSortColumn = "id";
    private static final String[] sortableColumns = {<#list fields?filter(f -> f.sortable?? && f.sortable == "true") as field>"${field.fieldName}"<#sep>, </#sep></#list>};
    @Autowired
    private ${entityName?cap_first}Service service;

    @GetMapping("/${entityName}List")
    public String load${entityName?cap_first}List(@RequestParam(value = "pageNumber", required = false, defaultValue = "0") int pageNumber,
            @RequestParam(value = "pageSize", required = false, defaultValue = "${defaultPage}") int pageSize,
            @RequestParam(value = "sortColumn", required = false, defaultValue = "${mainColumn}") String sortColumn,
            @RequestParam(value = "sortDirection", required = false, defaultValue = "${defaultSort}") Sort.Direction sortDirection,
            Model model) {

        // Convert sort column from string to an array of strings.
        String[] sortColumns = {defaultSortColumn};
        if (Arrays.asList(sortableColumns).contains(sortColumn)) {
            sortColumns = new String[]{sortColumn, defaultSortColumn};
        }

        // Get a page of records.
        PageRequest pageable = PageRequest.of(pageNumber, pageSize, sortDirection, sortColumns);
        Page<${entityName?cap_first}> page = service.findAll(pageable);

        ${entityName?cap_first}ListForm listForm = new ${entityName?cap_first}ListForm(page);
        model.addAttribute("listForm", listForm);
        return "${entityName}List";
    }

    @GetMapping("/${entityName}")
    public String load${entityName?cap_first}View(@RequestParam("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            ${entityName?cap_first} entity = service.findById(id);
            ${entityName?cap_first}View view = new ${entityName?cap_first}View(entity);
            model.addAttribute("view", view);
            return "${entityName}View";
        } catch (NotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "${singular?cap_first} not found.");
            return "redirect:/${entityName}List";
        }
    }
}
