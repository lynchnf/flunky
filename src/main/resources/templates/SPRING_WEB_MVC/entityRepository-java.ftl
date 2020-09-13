package ${application.basePackage}.domain.repository;

import ${application.basePackage}.domain.${entityName};
import org.springframework.data.repository.PagingAndSortingRepository;

public interface ${entityName}Repository extends PagingAndSortingRepository<${entityName}, Long> {
}
