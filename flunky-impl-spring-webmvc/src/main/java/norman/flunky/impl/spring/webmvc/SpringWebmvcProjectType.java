package norman.flunky.impl.spring.webmvc;

import norman.flunky.api.AbstractProjectType;
import norman.flunky.api.GenerationBean;

import java.util.ArrayList;
import java.util.List;

import static norman.flunky.api.TemplateType.COPY;
import static norman.flunky.api.TemplateType.GENERATE;

public class SpringWebmvcProjectType extends AbstractProjectType {
    private List<GenerationBean> applicationGenerationProperties = new ArrayList<>();
    private List<GenerationBean> enumGenerationProperties = new ArrayList<>();
    private List<GenerationBean> entityGenerationProperties = new ArrayList<>();

    public SpringWebmvcProjectType() {
        applicationGenerationProperties.add(new GenerationBean(".gitignore", "/.gitignore", COPY));
        applicationGenerationProperties
                .add(new GenerationBean("application.properties", "/src/main/resources/application.properties", COPY));
        applicationGenerationProperties.add(new GenerationBean("Application-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/Application.java", GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("common.js", "/src/main/resources/static/js/common.js", COPY));
        applicationGenerationProperties.add(new GenerationBean("EntityToSqlConverter-java.ftl",
                "/src/test/java/${basePackage?replace(\".\", \"/\")}/EntityToSqlConverter.java", GENERATE));
        applicationGenerationProperties.add(new GenerationBean("FakeDataFactory-java.ftl",
                "/src/test/java/${basePackage?replace(\".\", \"/\")}/FakeDataFactory.java", GENERATE));
        applicationGenerationProperties.add(new GenerationBean("HomePage-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/web/HomePage.java", GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("index-html.ftl", "/src/main/resources/templates/index.html", GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("jquery-3.5.1.min.js", "/src/main/resources/static/js/jquery-3.5.1.min.js",
                        COPY));
        applicationGenerationProperties.add(new GenerationBean("ListForm-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/web/view/ListForm.java", GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("logback-xml.ftl", "/src/main/resources/logback.xml", GENERATE));
        applicationGenerationProperties.add(new GenerationBean("LoggingException-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/exception/LoggingException.java", GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("main.css", "/src/main/resources/static/css/main.css", COPY));
        applicationGenerationProperties.add(new GenerationBean("MiscUtils-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/util/MiscUtils.java", GENERATE));
        applicationGenerationProperties.add(new GenerationBean("NotFoundException-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/exception/NotFoundException.java", GENERATE));
        applicationGenerationProperties.add(new GenerationBean("OptimisticLockingException-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/exception/OptimisticLockingException.java",
                GENERATE));
        applicationGenerationProperties.add(new GenerationBean("pom-xml.ftl", "/pom.xml", GENERATE));

        enumGenerationProperties.add(new GenerationBean("Enum-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/${enumName}.java", GENERATE));

        entityGenerationProperties.add(new GenerationBean("Entity-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/${entityName}.java", GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityController-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/${entityName}Controller.java",
                GENERATE));
        //entityGenerationProperties.add(new GenerationBean("EntityControllerTest-java.ftl",
        //        "/src/test/java/${application.basePackage?replace(\".\", \"/\")}/web/${entityName}ControllerTest.java",
        //        GENERATE));
        entityGenerationProperties.add(new GenerationBean("entityEdit-html.ftl",
                "/src/main/resources/templates/${entityName?uncap_first}Edit.html", GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityEditForm-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}EditForm.java",
                GENERATE));
        //entityGenerationProperties.add(new GenerationBean("EntityEditFormTest-java.ftl",
        //        "/src/test/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}EditFormTest.java",
        //        GENERATE));
        entityGenerationProperties.add(new GenerationBean("entityList-html.ftl",
                "/src/main/resources/templates/${entityName?uncap_first}List.html", GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityListForm-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}ListForm.java",
                GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityListRow-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}ListRow.java",
                GENERATE));
        //entityGenerationProperties.add(new GenerationBean("EntityListRowTest-java.ftl",
        //        "/src/test/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}ListRowTest.java",
        //        GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityRepository-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/repository/${entityName}Repository.java",
                GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityService-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/service/${entityName}Service.java",
                GENERATE));
        entityGenerationProperties.add(new GenerationBean("entityView-html.ftl",
                "/src/main/resources/templates/${entityName?uncap_first}View.html", GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityView-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}View.java",
                GENERATE));
        //entityGenerationProperties.add(new GenerationBean("EntityViewTest-java.ftl",
        //        "/src/test/java/${application.basePackage?replace(\".\", \"/\")}/web/view/${entityName}ViewTest.java",
        //        GENERATE));
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
