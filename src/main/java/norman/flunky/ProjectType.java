package norman.flunky;

import java.util.ArrayList;
import java.util.List;

public enum ProjectType {
    SPRING_WEB_MVC;

    ProjectType() {
    }

    public List<GenerationBean> getApplicationGenerationProperties() {
        List<GenerationBean> genBeans = new ArrayList<>();
        genBeans.add(new GenerationBean("pom-xml.ftl", "/pom.xml"));
        genBeans.add(new GenerationBean("application-java.ftl",
                "/src/main/java/${basePackage?replace(\".\", \"/\")}/Application.java"));
        return genBeans;
    }

    public List<GenerationBean> getEntityGenerationProperties() {
        List<GenerationBean> genBeans = new ArrayList<>();
        genBeans.add(new GenerationBean("entity-java.ftl",
                "/src/main/java/${application.basePackage?replace(\".\", \"/\")}/domain/${entityName}.java"));
        return genBeans;
    }
}
