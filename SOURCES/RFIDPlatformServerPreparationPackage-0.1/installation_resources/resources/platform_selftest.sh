#!/bin/sh

printf "Checking https://localhost:8143... ";

if curl --insecure https://localhost:8143/ > /dev/null 2>&1 ; then
        echo "OK.";
else
	echo "ERROR. Curl code: $?";
        echo "Selftest failed: The app is not completely online. Please check the app logs using 'pm2 logs' as nodejs user.";
        exit 1;
fi
