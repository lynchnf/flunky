package norman.flunky.ref.impl;

import norman.flunky.api.AbstractProjectType;
import norman.flunky.api.GenerationBean;
import norman.flunky.api.TemplateType;

import java.util.ArrayList;
import java.util.List;

public class RefImplProjectType extends AbstractProjectType {
    private List<GenerationBean> applicationGenerationProperties = new ArrayList<>();
    private List<GenerationBean> enumGenerationProperties = new ArrayList<>();
    private List<GenerationBean> entityGenerationProperties = new ArrayList<>();

    public RefImplProjectType() {
        applicationGenerationProperties.add(new GenerationBean(".gitignore", "/.gitignore", TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("index-jsp.ftl", "/src/main/webapp/index.jsp", TemplateType.GENERATE));
        applicationGenerationProperties.add(new GenerationBean("pom-xml.ftl", "/pom.xml", TemplateType.GENERATE));
        applicationGenerationProperties.add(new GenerationBean("readme-md.ftl", "/README.md", TemplateType.GENERATE));
        applicationGenerationProperties
                .add(new GenerationBean("web-xml.ftl", "/src/main/webapp/WEB-INF/web.xml", TemplateType.GENERATE));

        entityGenerationProperties.add(new GenerationBean("Entity-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/${entityName}.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityDeleteProcessor-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/${entityName}DeleteProcessor.java",
                TemplateType.GENERATE));
        entityGenerationProperties
                .add(new GenerationBean("entityEdit-jsp.ftl", "/src/main/webapp/${entityName?uncap_first}Edit.jsp",
                        TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityEditLoader-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/${entityName}EditLoader.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityEditProcessor-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/${entityName}EditProcessor.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityForm-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/form/${entityName}Form.java",
                TemplateType.GENERATE));
        entityGenerationProperties
                .add(new GenerationBean("entityList-jsp.ftl", "/src/main/webapp/${entityName?uncap_first}List.jsp",
                        TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityListLoader-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/${entityName}ListLoader.java",
                TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityService-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/service/${entityName}Service.java",
                TemplateType.GENERATE));
        entityGenerationProperties
                .add(new GenerationBean("entityView-jsp.ftl", "/src/main/webapp/${entityName?uncap_first}View.jsp",
                        TemplateType.GENERATE));
        entityGenerationProperties.add(new GenerationBean("EntityViewLoader-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/${entityName}ViewLoader.java",
                TemplateType.GENERATE));
    }

    @Override
    public String getTemplatePrefix() {
        return "norman/flunky/ref/impl";
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
