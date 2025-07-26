package ${application.basePackage};

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.service.${entityName}Service;
import org.apache.commons.lang3.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Random;

import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class ${entityName}DeleteProcessorTest {
    private Random rand = new Random();
    private Long id;
<#list fields as field>
    private String ${field.fieldName};
</#list>
    private ${entityName}DeleteProcessor processor;

    @Before
    public void setUp() throws Exception {
        id = rand.nextLong();
<#list fields as field>
        ${field.fieldName} = RandomStringUtils.randomAlphabetic(10);
</#list>

        ${entityName} entity = new ${entityName}();
        entity.setId(id);
<#list fields as field>
        entity.set${field.fieldName?cap_first}(${field.fieldName});
</#list>
        ${entityName}Service.saveEntity(entity);

        processor = new ${entityName}DeleteProcessor();
    }

    @After
    public void tearDown() throws Exception {
        List<${entityName}> entities = ${entityName}Service.getAllEntities();
        for (${entityName} entity : entities) {
            ${entityName}Service.deleteEntity(entity);
        }

        processor = null;
    }

    @Test
    public void testDoPostHttpServletRequestHttpServletResponse() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        when(request.getParameter("id")).thenReturn(String.valueOf(id));

        processor.doPost(request, response);

        verify(response).sendRedirect("${entityName?uncap_first}ListLoader");
        assertNull(${entityName}Service.getEntity(id));
    }
}
