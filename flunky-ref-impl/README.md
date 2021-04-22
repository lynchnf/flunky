# Flunky Reference Implementation

This is an example implementation of the API that is part of the [Flunky project](../README.md) for generating source
code for [CRUD applications](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete).

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

Copy file `flunky-ref-impl-x.x.x.jar` to directory `lib` in your Flunky installation as described [here](../README.md#to-run).
