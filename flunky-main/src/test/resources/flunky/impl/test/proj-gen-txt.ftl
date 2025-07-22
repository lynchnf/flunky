Title is ${artifactId?replace("-", " ")?capitalize}
<#list entities as entity>
Entity is ${entity.entityName} ${entity.otherEntProp}
</#list>
