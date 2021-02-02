<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head th:replace="fragments/head::head"></head>
<body>
<header th:replace="fragments/menu::menu"></header>
<main class="container">
    <h1>${singular?capitalize} Edit</h1>
    <div th:replace="fragments/alerts::alerts"></div>

    <form action="#" method="post" th:action="@{/${entityName}Edit}" th:object="${r"${"}editForm}">
        <ul class="alert alert-danger" th:if="${r"${"}#fields.hasAnyErrors()}">
            <li th:each="err:${r"${"}#fields.allErrors()}" th:text="${r"${"}err}"></li>
        </ul>
        <input type="hidden" th:field="*{id}"/>
        <input type="hidden" th:field="*{version}"/>
<#list fields?filter(f -> f.onEdit == "hidden" || f.onEdit == "view") as field>
        <input type="hidden" th:field="*{${field.fieldName}}"/>
</#list>

<#list fields?filter(f -> f.onEdit == "edit" || f.onEdit == "view") as field>
        <div class="form-group row">
            <label class="col-sm-3 col-form-label">${field.label?capitalize}<#if field.temporal?? && field.temporal="DATE"> (m/d/y)<#elseif field.temporal?? && field.temporal="TIME"> (h:m am/pm)<#elseif field.temporal?? && field.temporal="TIMESTAMP"> (m/d/y h:m am/pm)</#if></label>
<#if field.onEdit == "edit">
<#if field.type == "Boolean">
            <div class="col-sm-9">
                <select class="form-control" th:field="*{${field.fieldName}}" th:errorclass="is-invalid">
                    <option value="">Please select ...</option>
                    <option value="true">true</option>
                    <option value="false">false</option>
                </select>
            </div>
<#elseif field.temporal?? && field.temporal="DATE">
            <div class="input-group date col-sm-9" id="${field.fieldName}Picker" data-target-input="nearest">
                <input type="text" class="form-control datetimepicker-input" data-target="#${field.fieldName}Picker"
                       th:field="*{${field.fieldName}}" th:errorclass="is-invalid"/>
                <div class="input-group-append" data-target="#${field.fieldName}Picker" data-toggle="datetimepicker">
                    <div class="input-group-text"><i class="fas fa-calendar"></i></div>
                </div>
            </div>
<#elseif field.temporal?? && field.temporal="TIME">
            <div class="input-group date col-sm-9" id="${field.fieldName}Picker" data-target-input="nearest">
                <input type="text" class="form-control datetimepicker-input" data-target="#${field.fieldName}Picker"
                       th:field="*{${field.fieldName}}" th:errorclass="is-invalid"/>
                <div class="input-group-append" data-target="#${field.fieldName}Picker" data-toggle="datetimepicker">
                    <div class="input-group-text"><i class="fas fa-clock"></i></div>
                </div>
            </div>
<#elseif field.temporal?? && field.temporal="TIMESTAMP">
            <div class="input-group date col-sm-9" id="${field.fieldName}Picker" data-target-input="nearest">
                <input type="text" class="form-control datetimepicker-input" data-target="#${field.fieldName}Picker"
                       th:field="*{${field.fieldName}}" th:errorclass="is-invalid"/>
                <div class="input-group-append" data-target="#${field.fieldName}Picker" data-toggle="datetimepicker">
                    <div class="input-group-text"><i class="fas fa-calendar"></i></div>
                </div>
            </div>
<#elseif field.enumerated??>
            <div class="col-sm-9">
                <select class="form-control" th:field="*{${field.fieldName}}" th:errorclass="is-invalid">
                    <option value="">Please select ...</option>
                    <option th:each="value:${r"${T("}${application.basePackage}.domain.${field.type}).values()}"
                            th:value="${r"${value}"}" th:text="${r"${value}"}"></option>
                </select>
            </div>
<#elseif field.joinColumn??>
            <div class="col-sm-9">
                <select class="form-control" th:field="*{${field.fieldName}Id}" th:errorclass="is-invalid">
                    <option value="">Please select ...</option>
                    <option th:each="${field.fieldName}:${r"${all"}${field.fieldName?cap_first}}" th:value="${r"${"}${field.fieldName}.id}" th:text="${r"${"}${field.fieldName}}"></option>
                </select>
            </div>
<#else>
            <div class="col-sm-9">
                <input type="text" class="form-control" th:field="*{${field.fieldName}}" th:errorclass="is-invalid"/>
            </div>
</#if>
<#else>
            <div class="col-sm-9">
<#if field.type == "BigDecimal">
                <p class="form-control-plaintext" th:text="${r"${#numbers.formatCurrency(editForm."}${field.fieldName})}"></p>
<#elseif field.temporal?? && field.temporal="DATE">
                <p class="form-control-plaintext" th:text="${r"${#dates.format(editForm."}${field.fieldName},'M/d/yyyy')}"></p>
<#elseif field.temporal?? && field.temporal="TIME">
                <p class="form-control-plaintext" th:text="${r"${#dates.format(editForm."}${field.fieldName},'h:m a')}"></p>
<#elseif field.temporal?? && field.temporal="TIMESTAMP">
                <p class="form-control-plaintext" th:text="${r"${#dates.format(editForm."}${field.fieldName},'M/d/yyyy h:m a')}"></p>
<#elseif field.type == "Integer" || field.type == "Long">
                <p class="form-control-plaintext" th:text="${r"${#numbers.formatInteger(editForm."}${field.fieldName},1,'DEFAULT')}"></p>
<#else>
                <p class="form-control-plaintext" th:text="${r"${editForm."}${field.fieldName}}"></p>
</#if>
            </div>
</#if>
        </div>
</#list>

        <button type="submit" class="btn btn-primary">Save</button>
    </form>
</main>
<footer th:replace="fragments/footer::footer"></footer>
<#list fields?filter(f -> f.onEdit?? && f.onEdit == "edit" && f.temporal??)>
<script>
<#items as field>
<#if field.temporal="DATE">
    $("#${field.fieldName}Picker").datetimepicker({
        icons: {
            time: "fas fa-clock",
            date: "fas fa-calendar",
            up: "fas fa-arrow-up",
            down: "fas fa-arrow-down"
        },
        format: "L"
    });
<#elseif field.temporal="TIME">
    $("#${field.fieldName}Picker").datetimepicker({
        icons: {
            time: "fas fa-clock",
            date: "fas fa-calendar",
            up: "fas fa-arrow-up",
            down: "fas fa-arrow-down"
        },
        format: "LT"
    });
<#elseif field.temporal="TIMESTAMP">
    $("#${field.fieldName}Picker").datetimepicker({
        icons: {
            time: "fas fa-clock",
            date: "fas fa-calendar",
            up: "fas fa-arrow-up",
            down: "fas fa-arrow-down"
        }
    });
</#if>
</#items>
</script>
</#list>
</body>
</html>