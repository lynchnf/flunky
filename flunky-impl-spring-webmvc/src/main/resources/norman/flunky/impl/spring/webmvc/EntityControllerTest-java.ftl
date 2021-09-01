package ${application.basePackage}.web;

import ${application.basePackage}.FakeDataFactory;
import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.exception.NotFoundException;
import ${application.basePackage}.service.${entityName}Service;
import ${application.basePackage}.web.view.${entityName}EditForm;
import ${application.basePackage}.web.view.${entityName}ListForm;
import ${application.basePackage}.web.view.${entityName}View;
import org.apache.commons.lang3.RandomStringUtils;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.validation.AbstractBindingResult;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(${entityName}Controller.class)
public class ${entityName}ControllerTest {
    @Autowired
    private MockMvc mockMvc;
    @MockBean
    private ${entityName}Service service;

    @Test
    public void load${entityName}List() throws Exception {
        // Lets say we're gonna get the first of two pages of records.
        int pageNumber = 0;
        int pageSize = ${dftPageSize};
        long total = 2 * pageSize;
        Sort.Direction sortDirection = Sort.Direction.${dftSortDirection};
        String[] sortColumns = {"${dftSortField}", "id"};

        // Generate a sorted list of records.
        FakeDataFactory factory = new FakeDataFactory();
        List<${entityName}> entities = new ArrayList<>();
        for (int i = 0; i < pageSize; i++) {
            ${entityName} entity = factory.nextRandom${entityName}();
            entity.setId((long) (i + 1));
            entities.add(entity);
        }
        entities.sort(Comparator.comparing(${entityName}::get${dftSortField?cap_first}).thenComparing(${entityName}::getId));

        // Mock the service response.
        PageRequest pageable = PageRequest.of(pageNumber, pageSize, sortDirection, sortColumns);
        PageImpl<${entityName}> page = new PageImpl<>(entities, pageable, total);
        when(service.findAll(any(Pageable.class))).thenReturn(page);

        // @formatter:off
        MvcResult mvcResult = mockMvc.perform(get("/${entityName?uncap_first}List"))
                .andExpect(status().isOk())
                .andReturn();
        // @formatter:on
        ${entityName}ListForm listForm = (${entityName}ListForm) mvcResult.getModelAndView().getModel().get("listForm");
        assertEquals(pageNumber, listForm.getNumber());
        assertEquals(pageSize, listForm.getSize());
        assertEquals(sortColumns[0], listForm.getSortColumn());
        assertEquals(sortDirection, listForm.getSortDirection());
        assertEquals(2, listForm.getTotalPages());
        for (int i = 0; i < pageSize; i++) {
            assertEquals(entities.get(i).getId(), listForm.getRows().get(i).getId());
            assertEquals(entities.get(i).get${dftSortField?cap_first}(), listForm.getRows().get(i).get${dftSortField?cap_first}());
        }
    }

    @Test
    public void load${entityName}View() throws Exception {
        // Mock the service response.
        FakeDataFactory factory = new FakeDataFactory();
        ${entityName} entity = factory.nextRandom${entityName}();
        entity.setId(1L);
        when(service.findById(anyLong())).thenReturn(entity);

        // @formatter:off
        MvcResult mvcResult = mockMvc.perform(get("/${entityName?uncap_first}")
                    .param("id", "1"))
                .andExpect(status().isOk())
                .andReturn();
        // @formatter:on
        ${entityName}View view = (${entityName}View) mvcResult.getModelAndView().getModel().get("view");
        assertEquals(entity.getId(), view.getId());
        assertEquals(entity.get${dftSortField?cap_first}(), view.get${dftSortField?cap_first}());
    }

    @Test
    public void load${entityName}ViewNotFound() throws Exception {
        // Mock the service response.
        NotFoundException exception = new NotFoundException(mock(Logger.class), "${entityName?uncap_first}", 1);
        when(service.findById(anyLong())).thenThrow(exception);

        // @formatter:off
        mockMvc.perform(get("/${entityName?uncap_first}")
                    .param("id", "1"))
                .andExpect(status().isFound())
                .andExpect(redirectedUrl("/${entityName?uncap_first}List"))
                .andExpect(flash().attribute("errorMessage","${singular} not found."));
        // @formatter:on
    }

