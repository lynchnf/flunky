package ${basePackage}.exception;

import org.slf4j.Logger;

public class NotFoundException extends Exception {
    private static final String NOT_FOUND_ERROR = "%s was not found for id=%d.";

    public NotFoundException(Logger logger, String entityName, long id) {
        super(String.format(NOT_FOUND_ERROR, entityName, id));
        logger.warn(this.getMessage());
    }
}
