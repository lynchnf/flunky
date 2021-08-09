package norman.flunky.main;

import norman.flunky.api.ProjectType;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;

import java.io.File;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
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
        try (MockedStatic<ApplicationBean> mockStatic = mockStatic(ApplicationBean.class)) {
            ApplicationBean appBean = mock(ApplicationBean.class);
            mockStatic.when(() -> ApplicationBean.instance(anyString())).thenReturn(appBean);
            ProjectType type = mock(ProjectType.class);
            when(appBean.getProjectType()).thenReturn(type);
            File projectDirectory = mock(File.class);
            when(appBean.getProjectDirectory()).thenReturn(projectDirectory);
            when(projectDirectory.mkdirs()).thenReturn(true);

            Main.main(new String[]{"path-to=properties-file"});
        }
    }

    @Test
    void mainNoArgs() {
        assertThrows((Class<? extends Throwable>) LoggingException.class, () -> Main.main(new String[]{}));
    }
}
