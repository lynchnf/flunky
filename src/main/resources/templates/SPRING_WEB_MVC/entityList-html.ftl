<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head th:replace="fragments/head::head"></head>
<body>
<header th:replace="fragments/menu::menu"></header>
<main class="container">
    <h1>${plural?capitalize}</h1>
    <div th:replace="fragments/alerts::alerts"></div>

    <form id="listForm" action="#" method="get" th:action="@{/${entityName}List}">
        <input type="hidden" class="pageNumber" name="pageNumber" th:value="${r"${listForm.number}"}"/>
        <input type="hidden" class="pageSize" name="pageSize" th:value="${r"${listForm.size}"}"/>
        <input type="hidden" class="sortColumn" name="sortColumn" th:value="${r"${listForm.sortColumn}"}"/>
        <input type="hidden" class="sortDirection" name="sortDirection" th:value="${r"${listForm.sortDirection}"}"/>
        <input type="hidden" class="currentPage" th:value="${r"${listForm.number}"}"/>
        <input type="hidden" class="totalPages" th:value="${r"${listForm.totalPages}"}"/>

        <span th:if="${r"${listForm.hasPrevious()}"}">
            <a class="goToFirstPage" data-list-form="listForm" href="#"><i class="fas fa-angle-double-left"></i></a>
            &nbsp;
            <a class="goToPreviousPage" data-list-form="listForm" href="#"><i class="fas fa-angle-left"></i></a>
            &nbsp;
        </span>

        page <span th:text="${r"${listForm.number}"}+1"></span> of <span th:text="${r"${listForm.totalPages}"}"></span>

        <span th:if="${r"${listForm.hasNext()}"}">
            &nbsp;
            <a class="goToNextPage" data-list-form="listForm" href="#"><i class="fas fa-angle-right"></i></a>
            &nbsp;
            <a class="goToLastPage" data-list-form="listForm" href="#"><i class="fas fa-angle-double-right"></i></a>
        </span>

        &nbsp;&nbsp;&nbsp;
        page size
        <select class="changePageSize" data-list-form="listForm">
            <option value="5" th:selected="${r"${listForm.size}"}==5">5</option>
            <option value="10" th:selected="${r"${listForm.size}"}==10">10</option>
            <option value="20" th:selected="${r"${listForm.size}"}==20">20</option>
            <option value="50" th:selected="${r"${listForm.size}"}==50">50</option>
        </select>

        <table class="table table-sm table-striped">
            <thead>
            <tr>
<#list fields?filter(f -> f.onList?? && f.onList == "true") as field>
<#if field.sortable?? && field.sortable == "true">
                <th>
                    <a class="changeSort" data-list-form="listForm" data-sort-column="${field.fieldName}" href="#">
                        ${field.label?capitalize}
                        <span th:if="${r"${listForm.sortColumn"}=='${field.fieldName}'}">
                            <span th:if="${r"${listForm.ascending}"}"><i class="fas fa-caret-up"></i></span>
                            <span th:if="${r"${listForm.descending}"}"><i class="fas fa-caret-down"></i></span>
                        </span>
                    </a>
                </th>
<#else>
                <th>${field.label?capitalize}</th>
</#if>
</#list>
            </tr>
            </thead>
            <tbody>
            <tr th:each="row:${r"${listForm.rows}"}">
<#list fields?filter(f -> f.onList?? && f.onList == "true") as field>
<#if field.fieldName == mainField>
<#if field.type == "BigDecimal">
                <td><a th:href="@{/${entityName}(id=${r"${row.id}"})}" th:text="${r"${#numbers.formatCurrency(row."}${field.fieldName})}"></a></td>
<#elseif field.type == "Boolean">
                <td><a th:href="@{/${entityName}(id=${r"${row.id}"})}" th:text="${r"${row."}${field.fieldName}}"></a></td>
<#elseif field.temporal?? && field.temporal="DATE">
                <td><a th:href="@{/${entityName}(id=${r"${row.id}"})}" th:text="${r"${#dates.format(row."}${field.fieldName},'M/d/yyyy')}"></a></td>
<#elseif field.temporal?? && field.temporal="TIME">
                <td><a th:href="@{/${entityName}(id=${r"${row.id}"})}" th:text="${r"${#dates.format(row."}${field.fieldName},'H:m:s')}"></a></td>
<#elseif field.temporal?? && field.temporal="TIMESTAMP">
                <td><a th:href="@{/${entityName}(id=${r"${row.id}"})}" th:text="${r"${#dates.format(row."}${field.fieldName},'M/d/yyyy H:m:s')}"></a></td>
<#elseif field.type == "Integer">
                <td><a th:href="@{/${entityName}(id=${r"${row.id}"})}" th:text="${r"${#numbers.formatInteger(row."}${field.fieldName},1,'DEFAULT')}"></a></td>
<#elseif field.type == "Long">
                <td><a th:href="@{/${entityName}(id=${r"${row.id}"})}" th:text="${r"${#numbers.formatInteger(row."}${field.fieldName},1,'DEFAULT')}"></a></td>
<#elseif field.type == "String">
                <td><a th:href="@{/${entityName}(id=${r"${row.id}"})}" th:text="${r"${row."}${field.fieldName}}"></a></td>
<#else>
                <td><a th:href="@{/${entityName}(id=${r"${row.id}"})}"
                       th:text="${r"${(row."}${field.fieldName} != null)?row.${field.fieldName}.id:null}"></a></td>
</#if>
<#else>
<#if field.type == "BigDecimal">
                <td th:text="${r"${#numbers.formatCurrency(row."}${field.fieldName})}"></td>
<#elseif field.type == "Boolean">
                <td th:text="${r"${row."}${field.fieldName}}"></td>
<#elseif field.temporal?? && field.temporal="DATE">
                <td th:text="${r"${#dates.format(row."}${field.fieldName},'M/d/yyyy')}"></td>
<#elseif field.temporal?? && field.temporal="TIME">
                <td th:text="${r"${#dates.format(row."}${field.fieldName},'H:m:s')}"></td>
<#elseif field.temporal?? && field.temporal="TIMESTAMP">
                <td th:text="${r"${#dates.format(row."}${field.fieldName},'M/d/yyyy H:m:s')}"></td>
<#elseif field.type == "Integer">
                <td th:text="${r"${#numbers.formatInteger(row."}${field.fieldName},1,'DEFAULT')}"></td>
<#elseif field.type == "Long">
                <td th:text="${r"${#numbers.formatInteger(row."}${field.fieldName},1,'DEFAULT')}"></td>
<#elseif field.type == "String">
                <td th:text="${r"${row."}${field.fieldName}}"></td>
<#else>
                <td th:text="${r"${row."}${field.fieldName}}"></td>
</#if>
</#if>
</#list>
            </tr>
            </tbody>
        </table>
    </form>
</main>
<footer th:replace="fragments/footer::footer"></footer>
</body>
</html>
