echo Maven package

setlocal

if "%DO_MAVEN_PACKAGE%"=="true" (
    call mvn package -P release %*
) else (
    echo Skip Maven package
)
