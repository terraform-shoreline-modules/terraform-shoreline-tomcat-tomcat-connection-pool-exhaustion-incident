

#!/bin/bash



# Set the variables

TOMCAT_HOME=${PATH_TO_TOMCAT}

CONFIG_FILE=${PATH_TO_TOMCAT_CONFIG_FILE}

POOL_SIZE=${NEW_CONNECTION_POOL_SIZE}



# Stop the Tomcat server

$TOMCAT_HOME/bin/shutdown.sh



# Update the connection pool size in the Tomcat config file

sed -i "s/maxActive=\"[0-9]*\"/maxActive=\"$POOL_SIZE\"/g" $CONFIG_FILE



# Start the Tomcat server

$TOMCAT_HOME/bin/startup.sh