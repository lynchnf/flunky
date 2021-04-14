# Flunky

Source code generator

## To Build

To checkout Flunky and compile it, execute the following commands:

    cd <workspace-dir>
    git clone git@github.com:lynchnf/flunky.git
    cd flunky
    git checkout master
    mvn clean package
    
These commands will produce a tar.gz file and a zip file which contain everything needed to install Flunky.

## To Install

To install Flunky on a Linux machine, copy file `flunky-main-x.x.x-bin.tar.gz` to your target directory and
execute the following command:

    tar -xzf flunky-main-x.x.x-bin.tar.gz
    
On a Windows machine, copy file `flunky-main-x.x.x-bin.zip` to your target directory and unzip it.

When done, this will produce a directory named `flunky` which will contain everything needed to run Flunky.
    
## To Run

To use Flunky to generate a new project, the first thing needed is an implementation jar file which has built from a project with a dependency on `norman.flunky-api`. This project should contain a class which implements `norman.flunky.api.ProjectType` and [FreeMarker](https://freemarker.apache.org/) templates in a resource directory named by method `getTemplatePrefix()`.

As an example and reference implementation, Flunky contains jar file `flunky-ref-impl-x.x.x.jar`.

The second thing needed is a properties file (and associated CSV files) with the following information:

    project.type - The fully qualified name of a Java class that implements the interface norman.flunky.api.ProjectType.
    project.directory - The absolute path to a directory where you wish to generate your project. 
    group.id - The group id of the generated project.
    artifact.id - The artifact id of the generated project.
    version - The version of the generated project.
    base.package - The base name of the packages created for the generated project.
    description - An optional description for the generated project.
    enums.file - The name of a CSV file in the same directory as the properties file that contains information about enums to be created for the generated project. See the implementation jar file for documentation on how to create this file.
    entities.file - The name of a CSV file in the same directory as the properties file that contains information about entities to be created for the generated project. See the implementation jar file for documentation on how to create this file.
    fields.file - The name of a CSV file in the same directory as the properties file that contains information about entity fields to be created for the generated project. See the implementation jar file for documentation on how to create this file.

The last thing needed is to execute the shell script (or bat file) with the absolute path to your properties file as an argument. For example:
 
    ./flunky/bin/flunky.sh <path-to-props-file>

## To Do List

- [x] different date types: date, time, timestamp
  - [x] write data in FakeDataUtil
  - [x] data/time/datetime picker
  - [x] change label on date/time edit labels (M/d/yyyy => m/d/y, h:m a => h:m am/pm
- [x] enums
  - [x] generate
  - [x] edit dropdowns
- [ ] exclude stuff
  - [x] exclude fields from list, view, edit
  - [ ] exclude entity list/add from menu
  - [ ] conditional generation of files
- [ ] unit tests
- [ ] validation of files
- [x] separate jar files
  - [x] GenerationBean, ProjectType interface, TemplateType in one jar
  - [x] ProjectType implementation and template resources in second jar
  - [x] ApplicationBean, Main, LoggingException in third bean 
- [ ] bat and shell files to run from command line
- [ ] documentation!
  - [x] project docs
  - [ ] runtime module docs
