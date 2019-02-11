#set( $symbol_dollar = '$' )
@ECHO OFF

IF [%M2_HOME%]==[] (
    SET MVN_EXEC=mvn
)

IF NOT [%M2_HOME%]==[] (
    SET MVN_EXEC=%M2_HOME%\bin\mvn
)

IF [%1]==[] (
    echo "Usage: %0 {build_start|start|stop|purge|tail|tail_share|reload_share|reload_acs|build_test|test}"
    GOTO END
)

IF %1==build_start (
    %MVN_EXEC% clean package docker:build docker:volume-create docker:start
    GOTO END
)
IF %1==start (
    %MVN_EXEC% docker:start
    GOTO END
)
IF %1==stop (
    %MVN_EXEC% docker:stop -pl ${rootArtifactId}-share-docker
    %MVN_EXEC% docker:stop
    GOTO END
)
IF %1==purge (
    %MVN_EXEC% docker:stop -pl ${rootArtifactId}-share-docker
    %MVN_EXEC% docker:stop docker:remove docker:volume-remove
    GOTO END
)
IF %1==tail (
    %MVN_EXEC% docker:logs -Ddocker.logAll=true -Ddocker.follow -pl ${rootArtifactId}-platform-docker
    GOTO END
)
IF %1==tail_share (
    %MVN_EXEC% docker:logs -Ddocker.logAll=true -Ddocker.follow -pl ${rootArtifactId}-share-docker
    GOTO END
)
IF %1==reload_share (
    %MVN_EXEC% docker:stop package docker:build docker:start -pl ${rootArtifactId}-share,${rootArtifactId}-share-docker
    GOTO END
)
IF %1==reload_acs (
    %MVN_EXEC% docker:stop package docker:build docker:start -pl ${rootArtifactId}-platform,${rootArtifactId}-integration-tests,${rootArtifactId}-platform-docker
    GOTO END
)
IF %1==build_test (
    %MVN_EXEC% clean verify
    GOTO END
)
IF %1==test (
    %MVN_EXEC% verify
)
echo "Usage: %0 {build_start|start|stop|purge|tail|tail_share|reload_share|reload_acs|build_test|test}"
:END
EXIT /B %ERRORLEVEL%
