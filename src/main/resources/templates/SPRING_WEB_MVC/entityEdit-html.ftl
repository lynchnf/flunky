<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head th:replace="fragments/head::head"></head>
<body>
<header th:replace="fragments/menu::menu"></header>
<main class="container">
    <h1>${singular?capitalize} Edit</h1>
    <div th:replace="fragments/alerts::alerts"></div>
    <form th:action="@{/${entityName}Edit}" th:object="${r"${"}${entityName}Form}" method="post">
        <ul class="alert alert-danger" th:if="${r"${"}#fields.hasAnyErrors()}">
            <li th:each="err:${r"${"}#fields.allErrors()}" th:text="${r"${"}err}"></li>
        </ul>
        <input type="hidden" th:field="*{id}"/>
        <input type="hidden" th:field="*{version}"/>

        <div th:if="${r"${"}${entityName}Form.id}!=null" class="form-group row">
            <label class="col-sm-3 col-form-label">Id</label>
            <div class="col-sm-9">
                <p class="form-control-plaintext" th:text="${r"${"}${entityName}Form.id}"></p>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-3 col-form-label">Name</label>
            <div class="col-sm-9">
                <input type="text" class="form-control" th:field="*{name}" th:errorclass="is-invalid"/>
            </div>
        </div>
        <button type="submit" class="btn btn-primary">Save</button>
    </form>
</main>
<footer th:replace="fragments/footer::footer"></footer>
</body>
</html>
