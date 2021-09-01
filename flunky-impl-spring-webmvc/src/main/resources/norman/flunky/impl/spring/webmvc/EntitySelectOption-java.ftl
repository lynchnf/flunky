package ${basePackage}.web.view;

public class EntitySelectOption {
    private Long value;
    private String text;

    public EntitySelectOption(Long value, String text) {
        this.value = value;
        this.text = text;
    }

    public Long getValue() {
        return value;
    }

    public String getText() {
        return text;
    }
}
