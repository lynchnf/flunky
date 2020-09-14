<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head th:replace="fragments/head::head"></head>
<body>
<header th:replace="fragments/menu::menu"></header>
<main class="container">
    <h1>${singular?capitalize} List</h1>
    <div th:replace="fragments/alerts::alerts"></div>
    <form id="listForm" action="#" method="get" th:action="@{/acctList}">
        <input type="hidden" class="pageNumber" name="pageNumber" th:value="${listForm.number}"/>
        <input type="hidden" class="pageSize" name="pageSize" th:value="${listForm.size}"/>
        <input type="hidden" class="sortColumn" name="sortColumn" th:value="${listForm.sortColumn}"/>
        <input type="hidden" class="sortDirection" name="sortDirection" th:value="${listForm.sortDirection}"/>
        <input type="hidden" class="currentPage" th:value="${listForm.number}"/>
        <input type="hidden" class="totalPages" th:value="${listForm.totalPages}"/>

        <span th:if="${listForm.hasPrevious()}">
            <a class="goToFirstPage" data-list-form="listForm" href="#"><i class="fas fa-angle-double-left"></i></a>
            &nbsp;
            <a class="goToPreviousPage" data-list-form="listForm" href="#"><i class="fas fa-angle-left"></i></a>
            &nbsp;
        </span>

        page <span th:text="${listForm.number}+1"></span> of <span th:text="${listForm.totalPages}"></span>

        <span th:if="${listForm.hasNext()}">
            &nbsp;
            <a class="goToNextPage" data-list-form="listForm" href="#"><i class="fas fa-angle-right"></i></a>
            &nbsp;
            <a class="goToLastPage" data-list-form="listForm" href="#"><i class="fas fa-angle-double-right"></i></a>
        </span>

        &nbsp;&nbsp;&nbsp;
        page size
        <select class="changePageSize" data-list-form="listForm">
            <option value="5" th:selected="${listForm.size}==5">5</option>
            <option value="10" th:selected="${listForm.size}==10">10</option>
            <option value="20" th:selected="${listForm.size}==20">20</option>
            <option value="50" th:selected="${listForm.size}==50">50</option>
        </select>
    </form>
</main>
<footer th:replace="fragments/footer::footer"></footer>
</body>
</html>