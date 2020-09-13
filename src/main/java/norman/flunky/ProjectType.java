package norman.flunky;

import java.util.ArrayList;
import java.util.List;

public enum ProjectType {
    SPRING_WEB_MVC;

    ProjectType() {
    }

    public List<GenerationBean> getApplicationGenerationProperties() {
        List<GenerationBean> genBeans = new ArrayList<>();
        genBeans.add(new GenerationBean("application-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/Application.java"));
        genBeans.add(new GenerationBean("application-properties.ftl", "/src/main/resources/application.properties"));
        genBeans.add(new GenerationBean("dashboardController-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/web/DashboardController.java"));
        genBeans.add(new GenerationBean("index-html.ftl", "/src/main/resources/templates/index.html"));
        genBeans.add(new GenerationBean("listForm-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/web/view/ListForm.java"));
        genBeans.add(new GenerationBean("logback-xml.ftl", "/src/main/resources/logback.xml"));
        genBeans.add(new GenerationBean("loggingException-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/LoggingException.java"));
        genBeans.add(new GenerationBean("pom-xml.ftl", "/pom.xml"));
        return genBeans;
    }

    public List<GenerationBean> getEntityGenerationProperties() {
        List<GenerationBean> genBeans = new ArrayList<>();
        genBeans.add(new GenerationBean("entity-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/${entityName}.java"));
        genBeans.add(new GenerationBean("entityController-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/${entityName}Controller.java"));
        genBeans.add(new GenerationBean("entityListForm-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}ListForm.java"));
        genBeans.add(new GenerationBean("entityRepository-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/repository/${entityName}Repository.java"));
        genBeans.add(new GenerationBean("entityService-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/service/${entityName}Service.java"));
        genBeans.add(new GenerationBean("entityView-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}View.java"));
        return genBeans;
    }
}
