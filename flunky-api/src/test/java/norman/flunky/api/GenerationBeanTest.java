package norman.flunky.api;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static norman.flunky.api.TemplateType.GENERATE;
import static org.junit.jupiter.api.Assertions.*;

class GenerationBeanTest {
    GenerationBean bean;

    @BeforeEach
    void setUp() {
        bean = new GenerationBean("testTemplateName", "testOutputFilePath", GENERATE);
    }

    @AfterEach
    void tearDown() {
        bean = null;
    }

    @Test
    void getTemplateName() {
        assertEquals("testTemplateName", bean.getTemplateName());
    }

    @Test
    void getOutputFilePath() {
        assertEquals("testOutputFilePath", bean.getOutputFilePath());
    }

    @Test
    void getTemplateType() {
        assertEquals(GENERATE, bean.getTemplateType());
    }
}
