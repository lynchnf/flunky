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
<#if parentField??>
            <td><a th:href="@{/${entityName?uncap_first}List(parentId=${r"${"}editForm.${parentField}Id})}">${singular} List</a></td>
<#else>
            <td><a th:href="@{/${entityName?uncap_first}List}">${singular} List</a></td>
</#if>
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
    <#if field.joinColumn??>
        <input type="hidden" th:field="*{${field.fieldName}Id}"/>
    <#else>
        <input type="hidden" th:field="*{${field.fieldName}}"/>
    </#if>
</#list>
        <table>
<#list fields?filter(f -> !f.editDisplay?? || f.editDisplay != "hide") as field>
    <#if field.editDisplay?? && field.editDisplay == "edit">
            <tr>
                <th>${field.label}</th>
        <#if field.joinColumn??>
                <td><select th:field="*{${field.fieldName}Id}" th:errorclass="field-error">
                        <option value="">Please select ...</option>
                        <option th:each="option:${r"${"}all${field.fieldName?cap_first}}" th:value="${r"${"}option.value}" th:text="${r"${"}option.text}"></option>
                    </select></td>
        <#elseif field.enumType??>
                <td><select th:field="*{${field.fieldName}}" th:errorclass="field-error">
                        <option value="">Please select ...</option>
                        <option th:each="value:${r"${"}T(${application.basePackage}.domain.${field.type}).values()}" th:value="${r"${"}value}" th:text="${r"${"}value}"></option>
                    </select></td>
        <#elseif field.type = "Boolean">
                <td><select th:field="*{${field.fieldName}}" th:errorclass="field-error">
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
        <#elseif field.type == "Date" && field.temporalType?? && field.temporalType="DATE">
                <td th:text="${r"${"}#dates.format(row.${field.fieldName},'M/d/yyyy')}"></td>
        <#elseif field.type == "Date" && field.temporalType?? && field.temporalType="TIME">
                <td th:text="${r"${"}#dates.format(row.${field.fieldName},'h:m a')}"></td>
        <#elseif field.type == "Date" && field.temporalType?? && field.temporalType="TIMESTAMP">
                <td th:text="${r"${"}#dates.format(row.${field.fieldName},'M/d/yyyy h:m a')}"></td>
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
