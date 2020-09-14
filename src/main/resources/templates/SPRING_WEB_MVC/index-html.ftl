<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <title>${artifactId?replace("-", " ")?capitalize}</title>
</head>
<body>
<header></header>
<main>
    <h1>${artifactId?replace("-", " ")?capitalize}</h1>
    <div></div>
    <ul>
        <li>Content goes here.</li>
        <li>And here.</li>
    </ul>
</main>
<footer></footer>
</body>
</html>
