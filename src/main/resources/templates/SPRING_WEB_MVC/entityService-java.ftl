package ${application.basePackage}.service;

import ${application.basePackage}.domain.${entityName};
import ${application.basePackage}.domain.repository.${entityName}Repository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class ${entityName}Service {
    private static final Logger LOGGER = LoggerFactory.getLogger(${entityName}Service.class);
    @Autowired
    private ${entityName}Repository repository;

    public Page<${entityName}> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }
}
