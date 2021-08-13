package norman.flunky.api;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public abstract class AbstractProjectType implements ProjectType {
    @Override
    public List<String> validate(Map<String, String> applicationData, List<Map<String, String>> entitiesData,
            List<Map<String, String>> fieldsData, List<Map<String, String>> enumsData) {
        return new ArrayList<>();
    }
}
