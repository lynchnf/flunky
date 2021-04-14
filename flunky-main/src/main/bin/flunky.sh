#!/bin/bash

props_path=$1
if [[ "$props_path" == "" ]]; then
    echo "Usage: ./bin/${pom.parent.artifactId}.sh <path-to-properties-file>"
    exit 1
fi

bin_dir=$(dirname "$0")
cd $bin_dir/..

java -cp ${pom.artifactId}-${pom.version}.${pom.packaging}:lib/* norman.flunky.main.Main $props_path

exit 0
