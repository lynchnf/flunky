package norman.flunky.main;

import norman.flunky.api.GenerationBean;
import norman.flunky.api.ProjectType;
import norman.flunky.api.TemplateType;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;

import java.io.File;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class MainTest {
    @BeforeEach
    void setUp() {
    }

    @AfterEach
    void tearDown() {
    }

    @Test
    void main() {
        try (MockedStatic<ApplicationBean> beanMockedStatic = mockStatic(ApplicationBean.class);
                MockedStatic<SourceGenerator> generatorMockedStatic = mockStatic(SourceGenerator.class)) {

            // Mock the ApplicationBean.
            ApplicationBean appBean = mock(ApplicationBean.class);
            beanMockedStatic.when(() -> ApplicationBean.instance(anyString())).thenReturn(appBean);
            ProjectType type = mock(ProjectType.class);
            when(appBean.getProjectType()).thenReturn(type);
            File projDir = new File("/test/project/directory");
            when(appBean.getProjectDirectory()).thenReturn(projDir);
            Map<String, Object> model = new HashMap<>();
            model.put("test-key", "test-value");
            when(appBean.getApplicationModel()).thenReturn(model);
            when(appBean.getEnumModels()).thenReturn(Arrays.asList(model));
            when(appBean.getEntityModels()).thenReturn(Arrays.asList(model));

            // Mock the ProjectType.
            when(type.getTemplatePrefix()).thenReturn("test/template/prefix");
            GenerationBean genBean =
                    new GenerationBean("test-template-name.ftl", "test/output/file/path", TemplateType.GENERATE);
            when(type.getApplicationGenerationProperties()).thenReturn(Arrays.asList(genBean));
            when(type.getEnumGenerationProperties()).thenReturn(Arrays.asList(genBean));
            when(type.getEntityGenerationProperties()).thenReturn(Arrays.asList(genBean));

            // Mock the SourceGenerator.
            SourceGenerator generator = mock(SourceGenerator.class);
            generatorMockedStatic.when(() -> SourceGenerator.instance()).thenReturn(generator);
            when(generator.createProjDir(any(File.class))).thenReturn(projDir);
            when(generator.createSourceFile(anyString(), any(File.class), anyMap(), any(GenerationBean.class)))
                    .thenReturn(new File("/test/out/file"));

            // Execute the test.
            Main.main(new String[]{"/test/path/to/properties.file"});

            // Verify we called methods on the SourceGenerator.
            verify(generator, times(1)).createProjDir(any(File.class));
            verify(generator, times(3))
                    .createSourceFile(anyString(), any(File.class), anyMap(), any(GenerationBean.class));
        }
    }

    @Test
    void mainNoArgs() {
        assertThrows((Class<? extends Throwable>) LoggingException.class, () -> Main.main(new String[]{}));
    }
}
