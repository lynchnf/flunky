<%@ page import="${application.basePackage}.form.${entityName}Form" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>${application.artifactId?replace("-", " ")?capitalize}</title>
</head>
<body>
<h1>${application.artifactId?replace("-", " ")?capitalize} - ${singular} List</h1>
<% List<${entityName}Form> rows = (List<${entityName}Form>) request.getAttribute("rows"); %>
<a href="index.jsp">Home</a>
<a href="${entityName?uncap_first}EditLoader">Create Entity</a>
<table>
    <thead>
    <tr>
        <th>Id</th>
<#list fields as field>
        <th>${field.label}</th>
</#list>
    </tr>
    </thead>
    <tbody>
    <% for (${entityName}Form row : rows) { %>
    <tr>
        <td><a href="${entityName?uncap_first}ViewLoader?id=<%= row.getId() %>"><%= row.getId() %></a></td>
<#list fields as field>
        <td><%= row.get${field.fieldName?cap_first}() %></td>
</#list>
    </tr>
    <% } %>
    </tbody>
</table>
</body>
</html>
