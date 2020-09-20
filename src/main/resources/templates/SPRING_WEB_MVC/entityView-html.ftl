<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head th:replace="fragments/head::head"></head>
<body>
<header th:replace="fragments/menu::menu"></header>
<main class="container">
    <h1>${singular?capitalize}</h1>
    <div th:replace="fragments/alerts::alerts"></div>


<#list fields as field>
    <div class="form-group row">
        <label class="col-sm-3 col-form-label">${field.description}</label>
        <div class="col-sm-9">
            <p class="form-control-plaintext" th:text="${r"${view."}${field.fieldName}}"></p>
        </div>
    </div>
</#list>

    <a class="btn btn-primary" th:href="@{/${entityName}Edit(id=${r"${view.id})}"}">Edit</a>
</main>
<footer th:replace="fragments/footer::footer"></footer>
</body>
</html>