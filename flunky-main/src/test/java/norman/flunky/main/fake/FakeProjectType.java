package norman.flunky.main.fake;

import java.util.List;

import norman.flunky.api.GenerationBean;
import norman.flunky.api.ProjectType;

public class FakeProjectType implements ProjectType {
    @Override
    public String getTemplatePrefix() {
        return null;
    }

    @Override
    public List<GenerationBean> getApplicationGenerationProperties() {
        return null;
    }

    @Override
    public List<GenerationBean> getEntityGenerationProperties() {
        return null;
    }

    @Override
    public List<GenerationBean> getEnumGenerationProperties() {
        return null;
    }
}
