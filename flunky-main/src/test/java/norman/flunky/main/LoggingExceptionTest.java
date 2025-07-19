package norman.flunky.main;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;

class LoggingExceptionTest {
    Logger mockLogger;

    @BeforeEach
    void setUp() throws Exception {
        mockLogger = mock(Logger.class);
    }

    @AfterEach
    void tearDown() throws Exception {
        mockLogger = null;
    }

    @Test
    void testLoggingExceptionLoggerString() {
        String message = "Test error message";

        LoggingException exception = new LoggingException(mockLogger, message);

        verify(mockLogger).error(message);
        assertInstanceOf(RuntimeException.class, exception);
        assertEquals(message, exception.getMessage());
    }

    @Test
    void testLoggingExceptionLoggerStringThrowable() {
        String message = "Test error message";
        Throwable cause = new Exception("Test cause message");

        LoggingException exception = new LoggingException(mockLogger, message, cause);

        verify(mockLogger).error(message, cause);
        assertInstanceOf(RuntimeException.class, exception);
        assertEquals(message, exception.getMessage());
        assertEquals(cause, exception.getCause());
    }
}
