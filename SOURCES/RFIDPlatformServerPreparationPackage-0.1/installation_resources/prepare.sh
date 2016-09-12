#!/bin/sh
if [ "$(whoami)" == "nodejs" ]; then
		echo "User: nodejs.";
		/opt/rfidmonitor/installation_resources/resources/prepare_child.sh;
else
	if sudo -v > /dev/null 2>&1; then
		echo "User: not nodejs. Using 'runuser' ";
		sudo runuser -l nodejs -c '/opt/rfidmonitor/installation_resources/resources/prepare_child.sh'; 
	else
		echo "Failed to use 'sudo' . Does the current user have 'sudo' permissions? Did you type its password too many times wrong? Switch to user 'nodejs' that not requires sudo, or get sudoers permission for the current user.";
		exit 1;
	fi
fi
