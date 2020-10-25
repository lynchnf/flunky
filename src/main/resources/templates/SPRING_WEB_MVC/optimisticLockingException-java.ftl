package ${basePackage}.exception;

import org.slf4j.Logger;

public class OptimisticLockingException extends Exception {
    private static final String OPTIMISTIC_LOCKING_ERROR = "%s with id=%d was updated by another user.";
    private String entityName;
    private long id;

    public OptimisticLockingException(Logger logger, String entityName, long id, Throwable cause) {
        super(String.format(OPTIMISTIC_LOCKING_ERROR, entityName, id), cause);
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
