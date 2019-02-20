#set( $symbol_dollar = '$' )
#!/bin/sh

export COMPOSE_FILE_PATH=${symbol_dollar}{PWD}/target/classes/docker/docker-compose.yml
export COMPOSE_FILE_OVERRIDE=${symbol_dollar}{PWD}/target/classes/docker/docker-compose.override.yml
export MVN_BUILD_PARAMS=

if [ -z "${symbol_dollar}{M2_HOME}" ]; then
  export MVN_EXEC="mvn"
else
  export MVN_EXEC="${symbol_dollar}{M2_HOME}/bin/mvn"
fi

if [ "$2"=="local" ]; then
  export COMPOSE_FILE_OVERRIDE=${symbol_dollar}{PWD}/target/classes/docker/docker-compose.local.yml
  export MVN_BUILD_PARAMS=-Dlocal=true ${symbol_dollar}{MVN_BUILD_PARAMS}
fi

start_docker() {
    ${symbol_dollar}MVN_EXEC package exec:exec@start-docker exec:exec@tail-docker -N ${symbol_dollar}{MVN_BUILD_PARAMS}
}

start_local() {
    ${symbol_dollar}MVN_EXEC package exec:exec@start-docker cargo:run ${symbol_dollar}{MVN_BUILD_PARAMS}
}

down_docker() {
    ${symbol_dollar}MVN_EXEC package exec:exec@stop-docker -N ${symbol_dollar}{MVN_BUILD_PARAMS}
}

purge() {
    ${symbol_dollar}MVN_EXEC package exec:exec@purge-docker -N ${symbol_dollar}{MVN_BUILD_PARAMS}
    ${symbol_dollar}MVN_EXEC clean ${symbol_dollar}{MVN_BUILD_PARAMS}
}

build() {
    ${symbol_dollar}MVN_EXEC package ${symbol_dollar}{MVN_BUILD_PARAMS}
}

reload_share() {
    docker-compose -f ${symbol_dollar}COMPOSE_FILE_PATH kill ${rootArtifactId}-share
    yes | docker-compose -f ${symbol_dollar}COMPOSE_FILE_PATH rm -f ${rootArtifactId}-share
    ${symbol_dollar}MVN_EXEC clean package -pl ${rootArtifactId}-share,${rootArtifactId}-share-docker
    docker-compose -f ${symbol_dollar}COMPOSE_FILE_PATH up --build -d ${rootArtifactId}-share
}

reload_acs() {
    docker-compose -f ${symbol_dollar}COMPOSE_FILE_PATH kill ${rootArtifactId}-acs
    yes | docker-compose -f ${symbol_dollar}COMPOSE_FILE_PATH rm -f ${rootArtifactId}-acs
    ${symbol_dollar}MVN_EXEC clean package -pl ${rootArtifactId}-platform,${rootArtifactId}-platform-docker
    docker-compose -f ${symbol_dollar}COMPOSE_FILE_PATH up --build -d ${rootArtifactId}-acs
}

tail() {
    ${symbol_dollar}MVN_EXEC package exec:exec@tail-docker -N ${symbol_dollar}{MVN_BUILD_PARAMS}
}

tail_all() {
    ${symbol_dollar}MVN_EXEC package exec:exec@tail-all-docker -N ${symbol_dollar}{MVN_BUILD_PARAMS}
}

test() {
    ${symbol_dollar}MVN_EXEC verify ${symbol_dollar}{MVN_BUILD_PARAMS}
}

help() {
    echo "Usage: ${symbol_dollar}0 {build_start|start|stop|purge|tail|reload_share|reload_acs|build_test|test}"
    echo "Or   : ${symbol_dollar}0 {build_start|start|stop|purge|tail|build_test|test} local"
}

case "${symbol_dollar}1" in
  build_start)
    if [ "$2"=="local" ]; then
        start_local
    else
        build
        start_docker
    fi
    ;;
  start)
    if [ "$2"=="local" ]; then
        start_local
    else
        start_docker
    fi
    ;;
  stop)
    down_docker
    ;;
  purge)
    purge
    ;;
  tail)
    tail
    ;;
  reload_share)
    if [ "$2"=="local" ]; then
        help
    else
        reload_share
    fi
    ;;
  reload_acs)
    if [ "$2"=="local" ]; then
        help
    else
        reload_acs
    fi
    ;;
  build_test)
    test
    tail_all
    down_docker
    ;;
  test)
    test
    ;;
  *)
    help
esac