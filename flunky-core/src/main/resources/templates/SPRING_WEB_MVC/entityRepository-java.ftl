package ${application.basePackage}.domain.repository;

import ${application.basePackage}.domain.${entityName?cap_first};
import org.springframework.data.repository.PagingAndSortingRepository;

public interface ${entityName?cap_first}Repository extends PagingAndSortingRepository<${entityName?cap_first}, Long> {
}
