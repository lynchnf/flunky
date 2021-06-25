package norman.flunky.impl.spring.webmvc;

import norman.flunky.api.GenerationBean;
import norman.flunky.api.ProjectType;
import norman.flunky.api.TemplateType;

import java.util.ArrayList;
import java.util.List;

public class SpringWebmvcProjectType implements ProjectType {
    private List<GenerationBean> applicationGenerationProperties = new ArrayList<>();
    private List<GenerationBean> enumGenerationProperties = new ArrayList<>();
    private List<GenerationBean> entityGenerationProperties = new ArrayList<>();

    public SpringWebmvcProjectType() {
        applicationGenerationProperties.add(new GenerationBean(".gitignore", "/.gitignore", TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("application.properties", "/src/main/resources/application.properties",
                        TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("Application-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/Application.java", TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("common.js", "/src/main/resources/static/js/common.js", TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("FakeDataUtil-java.ftl",
                "/src/test/java/${basePackage?replace(\".\", \"/\")}/FakeDataUtil.java", TemplateType.GENERATE));
        applicationGenerationProperties.add(new GenerationBean("HomePage-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/web/HomePage.java", TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("index-html.ftl", "/src/main/resources/templates/index.html",
                        TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("jquery-3.5.1.min.js", "/src/main/resources/static/js/jquery-3.5.1.min.js",
                        TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("ListForm-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/web/view/ListForm.java", TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("logback-xml.ftl", "/src/main/resources/logback.xml", TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("main.css", "/src/main/resources/static/css/main.css", TemplateType.COPY));
        applicationGenerationProperties.add(new GenerationBean("NotFoundException-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/exception/NotFoundException.java",
                TemplateType.GENERATE));
        applicationGenerationProperties.add(new GenerationBean("OptimisticLockingException-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/exception/OptimisticLockingException.java",
                TemplateType.GENERATE));
        applicationGenerationProperties.add(new GenerationBean("pom-xml.ftl", "/pom.xml", TemplateType.GENERATE));

        entityGenerationProperties.add(new GenerationBean("Entity-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/${entityName}.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityController-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/${entityName}Controller.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityControllerTest-java.ftl",
                "/src/test/java/${application.basePackage?replace(\".\", \"/\")}/web/${entityName}ControllerTest.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("entityEdit-html.ftl",
                "/src/main/resources/templates/${entityName?uncap_first}Edit.html", TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityEditForm-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}EditForm.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityEditFormTest-java.ftl",
                "/src/main/test/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}EditFormTest.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("entityList-html.ftl",
                "/src/main/resources/templates/${entityName?uncap_first}List.html", TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityListForm-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}ListForm.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityListRow-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}ListRow.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityListRowTest-java.ftl",
                "/src/main/test/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}ListRowTest.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityRepository-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/repository/${entityName}Repository.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityService-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/service/${entityName}Service.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("entityView-html.ftl",
                "/src/main/resources/templates/${entityName?uncap_first}View.html", TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityView-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}View.java",
                TemplateType.GENERATE));
    }

    @Override
    public String getTemplatePrefix() {
        return "norman/flunky/impl/spring/webmvc";
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
