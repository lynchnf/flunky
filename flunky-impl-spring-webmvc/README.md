# Flunky Spring Web MVC Implementation

### Entities File

A CSV file that contains information about entities to be created for your generated project.

    entityName - Java class name for an entity.
    singular - A descriptive name for a singular instance of this entity. It is recommended that this name be capitalized.
    plural - A descriptive name for multiple instances of this entity. It is recommended that this name be capitalized.
    toString - A Java expression which is used to override the toString() method for this entity.
    
LIST
    
    mainField
    defaultSort
    defaultPage
    
FAKE DATA
    
    nbrOfFakeRecords

### Fields File

A CSV file that contains information about entity fields to be created for your generated project.

    entityName - Java class name for an entity.
    fieldName - Variable name for a field in the named entity.
    label - A descriptive label for this entity name. It is recommended that this label be capitalized.
    type - Valid values are String
    length
    precision
    scale
    nullable - Valid values are true or false. If left blank, true is the default.

LIST

    listDisplay - Valid values are hide, show, or sort. If left blank, hide is the default.
    
VIEW

    viewDisplay - Valid values are hide or show. If left blank, hide is the default.
    
EDIT

    editDisplay - Valid values are hide, show, or edit. If left blank, hide is the default.
    dftValue -