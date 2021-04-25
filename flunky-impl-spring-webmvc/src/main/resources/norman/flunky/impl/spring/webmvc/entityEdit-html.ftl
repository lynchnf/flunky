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

    <form action="#" method="post" th:action="@{/customerEdit}" th:object="${r"${"}editForm}">
        <ul class="error-message" th:if="${r"${"}#fields.hasAnyErrors()}">
            <li th:each="err:${r"${"}#fields.allErrors()}" th:text="${r"${"}err}"></li>
        </ul>
        <input type="hidden" th:field="*{id}"/>
        <input type="hidden" th:field="*{version}"/>
<#list fields?filter(f -> !f.editDisplay?? || f.editDisplay == "hide") as field>
        <input type="hidden" th:field="*{${field.fieldName}}"/>
</#list>
        <table>
<#list fields?filter(f -> f.editDisplay?? && (f.editDisplay == "show" || f.editDisplay == "edit")) as field>
    <#if field.editDisplay == "show">
            <tr>
                <th>${field.label}</th>
                <td th:text="${r"${"}editForm.${field.fieldName}}"></td>
            </tr>
    <#elseif field.editDisplay == "edit">
            <tr>
                <th>${field.label}</th>
                <td><input type="text" th:field="*{${field.fieldName}}" th:errorclass="field-error"/></td>
            </tr>
    </#if>
</#list>
        </table>
        <input type="submit" value="Save">
    </form>
</main>
<footer>
    <script src="js/jquery-3.5.1.min.js"></script>
    <script src="js/common.js"></script>
</footer>
</body>
</html>
