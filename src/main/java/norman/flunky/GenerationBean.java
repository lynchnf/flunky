package norman.flunky;

public class GenerationBean {
    private String templateName;
    private String outputFilePath;

    public GenerationBean(String templateName, String outputFilePath) {
        this.templateName = templateName;
        this.outputFilePath = outputFilePath;
    }

    public String getTemplateName() {
        return templateName;
    }

    public String getOutputFilePath() {
        return outputFilePath;
    }
}
