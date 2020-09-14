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
        genBeans.add(new GenerationBean("application-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/Application.java", GENERATE));
        genBeans.add(new GenerationBean("application-properties", "/src/main/resources/application.properties", COPY));
        genBeans.add(
                new GenerationBean("bootstrap-4.4.1.min.css", "/src/main/resources/static/css/bootstrap-4.4.1.min.css",
                        COPY));
        genBeans.add(
                new GenerationBean("bootstrap-4.4.1.min.js", "/src/main/resources/static/js/bootstrap-4.4.1.min.js",
                        COPY));
        genBeans.add(new GenerationBean("dashboardController-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/web/DashboardController.java", GENERATE));
        genBeans.add(new GenerationBean("fontawesome-free-5.14.0.min.css",
                "/src/main/resources/static/css/fontawesome-free-5.14.0.min.css", COPY));
        genBeans.add(new GenerationBean("index-html.ftl", "/src/main/resources/templates/index.html", GENERATE));
        genBeans.add(new GenerationBean("listForm-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/web/view/ListForm.java", GENERATE));
        genBeans.add(new GenerationBean("logback-xml.ftl", "/src/main/resources/logback.xml", GENERATE));
        genBeans.add(new GenerationBean("loggingException-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/LoggingException.java", GENERATE));
        genBeans.add(new GenerationBean("pom-xml.ftl", "/pom.xml", GENERATE));
        return genBeans;
    }

    public List<GenerationBean> getEntityGenerationProperties() {
        List<GenerationBean> genBeans = new ArrayList<>();
        genBeans.add(new GenerationBean("entity-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/${entityName}.java", GENERATE));
        genBeans.add(new GenerationBean("entityController-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/${entityName}Controller.java",
                GENERATE));
        genBeans.add(new GenerationBean("entityListForm-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}ListForm.java",
                GENERATE));
        genBeans.add(new GenerationBean("entityRepository-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/repository/${entityName}Repository.java",
                GENERATE));
        genBeans.add(new GenerationBean("entityService-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/service/${entityName}Service.java",
                GENERATE));
        genBeans.add(new GenerationBean("entityView-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}View.java",
                GENERATE));
        return genBeans;
    }
}
