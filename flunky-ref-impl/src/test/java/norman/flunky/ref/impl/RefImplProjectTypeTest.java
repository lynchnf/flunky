package norman.flunky.ref.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Arrays;
import java.util.List;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import norman.flunky.api.GenerationBean;

class RefImplProjectTypeTest {
    RefImplProjectType projectType;

    @BeforeEach
    void setUp() throws Exception {
        projectType = new RefImplProjectType();
    }

    @AfterEach
    void tearDown() throws Exception {
        projectType = null;
    }

    @Test
    void testGetTemplatePrefix() {
        assertEquals("flunky/ref/impl", projectType.getTemplatePrefix());
    }

    @Test
    void testGetApplicationGenerationProperties() {
        List<String> actualTemplateNames = Arrays
                .asList(new String[] { "gitignore", "index-jsp.ftl", "pom-xml.ftl", "readme-md.ftl", "web-xml.ftl" });

        assertEquals(actualTemplateNames.size(), projectType.getApplicationGenerationProperties().size());

        for (GenerationBean bean : projectType.getApplicationGenerationProperties()) {
            assertTrue(actualTemplateNames.contains(bean.getTemplateName()), "Actual template name "
                    + bean.getTemplateName() + " not found in list of expected template names.");
        }
    }

    @Test
    void testGetEntityGenerationProperties() {
        List<String> actualTemplateNames = Arrays
                .asList(new String[] { "Entity-java.ftl", "EntityDeleteProcessor-java.ftl", "entityEdit-jsp.ftl",
                        "EntityEditLoader-java.ftl", "EntityEditProcessor-java.ftl", "EntityForm-java.ftl",
                        "entityList-jsp.ftl", "EntityListLoader-java.ftl", "EntityService-java.ftl",
                        "entityView-jsp.ftl", "EntityViewLoader-java.ftl" });

        assertEquals(actualTemplateNames.size(), projectType.getEntityGenerationProperties().size());

        for (GenerationBean bean : projectType.getEntityGenerationProperties()) {
            assertTrue(actualTemplateNames.contains(bean.getTemplateName()), "Actual template name "
                    + bean.getTemplateName() + " not found in list of expected template names.");
        }
    }

    @Test
    void testGetEnumGenerationProperties() {
        assertEquals(0, projectType.getEnumGenerationProperties().size());
    }
}
