package ${application.basePackage}.web;

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.exception.NotFoundException;
import ${application.basePackage}.exception.OptimisticLockingException;
import ${application.basePackage}.service.${entityName}Service;
import ${application.basePackage}.web.view.${entityName}EditForm;
import ${application.basePackage}.web.view.${entityName}ListForm;
import ${application.basePackage}.web.view.${entityName}View;
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
public class ${entityName}Controller {
    private static final Logger LOGGER = LoggerFactory.getLogger(${entityName}Controller.class);
    private static final String defaultSortColumn = "id";
    private static final String[] sortableColumns = {<#list fields?filter(f -> f.listDisplay?? && f.listDisplay == "sort") as field>"${field.fieldName}"<#sep>, </#sep></#list>};
    @Autowired
    private ${entityName}Service service;

    @GetMapping("/${entityName?uncap_first}List")
    public String load${entityName}List(
            @RequestParam(value = "pageNumber", required = false, defaultValue = "0") int pageNumber,
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
        Page<${entityName}> page = service.findAll(pageable);
        
        // Display the page of records.
        ${entityName}ListForm listForm = new ${entityName}ListForm(page);
        model.addAttribute("listForm", listForm);
        return "${entityName?uncap_first}List";
    }
    
    @GetMapping("/${entityName?uncap_first}")
    public String load${entityName}View(@RequestParam("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            ${entityName} entity = service.findById(id);
            ${entityName}View view = new ${entityName}View(entity);
            model.addAttribute("view", view);
            return "${entityName?uncap_first}View";
        } catch (NotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "${singular} not found.");
            return "redirect:/${entityName?uncap_first}List";
        }
    }
    
    @GetMapping("/${entityName?uncap_first}Edit")
    public String load${entityName}Edit(@RequestParam(value = "id", required = false) Long id, Model model,
            RedirectAttributes redirectAttributes) {
    
        // If no id, add new record.
        if (id == null) {
            model.addAttribute("editForm", new ${entityName}EditForm());
            return "${entityName?uncap_first}Edit";
        }

        // Otherwise, edit existing record.
        try {
            ${entityName} entity = service.findById(id);
            ${entityName}EditForm editForm = new ${entityName}EditForm(entity);
            model.addAttribute("editForm", editForm);
            return "${entityName?uncap_first}Edit";
        } catch (NotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "${singular} not found.");
            return "redirect:/${entityName?uncap_first}List";
        }
    }
    
    @PostMapping("/${entityName?uncap_first}Edit")
    public String process${entityName}Edit(@Valid @ModelAttribute("editForm") ${entityName}EditForm editForm,
            BindingResult bindingResult, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            return "${entityName?uncap_first}Edit";
        }

        // Convert form to entity.
        Long id = editForm.getId();
        try {
            ${entityName} entity = editForm.toEntity();

            // Save entity.
            ${entityName} save = service.save(entity);
            String successMessage = "${singular} successfully added.";
            if (id != null) {
                successMessage = "${singular} successfully updated.";
            }
            redirectAttributes.addFlashAttribute("successMessage", successMessage);
            redirectAttributes.addAttribute("id", save.getId());
            return "redirect:/${entityName?uncap_first}?id={id}";
        } catch (NotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getEntityName() + " not found.");
            return "redirect:/${entityName?uncap_first}List";
        } catch (OptimisticLockingException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "${singular} was updated by another user.");
            return "redirect:/${entityName?uncap_first}List";
        }
    }
}
