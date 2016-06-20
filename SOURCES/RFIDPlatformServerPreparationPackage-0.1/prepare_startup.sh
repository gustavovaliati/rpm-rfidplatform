#!/bin/sh

#multi core
#pm2 start /opt/rfidmonitor/platform/app.js --name "rfidplatform" -i 0;

#single core
if [ "$(whoami)" == "nodejs" ]; then
echo "sou nodejs";
	pm2 stop rfidplatform;
	pm2 start /opt/rfidmonitor/platform/app.js --name "rfidplatform" &&
	pm2 save &&
	pm2 startup redhat;

elif [ "$(whoami)" == "root" ]; then

	runuser -l nodejs -c 'pm2 stop rfidplatform; pm2 start /opt/rfidmonitor/platform/app.js --name "rfidplatform" && pm2 save && pm2 startup redhat;'
else
	echo "This script must be executed as user 'nodejs' or 'root'";
	exit 1;
fi
