package ${application.basePackage}.service;

import ${application.basePackage}.domain.${entityName?cap_first};
import ${application.basePackage}.domain.repository.${entityName?cap_first}Repository;
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
public class ${entityName?cap_first}Service {
    private static final Logger LOGGER = LoggerFactory.getLogger(${entityName?cap_first}Service.class);
    @Autowired
    private ${entityName?cap_first}Repository repository;

    public Iterable<${entityName?cap_first}> findAll() {
        Sort sort = Sort.by(Sort.Direction.${defaultSort}, "${mainField}", "id");
        return repository.findAll(sort);
    }

    public Page<${entityName?cap_first}> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public ${entityName?cap_first} findById(Long id) throws NotFoundException {
        Optional<${entityName?cap_first}> optional = repository.findById(id);
        if (!optional.isPresent()) {
            throw new NotFoundException(LOGGER, "${singular?cap_first}", id);
        }
        return optional.get();
    }

    public ${entityName?cap_first} save(${entityName?cap_first} entity) throws OptimisticLockingException {
        try {
            return repository.save(entity);
        } catch (ObjectOptimisticLockingFailureException e) {
            throw new OptimisticLockingException(LOGGER, "${singular?cap_first}", entity.getId(), e);
        }
    }
}