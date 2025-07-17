@echo off
if "%OS%" == "Windows_NT" setlocal
if "%1" == "" goto noparm
set CURRENT_DIR=%cd%
cd /d %0\..\..

start "${project.parent.name}" /B java -cp ${project.artifactId}-${project.version}.${project.packaging};lib/* norman.flunky.main.Main %1

cd %CURRENT_DIR%
goto end

:noparm
echo Usage: %0 ^<path-to-properties-file^>

:end
