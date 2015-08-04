#!/bin/bash

if [ ! -f /etc/rundeck/profile ]; then
	cp -Rfp /etc/rundeck-org/* /etc/rundeck/
fi

chown -Rf rundeck:rundeck /etc/rundeck /var/rundeck /var/lib/rundeck
chmod -Rf o-rwx /etc/rundeck /var/rundeck /var/lib/rundeck

chown -Rf :adm /var/lib/rundeck/logs
chmod g+s,o+x /var/lib/rundeck/logs

. /etc/rundeck/profile

DAEMON="java"
DAEMON_ARGS="${RDECK_JVM} -cp ${BOOTSTRAP_CP} com.dtolabs.rundeck.RunServer /var/lib/rundeck 4440"

rundeckd="$DAEMON $DAEMON_ARGS"

su rundeck -s /bin/bash -c "$rundeckd"
