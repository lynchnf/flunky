package norman.flunky.main.fake;

import java.util.ArrayList;
import java.util.List;

import norman.flunky.api.GenerationBean;
import norman.flunky.api.ProjectType;
import norman.flunky.api.TemplateType;

public class FakeProjectType implements ProjectType {
    private List<GenerationBean> applicationGenerationProperties = new ArrayList<>();
    private List<GenerationBean> enumGenerationProperties = new ArrayList<>();
    private List<GenerationBean> entityGenerationProperties = new ArrayList<>();

    public FakeProjectType() {
        applicationGenerationProperties.add(new GenerationBean("copy-test.txt", "/copy-test.txt", TemplateType.COPY));
        applicationGenerationProperties
                .add(new GenerationBean("proj-gen-txt.ftl", "/src/proj-gen.txt", TemplateType.GENERATE));

        entityGenerationProperties.add(new GenerationBean("ent-gen-txt.ftl",
                "/src/${application.basePackage?replace(\".\", \"/\")}/${entityName}-gen.txt", TemplateType.GENERATE));
    }

    @Override
    public String getTemplatePrefix() {
        return "flunky/impl/test";
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
