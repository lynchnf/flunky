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
            <td><a th:href="@{/${entityName?uncap_first}Edit(parentId=${r"${"}listForm.parentId})}">Create ${singular}</a></td>
<#else>
            <td><a th:href="@{/${entityName?uncap_first}Edit}">Create ${singular}</a></td>
</#if>
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
<#if parentField??>
        <input type="hidden" name="parentId" th:value="${r"${"}listForm.parentId}"/>
</#if>

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
    <#if field.fieldName == listLinkField>
        <#if field.type == "BigDecimal">
                <td><a th:href="@{/${entityName?uncap_first}(id=${r"${"}row.id})}" th:text="${r"${"}#numbers.formatCurrency(row.${field.fieldName})}"></a></td>
        <#elseif field.type == "Byte" || field.type == "Short" || field.type == "Integer" || field.type == "Long">
                <td><a th:href="@{/${entityName?uncap_first}(id=${r"${"}row.id})}" th:text="${r"${"}#numbers.formatInteger(row.${field.fieldName},1,'DEFAULT')}"></a></td>
        <#elseif field.type == "Date" && field.temporalType?? && field.temporalType="DATE">
                <td><a th:href="@{/${entityName?uncap_first}(id=${r"${"}row.id})}" th:text="${r"${"}#dates.format(row.${field.fieldName},'M/d/yyyy')}"></a></td>
        <#elseif field.type == "Date" && field.temporalType?? && field.temporalType="TIME">
                <td><a th:href="@{/${entityName?uncap_first}(id=${r"${"}row.id})}" th:text="${r"${"}#dates.format(row.${field.fieldName},'h:m a')}"></a></td>
        <#elseif field.type == "Date" && field.temporalType?? && field.temporalType="TIMESTAMP">
                <td><a th:href="@{/${entityName?uncap_first}(id=${r"${"}row.id})}" th:text="${r"${"}#dates.format(row.${field.fieldName},'M/d/yyyy h:m a')}"></a></td>
        <#else>
                <td><a th:href="@{/${entityName?uncap_first}(id=${r"${"}row.id})}" th:text="${r"${"}row.${field.fieldName}}"></a></td>
        </#if>
    <#else>
        <#if field.type == "BigDecimal">
                <td th:text="${r"${"}#numbers.formatCurrency(row.${field.fieldName})}"></td>
        <#elseif field.type == "Byte" || field.type == "Short" || field.type == "Integer" || field.type == "Long">
                <td th:text="${r"${"}#numbers.formatInteger(row.${field.fieldName},1,'DEFAULT')}"></td>
        <#elseif field.type == "Date" && field.temporalType?? && field.temporalType="DATE">
                <td th:text="${r"${"}#dates.format(row.${field.fieldName},'M/d/yyyy')}"></td>
        <#elseif field.type == "Date" && field.temporalType?? && field.temporalType="TIME">
                <td th:text="${r"${"}#dates.format(row.${field.fieldName},'h:m a')}"></td>
        <#elseif field.type == "Date" && field.temporalType?? && field.temporalType="TIMESTAMP">
                <td th:text="${r"${"}#dates.format(row.${field.fieldName},'M/d/yyyy h:m a')}"></td>
        <#else>
                <td th:text="${r"${"}row.${field.fieldName}}"></td>
        </#if>
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
