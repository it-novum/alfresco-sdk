# Alfresco AIO Project - SDK 4.0

This is an All-In-One (AIO) project for Alfresco SDK 4.0.

Run with `./run.sh build_start` or `./run.bat build_start` and verify that it

 * Runs Alfresco Content Service (ACS)
 * Runs Alfresco Share
 * Runs Alfresco Search Service (ASS)
 * Runs PostgreSQL database
 * Deploys the JAR assembled modules
 
All the services of the project are now run as docker containers. The run script offers the next tasks:

 * `build_start`. Build the whole project, recreate the ACS and Share docker images, start the dockerised environment composed by ACS, Share, ASS and 
 PostgreSQL and tail the logs of all the containers.
 * `start`. Start the dockerised environment without building the project and tail the logs of all the containers.
 * `stop`. Stop the dockerised environment.
 * `purge`. Stop the dockerised container and delete all the persistent data (docker volumes).
 * `tail`. Tail the logs of all the containers.
 * `reload_share`. Build the Share module, recreate the Share docker image and restart the Share container.
 * `reload_acs`. Build the ACS module, recreate the ACS docker image and restart the ACS container.
 * `build_test`. Build the whole project, recreate the ACS and Share docker images, start the dockerised environment, execute the integration tests from the
 `integration-tests` module and stop the environment.
 * `test`. Execute the integration tests (the environment must be already started).

# Few things to notice

 * No parent pom
 * No WAR projects, the jars are included in the custom docker images
 * No runner project - the Alfresco environment is now managed through [Docker](https://www.docker.com/)
 * Standard JAR packaging and layout
 * Works seamlessly with Eclipse and IntelliJ IDEA
 * JRebel for hot reloading, JRebel maven plugin for generating rebel.xml [JRebel integration documentation]
 * AMP as an assembly
 * Persistent test data through restart thanks to the use of Docker volumes for ACS, ASS and database data
 * Integration tests module to execute tests against the final environment (dockerised)
 * Resources loaded from META-INF
 * Web Fragment (this includes a sample servlet configured via web fragment)

# Running local deployment (experimental)

The project supports running ACS and Share in the local tomcat mode. In that mode the database and ASS are run within the docker containers but ACS and Share are deployed in a locally installed tomcat.

To run the project in that mode add `local` parameter to the run command.  E.g. `./run.sh build_start local`. You will need to add that parameter to any run command you want to execute (including purge). Please also note that reloading share and acs commands are not available at the moment in the local mode.

**Important!** You can only run in the local mode or container mode - you cannot mix modes. If you want to change the mode, you need to execute purge first.

**Important!** At the moment, the configuration files for the local mode are separate from the container mode. They are located in the `[artifactId]-integration-tests/src/main/tomcat` folder. Also, the additional extension modules that need to be deployed are configured separately - please look into `[artifactId]-integration-tests/pom.xml` and plugin executions with ids `collect-acs-extensions` and `collect-share-extensions`.

# Running with maven commands

The project (in both modes) can be also run mostly in with pure maven commands. For example instead of `run build_test` you can execute `mvn verify`. The exact commands depend on the mode - please have a look into the run script.  

# TODO

  * Abstract assembly into a dependency so we don't have to ship the assembly in the archetype
  * Functional/remote unit tests
