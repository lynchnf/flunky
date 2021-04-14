package ${application.basePackage}.service;

import ${application.basePackage}.domain.${entityName};

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ${entityName}Service {
    // If this was a real application, this service would use a real database.
    private static Map<Long, ${entityName}> entities = new HashMap<>();

    public static List<${entityName}> getAllEntities() {
        ArrayList<${entityName}> allEntities = new ArrayList<>(entities.values());
        Comparator<${entityName}> comparator = new Comparator<${entityName}>() {
            @Override
            public int compare(${entityName} o1, ${entityName} o2) {
                return o1.getId().compareTo(o2.getId());
            }
        };
        Collections.sort(allEntities, comparator);
        return allEntities;
    }

    public static ${entityName} getEntity(Long id) {
        return entities.get(id);
    }

    public static ${entityName} saveEntity(${entityName} entity) {
        Long id = entity.getId();
        if (id == null) {
            Long highKey = 0L;
            for (Long key : entities.keySet()) {
                if (key > highKey) {
                    highKey = key;
                }
            }
            id = highKey + 1;
            entity.setId(id);
        }
        entities.put(id, entity);
        return entity;
    }

    public static void deleteEntity(${entityName} entity) {
        Long id = entity.getId();
        if (id != null) {
            entities.remove(id);
        }
    }
}
