package norman.flunky.spring.web.mvc;

import norman.flunky.api.GenerationBean;
import norman.flunky.api.ProjectType;
import norman.flunky.api.TemplateType;

import java.util.ArrayList;
import java.util.List;

public class SpringWebMvcProjectType implements ProjectType {
    private List<GenerationBean> applicationGenerationProperties = new ArrayList<>();
    private List<GenerationBean> enumGenerationProperties = new ArrayList<>();
    private List<GenerationBean> entityGenerationProperties = new ArrayList<>();

    public SpringWebMvcProjectType() {
        applicationGenerationProperties.add(new GenerationBean(".gitignore", "/.gitignore", TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("alerts.html", "/src/main/resources/templates/fragments/alerts.html",
                        TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("application-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/Application.java", TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("application-properties", "/src/main/resources/application.properties",
                        TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("bootstrap-4.4.1.min.css",
                "/src/main/resources/static/css/bootstrap-4.4.1.min.css", TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("bootstrap-4.4.1.min.js",
                "/src/main/resources/static/js/bootstrap-4.4.1.min.js", TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("common.js", "/src/main/resources/static/js/common.js", TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("dashboardController-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/web/DashboardController.java",
                TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("error.html", "/src/main/resources/templates/error.html", TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("fa-brands-400.eot", "/src/main/resources/static/webfonts/fa-brands-400.eot",
                        TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("fa-brands-400.svg", "/src/main/resources/static/webfonts/fa-brands-400.svg",
                        TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("fa-brands-400.ttf", "/src/main/resources/static/webfonts/fa-brands-400.ttf",
                        TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("fa-brands-400.woff", "/src/main/resources/static/webfonts/fa-brands-400.woff",
                        TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("fa-brands-400.woff2",
                "/src/main/resources/static/webfonts/fa-brands-400.woff2", TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("fa-regular-400.eot", "/src/main/resources/static/webfonts/fa-regular-400.eot",
                        TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("fa-regular-400.svg", "/src/main/resources/static/webfonts/fa-regular-400.svg",
                        TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("fa-regular-400.ttf", "/src/main/resources/static/webfonts/fa-regular-400.ttf",
                        TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("fa-regular-400.woff",
                "/src/main/resources/static/webfonts/fa-regular-400.woff", TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("fa-regular-400.woff2",
                "/src/main/resources/static/webfonts/fa-regular-400.woff2", TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("fa-solid-900.eot", "/src/main/resources/static/webfonts/fa-solid-900.eot",
                        TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("fa-solid-900.svg", "/src/main/resources/static/webfonts/fa-solid-900.svg",
                        TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("fa-solid-900.ttf", "/src/main/resources/static/webfonts/fa-solid-900.ttf",
                        TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("fa-solid-900.woff", "/src/main/resources/static/webfonts/fa-solid-900.woff",
                        TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("fa-solid-900.woff2", "/src/main/resources/static/webfonts/fa-solid-900.woff2",
                        TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("fakeDataUtil-java.ftl",
                "/src/test/java/${basePackage?replace(\".\", \"/\")}/FakeDataUtil.java", TemplateType.GENERATE));
        applicationGenerationProperties.add(new GenerationBean("fontawesome-free-5.14.0.min.css",
                "/src/main/resources/static/css/fontawesome-free-5.14.0.min.css", TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("footer.html", "/src/main/resources/templates/fragments/footer.html",
                        TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("head-html.ftl", "/src/main/resources/templates/fragments/head.html",
                        TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("index-html.ftl", "/src/main/resources/templates/index.html",
                        TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("jquery-3.5.1.min.js", "/src/main/resources/static/js/jquery-3.5.1.min.js",
                        TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("listForm-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/web/view/ListForm.java", TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("logback-xml.ftl", "/src/main/resources/logback.xml", TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("logo.png", "/src/main/resources/static/images/logo.png", TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("main.css", "/src/main/resources/static/css/main.css", TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("menu-html.ftl", "/src/main/resources/templates/fragments/menu.html",
                        TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("moment-2.29.1.min.js", "/src/main/resources/static/js/moment-2.29.1.min.js",
                        TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("notFoundException-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/exception/NotFoundException.java",
                TemplateType.GENERATE));
        applicationGenerationProperties.add(new GenerationBean("optimisticLockingException-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/exception/OptimisticLockingException.java",
                TemplateType.GENERATE));
        applicationGenerationProperties.add(new GenerationBean("pom-xml.ftl", "/pom.xml", TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("popper-1.16.1.min.js", "/src/main/resources/static/js/popper-1.16.1.min.js",
                        TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("readme-md.ftl", "/README.md", TemplateType.GENERATE));
        applicationGenerationProperties.add(new GenerationBean("tempusdominus-bootstrap-4-5.1.3.min.css",
                "/src/main/resources/static/css/tempusdominus-bootstrap-4-5.1.3.min.css", TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("tempusdominus-bootstrap-4-5.1.3.min.js",
                "/src/main/resources/static/js/tempusdominus-bootstrap-4-5.1.3.min.js", TemplateType.COPY));

        enumGenerationProperties.add(new GenerationBean("enum-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/${enumName?cap_first}.java",
                TemplateType.GENERATE));

        entityGenerationProperties.add(new GenerationBean("entity-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/${entityName?cap_first}.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("entityController-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/${entityName?cap_first}Controller.java",
                TemplateType.GENERATE));
        entityGenerationProperties
                .add(new GenerationBean("entityEdit-html.ftl", "/src/main/resources/templates/${entityName}Edit.html",
                        TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("entityEditForm-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName?cap_first}EditForm.java",
                TemplateType.GENERATE));
        entityGenerationProperties
                .add(new GenerationBean("entityList-html.ftl", "/src/main/resources/templates/${entityName}List.html",
                        TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("entityListForm-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName?cap_first}ListForm.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("entityListRow-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName?cap_first}ListRow.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("entityRepository-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/repository/${entityName?cap_first}Repository.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("entityService-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/service/${entityName?cap_first}Service.java",
                TemplateType.GENERATE));
        entityGenerationProperties
                .add(new GenerationBean("entityView-html.ftl", "/src/main/resources/templates/${entityName}View.html",
                        TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("entityView-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName?cap_first}View.java",
                TemplateType.GENERATE));
    }

    @Override
    public String name() {
        return "spring/web/mvc";
    }

    @Override
    public List<GenerationBean> getApplicationGenerationProperties() {
        return applicationGenerationProperties;
    }

    @Override
    public List<GenerationBean> getEntityGenerationProperties() {
        return entityGenerationProperties;
    }

    @Override
    public List<GenerationBean> getEnumGenerationProperties() {
        return enumGenerationProperties;
    }
}
