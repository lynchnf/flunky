package ${basePackage}.web.view;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.util.Iterator;
import java.util.List;
import java.util.function.Function;

public class ListForm<T> implements Page<T> {
    private Page<T> innerPage;
    private Sort.Order sortOrder;

    public ListForm(Page<T> innerPage) {
        this.innerPage = innerPage;
        sortOrder = innerPage.getSort().iterator().next();
    }

    public String getSortColumn() {
        return sortOrder.getProperty();
    }

    public Sort.Direction getSortDirection() {
        return sortOrder.getDirection();
    }

    public boolean isAscending() {
        return sortOrder.getDirection() == Sort.Direction.ASC;
    }

    public boolean isDescending() {
        return sortOrder.getDirection() == Sort.Direction.DESC;
    }

    @Override
    public int getTotalPages() {
        return innerPage.getTotalPages();
    }

    @Override
    public long getTotalElements() {
        return innerPage.getTotalElements();
    }

    @Override
    public int getNumber() {
        return innerPage.getNumber();
    }

    @Override
    public int getSize() {
        return innerPage.getSize();
    }

    @Override
    public int getNumberOfElements() {
        return innerPage.getNumberOfElements();
    }

    @Override
    public List<T> getContent() {
        return innerPage.getContent();
    }

    @Override
    public boolean hasContent() {
        return innerPage.hasContent();
    }

    @Override
    public Sort getSort() {
        return innerPage.getSort();
    }

    @Override
    public boolean isFirst() {
        return innerPage.isFirst();
    }

    @Override
    public boolean isLast() {
        return innerPage.isLast();
    }

    @Override
    public boolean hasNext() {
        return innerPage.hasNext();
    }

    @Override
    public boolean hasPrevious() {
        return innerPage.hasPrevious();
    }

    @Override
    public Pageable nextPageable() {
        return innerPage.nextPageable();
    }

    @Override
    public Pageable previousPageable() {
        return innerPage.previousPageable();
    }

    @Override
    public <U> Page<U> map(Function<? super T, ? extends U> function) {
        return innerPage.map(function);
    }

    @Override
    public Iterator<T> iterator() {
        return innerPage.iterator();
    }
}