    @Test
    public void load${entityName}EditExistingEntity() throws Exception {
        // Mock the service response.
        FakeDataFactory factory = new FakeDataFactory();
        ${entityName} entity = factory.nextRandom${entityName}();
        entity.setId(1L);
        entity.setVersion(2);
        when(service.findById(anyLong())).thenReturn(entity);

        // @formatter:off
        MvcResult mvcResult = mockMvc.perform(get("/${entityName?uncap_first}Edit")
                    .param("id", "1"))
                .andExpect(status().isOk())
                .andReturn();
        // @formatter:on
        ${entityName}EditForm editForm = (${entityName}EditForm) mvcResult.getModelAndView().getModel().get("editForm");
        assertEquals(entity.getId(), editForm.getId());
        assertEquals(entity.getVersion(), editForm.getVersion());
        assertEquals(entity.get${dftSortField?cap_first}(), editForm.get${dftSortField?cap_first}());
    }

    @Test
    public void load${entityName}EditNewEntity() throws Exception {
        // @formatter:off
        MvcResult mvcResult = mockMvc.perform(get("/${entityName?uncap_first}Edit"))
            .andExpect(status().isOk())
            .andReturn();
        // @formatter:on
        ${entityName}EditForm editForm = (${entityName}EditForm) mvcResult.getModelAndView().getModel().get("editForm");
        assertNull(editForm.getId());
        assertEquals(0, editForm.getVersion());
        assertNull(editForm.get${dftSortField?cap_first}());
    }

    @Test
    public void process${entityName}Edit() throws Exception {
        // Mock the service response.
        FakeDataFactory factory = new FakeDataFactory();
        ${entityName} entity = factory.nextRandom${entityName}();
        entity.setId(1L);
        entity.setVersion(2);
        when(service.save(any(${entityName}.class))).thenReturn(entity);

        // @formatter:off
        mockMvc.perform(post("/${entityName?uncap_first}Edit")
<#list fields as field>
    <#if field.type == "String">
                    .param("${field.fieldName}", entity.get${field.fieldName?cap_first}())<#if field?is_last>)</#if>
    <#else>
                    .param("${field.fieldName}", String.valueOf(entity.get${field.fieldName?cap_first}()))<#if field?is_last>)</#if>
    </#if>
</#list>
                .andExpect(status().isFound())
                .andExpect(redirectedUrl("/${entityName?uncap_first}?id=1"))
                .andExpect(flash().attribute("successMessage","${singular} successfully added."));
        // @formatter:on
        verify(service).save(any(${entityName}.class));
    }

    @Test
    public void process${entityName}EditWithNullErrors() throws Exception {
        // @formatter:off
        MvcResult mvcResult = mockMvc.perform(post("/${entityName?uncap_first}Edit"))
                .andExpect(status().isOk())
                .andReturn();
        // @formatter:on
        AbstractBindingResult bindingResult = (AbstractBindingResult) mvcResult.getModelAndView().getModel()
                .get("org.springframework.validation.BindingResult.editForm");
        assertTrue(bindingResult.hasErrors());
<#list fields as field>
    <#if field.nullable?? && field.nullable == "false" && !field.dftValue??>
        assertNotNull(bindingResult.getFieldError("${field.fieldName}"));
    <#else>
        assertNull(bindingResult.getFieldError("${field.fieldName}"));
    </#if>
</#list>
    }

    @Test
    public void process${entityName}EditWithSizeErrors() throws Exception {
        // @formatter:off
        String bigString = RandomStringUtils.randomAlphabetic(300);
        MvcResult mvcResult = mockMvc.perform(post("/${entityName?uncap_first}Edit")
<#list fields as field>
                    .param("${field.fieldName}", bigString)<#if field?is_last>)</#if>
</#list>
                .andExpect(status().isOk())
                .andReturn();
        // @formatter:on
        AbstractBindingResult bindingResult = (AbstractBindingResult) mvcResult.getModelAndView().getModel()
                .get("org.springframework.validation.BindingResult.editForm");
        assertTrue(bindingResult.hasErrors());
<#list fields as field>
        assertNotNull(bindingResult.getFieldError("${field.fieldName}"));
</#list>
    }
}
