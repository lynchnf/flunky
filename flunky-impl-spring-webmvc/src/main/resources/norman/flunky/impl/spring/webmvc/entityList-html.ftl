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
            <td><a th:href="@{/${entityName?uncap_first}Edit}">Create ${singular}</a></td>
            <td>
                <small>Version</small>
                <small th:text="${r"#{"}application.version}"></small>
            </td>
        </tr>
    </table>
</header>
<main>
    <h1>${plural}</h1>
    <div>
        <ul class="success-message" th:if="${r"${"}successMessage}">
            <li th:text="${r"${"}successMessage}"></li>
        </ul>
        <ul class="error-message" th:if="${r"${"}errorMessage}">
            <li th:text="${r"${"}errorMessage}"></li>
        </ul>
    </div>

    <form id="listForm" action="#" method="get" th:action="@{/${entityName?uncap_first}List}">
        <input type="hidden" class="pageNumber" name="pageNumber" th:value="${r"${"}listForm.number}"/>
        <input type="hidden" class="pageSize" name="pageSize" th:value="${r"${"}listForm.size}"/>
        <input type="hidden" class="sortColumn" name="sortColumn" th:value="${r"${"}listForm.sortColumn}"/>
        <input type="hidden" class="sortDirection" name="sortDirection" th:value="${r"${"}listForm.sortDirection}"/>
        <input type="hidden" class="currentPage" th:value="${r"${"}listForm.number}"/>
        <input type="hidden" class="totalPages" th:value="${r"${"}listForm.totalPages}"/>

        <span th:if="${r"${"}listForm.hasPrevious()}">
            <a class="goToFirstPage" data-list-form="listForm" href="#">&lt;&lt;</a>
            &nbsp;
            <a class="goToPreviousPage" data-list-form="listForm" href="#">&lt;</a>
            &nbsp;
        </span>

        page <span th:text="${r"${"}listForm.number}+1"></span> of <span th:text="${r"${"}listForm.totalPages}"></span>

        <span th:if="${r"${"}listForm.hasNext()}">
            &nbsp;
            <a class="goToNextPage" data-list-form="listForm" href="#">&gt;</a>
            &nbsp;
            <a class="goToLastPage" data-list-form="listForm" href="#">&gt;&gt;</a>
        </span>

        &nbsp;&nbsp;&nbsp;
        page size
        <select class="changePageSize" data-list-form="listForm">
            <option value="5" th:selected="${r"${"}listForm.size}==5">5</option>
            <option value="10" th:selected="${r"${"}listForm.size}==10">10</option>
            <option value="20" th:selected="${r"${"}listForm.size}==20">20</option>
            <option value="50" th:selected="${r"${"}listForm.size}==50">50</option>
        </select>

        <table>
            <tr>
<#list fields?filter(f -> !f.listDisplay?? || f.listDisplay != "hide") as field>
    <#if field.listDisplay?? && field.listDisplay == "sort">
                <th>
                    <a class="changeSort" data-list-form="listForm" data-sort-column="${field.fieldName}" href="#">
                        ${field.label?capitalize}
                        <span th:if="${r"${"}listForm.sortColumn=='${field.fieldName}'}">
                            <span th:if="${r"${"}listForm.ascending}">&and;</span>
                            <span th:if="${r"${"}listForm.descending}">&or;</span>
                        </span>
                    </a>
                </th>
    <#else>
                <th>${field.label}</th>
    </#if>
</#list>
            </tr>
            <tr th:each="row:${r"${"}listForm.rows}">
<#list fields?filter(f -> !f.listDisplay?? || f.listDisplay != "hide") as field>
                    <#if field.fieldName == mainField>
                <td><a th:href="@{/${entityName?uncap_first}(id=${r"${"}row.id})}" th:text="${r"${"}row.${field.fieldName}}"></a></td>
    <#else>
                <td th:text="${r"${"}row.${field.fieldName}}"></td>
    </#if>
</#list>
            </tr>
        </table>
    </form>
</main>
<footer>
    <script src="js/jquery-3.5.1.min.js"></script>
    <script src="js/common.js"></script>
</footer>
</body>
</html>
