package norman.flunky.main;

import norman.flunky.api.GenerationBean;
import norman.flunky.api.ProjectType;
import norman.flunky.api.TemplateType;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
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
        try (MockedStatic<AppPropertiesIngestor> ingestorMockedStatic = mockStatic(AppPropertiesIngestor.class);
                MockedStatic<DataModelDigestor> digestorMockedStatic = mockStatic(DataModelDigestor.class);
                MockedStatic<SourceExcretor> excretorMockedStatic = mockStatic(SourceExcretor.class)) {

            // Mock the App Properties Ingestor.
            AppPropertiesIngestor ingestor = mock(AppPropertiesIngestor.class);
            ingestorMockedStatic.when(() -> AppPropertiesIngestor.instance(anyString())).thenReturn(ingestor);
            ProjectType projectType = mock(ProjectType.class);
            when(ingestor.getProjectType()).thenReturn(projectType);
            when(ingestor.getProjectDirectory()).thenReturn(new File("/test/project/directory"));
            Map<String, String> data = new LinkedHashMap<>();
            data.put("test-key", "test-value");
            when(ingestor.getApplicationData()).thenReturn(data);
            when(ingestor.getEntitiesData()).thenReturn(Arrays.asList(data));
            when(ingestor.getFieldsData()).thenReturn(Arrays.asList(data));
            when(ingestor.getEnumsData()).thenReturn(Arrays.asList(data));

            // Mock the Project Type.
            when(projectType.validate(anyMap(), anyList(), anyList(), anyList())).thenReturn(new ArrayList<>());
            when(projectType.getTemplatePrefix()).thenReturn("test/template/prefix");
            GenerationBean genBean =
                    new GenerationBean("test-template-name.ftl", "test/output/file/path", TemplateType.GENERATE);
            when(projectType.getApplicationGenerationProperties()).thenReturn(Arrays.asList(genBean));
            when(projectType.getEnumGenerationProperties()).thenReturn(Arrays.asList(genBean));
            when(projectType.getEntityGenerationProperties()).thenReturn(Arrays.asList(genBean));

            // Mock the Data Model Digestor.
            DataModelDigestor digestor = mock(DataModelDigestor.class);
            digestorMockedStatic.when(() -> DataModelDigestor.instance(anyMap(), anyList(), anyList(), anyList()))
                    .thenReturn(digestor);
            Map<String, Object> model = new LinkedHashMap<>();
            model.put("test-key", "test-value");
            when(digestor.getApplicationModel()).thenReturn(model);
            when(digestor.getEnumModels()).thenReturn(Arrays.asList(model));
            when(digestor.getEntityModels()).thenReturn(Arrays.asList(model));

            // Mock the Source Excretor.
            SourceExcretor excretor = mock(SourceExcretor.class);
            excretorMockedStatic.when(() -> SourceExcretor.instance(any(File.class), anyString())).thenReturn(excretor);
            when(excretor.generateSourceFile(anyMap(), any(GenerationBean.class)))
                    .thenReturn(new File("/test/out/file"));

            // Execute the test.
            Main.main(new String[]{"/test/path/to/properties.file"});

            // Verify the calls.
            verify(ingestor, times(1)).getProjectType();
            verify(ingestor, times(1)).getProjectDirectory();
            verify(ingestor, times(1)).getApplicationData();
            verify(ingestor, times(1)).getEntitiesData();
            verify(ingestor, times(1)).getFieldsData();
            verify(ingestor, times(1)).getEnumsData();

            verify(projectType, times(1)).validate(anyMap(), anyList(), anyList(), anyList());
            verify(projectType, times(1)).getTemplatePrefix();
            verify(projectType, times(1)).getApplicationGenerationProperties();
            verify(projectType, times(1)).getEnumGenerationProperties();
            verify(projectType, times(1)).getEntityGenerationProperties();

            verify(digestor, times(1)).getApplicationModel();
            verify(digestor, times(1)).getEnumModels();
            verify(digestor, times(1)).getEntityModels();

            verify(excretor, times(3)).generateSourceFile(anyMap(), any(GenerationBean.class));
        }
    }

    @Test
    void mainNoArgs() {
        assertThrows((Class<? extends Throwable>) LoggingException.class, () -> Main.main(new String[]{}));
    }
}
