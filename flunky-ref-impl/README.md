# Flunky Reference Implementation

This is an example implementation of the API that is part of the [Flunky project](../README.md) for generating source
code for [CRUD applications](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete).
This implementation will produce a web application that is made up of servlets and JSPs (Java Server Pages) with a
`web.xml` deployment descriptor.
It compiles down to a WAR file (Web Archive file) that can be deployed to an application server such as Tomcat.

Please note: This just creates a "demo" web application which does not have a database. 

## To Build

This JAR file is created when the parent project is built.  
To check it out and compile it, execute the following commands:

    cd <workspace-dir>
    git clone git@github.com:lynchnf/flunky.git
    cd flunky
    git checkout master
    mvn clean package
    
These commands will produce a file named `flunky-ref-impl-x.x.x.jar` in directory
`<workspace-dir>/flunky/flunky-ref-impl/target`.

## To Use

Copy file `flunky-ref-impl-x.x.x.jar` to directory `lib` in your Flunky installation as described by step 1 of the
[Flunky - To Run](../README.md#to-run) instructions.

Create the following CSV files as described by step 3 of the [Flunky - To Run](../README.md#to-run) instructions.

### Entities File

A CSV file that contains information about entities to be created for your generated project.

    entityName - Java class name for an entity.
    singular - A descriptive name for a singular instance of this entity. It is recommended that this name be capitalized.

### Fields File

A CSV file that contains information about entity fields to be created for your generated project.

    entityName - Java class name for an entity.
    fieldName - Variable name for a field in the named entity.
    label - A descriptive label for this entity name. It is recommended that this label be capitalized.

See [Java naming conventions](https://www.oracle.com/java/technologies/javase/codeconventions-namingconventions.html)
for more information on "good" values for your Java class and variable names.
