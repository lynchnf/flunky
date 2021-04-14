<%@ page import="${application.basePackage}.form.${entityName}Form" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<html>
<head>
    <title>${application.artifactId?replace("-", " ")?capitalize}</title>
</head>
<body>
<h1>${application.artifactId?replace("-", " ")?capitalize} - ${singular} Edit</h1>
<% ${entityName}Form form = (${entityName}Form) request.getAttribute("form"); %>
<a href="index.jsp">Home</a>
<a href="${entityName?uncap_first}ListLoader">List</a>
<% if (form.getId() != StringUtils.EMPTY) { %>
<a href="${entityName?uncap_first}ViewLoader?id=<%= form.getId() %>">View</a>
<% } %>
<form method="post" action="${entityName?uncap_first}EditProcessor">
    <input type="hidden" name="id" value="<%= form.getId() %>">
    <table>
        <tbody>
        <% if (form.getId() != StringUtils.EMPTY) { %>
        <tr>
            <td><strong>Id</strong></td>
            <td><%= form.getId() %> </td>
        </tr>
        <% } %>
<#list fields as field>
        <tr>
            <td><strong>${field.label}</strong></td>
            <td><input type="text" name="${field.fieldName}" value="<%= form.get${field.fieldName?cap_first}() %>"></td>
        </tr>
</#list>
        <tr>
            <td></td>
            <td>
                <button type="submit">Save</button>
            </td>
        </tr>
        </tbody>
    </table>
</form>
</body>
</html>
