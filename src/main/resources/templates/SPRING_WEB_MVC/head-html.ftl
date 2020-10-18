<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head th:fragment="head">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="css/bootstrap-4.4.1.min.css">
    <link rel="stylesheet" href="css/fontawesome-free-5.14.0.min.css">
    <link rel="stylesheet" href="css/gijgo-1.9.13.min.css">
    <link rel="stylesheet" href="css/main.css">
    <title>${artifactId?replace("-", " ")?capitalize}</title>
</head>
</html>
