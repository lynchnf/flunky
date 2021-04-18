# Flunky

## Source code generator

Flunky is an application that generates source code for
[CRUD applications](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete).
You supply it with a properties file and several CSV files that tell it about the CRUD app you are creating.

The properties file tells Flunky about project information such as name, description, and type of project.
The type will refer to a Java class in an implementation JAR (Java archive) that is on the classpath for Flunky and is a
run-time dependency.

Documentation for the JAR file *should* specify what CSV files are needed.
These CSV files should contain information about [entities](https://en.wikipedia.org/wiki/Entity-relationship_model)
(or [tables](https://en.wikipedia.org/wiki/Table_(database\))), fields (or rows), and (optionally)
[enums](https://en.wikipedia.org/wiki/Enumerated_type).

The Flunky project comes with one example implementation JAR, `flunky-ref-impl-x.x.x.jar`.
(See documentation [here](flunky-ref-impl/README.md).)
If you are building Flunky from source, this JAR will be created when Flunky is built.
If you downloaded a binary distribution of Flunky (i.e. a tar or zip file), you will have to download an implementation
JAR file separately.

A key feature of Flunky is to allow *you* to create and use your own custom implementation JAR to generate CRUD apps for
your own specific needs and with your own special style.
You will need to create a Java project with a compile dependency on `norman:flunky-api:x.x.x.`.
This project needs to contain one class that implements `norman.flunky.api.ProjectType`, a resource directory which
contains all your [FreeMarker](https://freemarker.apache.org/) templates, and (hopefully) documentation.
Use the `flunky-ref-impl` project as an example to guide you. 

## To Build

To checkout Flunky and compile it, execute the following commands:

    cd <workspace-dir>
    git clone git@github.com:lynchnf/flunky.git
    cd flunky
    git checkout master
    mvn clean package
    
These commands will produce a tar.gz file and a zip file which contain everything needed to install Flunky.
You will find these files in directory `<workspace-dir>/flunky/flunky-main/target`.

## To Install

To install Flunky on a Linux machine, copy file `flunky-main-x.x.x-bin.tar.gz` to your target directory and
execute `tar -xf flunky-main-x.x.x-bin.tar.gz`.
    
On a Windows machine, copy file `flunky-main-x.x.x-bin.zip` to your target directory and unzip it.

When done, this will produce a directory named `flunky` which will contain everything needed to run Flunky.
    
## To Run

To use Flunky to generate a new project, do the following:

1.  Copy an implementation JAR file in to directory `flunky/lib`.

2.  Create a properties file with the following fields:

        project.type - The fully qualified name of a Java class that implements the interface norman.flunky.api.ProjectType.
        project.directory - The absolute path to a directory where you wish to generate your project. 
        group.id - The group id of the generated project.
        artifact.id - The artifact id of the generated project.
        version - The version of the generated project.
        base.package - The base name of the packages created for the generated project.
        description - (optional) A description for the generated project.
        entities.file - (optional) The name of a CSV file that contains information about entities to be created for your generated project.
        fields.file - (optional) The name of a CSV file that contains information about entity fields to be created for your generated project.
        enums.file - (optional) The name of a CSV file that contains information about enums to be created for your generated project.

    See the [Maven guide to naming conventions](https://maven.apache.org/guides/mini/guide-naming-conventions.html) for
    more information on "good" values for your group id, artifact id, and version.
    
3.  Create CSV files (as documented for your implementation JAR).
    These CSV files need to be in the same directory as your properties file.

4.  On a Linux machine, execute command `./flunky/bin/flunky.sh <path-to-your-properties-file>`. 
    On a Windows machine, execute `flunky\bin\flunky.bat <path-to-your-properties-file>`.
