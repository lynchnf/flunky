package norman.flunky.main;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.slf4j.Logger;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

public class LoggingExceptionTest {
    private Logger mockLogger;

    @Before
    public void setUp() throws Exception {
        mockLogger = mock(Logger.class);
    }

    @After
    public void tearDown() throws Exception {
        mockLogger = null;
    }

    @Test
    public void testLoggingExceptionLoggerString() {
        String message = "Test error message";

        LoggingException exception = new LoggingException(mockLogger, message);

        verify(mockLogger).error(message);
        assertTrue(exception instanceof RuntimeException);
        assertEquals(message, exception.getMessage());
    }

    @Test
    public void testLoggingExceptionLoggerStringThrowable() {
        String message = "Test error message";
        Throwable cause = new Exception("Test cause message");

        LoggingException exception = new LoggingException(mockLogger, message, cause);

        verify(mockLogger).error(message, cause);
        assertTrue(exception instanceof RuntimeException);
        assertEquals(message, exception.getMessage());
        assertEquals(cause, exception.getCause());
    }
}
