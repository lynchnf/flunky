<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head th:replace="fragments/head::head"></head>
<body>
<header th:replace="fragments/menu::menu"></header>
<main class="container-fluid">
    <h1>${artifactId?replace("-", " ")?capitalize}</h1>
    <div th:replace="fragments/alerts::alerts"></div>

    <div class="row">
        <div class="col-md-6">
            <p>Content goes here.</p>
            <p>And here.</p>
        </div>
    </div>
</main>
<footer th:replace="fragments/footer::footer"></footer>
</body>
</html>
