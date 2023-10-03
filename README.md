
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Tomcat Connection Pool Exhaustion Incident
---

Tomcat Connection Pool Exhaustion Incident occurs when the maximum number of connections that a Tomcat server can handle has been reached. This can happen due to an increase in traffic or a sudden surge in user activity. When the connection pool is exhausted, new requests cannot be handled, and the application may become unavailable. This type of incident requires immediate attention to ensure that the application is restored to its normal functioning state.

### Parameters
```shell
export VERSION="PLACEHOLDER"

export WEBAPP_NAME="PLACEHOLDER"

export USERNAME="PLACEHOLDER"

export PASSWORD="PLACEHOLDER"

export NEW_CONNECTION_POOL_SIZE="PLACEHOLDER"

export PATH_TO_TOMCAT="PLACEHOLDER"

export PATH_TO_TOMCAT_CONFIG_FILE="PLACEHOLDER"
```

## Debug

### Check if Tomcat server is running
```shell
systemctl status tomcat ${VERSION}
```

### Check if there are any errors in the Tomcat logs
```shell
tail -n 100 /var/log/tomcat${VERSION}/catalina.out
```

### Check the number of active database connections
```shell
sudo -u postgres psql -c "SELECT datname,numbackends FROM pg_stat_database;"
```

### Check the maximum number of connections allowed in the connection pool configuration
```shell
grep "maxActive" /opt/tomcat${VERSION}/conf/context.xml
```

### Check the current number of open connections in the connection pool
```shell
curl -u ${USERNAME}:${PASSWORD} http://localhost:8080/manager/jmxproxy/?get=Tomcat%3Atype%3DDatasource%2Ccontext%3D%2F${WEBAPP_NAME}%2Chost%3Dlocalhost&att=Active
```

### Check the available memory on the server
```shell
free -m
```

## Repair

### Increase the connection pool size to accommodate more incoming connections.
```shell


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


```