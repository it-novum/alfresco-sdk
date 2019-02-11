#set( $symbol_dollar = '$' )
#!/bin/sh

if [ -z "${symbol_dollar}{M2_HOME}" ]; then
  export MVN_EXEC="mvn"
else
  export MVN_EXEC="${symbol_dollar}{M2_HOME}/bin/mvn"
fi

case "${symbol_dollar}1" in
  build_start)
    ${symbol_dollar}MVN_EXEC clean package docker:build docker:volume-create docker:start
    ;;
  start)
    ${symbol_dollar}MVN_EXEC docker:start
    ;;
  stop)
    ${symbol_dollar}MVN_EXEC docker:stop -pl ${rootArtifactId}-share-docker
    ${symbol_dollar}MVN_EXEC docker:stop
    ;;
  purge)
    ${symbol_dollar}MVN_EXEC docker:stop -pl ${rootArtifactId}-share-docker
    ${symbol_dollar}MVN_EXEC docker:stop docker:remove docker:volume-remove
    ;;
  tail)
    ${symbol_dollar}MVN_EXEC docker:logs -Ddocker.logAll=true -Ddocker.follow -pl ${rootArtifactId}-platform-docker
    ;;
  tail_share)
    ${symbol_dollar}MVN_EXEC docker:logs -Ddocker.logAll=true -Ddocker.follow -pl ${rootArtifactId}-share-docker
    ;;
  reload_share)
    ${symbol_dollar}MVN_EXEC docker:stop package docker:build docker:start -pl ${rootArtifactId}-share,${rootArtifactId}-share-docker
    ;;
  reload_acs)
    ${symbol_dollar}MVN_EXEC docker:stop package docker:build docker:start -pl ${rootArtifactId}-platform,${rootArtifactId}-integration-tests,${rootArtifactId}-platform-docker
    ;;
  build_test)
    ${symbol_dollar}MVN_EXEC clean verify
    ;;
  test)
    ${symbol_dollar}MVN_EXEC verify
    ;;
  *)
    echo "Usage: ${symbol_dollar}0 {build_start|start|stop|purge|tail|tail_share|reload_share|reload_acs|build_test|test}"
esac