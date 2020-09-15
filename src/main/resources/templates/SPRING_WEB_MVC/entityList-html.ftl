<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head th:replace="fragments/head::head"></head>
<body>
<header th:replace="fragments/menu::menu"></header>
<main class="container">
    <h1>${singular?capitalize} List</h1>
    <div th:replace="fragments/alerts::alerts"></div>
    <form id="listForm" action="#" method="get" th:action="@{/acctList}">
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
    </form>
</main>
<footer th:replace="fragments/footer::footer"></footer>
</body>
</html>