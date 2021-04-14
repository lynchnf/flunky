package ${application.basePackage};

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.form.${entityName}Form;
import ${application.basePackage}.service.${entityName}Service;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ${entityName}EditLoader extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        ${entityName}Form form = null;
        if (idStr == null) {
            form = new ${entityName}Form();
        } else {
            Long id = Long.parseLong(idStr);
            ${entityName} entity = ${entityName}Service.getEntity(id);
            if (entity != null) {
                form = new ${entityName}Form(entity);
            }
        }
        if (form == null) {
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else {
            request.setAttribute("form", form);
            request.getRequestDispatcher("${entityName?uncap_first}Edit.jsp").forward(request, response);
        }
    }
}
