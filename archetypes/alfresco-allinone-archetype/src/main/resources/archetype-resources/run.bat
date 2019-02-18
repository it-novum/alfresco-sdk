#set( $symbol_dollar = '$' )
@ECHO OFF

IF [%M2_HOME%]==[] (
    SET MVN_EXEC=mvn
)

IF NOT [%M2_HOME%]==[] (
    SET MVN_EXEC=%M2_HOME%\bin\mvn
)

IF [%1]==[] (
    echo "Usage: %0 {build_start|start|start_tomcat|stop|purge|build_test}"
    GOTO END
)

IF %1==build_start (
    %MVN_EXEC% package docker:build docker:volume-create docker:start cargo:run
    GOTO END
)
IF %1==start (
    %MVN_EXEC% package docker:start cargo:run
    GOTO END
)
IF %1==start_tomcat (
    %MVN_EXEC% package cargo:run
    GOTO END
)
IF %1==stop (
    %MVN_EXEC% package docker:stop -DskipTests=true
    GOTO END
)
IF %1==purge (
    %MVN_EXEC% clean
    GOTO END
)
IF %1==build_test (
    %MVN_EXEC% verify
    GOTO END
)
echo "Usage: %0 {build_start|start|start_tomcat|stop|purge|build_test}"
:END
EXIT /B %ERRORLEVEL%
