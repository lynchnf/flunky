package ${application.basePackage}.web;

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.exception.NotFoundException;
import ${application.basePackage}.exception.OptimisticLockingException;
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

import static com.mycompany.example.my.app.FakeDataUtil.nextRandom${entityName};
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
        int pageSize = ${defaultPage};
        long total = 2 * pageSize;
        Sort.Direction sortDirection = Sort.Direction.${defaultSort};
        String[] sortColumns = {"${mainField}", "id"};

        // Generate a sorted list of records.
        List<${entityName}> entities = new ArrayList<>();
        for (int i = 0; i < pageSize; i++) {
            ${entityName} entity = nextRandom${entityName}();
            entity.setId((long) (i + 1));
            entities.add(entity);
        }
        entities.sort(Comparator.comparing(${entityName}::get${mainField?cap_first}).thenComparing(${entityName}::getId));

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
            assertEquals(entities.get(i).getAcctNbr(), listForm.getRows().get(i).getAcctNbr());
        }
    }

    @Test
    public void load${entityName}View() throws Exception {
        // Mock the service response.
        ${entityName} entity = nextRandom${entityName}();
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
        assertEquals(entity.getAcctNbr(), view.getAcctNbr());
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
                .andExpect(flash().attribute("errorMessage","${entityName} not found."));
        // @formatter:on
    }

    @Test
    public void load${entityName}EditExistingEntity() throws Exception {
        // Mock the service response.
        ${entityName} entity = nextRandom${entityName}();
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
        assertEquals(entity.getAcctNbr(), editForm.getAcctNbr());
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
        assertNull(editForm.getAcctNbr());
    }

    @Test
    public void process${entityName}Edit() throws Exception {
        // Mock the service response.
        ${entityName} entity = nextRandom${entityName}();
        entity.setId(1L);
        entity.setVersion(2);
        when(service.save(any(${entityName}.class))).thenReturn(entity);

        // @formatter:off
        mockMvc.perform(post("/${entityName?uncap_first}Edit")
                    .param("acctNbr", entity.getAcctNbr())
                    .param("name", entity.getName())
                    .param("addressLine1", entity.getAddressLine1())
                    .param("addressLine2", entity.getAddressLine2())
                    .param("city", entity.getCity())
                    .param("stateCode", entity.getStateCode())
                    .param("postalCode", entity.getPostalCode()))
                .andExpect(status().isFound())
                .andExpect(redirectedUrl("/${entityName?uncap_first}?id=1"))
                .andExpect(flash().attribute("successMessage","${entityName} successfully added."));
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
        assertNotNull(bindingResult.getFieldError("acctNbr"));
        assertNull(bindingResult.getFieldError("name"));
        assertNull(bindingResult.getFieldError("addressLine1"));
        assertNull(bindingResult.getFieldError("addressLine2"));
        assertNull(bindingResult.getFieldError("city"));
        assertNull(bindingResult.getFieldError("stateCode"));
        assertNull(bindingResult.getFieldError("postalCode"));
    }

    @Test
    public void process${entityName}EditWithSizeErrors() throws Exception {
        // @formatter:off
        String bigString = RandomStringUtils.randomAlphabetic(300);
        MvcResult mvcResult = mockMvc.perform(post("/${entityName?uncap_first}Edit")
                    .param("acctNbr", bigString)
                    .param("name", bigString)
                    .param("addressLine1", bigString)
                    .param("addressLine2", bigString)
                    .param("city", bigString)
                    .param("stateCode", bigString)
                    .param("postalCode", bigString))
                .andExpect(status().isOk())
                .andReturn();
        // @formatter:on
        AbstractBindingResult bindingResult = (AbstractBindingResult) mvcResult.getModelAndView().getModel()
                .get("org.springframework.validation.BindingResult.editForm");
        assertTrue(bindingResult.hasErrors());
        assertNotNull(bindingResult.getFieldError("acctNbr"));
        assertNotNull(bindingResult.getFieldError("name"));
        assertNotNull(bindingResult.getFieldError("addressLine1"));
        assertNotNull(bindingResult.getFieldError("addressLine2"));
        assertNotNull(bindingResult.getFieldError("city"));
        assertNotNull(bindingResult.getFieldError("stateCode"));
        assertNotNull(bindingResult.getFieldError("postalCode"));
    }
}
