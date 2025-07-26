package norman.flunky.ref.impl;

import norman.flunky.api.GenerationBean;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class RefImplProjectTypeTest {
    private RefImplProjectType projectType;

    @Before
    public void setUp() throws Exception {
        projectType = new RefImplProjectType();
    }

    @After
    public void tearDown() throws Exception {
        projectType = null;
    }

    @Test
    public void testGetTemplatePrefix() {
        assertEquals("flunky/ref/impl", projectType.getTemplatePrefix());
    }

    @Test
    public void testGetApplicationGenerationProperties() {
        List<String> actualTemplateNames = Arrays
                .asList(new String[] { "gitignore", "index-jsp.ftl", "pom-xml.ftl", "readme-md.ftl", "web-xml.ftl" });

        assertEquals(actualTemplateNames.size(), projectType.getApplicationGenerationProperties().size());

        for (GenerationBean bean : projectType.getApplicationGenerationProperties()) {
            assertTrue(
                    "Actual template name " + bean.getTemplateName() + " not found in list of expected template names.",
                    actualTemplateNames.contains(bean.getTemplateName()));
        }
    }

    @Test
    public void testGetEntityGenerationProperties() {
        List<String> actualTemplateNames = Arrays.asList(new String[] { "Entity-java.ftl",
                "EntityDeleteProcessor-java.ftl", "EntityDeleteProcessorTest-java.ftl", "entityEdit-jsp.ftl",
                "EntityEditLoader-java.ftl", "EntityEditLoaderTest-java.ftl", "EntityEditProcessor-java.ftl",
                "EntityEditProcessorTest-java.ftl", "EntityForm-java.ftl", "EntityFormTest-java.ftl",
                "entityList-jsp.ftl", "EntityListLoader-java.ftl", "EntityListLoaderTest-java.ftl",
                "EntityService-java.ftl", "EntityServiceTest-java.ftl", "entityView-jsp.ftl",
                "EntityViewLoader-java.ftl", "EntityViewLoaderTest-java.ftl" });

        assertEquals(actualTemplateNames.size(), projectType.getEntityGenerationProperties().size());

        for (GenerationBean bean : projectType.getEntityGenerationProperties()) {
            assertTrue(
                    "Actual template name " + bean.getTemplateName() + " not found in list of expected template names.",
                    actualTemplateNames.contains(bean.getTemplateName()));
        }
    }

    @Test
    public void testGetEnumGenerationProperties() {
        assertEquals(0, projectType.getEnumGenerationProperties().size());
    }
}
