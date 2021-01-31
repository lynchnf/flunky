<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head th:replace="fragments/head::head"></head>
<body>
<header th:fragment="menu">
    <nav class="navbar navbar-expand-md navbar-dark bg-dark">
        <a class="navbar-brand" th:href="@{/}">
            <img src="images/logo.png" class="img-fluid" alt="Home">
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarMain"
                aria-controls="navbarMain" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarMain">
            <ul class="navbar-nav mr-auto">
<#list entities?filter(e -> e.onMenu?? && e.onMenu == "true") as entity>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" data-toggle="dropdown">${entity.plural?capitalize}</a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" th:href="@{/${entity.entityName}List}">${entity.singular?capitalize} List</a>
                        <a class="dropdown-item" th:href="@{/${entity.entityName}Edit}">Add ${entity.singular?capitalize}</a>
                    </div>
                </li>
</#list>
                <li class="d-md-none">
                    <small class="text-light">Version:</small>
                    <small class="text-light" th:text="${r"#{application.version}"}"></small>
                </li>
            </ul>
        </div>
        <div class="d-none d-md-block">
            <small class="text-light">Version:</small>
            <small class="text-light" th:text="${r"#{application.version}"}"></small>
        </div>
    </nav>
</header>
<footer th:replace="fragments/footer::footer"></footer>
</body>
</html>
