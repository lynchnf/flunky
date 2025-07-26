package ${application.basePackage};

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.service.${entityName}Service;
import org.apache.commons.lang3.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Random;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class ${entityName}ListLoaderTest {
    private Random rand = new Random();
    private Long id;
<#list fields as field>
    private String ${field.fieldName};
</#list>
    private ${entityName}ListLoader loader;

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

        loader = new ${entityName}ListLoader();
    }

    @After
    public void tearDown() throws Exception {
        List<${entityName}> entities = ${entityName}Service.getAllEntities();
        for (${entityName} entity : entities) {
            ${entityName}Service.deleteEntity(entity);
        }

        loader = null;
    }

    @Test
    public void testDoPostHttpServletRequestHttpServletResponse() throws ServletException, IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        RequestDispatcher dispatcher = mock(RequestDispatcher.class);
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);

        loader.doPost(request, response);

        verify(request).setAttribute(eq("rows"), any(List.class));
        verify(request).getRequestDispatcher("${entityName?uncap_first}List.jsp");
        verify(dispatcher).forward(any(ServletRequest.class), any(ServletResponse.class));
    }
}
