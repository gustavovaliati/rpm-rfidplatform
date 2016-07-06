#!/bin/sh

#multi core
#pm2 start /opt/rfidmonitor/platform/app.js --name "rfidplatform" -i 0;

#single core
if [ "$(whoami)" == "nodejs" ]; then
	pm2 stop rfidplatform > /dev/null 2>&1;
	pm2 start /opt/rfidmonitor/platform/app.js --name "rfidplatform" > /dev/null 2>&1 &&
	pm2 save > /dev/null 2>&1 &&
	pm2 startup redhat > /dev/null 2>&1;

elif [ "$(whoami)" == "root" ]; then

	runuser -l nodejs -c 'pm2 stop rfidplatform > /dev/null 2>&1; pm2 start /opt/rfidmonitor/platform/app.js --name "rfidplatform" > /dev/null 2>&1 && pm2 save > /dev/null 2>&1 && pm2 startup redhat > /dev/null 2>&1;'
else
	echo "This script must be executed as user 'nodejs' or 'root'";
	exit 1;
fi