<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head th:replace="fragments/head::head"></head>
<body>
<header th:replace="fragments/menu::menu"></header>
<main class="container">
    <h1>${singular?capitalize}</h1>
    <div th:replace="fragments/alerts::alerts"></div>

<#list fields?filter(f -> f.onEdit?? && f.onEdit == "true") as field>
    <div class="form-group row">
        <label class="col-sm-3 col-form-label">${field.label?capitalize}</label>
        <div class="col-sm-9">
<#if field.type == "BigDecimal">
            <p class="form-control-plaintext" th:text="${r"${#numbers.formatCurrency(view."}${field.fieldName})}"></p>
<#elseif field.type == "Boolean">
            <p class="form-control-plaintext" th:text="${r"${view."}${field.fieldName}}"></p>
<#elseif field.temporal?? && field.temporal="DATE">
            <p class="form-control-plaintext" th:text="${r"${#dates.format(view."}${field.fieldName},'M/d/yyyy')}"></p>
<#elseif field.temporal?? && field.temporal="TIME">
            <p class="form-control-plaintext" th:text="${r"${#dates.format(view."}${field.fieldName},'H:m:s')}"></p>
<#elseif field.temporal?? && field.temporal="TIMESTAMP">
            <p class="form-control-plaintext" th:text="${r"${#dates.format(view."}${field.fieldName},'M/d/yyyy H:m:s')}"></p>
<#elseif field.type == "Integer">
            <p class="form-control-plaintext" th:text="${r"${#numbers.formatInteger(view."}${field.fieldName},1,'DEFAULT')}"></p>
<#elseif field.type == "Long">
            <p class="form-control-plaintext" th:text="${r"${#numbers.formatInteger(view."}${field.fieldName},1,'DEFAULT')}"></p>
<#elseif field.type == "String">
            <p class="form-control-plaintext" th:text="${r"${view."}${field.fieldName}}"></p>
<#else>
            <p class="form-control-plaintext" th:text="${r"${view."}${field.fieldName}}"></p>
</#if>
        </div>
    </div>
</#list>

    <a class="btn btn-primary" th:href="@{/${entityName}Edit(id=${r"${view.id}"})}">Edit</a>
</main>
<footer th:replace="fragments/footer::footer"></footer>
</body>
</html>
