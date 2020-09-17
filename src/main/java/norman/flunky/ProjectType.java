package norman.flunky;

import java.util.ArrayList;
import java.util.List;

import static norman.flunky.TemplateType.COPY;
import static norman.flunky.TemplateType.GENERATE;

public enum ProjectType {
    SPRING_WEB_MVC;

    ProjectType() {
    }

    public List<GenerationBean> getApplicationGenerationProperties() {
        List<GenerationBean> genBeans = new ArrayList<>();
        genBeans.add(new GenerationBean("alerts.html", "/src/main/resources/templates/fragments/alerts.html", COPY));
        genBeans.add(new GenerationBean("application-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/Application.java", GENERATE));
        genBeans.add(new GenerationBean("application-properties", "/src/main/resources/application.properties", COPY));
        genBeans.add(
                new GenerationBean("bootstrap-4.4.1.min.css", "/src/main/resources/static/css/bootstrap-4.4.1.min.css",
                        COPY));
        genBeans.add(
                new GenerationBean("bootstrap-4.4.1.min.js", "/src/main/resources/static/js/bootstrap-4.4.1.min.js",
                        COPY));
        genBeans.add(new GenerationBean("common.js", "/src/main/resources/static/js/common.js", COPY));
        genBeans.add(new GenerationBean("dashboardController-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/web/DashboardController.java", GENERATE));
        genBeans.add(new GenerationBean("error.html", "/src/main/resources/templates/error.html", COPY));
        genBeans.add(
                new GenerationBean("fa-brands-400.eot", "/src/main/resources/static/webfonts/fa-brands-400.eot", COPY));
        genBeans.add(
                new GenerationBean("fa-brands-400.svg", "/src/main/resources/static/webfonts/fa-brands-400.svg", COPY));
        genBeans.add(
                new GenerationBean("fa-brands-400.ttf", "/src/main/resources/static/webfonts/fa-brands-400.ttf", COPY));
        genBeans.add(new GenerationBean("fa-brands-400.woff", "/src/main/resources/static/webfonts/fa-brands-400.woff",
                COPY));
        genBeans.add(
                new GenerationBean("fa-brands-400.woff2", "/src/main/resources/static/webfonts/fa-brands-400.woff2",
                        COPY));
        genBeans.add(new GenerationBean("fa-regular-400.eot", "/src/main/resources/static/webfonts/fa-regular-400.eot",
                COPY));
        genBeans.add(new GenerationBean("fa-regular-400.svg", "/src/main/resources/static/webfonts/fa-regular-400.svg",
                COPY));
        genBeans.add(new GenerationBean("fa-regular-400.ttf", "/src/main/resources/static/webfonts/fa-regular-400.ttf",
                COPY));
        genBeans.add(
                new GenerationBean("fa-regular-400.woff", "/src/main/resources/static/webfonts/fa-regular-400.woff",
                        COPY));
        genBeans.add(
                new GenerationBean("fa-regular-400.woff2", "/src/main/resources/static/webfonts/fa-regular-400.woff2",
                        COPY));
        genBeans.add(
                new GenerationBean("fa-solid-900.eot", "/src/main/resources/static/webfonts/fa-solid-900.eot", COPY));
        genBeans.add(
                new GenerationBean("fa-solid-900.svg", "/src/main/resources/static/webfonts/fa-solid-900.svg", COPY));
        genBeans.add(
                new GenerationBean("fa-solid-900.ttf", "/src/main/resources/static/webfonts/fa-solid-900.ttf", COPY));
        genBeans.add(
                new GenerationBean("fa-solid-900.woff", "/src/main/resources/static/webfonts/fa-solid-900.woff", COPY));
        genBeans.add(new GenerationBean("fa-solid-900.woff2", "/src/main/resources/static/webfonts/fa-solid-900.woff2",
                COPY));
        genBeans.add(new GenerationBean("fontawesome-free-5.14.0.min.css",
                "/src/main/resources/static/css/fontawesome-free-5.14.0.min.css", COPY));
        genBeans.add(new GenerationBean("footer.html", "/src/main/resources/templates/fragments/footer.html", COPY));
        genBeans.add(
                new GenerationBean("head-html.ftl", "/src/main/resources/templates/fragments/head.html", GENERATE));
        genBeans.add(new GenerationBean("index-html.ftl", "/src/main/resources/templates/index.html", GENERATE));
        genBeans.add(
                new GenerationBean("jquery-3.5.1.min.js", "/src/main/resources/static/js/jquery-3.5.1.min.js", COPY));
        genBeans.add(new GenerationBean("listForm-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/web/view/ListForm.java", GENERATE));
        genBeans.add(new GenerationBean("logback-xml.ftl", "/src/main/resources/logback.xml", GENERATE));
        genBeans.add(new GenerationBean("loggingException-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/LoggingException.java", GENERATE));
        genBeans.add(new GenerationBean("main.css", "/src/main/resources/static/css/main.css", COPY));
        genBeans.add(
                new GenerationBean("menu-html.ftl", "/src/main/resources/templates/fragments/menu.html", GENERATE));
        genBeans.add(new GenerationBean("pom-xml.ftl", "/pom.xml", GENERATE));
        genBeans.add(
                new GenerationBean("popper-1.16.1.min.js", "/src/main/resources/static/js/popper-1.16.1.min.js", COPY));
        return genBeans;
    }

    public List<GenerationBean> getEntityGenerationProperties() {
        List<GenerationBean> genBeans = new ArrayList<>();
        genBeans.add(new GenerationBean("entity-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/${entityName?cap_first}.java",
                GENERATE));
        genBeans.add(new GenerationBean("entityController-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/${entityName?cap_first}Controller.java",
                GENERATE));
        genBeans.add(new GenerationBean("entityList-html.ftl", "/src/main/resources/templates/${entityName}List.html",
                GENERATE));
        genBeans.add(new GenerationBean("entityListForm-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName?cap_first}ListForm.java",
                GENERATE));
        genBeans.add(new GenerationBean("entityListRow-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName?cap_first}ListRow.java",
                GENERATE));
        genBeans.add(new GenerationBean("entityRepository-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/repository/${entityName?cap_first}Repository.java",
                GENERATE));
        genBeans.add(new GenerationBean("entityService-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/service/${entityName?cap_first}Service.java",
                GENERATE));
        return genBeans;
    }
}
