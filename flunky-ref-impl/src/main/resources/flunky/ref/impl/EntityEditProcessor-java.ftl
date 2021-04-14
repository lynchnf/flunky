package ${application.basePackage};

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.form.${entityName}Form;
import ${application.basePackage}.service.${entityName}Service;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ${entityName}EditProcessor extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ${entityName}Form form = new ${entityName}Form();
        form.setId(request.getParameter("id"));
<#list fields as field>
        form.set${field.fieldName?cap_first}(request.getParameter("${field.fieldName}"));
</#list>
        ${entityName} entity = form.toEntity();
        ${entityName} save = ${entityName}Service.saveEntity(entity);
        response.sendRedirect("${entityName?uncap_first}ViewLoader?id=" + save.getId());
    }
}
