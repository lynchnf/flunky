#!/bin/bash

props_path=$1
if [[ "$props_path" == "" ]]; then
    echo "Usage: ./bin/${project.parent.artifactId}.sh <path-to-properties-file>"
    exit 1
fi

bin_dir=$(dirname "$0")
cd $bin_dir/..

java -cp ${project.artifactId}-${project.version}.${project.packaging}:lib/* norman.flunky.main.Main $props_path

exit 0
