package ${application.basePackage}.service;

import ${application.basePackage}.domain.${entityName?cap_first};
import ${application.basePackage}.domain.repository.${entityName?cap_first}Repository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class ${entityName?cap_first}Service {
    private static final Logger LOGGER = LoggerFactory.getLogger(${entityName?cap_first}Service.class);
    @Autowired
    private ${entityName?cap_first}Repository repository;

    public Page<${entityName?cap_first}> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }
}
