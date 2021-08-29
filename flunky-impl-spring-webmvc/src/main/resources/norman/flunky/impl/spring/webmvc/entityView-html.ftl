<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <link rel="stylesheet" href="css/main.css">
    <title>${application.artifactId?replace("-", " ")?capitalize}</title>
</head>
<body>
<header>
    <table>
        <tr>
            <td><a th:href="@{/}">Home</a></td>
            <td><a th:href="@{/${entityName?uncap_first}List}">${singular} List</a></td>
            <td><a th:href="@{/${entityName?uncap_first}Edit(id=${r"${"}view.id})}">Edit ${singular}</a></td>
            <td>
                <small>Version</small>
                <small th:text="${r"#{"}application.version}"></small>
            </td>
        </tr>
    </table>
</header>
<main>
    <h1>${singular}</h1>
    <div>
        <ul class="success-message" th:if="${r"${"}successMessage}">
            <li th:text="${r"${"}successMessage}"></li>
        </ul>
        <ul class="error-message" th:if="${r"${"}errorMessage}">
            <li th:text="${r"${"}errorMessage}"></li>
        </ul>
    </div>

    <table>
<#list fields?filter(f -> !f.viewDisplay?? || f.viewDisplay != "hide") as field>
        <tr>
            <th>${field.label}</th>
    <#if field.type == "BigDecimal">
            <td th:text="${r"${"}#numbers.formatCurrency(view.${field.fieldName})}"></td>
    <#elseif field.type == "Byte" || field.type == "Short" || field.type == "Integer" || field.type == "Long">
            <td th:text="${r"${"}#numbers.formatInteger(view.${field.fieldName},1,'DEFAULT')}"></td>
    <#elseif field.type == "Date" && field.temporalType?? && field.temporalType="DATE">
            <td th:text="${r"${"}#dates.format(view.${field.fieldName},'M/d/yyyy')}"></td>
    <#elseif field.type == "Date" && field.temporalType?? && field.temporalType="TIME">
            <td th:text="${r"${"}#dates.format(view.${field.fieldName},'h:m a')}"></td>
    <#elseif field.type == "Date" && field.temporalType?? && field.temporalType="TIMESTAMP">
            <td th:text="${r"${"}#dates.format(view.${field.fieldName},'M/d/yyyy h:m a')}"></td>
    <#else>
            <td th:text="${r"${"}view.${field.fieldName}}"></td>
    </#if>
        </tr>
</#list>
    </table>
    <form action="#" method="post" th:action="@{/${entityName?uncap_first}Delete}">
        <input type="hidden" th:field="${r"${"}view.id}"/>
        <input type="hidden" th:field="${r"${"}view.version}"/>
        <input type="submit" value="Delete" onclick="return confirm('Are you sure?')">
    </form>
    <ul>
<#list application.entities?filter(e2 -> e2.parentField??) as entity2>
    <#list entity2.fields?filter(f2 -> f2.type == entityName && f2.fieldName == entity2.parentField) as field2>
        <li><a th:href="@{/${entity2.entityName?uncap_first}List(parentId=${r"${"}view.id})}">${entity2.plural}</a></li>
    </#list>
</#list>
    </ul>
</main>
<footer>
    <script src="js/jquery-3.5.1.min.js"></script>
    <script src="js/common.js"></script>
</footer>
</body>
</html>
