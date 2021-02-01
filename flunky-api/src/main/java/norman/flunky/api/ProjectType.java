package norman.flunky.api;

import java.util.List;

public interface ProjectType {
    String name();

    List<GenerationBean> getApplicationGenerationProperties();

    List<GenerationBean> getEntityGenerationProperties();

    List<GenerationBean> getEnumGenerationProperties();
}
