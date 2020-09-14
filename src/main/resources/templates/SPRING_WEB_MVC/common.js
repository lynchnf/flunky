var goToFirstPage = function (event) {
    event.preventDefault();
    event.stopPropagation();
    var listFormId = $(this).attr("data-list-form");
    var oldVal = Number($("#" + listFormId + " .pageNumber").val());
    var newVal = 0;
    console.log("goToFirstPage: changing pageNumber from " + oldVal + " to " + newVal + ".");
    $("#" + listFormId + " .pageNumber").val(newVal);
    $("#" + listFormId).submit();
};

var goToPreviousPage = function (event) {
    event.preventDefault();
    event.stopPropagation();
    var listFormId = $(this).attr("data-list-form");
    var oldVal = Number($("#" + listFormId + " .pageNumber").val());
    var newVal = Number($("#" + listFormId + " .currentPage").val()) - 1;
    console.log("goToPreviousPage: changing pageNumber from " + oldVal + " to " + newVal + ".");
    $("#" + listFormId + " .pageNumber").val(newVal);
    $("#" + listFormId).submit();
};

var goToNextPage = function (event) {
    event.preventDefault();
    event.stopPropagation();
    var listFormId = $(this).attr("data-list-form");
    var oldVal = Number($("#" + listFormId + " .pageNumber").val());
    var newVal = Number($("#" + listFormId + " .currentPage").val()) + 1;
    console.log("goToNextPage: changing pageNumber from " + oldVal + " to " + newVal + ".");
    $("#" + listFormId + " .pageNumber").val(newVal);
    $("#" + listFormId).submit();
};

var goToLastPage = function (event) {
    event.preventDefault();
    event.stopPropagation();
    var listFormId = $(this).attr("data-list-form");
    var oldVal = Number($("#" + listFormId + " .pageNumber").val());
    var newVal = Number($("#" + listFormId + " .totalPages").val()) - 1;
    console.log("goToLastPage: changing pageNumber from " + oldVal + " to " + newVal + ".");
    $("#" + listFormId + " .pageNumber").val(newVal);
    $("#" + listFormId).submit();
};

var changePageSize = function (event) {
    var listFormId = $(this).attr("data-list-form");
    console.log("changePageSize: resetting pageNumber to 0.");
    $("#" + listFormId + " .pageNumber").val(0);
    var oldVal = Number($("#" + listFormId + " .pageSize").val());
    var newVal = Number($(this).val());
    console.log("changePageSize: changing pageSize from " + oldVal + " to " + newVal + ".");
    $("#" + listFormId + " .pageSize").val(newVal);
    $("#" + listFormId).submit();
};

var changeSort = function (event) {
    event.preventDefault();
    event.stopPropagation();
    var listFormId = $(this).attr("data-list-form");
    console.log("changePageSize: resetting pageNumber to 0.");
    $("#" + listFormId + " .pageNumber").val(0);
    var oldCol = $("#" + listFormId + " .sortColumn").val();
    var oldDir = $("#" + listFormId + " .sortDirection").val();
    var newCol = $(this).attr("data-sort-column");
    if (newCol == oldCol) {
        var newDir = "DESC";
        if (oldDir == "DESC") {
            newDir = "ASC";
        }
        console.log("changeSort: changing sortDirection from " + oldDir + " to " + newDir + ".");
        $("#" + listFormId + " .sortDirection").val(newDir);
    } else {
        console.log("changeSort: resetting sortDirection to ASC.");
        $("#" + listFormId + " .sortDirection").val("ASC");
        console.log("changeSort: changing sortColumn from " + oldCol + " to " + newCol + ".");
        $("#" + listFormId + " .sortColumn").val(newCol);
    }
    $("#" + listFormId).submit();
};

$(document).ready(function () {
    $(".goToFirstPage").on("click", goToFirstPage);
    $(".goToPreviousPage").on("click", goToPreviousPage);
    $(".goToNextPage").on("click", goToNextPage);
    $(".goToLastPage").on("click", goToLastPage);
    $(".changePageSize").on("change", changePageSize);
    $(".changeSort").on("click", changeSort);
});
