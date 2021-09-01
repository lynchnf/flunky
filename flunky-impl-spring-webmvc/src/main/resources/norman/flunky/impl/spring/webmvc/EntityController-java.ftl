package ${application.basePackage}.web;

import ${application.basePackage}.domain.${entityName};
<#list fields?filter(f -> f.joinColumn??) as field>
import ${application.basePackage}.domain.${field.type};
</#list>
import ${application.basePackage}.exception.NotFoundException;
import ${application.basePackage}.exception.OptimisticLockingException;
import ${application.basePackage}.exception.ReferentialIntegrityException;
import ${application.basePackage}.service.${entityName}Service;
<#list fields?filter(f -> f.joinColumn??) as field>
import ${application.basePackage}.service.${field.type}Service;
</#list>
import ${application.basePackage}.web.view.${entityName}EditForm;
import ${application.basePackage}.web.view.${entityName}ListForm;
import ${application.basePackage}.web.view.${entityName}View;
import ${application.basePackage}.web.view.EntitySelectOption;
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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
public class ${entityName}Controller {
    private static final Logger LOGGER = LoggerFactory.getLogger(${entityName}Controller.class);
    private static final String defaultSortColumn = "id";
    private static final String[] sortableColumns = {<#list fields?filter(f -> f.listDisplay?? && f.listDisplay == "sort") as field>"${field.fieldName}"<#sep>, </#sep></#list>};
    @Autowired
    private ${entityName}Service service;
<#list fields?filter(f -> f.joinColumn??) as field>
    @Autowired
    private ${field.type}Service ${field.fieldName}Service;
</#list>

    @GetMapping("/${entityName?uncap_first}List")
    public String load${entityName}List(
            @RequestParam(value = "pageNumber", required = false, defaultValue = "0") int pageNumber,
            @RequestParam(value = "pageSize", required = false, defaultValue = "${dftPageSize}") int pageSize,
            @RequestParam(value = "sortColumn", required = false, defaultValue = "${dftSortField}") String sortColumn,
            @RequestParam(value = "sortDirection", required = false, defaultValue = "${dftSortDirection}") Sort.Direction sortDirection,
            <#if parentField??>@RequestParam(value = "parentId") Long parentId, </#if>Model model) {

        // Convert sort column from string to an array of strings.
        String[] sortColumns = {defaultSortColumn};
        if (Arrays.asList(sortableColumns).contains(sortColumn)) {
            sortColumns = new String[]{sortColumn, defaultSortColumn};
        }

        // Get a page of records.
        PageRequest pageable = PageRequest.of(pageNumber, pageSize, sortDirection, sortColumns);
        Page<${entityName}> page = service.findAll(<#if parentField??>parentId, </#if>pageable);

        // Display the page of records.
        ${entityName}ListForm listForm = new ${entityName}ListForm(page);
<#if parentField??>
        listForm.setParentId(parentId);
</#if>
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
            redirectAttributes.addFlashAttribute("errorMessage", "${singular} was not found.");
            return "redirect:/";
        }
    }

    @GetMapping("/${entityName?uncap_first}Edit")
    public String load${entityName}Edit(@RequestParam(value = "id", required = false) Long id,
<#if parentField??>
            @RequestParam(value = "parentId", required = false) Long parentId,
</#if>
            Model model, RedirectAttributes redirectAttributes) {

        // If no id, add new record.
        if (id == null) {
<#if parentField??>
    <#list fields?filter(f -> f.joinColumn?? && f.fieldName == parentField) as field>
            try {
                ${field.type} parent = ${parentField}Service.findById(parentId);
                ${entityName}EditForm editForm = new ${entityName}EditForm(parent);
                model.addAttribute("editForm", editForm);
                return "${entityName?uncap_first}Edit";
            } catch (NotFoundException e) {
        <#list application.entities?filter(e2 -> e2.entityName == field.type) as entity2>
                redirectAttributes.addFlashAttribute("errorMessage", "${entity2.singular} was not found.");
        </#list>
                return "redirect:/";
            }
    </#list>
<#else>
            model.addAttribute("editForm", new ${entityName}EditForm());
            return "${entityName?uncap_first}Edit";
</#if>
        } else {

            // Otherwise, edit existing record.
            try {
                ${entityName} entity = service.findById(id);
                ${entityName}EditForm editForm = new ${entityName}EditForm(entity);
                model.addAttribute("editForm", editForm);
                return "${entityName?uncap_first}Edit";
            } catch (NotFoundException e) {
                redirectAttributes.addFlashAttribute("errorMessage", "${singular} was not found.");
                return "redirect:/";
            }
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
<#list fields?filter(f -> f.joinColumn??) as field>
            editForm.set${field.fieldName?cap_first}Service(${field.fieldName}Service);
</#list>
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
            redirectAttributes.addFlashAttribute("errorMessage", "${singular} was not found.");
            return "redirect:/";
        } catch (OptimisticLockingException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "${singular} was updated by another user.");
            return "redirect:/";
        }
    }

    @PostMapping("/${entityName?uncap_first}Delete")
    public String process${entityName}Delete(@RequestParam("id") Long id, @RequestParam("version") Integer version,
            RedirectAttributes redirectAttributes) {
        try {
            ${entityName} entity = service.findById(id);
            if (entity.getVersion() == version) {
<#if parentField??>
                Long parentId = entity.get${parentField?cap_first}().getId();
</#if>
                service.delete(entity);
                String successMessage = "${singular} successfully deleted.";
                redirectAttributes.addFlashAttribute("successMessage", successMessage);
<#if parentField??>
                redirectAttributes.addAttribute("parentId", parentId);
                return "redirect:/${entityName?uncap_first}List?parentId={parentId}";
<#else>
                return "redirect:/${entityName?uncap_first}List";
</#if>
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "${singular} was updated by another user.");
                return "redirect:/";
            }
        } catch (NotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "${singular} was not found.");
            return "redirect:/";
        } catch (OptimisticLockingException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "${singular} was updated by another user.");
            return "redirect:/";
        } catch (ReferentialIntegrityException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "${singular} cannot be deleted because other data depends on it.");
            return "redirect:/";
        }
    }
<#list fields?filter(f -> f.joinColumn??) as field>
    <#assign hasParent = false />
    <#if entityName == field.type>
        <#if parentField??>
            <#assign hasParent = true />
        </#if>
    <#else>
        <#list application.entities?filter(e2 -> e2.entityName == field.type) as entity2>
            <#if entity2.parentField??>
                <#assign hasParent = true />
            </#if>
        </#list>
    </#if>

    @ModelAttribute("all${field.fieldName?cap_first}")
    public List<EntitySelectOption> load${field.fieldName?cap_first}SelectOptions(<#if hasParent>Long parentId</#if>) {
        List<EntitySelectOption> options = new ArrayList<>();
        for (${field.type} entity : ${field.fieldName}Service.findAll(<#if hasParent>parentId</#if>)) {
            EntitySelectOption option = new EntitySelectOption(entity.getId(), entity.toString());
            options.add(option);
        }
        return options;
    }
</#list>
}
