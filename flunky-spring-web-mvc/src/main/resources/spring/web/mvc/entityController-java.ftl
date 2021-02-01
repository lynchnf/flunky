package ${application.basePackage}.web;

import ${application.basePackage}.domain.${entityName?cap_first};
<#list fields?filter(f -> f.joinColumn??) as field>
    import ${application.basePackage}.domain.${field.type};
</#list>
import ${application.basePackage}.exception.NotFoundException;
import ${application.basePackage}.exception.OptimisticLockingException;
import ${application.basePackage}.service.${entityName?cap_first}Service;
<#list fields?filter(f -> f.joinColumn??) as field>
    import ${application.basePackage}.service.${field.type}Service;
</#list>
import ${application.basePackage}.web.view.${entityName?cap_first}EditForm;
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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;
import java.util.Arrays;

@Controller
public class ${entityName?cap_first}Controller {
    private static final Logger LOGGER = LoggerFactory.getLogger(${entityName?cap_first}Controller.class);
    private static final String defaultSortColumn = "id";
    private static final String[] sortableColumns = {<#list fields?filter(f -> f.sortable?? && f.sortable == "true") as field>"${field.fieldName}"<#sep>, </#sep></#list>};
    @Autowired
    private ${entityName?cap_first}Service service;
<#list fields?filter(f -> f.joinColumn??) as field>
    @Autowired
    private ${field.type}Service ${field.fieldName}Service;
</#list>

    @GetMapping("/${entityName}List")
    public String load${entityName?cap_first}List(@RequestParam(value = "pageNumber", required = false, defaultValue = "0") int pageNumber,
            @RequestParam(value = "pageSize", required = false, defaultValue = "${defaultPage}") int pageSize,
            @RequestParam(value = "sortColumn", required = false, defaultValue = "${mainField}") String sortColumn,
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

        // Display the page of records.
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

    @GetMapping("/${entityName}Edit")
    public String load${entityName?cap_first}Edit(@RequestParam(value = "id", required = false) Long id, Model model,
            RedirectAttributes redirectAttributes) {

        // If no id, add new record.
        if (id == null) {
            model.addAttribute("editForm", new ${entityName?cap_first}EditForm());
            return "${entityName}Edit";
        }

        // Otherwise, edit existing record.
        try {
            ${entityName?cap_first} entity = service.findById(id);
            ${entityName?cap_first}EditForm editForm = new ${entityName?cap_first}EditForm(entity);
            model.addAttribute("editForm", editForm);
            return "${entityName}Edit";
        } catch (NotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "${singular?cap_first} not found.");
            return "redirect:/${entityName}List";
        }
    }

    @PostMapping("/${entityName}Edit")
    public String process${entityName?cap_first}Edit(@Valid @ModelAttribute("editForm") ${entityName?cap_first}EditForm editForm, BindingResult bindingResult,
            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            return "${entityName}Edit";
        }

        // Convert form to entity.
        Long id = editForm.getId();
        try {
<#list fields?filter(f -> f.joinColumn??) as field>
            editForm.set${field.fieldName?cap_first}Service(${field.fieldName}Service);
</#list>
            ${entityName?cap_first} entity = editForm.toEntity();

            // Save entity.
            ${entityName?cap_first} save = service.save(entity);
            String successMessage = "${singular?cap_first} successfully added.";
            if (id != null) {
                successMessage = "${singular?cap_first} successfully updated.";
            }
            redirectAttributes.addFlashAttribute("successMessage", successMessage);
            redirectAttributes.addAttribute("id", save.getId());
            return "redirect:/${entityName}?id={id}";
        } catch (NotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getEntityName() + " not found.");
            return "redirect:/${entityName}List";
        } catch (OptimisticLockingException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "${singular?cap_first} was updated by another user.");
            return "redirect:/${entityName}List";
        }
    }
<#list fields?filter(f -> f.joinColumn??) as field>

    @ModelAttribute("all${field.fieldName?cap_first}")
    public Iterable<${field.type}> load${field.fieldName?cap_first}DropDown() {
        return ${field.fieldName}Service.findAll();
    }
</#list>
}
