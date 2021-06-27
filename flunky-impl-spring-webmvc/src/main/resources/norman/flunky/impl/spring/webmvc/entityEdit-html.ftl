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

    <form action="#" method="post" th:action="@{/${entityName?uncap_first}Edit}" th:object="${r"${"}editForm}">
        <ul class="error-message" th:if="${r"${"}#fields.hasAnyErrors()}">
            <li th:each="err:${r"${"}#fields.allErrors()}" th:text="${r"${"}err}"></li>
        </ul>
        <input type="hidden" th:field="*{id}"/>
        <input type="hidden" th:field="*{version}"/>
<#list fields?filter(f -> !f.editDisplay?? || f.editDisplay != "edit") as field>
        <input type="hidden" th:field="*{${field.fieldName}}"/>
</#list>
        <table>
<#list fields?filter(f -> !f.editDisplay?? || f.editDisplay != "hide") as field>
    <#if field.editDisplay?? && field.editDisplay == "edit">
            <tr>
                <th>${field.label}</th>
        <#if field.type = "Boolean">
                <td><select th:field="*{booleanField}" th:errorclass="is-invalid">
                        <option value="">Please select ...</option>
                        <option value="true">true</option>
                        <option value="false">false</option>
                    </select></td>
        <#else>
                <td><input type="text" th:field="*{${field.fieldName}}" th:errorclass="field-error"/></td>
        </#if>
            </tr>
    <#else>
            <tr>
                <th>${field.label}</th>
        <#if field.type == "BigDecimal">
                <td th:text="${r"${"}#numbers.formatCurrency(editForm.${field.fieldName})}"></td>
        <#elseif field.type == "Byte" || field.type == "Short" || field.type == "Integer" || field.type == "Long">
                <td th:text="${r"${"}#numbers.formatInteger(editForm.${field.fieldName},1,'DEFAULT')}"></td>
        <#else>
                <td th:text="${r"${"}editForm.${field.fieldName}}"></td>
        </#if>
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
