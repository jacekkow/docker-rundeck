#!/bin/bash

if [ ! -f /etc/rundeck/profile ]; then
	cp -Rfp /etc/rundeck-org/* /etc/rundeck/
fi

chown -Rf rundeck:rundeck /etc/rundeck /var/rundeck /var/lib/rundeck
chmod -Rf o-rwx /etc/rundeck /var/rundeck /var/lib/rundeck

chown -Rf :adm /var/lib/rundeck/logs
chmod g+s,o+x /var/lib/rundeck/logs

. /etc/rundeck/profile

# Rundeck 2.6 to 2.7 migration - new profile file
if [ -z "$rundeckd" ]; then
	mv -f /etc/rundeck/profile /etc/rundeck/profile.pre-migration
	cp -f /etc/rundeck-org/profile /etc/rundeck/profile
	. /etc/rundeck/profile
fi

su rundeck -s /bin/bash -c "$rundeckd"
