<#if field.joinColumn??>
<#elseif field.enumType??>
<#elseif field.type == "BigDecimal">
<#elseif field.type == "Boolean">
<#elseif field.type == "Byte">
<#elseif field.type == "Short">
<#elseif field.type == "Integer">
<#elseif field.type == "Long">
<#elseif field.type == "Date" && field.temporalType?? && field.temporalType == "DATE">
<#elseif field.type == "Date" && field.temporalType?? && field.temporalType == "TIME">
<#elseif field.type == "Date" && field.temporalType?? && field.temporalType == "TIMESTAMP">
<#elseif field.type == "String">
</#if>
