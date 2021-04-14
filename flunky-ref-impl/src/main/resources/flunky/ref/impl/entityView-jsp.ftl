<%@ page import="${application.basePackage}.form.${entityName}Form" %>
<html>
<head>
    <title>${application.artifactId?replace("-", " ")?capitalize}</title>
</head>
<body>
<h1>${application.artifactId?replace("-", " ")?capitalize} - ${singular} View</h1>
<% ${entityName}Form view = (${entityName}Form) request.getAttribute("view"); %>
<a href="index.jsp">Home</a>
<a href="${entityName?uncap_first}ListLoader">List</a>
<a href="${entityName?uncap_first}EditLoader?id=<%= view.getId() %>">Edit</a>
<a href="${entityName?uncap_first}DeleteProcessor?id=<%= view.getId() %>">Delete</a>
<table>
    <tbody>
    <tr>
        <td><strong>Id</strong></td>
        <td><%= view.getId() %>
        </td>
    </tr>
<#list fields as field>
    <tr>
        <td><strong>${field.label}</strong></td>
        <td><%= view.get${field.fieldName?cap_first}() %></td>
    </tr>
</#list>
    </tbody>
</table>
</body>
</html>
