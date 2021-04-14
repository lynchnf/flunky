package ${application.basePackage};

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.form.${entityName}Form;
import ${application.basePackage}.service.${entityName}Service;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ${entityName}ViewLoader extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        ${entityName} entity = ${entityName}Service.getEntity(id);
        if (entity == null) {
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else {
            ${entityName}Form view = new ${entityName}Form(entity);
            request.setAttribute("view", view);
            request.getRequestDispatcher("${entityName?uncap_first}View.jsp").forward(request, response);
        }
    }
}
