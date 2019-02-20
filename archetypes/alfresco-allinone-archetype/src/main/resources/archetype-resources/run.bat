#set( $symbol_dollar = '$' )
@ECHO OFF

SET COMPOSE_FILE_PATH=%CD%\target\docker\docker-compose.yml
SET COMPOSE_FILE_OVERRIDE=%CD%\target\docker\docker-compose.override.yml
SET MVN_BUILD_PARAMS=

IF [%M2_HOME%]==[] (
    SET MVN_EXEC=mvn
)

IF NOT [%M2_HOME%]==[] (
    SET MVN_EXEC=%M2_HOME%\bin\mvn
)

IF [%1]==[] (
    GOTO HELP
)

IF [%2]==[local] (
    SET COMPOSE_FILE_OVERRIDE="%CD%\target\docker\docker-compose.local.yml"
    SET MVN_BUILD_PARAMS=-Dlocal=true %MVN_BUILD_PARAMS%
)

SET COMPOSE_FILES=-f "%COMPOSE_FILE_PATH%" -f "%COMPOSE_FILE_OVERRIDE%"

IF %1==build_start (
    IF [%2]==[local] (
        CALL :start_local
    ) ELSE (
        CALL :build
        CALL :start_docker
    )
    GOTO END
)
IF %1==start (
    IF [%2]==[local] (
        CALL :start_local
    ) ELSE (
        CALL :start_docker
    )
    GOTO END
)
IF %1==stop (
    CALL :down_docker
    GOTO END
)
IF %1==purge (
    CALL :purge
    GOTO END
)
IF %1==tail (
    CALL :tail
    GOTO END
)
IF %1==reload_share (
    IF [%2]==[local] GOTO HELP
    CALL :reload_share
    GOTO END
)
IF %1==reload_acs (
    IF [%2]==[local] GOTO HELP
    CALL :reload_acs
    GOTO END
)
IF %1==build_test (
    CALL :test
    CALL :tail_all
    CALL :down_docker
    GOTO END
)
IF %1==test (
    CALL :test
    GOTO END
)
:HELP
echo "Usage: %0 {build_start|start|stop|purge|tail|reload_share|reload_acs|build_test|test} [local]"
echo "Or   : %0 {build_start|start|stop|purge|tail|build_test|test} local"
:END
EXIT /B %ERRORLEVEL%

:start_docker
    call %MVN_EXEC% package exec:exec@start-docker exec:exec@tail-docker -N %MVN_BUILD_PARAMS%
EXIT /B 0
:start_local
    call %MVN_EXEC% package exec:exec@start-docker cargo:run %MVN_BUILD_PARAMS%
EXIT /B 0
:down_docker
    call %MVN_EXEC% package exec:exec@stop-docker -N %MVN_BUILD_PARAMS%
EXIT /B 0
:build
    call %MVN_EXEC% package %MVN_BUILD_PARAMS%
EXIT /B 0
:reload_share
    docker-compose %COMPOSE_FILES% kill ${rootArtifactId}-share
    docker-compose %COMPOSE_FILES% rm -f ${rootArtifactId}-share
    call %MVN_EXEC% package -pl ${rootArtifactId}-share,${rootArtifactId}-share-docker
    docker-compose %COMPOSE_FILES% up --build -d ${rootArtifactId}-share
EXIT /B 0
:reload_acs
    docker-compose %COMPOSE_FILES%" kill ${rootArtifactId}-acs
    docker-compose %COMPOSE_FILES%" rm -f ${rootArtifactId}-acs
    call %MVN_EXEC% package -pl ${rootArtifactId}-platform,${rootArtifactId}-platform-docker
    docker-compose %COMPOSE_FILES% up --build -d ${rootArtifactId}-acs
EXIT /B 0
:tail
    call %MVN_EXEC% package exec:exec@tail-docker -N %MVN_BUILD_PARAMS%
EXIT /B 0
:tail_all
    call %MVN_EXEC% package exec:exec@tail-all-docker -N %MVN_BUILD_PARAMS%
EXIT /B 0
:test
    call %MVN_EXEC% verify %MVN_BUILD_PARAMS%
EXIT /B 0
:purge
    call %MVN_EXEC% package exec:exec@purge-docker -N %MVN_BUILD_PARAMS%
    call %MVN_EXEC% clean %MVN_BUILD_PARAMS%
EXIT /B 0