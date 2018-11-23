#!/bin/bash

if [ ! -f /etc/rundeck/profile ]; then
	cp -Rfp /etc/rundeck-org/* /etc/rundeck/
fi

# Rundeck 3.0 - new property
if ! grep -q -e "^rundeck.log4j.config.file" /etc/rundeck/rundeck-config.properties; then
	echo "rundeck.log4j.config.file = /etc/rundeck/log4j.properties" \
		>> /etc/rundeck/rundeck-config.properties
fi

# Rundeck 2.7, 3.0 - new profile
cp -fp /etc/rundeck-org/profile /etc/rundeck/profile

chown -Rf rundeck:rundeck /etc/rundeck /var/rundeck /var/lib/rundeck
chmod -Rf o-rwx /etc/rundeck /var/rundeck /var/lib/rundeck

chown -Rf :adm /var/lib/rundeck/logs
chmod g+s,o+x /var/lib/rundeck/logs

. /etc/rundeck/profile

su rundeck -s /bin/bash -c "$rundeckd"
