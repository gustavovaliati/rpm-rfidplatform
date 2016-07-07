#!/bin/sh
if [ "$(whoami)" == "nodejs" ]; then
		echo "User: nodejs.";
		printf "Executing script to create ssl cert files..." &&
		/opt/rfidmonitor/installation_resources/resources/prepare_ssl.sh &&
		echo "Done." &&
		printf "Executing script to selftest" &&
		/opt/rfidmonitor/installation_resources/resources/platform_selftest.sh &&
		echo "Done." &&
		printf "Executing script to prepare pm2 to get the app online..." &&
		/opt/rfidmonitor/installation_resources/resources/prepare_startup.sh && 
		echo "Done." || exit 1;
else
	if sudo -v > /dev/null 2>&1; then
		echo "User: not nodejs. Using 'runuser' ";

		printf "Executing script to create ssl cert files..." &&
		sudo runuser -l nodejs -c '/opt/rfidmonitor/installation_resources/resources/prepare_ssl.sh' &&
		echo "Done." &&
		printf "Executing script to selftest" &&
		sudo runuser -l nodejs -c '/opt/rfidmonitor/installation_resources/resources/platform_selftest.sh' &&
		echo "Done." &&
		printf "Executing script to prepare pm2 to get the app online..." &&
		sudo runuser -l nodejs -c '/opt/rfidmonitor/installation_resources/resources/prepare_startup.sh' &&
		echo "Done." || exit 1;
	else
		echo "Failed to use 'sudo' . Does the current user have 'sudo' permissions? Did you type its password too many times wrong? Switch to user 'nodejs' that not requires sudo, or get sudoers permission for the current user.";
		exit 1;
	fi
fi
