package ${application.basePackage}.service;

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.domain.repository.${entityName}Repository;
import ${application.basePackage}.exception.NotFoundException;
import ${application.basePackage}.exception.OptimisticLockingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.orm.ObjectOptimisticLockingFailureException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class ${entityName}Service {
    private static final Logger LOGGER = LoggerFactory.getLogger(${entityName}Service.class);
    @Autowired
    private ${entityName}Repository repository;

    public Iterable<${entityName}> findAll() {
        Sort sort = Sort.by(Sort.Direction.${defaultSort}, "${mainField}", "id");
        return repository.findAll(sort);
    }

    public Page<${entityName}> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public ${entityName} findById(Long id) throws NotFoundException {
        Optional<${entityName}> optional = repository.findById(id);
        if (!optional.isPresent()) {
            throw new NotFoundException(LOGGER, "${singular}", id);
        }
        return optional.get();
    }

    public ${entityName} save(${entityName} entity) throws OptimisticLockingException {
        try {
            return repository.save(entity);
        } catch (ObjectOptimisticLockingFailureException e) {
            throw new OptimisticLockingException(LOGGER, "${singular}", entity.getId(), e);
        }
    }

    public void delete(${entityName} entity) throws OptimisticLockingException {
        try {
            repository.delete(entity);
        } catch (ObjectOptimisticLockingFailureException e) {
            throw new OptimisticLockingException(LOGGER, "${singular}", entity.getId(), e);
        }
    }
}
