package norman.flunky;

public class GenerationBean {
    private String templateName;
    private String outputFilePath;
    private TemplateType templateType;

    public GenerationBean(String templateName, String outputFilePath, TemplateType templateType) {
        this.templateName = templateName;
        this.outputFilePath = outputFilePath;
        this.templateType = templateType;
    }

    public String getTemplateName() {
        return templateName;
    }

    public String getOutputFilePath() {
        return outputFilePath;
    }

    public TemplateType getTemplateType() {
        return templateType;
    }
}
