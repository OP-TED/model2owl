@echo off

rem
rem Set environment variables
rem
call "%~dp0set-env.cmd"

rem
rem Begin localization of environment changes
rem
setlocal

rem
rem Determine curl
rem
set "CURL=%SYSTEMROOT%\system32\curl.exe"
if not exist "%CURL%" set CURL=curl

rem
rem Ant
rem
echo Install Ant %ANT_VERSION%

rem Create dir to invalidate any preinstalled Ant
if not exist "%ANT_HOME%" mkdir "%ANT_HOME%"

rem Temp downloaded file
set "ANT_TEMP_ARCHIVE=%TEMP%\ant.tar.gz"

rem curl version for inspection
"%CURL%" --version

rem --connect-timeout is for curl/curl#4461
"%CURL%" ^
    --fail ^
    --connect-timeout 20 ^
    --location ^
    --output "%ANT_TEMP_ARCHIVE%" ^
    --retry 5 ^
    --retry-connrefused ^
    --silent ^
    --show-error ^
    "http://archive.apache.org/dist/ant/binaries/apache-ant-%ANT_VERSION%-bin.tar.gz" ^
    || goto :EOF

call "%~dp0extract-tgz.cmd" ^
    "%ANT_TEMP_ARCHIVE%" ^
    "%ANT_HOME%\.." ^
    || goto :EOF

rem Delete the temp downloaded file
del "%ANT_TEMP_ARCHIVE%"

rem
rem Other deps
rem
echo Install the other deps
call ant -buildfile "%~dp0build_install-deps.xml"
