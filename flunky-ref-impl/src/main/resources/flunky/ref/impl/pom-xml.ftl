<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>${groupId}</groupId>
    <artifactId>${artifactId}</artifactId>
    <version>${version}</version>
    <packaging>war</packaging>

    <name>${artifactId?replace("-", " ")?capitalize}</name>
<#if description??>    <description>${description}</description></#if>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>

        <maven-clean-plugin.version>3.1.0</maven-clean-plugin.version>
        <maven-compiler-plugin.version>3.8.0</maven-compiler-plugin.version>
        <maven-deploy-plugin.version>2.8.2</maven-deploy-plugin.version>
        <maven-install-plugin.version>2.5.2</maven-install-plugin.version>
        <maven-war-plugin.version>3.1.0</maven-war-plugin.version>
        <maven-project-info-reports-plugin.version>3.0.0</maven-project-info-reports-plugin.version>
        <maven-resources-plugin.version>3.0.2</maven-resources-plugin.version>
        <maven-site-plugin.version>3.7.1</maven-site-plugin.version>
        <maven-surefire-plugin.version>2.22.1</maven-surefire-plugin.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <version>3.1.0</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-lang3</artifactId>
            <version>3.12.0</version>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.11</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-core</artifactId>
            <version>4.11.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <finalName>${artifactId}</finalName>
        <pluginManagement>
            <plugins>
                <plugin>
                    <artifactId>maven-clean-plugin</artifactId>
                    <version>${"$"}{maven-clean-plugin.version}</version>
                </plugin>
                <plugin>
                    <artifactId>maven-resources-plugin</artifactId>
                    <version>${"$"}{maven-resources-plugin.version}</version>
                </plugin>
                <plugin>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <version>${"$"}{maven-compiler-plugin.version}</version>
                </plugin>
                <plugin>
                    <artifactId>maven-surefire-plugin</artifactId>
                    <version>${"$"}{maven-surefire-plugin.version}</version>
                </plugin>
                <plugin>
                    <artifactId>maven-war-plugin</artifactId>
                    <version>${"$"}{maven-war-plugin.version}</version>
                </plugin>
                <plugin>
                    <artifactId>maven-install-plugin</artifactId>
                    <version>${"$"}{maven-install-plugin.version}</version>
                </plugin>
                <plugin>
                    <artifactId>maven-deploy-plugin</artifactId>
                    <version>${"$"}{maven-deploy-plugin.version}</version>
                </plugin>
                <plugin>
                    <artifactId>maven-site-plugin</artifactId>
                    <version>${"$"}{maven-site-plugin.version}</version>
                </plugin>
                <plugin>
                    <artifactId>maven-project-info-reports-plugin</artifactId>
                    <version>${"$"}{maven-project-info-reports-plugin.version}</version>
                </plugin>
            </plugins>
        </pluginManagement>
    </build>
</project>
