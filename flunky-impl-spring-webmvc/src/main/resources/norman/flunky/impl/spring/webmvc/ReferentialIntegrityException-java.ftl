package ${basePackage}.exception;

import org.slf4j.Logger;

public class ReferentialIntegrityException extends Exception {
    private static final String REFERENTIAL_INTEGRITY_ERROR =
            "%s with id=%d can not be deleted because it would cause a referential integrity error in the database.";
    private String entityName;
    private long id;

    public ReferentialIntegrityException(Logger logger, String entityName, long id, Throwable cause) {
        super(String.format(REFERENTIAL_INTEGRITY_ERROR, entityName, id), cause);
        this.entityName = entityName;
        this.id = id;
        logger.warn(this.getMessage(), this.getCause());
    }

    public String getEntityName() {
        return entityName;
    }

    public long getId() {
        return id;
    }
}
