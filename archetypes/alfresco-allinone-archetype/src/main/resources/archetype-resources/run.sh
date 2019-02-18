#set( $symbol_dollar = '$' )
#!/bin/sh

if [ -z "${symbol_dollar}{M2_HOME}" ]; then
  export MVN_EXEC="mvn"
else
  export MVN_EXEC="${symbol_dollar}{M2_HOME}/bin/mvn"
fi

case "${symbol_dollar}1" in
  build_start)
    ${symbol_dollar}MVN_EXEC package docker:build docker:volume-create docker:start cargo:run
    ;;
  start)
    ${symbol_dollar}MVN_EXEC package docker:start cargo:run
    ;;
  start_tomcat)
    ${symbol_dollar}MVN_EXEC package cargo:run
    ;;
  stop)
    ${symbol_dollar}MVN_EXEC package docker:stop -DskipTests=true
    ;;
  purge)
    ${symbol_dollar}MVN_EXEC clean
    ;;
  build_test)
    ${symbol_dollar}MVN_EXEC verify
    ;;
  *)
    echo "Usage: ${symbol_dollar}0 {build_start|start|start_tomcat|stop|purge|build_test}"
esac