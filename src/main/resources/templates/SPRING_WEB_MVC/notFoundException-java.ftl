package ${basePackage}.exception;

import org.slf4j.Logger;

public class NotFoundException extends Exception {
    private static final String NOT_FOUND_ERROR = "%s was not found for id=%d.";
    private String entityName;
    private long id;

    public NotFoundException(Logger logger, String entityName, long id) {
        super(String.format(NOT_FOUND_ERROR, entityName, id));
        this.entityName = entityName;
        this.id = id;
        logger.warn(this.getMessage());
    }

    public String getEntityName() {
        return entityName;
    }

    public long getId() {
        return id;
    }
}
