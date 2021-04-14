<html>
<head>
    <title>${artifactId?replace("-", " ")?capitalize}</title>
</head>
<body>
<h1>${artifactId?replace("-", " ")?capitalize} - Home</h1>
<ul>
<#list entities as entity>
    <li><a href="${entity.entityName?uncap_first}ListLoader">${entity.singular} List</a></li>
</#list>
</ul>
</body>
</html>
