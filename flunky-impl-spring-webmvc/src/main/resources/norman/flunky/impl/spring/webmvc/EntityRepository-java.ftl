package ${application.basePackage}.domain.repository;

import ${application.basePackage}.domain.${entityName};
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.repository.PagingAndSortingRepository;

public interface ${entityName}Repository extends PagingAndSortingRepository<${entityName}, Long> {
<#if parentField??>
    Iterable<${entityName}> findBy${parentField?cap_first}_Id(Long parentId, Sort sort);

    Page<${entityName}> findBy${parentField?cap_first}_Id(Long parentId, Pageable pageable);
</#if>
}
