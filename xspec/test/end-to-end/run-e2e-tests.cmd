@echo off
setlocal
set ANT_ARGS=-buildfile "%~dp0ant\run-e2e-tests\build.xml" -lib "%SAXON_JAR%" %*
if /i "%APPVEYOR%"=="True" set ANT_ARGS=%ANT_ARGS% -Dappveyor.filename="%~nx0"
call ant
