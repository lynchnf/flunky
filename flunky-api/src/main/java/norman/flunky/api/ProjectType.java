package norman.flunky.api;

import java.util.List;
import java.util.Map;

public interface ProjectType {
    String getTemplatePrefix();

    List<String> validate(Map<String, String> applicationData, List<Map<String, String>> entitiesData,
            List<Map<String, String>> fieldsData, List<Map<String, String>> enumsData);

    List<GenerationBean> getApplicationGenerationProperties();

    List<GenerationBean> getEntityGenerationProperties();

    List<GenerationBean> getEnumGenerationProperties();
}
