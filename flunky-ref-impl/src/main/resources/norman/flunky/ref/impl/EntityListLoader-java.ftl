package ${application.basePackage};

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.form.${entityName}Form;
import ${application.basePackage}.service.${entityName}Service;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ${entityName}ListLoader extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<${entityName}> entities = ${entityName}Service.getAllEntities();
        List<${entityName}Form> rows = new ArrayList<>();
        for (${entityName} entity : entities) {
            ${entityName}Form row = new ${entityName}Form(entity);
            rows.add(row);
        }
        request.setAttribute("rows", rows);
        request.getRequestDispatcher("${entityName?uncap_first}List.jsp").forward(request, response);
    }
}
