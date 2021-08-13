package norman.flunky.main.fake;

import norman.flunky.api.GenerationBean;
import norman.flunky.api.ProjectType;

import java.util.List;
import java.util.Map;

public class FakeProjectType implements ProjectType {
    @Override
    public String getTemplatePrefix() {
        return null;
    }

    @Override
    public List<String> validate(Map<String, String> applicationData, List<Map<String, String>> entitiesData,
            List<Map<String, String>> fieldsData, List<Map<String, String>> enumsData) {
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
