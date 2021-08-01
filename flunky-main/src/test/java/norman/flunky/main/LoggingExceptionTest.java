package norman.flunky.main;

import org.junit.jupiter.api.Test;
import org.slf4j.Logger;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class LoggingExceptionTest {
    @Test
    void constructorWithMessage() {
        Logger logger = mock(Logger.class);
        LoggingException exception = new LoggingException(logger, "Test error message");
        assertEquals("Test error message", exception.getMessage());
        assertNull(exception.getCause());
        verify(logger).error(anyString());
    }

    @Test
    void constructorWithMessageAndCause() {
        Logger logger = mock(Logger.class);
        Throwable cause = new Exception("Something bad happened");
        LoggingException exception = new LoggingException(logger, "Test error message", cause);
        assertEquals("Test error message", exception.getMessage());
        assertEquals("Something bad happened", exception.getCause().getMessage());
        verify(logger).error(anyString(), any(Throwable.class));
    }
}