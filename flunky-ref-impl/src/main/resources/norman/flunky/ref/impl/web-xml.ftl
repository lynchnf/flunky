<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">
<#list entities as entity>
    <servlet>
        <servlet-name>${entity.entityName}ListLoader</servlet-name>
        <servlet-class>${basePackage}.${entity.entityName}ListLoader</servlet-class>
    </servlet>
    <servlet>
        <servlet-name>${entity.entityName}ViewLoader</servlet-name>
        <servlet-class>${basePackage}.${entity.entityName}ViewLoader</servlet-class>
    </servlet>
    <servlet>
        <servlet-name>${entity.entityName}EditLoader</servlet-name>
        <servlet-class>${basePackage}.${entity.entityName}EditLoader</servlet-class>
    </servlet>
    <servlet>
        <servlet-name>${entity.entityName}EditProcessor</servlet-name>
        <servlet-class>${basePackage}.${entity.entityName}EditProcessor</servlet-class>
    </servlet>
    <servlet>
        <servlet-name>${entity.entityName}DeleteProcessor</servlet-name>
        <servlet-class>${basePackage}.${entity.entityName}DeleteProcessor</servlet-class>
    </servlet>
</#list>
<#list entities as entity>
    <servlet-mapping>
        <servlet-name>${entity.entityName}ListLoader</servlet-name>
        <url-pattern>/${entity.entityName?uncap_first}ListLoader</url-pattern>
    </servlet-mapping>
    <servlet-mapping>
        <servlet-name>${entity.entityName}ViewLoader</servlet-name>
        <url-pattern>/${entity.entityName?uncap_first}ViewLoader</url-pattern>
    </servlet-mapping>
    <servlet-mapping>
        <servlet-name>${entity.entityName}EditLoader</servlet-name>
        <url-pattern>/${entity.entityName?uncap_first}EditLoader</url-pattern>
    </servlet-mapping>
    <servlet-mapping>
        <servlet-name>${entity.entityName}EditProcessor</servlet-name>
        <url-pattern>/${entity.entityName?uncap_first}EditProcessor</url-pattern>
    </servlet-mapping>
    <servlet-mapping>
        <servlet-name>${entity.entityName}DeleteProcessor</servlet-name>
        <url-pattern>/${entity.entityName?uncap_first}DeleteProcessor</url-pattern>
    </servlet-mapping>
</#list>
</web-app>
