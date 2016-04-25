#!/usr/bin/env bash

set -e

APP_NAME="application"
APP_REPO="deb http://foo.bar"
APP_CONFIG_FILE=/etc/myapp.conf

# install 
echo  ${APP_REPO} >> /etc/apt/sources.list.d/${APP_NAME}.list
apt-get update
apt-get install ${APP_NAME}

# change configuration
sed 's/old_line/new_line/g' < ${APP_CONFIG_FILE} > ${APP_CONFIG_FILE}.tmp && mv ${APP_CONFIG_FILE}.tmp ${APP_CONFIG_FILE}


# appended tar.gz with compressed files
# to be extracted at root fs path /
# It's nice to include a /lib/systemd/system/${APP_NAME}.service
# to handle initialization on boot
ARCHIVE=$(awk '/^ARCHIVE_HERE$/{print NR +1; exit 0;}' "$0")
echo ${ARCHIVE}
tail -n+${ARCHIVE} "$0" | tar -pxzsv -C /

# Enable on boot and start
/bin/systemctl daemon-reload
/bin/systemctl enable ${APP_NAME}.service
/bin/systemctl start ${APP_NAME}.service

exit 0

ARCHIVE_HERE
