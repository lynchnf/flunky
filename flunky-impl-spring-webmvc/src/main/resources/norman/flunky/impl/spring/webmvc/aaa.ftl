<#if field.joinColumn??>
<#elseif field.enumType??>
<#elseif field.type == "BigDecimal">
<#elseif field.type == "Boolean">
<#elseif field.type == "Byte">
<#elseif field.type == "Short">
<#elseif field.type == "Integer">
<#elseif field.type == "Long">
<#elseif field.type == "Date">
<#if field.temporalType?? && field.temporalType == "DATE">
<#elseif field.temporalType?? && field.temporalType == "TIME">
<#elseif ield.temporalType?? && field.temporalType == "TIMESTAMP">
</#if>
<#elseif field.type == "String">
</#if>
