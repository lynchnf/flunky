<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head th:replace="fragments/head::head"></head>
<body>
<header th:replace="fragments/menu::menu"></header>
<main class="container">
    <h1>${singular?capitalize} Edit</h1>
    <div th:replace="fragments/alerts::alerts"></div>

    <form action="#" method="post" th:action="@{/${entityName}Edit}" th:object="${r"${"}editForm}">
        <ul class="alert alert-danger" th:if="${r"${"}#fields.hasAnyErrors()}">
            <li th:each="err:${r"${"}#fields.allErrors()}" th:text="${r"${"}err}"></li>
        </ul>
        <input type="hidden" th:field="*{id}"/>
        <input type="hidden" th:field="*{version}"/>
<#list fields?filter(f -> f.onEdit?? && f.onEdit == "true") as field>
        <div class="form-group row">
            <label class="col-sm-3 col-form-label">${field.label?capitalize}<#if field.type == "Date"> (M/d/yyyy)</#if></label>
            <div class="col-sm-9">
<#if field.type == "BigDecimal">
                <input type="text" class="form-control" th:field="*{${field.fieldName}}" th:errorclass="is-invalid"/>
<#elseif field.type == "Boolean">
                <select class="form-control" th:field="*{${field.fieldName}}" th:errorclass="is-invalid">
                    <option value="">Please select ...</option>
                    <option value="true">true</option>
                    <option value="false">false</option>
                </select>
<#elseif field.type == "Date">
                <input type="text" class="form-control" th:field="*{${field.fieldName}}" th:errorclass="is-invalid"/>
<#elseif field.type == "Integer">
                <input type="text" class="form-control" th:field="*{${field.fieldName}}" th:errorclass="is-invalid"/>
<#elseif field.type == "Long">
                <input type="text" class="form-control" th:field="*{${field.fieldName}}" th:errorclass="is-invalid"/>
<#elseif field.type == "String">
                <input type="text" class="form-control" th:field="*{${field.fieldName}}" th:errorclass="is-invalid"/>
<#else>
                <select class="form-control" th:field="*{${field.fieldName}Id}" th:errorclass="is-invalid">
                    <option value="">Please select ...</option>
                    <option th:each="${field.fieldName}:${r"${all"}${field.fieldName?cap_first}}" th:value="${r"${"}${field.fieldName}.id}" th:text="${r"${"}${field.fieldName}}"></option>
                </select>
</#if>
            </div>
        </div>
</#list>
        <button type="submit" class="btn btn-primary">Save</button>
    </form>
</main>
<footer th:replace="fragments/footer::footer"></footer>
<#list fields?filter(f -> f.onEdit?? && f.onEdit == "true" && f.type?? && f.type == "Date")>
<script>
<#items as field>
    $("#${field.fieldName}").datepicker({uiLibrary: 'bootstrap4', iconsLibrary: 'fontawesome'});
</#items>
</script>
</#list>
</body>
</html>
