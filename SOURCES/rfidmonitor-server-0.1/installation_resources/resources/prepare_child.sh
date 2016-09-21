#!/bin/sh

#set -e;

#Parameters
appDir="/opt/rfidmonitor/platform";
dbAppConfigFile="/opt/rfidmonitor/platform/server/config/db/postgres.json";
sslAppDir="/opt/rfidmonitor/platform/server/config/ssl";
sslFiles="$sslAppDir/platform-cert.pem $sslAppDir/platform-cert-req.csr  $sslAppDir/platform-key.pem";
missingSsl=false;


if [ "$(whoami)" != "nodejs" ]; then
        echo "This script must be executed as user 'nodejs'. Aborting.";
        exit 1;
fi

echo "--------------------------------------";
echo " DB CONFIG";
echo "--------------------------------------";

echo "Be sure your DB config file is containing the correct access information.";
echo "File: $dbAppConfigFile";
printf "\n";

while true; do
    read -p "Is your DB configuration file OK? [y/n] " yn
    case $yn in
        [Yy]* )
		if  /usr/local/bin/node $appDir/test/dbCheck.js ;then
        		echo "DB connection OK.";
		else
			echo "DB connection FAILED.";
			echo "Please confirm if the database is online or your configuration file is OK.";
			exit 1;
		fi
	break;;
        [Nn]* ) echo "So, please review your DB config file. Aborting."; exit 1 ;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "--------------------------------------";
echo "SSL CONFIG";
echo "--------------------------------------";
echo "Checking the if ssl files are present;"
	for sslFile in $sslFiles
	do
		printf "File $sslFile : ";
		if [ ! -f $sslFile ]; then
			echo "MISSING.";
			missingSsl=true;
		else
			echo "PRESENT.";
		fi
	done

	if [[ "$missingSsl" == true ]] ;then
		while true; do
    			read -p "There are one or more missing ssl files. Do you want help to regenerate all ssl files? [y/n] " yn
    			case $yn in
        		[Yy]* )
				openssl genrsa -out $sslAppDir/platform-key.pem 1024 &&
				openssl req -new -key $sslAppDir/platform-key.pem -out $sslAppDir/platform-cert-req.csr &&
				openssl x509 -req -in $sslAppDir/platform-cert-req.csr -signkey $sslAppDir/platform-key.pem -out $sslAppDir/platform-cert.pem ;
        		break;;
        		[Nn]* ) echo "So, please generate the missing file[s] manually. Aborting."; exit 1 ;;
        		* ) echo "Please answer yes or no.";;
    			esac
		done
	fi
  
echo "--------------------------------------";
echo "APP STARTUP CONFIG";
echo "--------------------------------------";
#multi core
	#pm2 start /opt/rfidmonitor/platform/app.js --name "rfidplatform" -i 0;

#single core
	echo "Stopping any rfidplatform running.";
	pm2 stop rfidplatform > /dev/null 2>&1;
	echo "Starting rfidplatform app";
	pm2 start $appDir/app.js --name "rfidplatform" &&
	echo "Saving current apps" &&
	pm2 save &&
	echo "Done." ;

echo "--------------------------------------";
echo "--- SELFTEST"
echo "--------------------------------------";

printf "Checking 'https://localhost:8143' ";

tries_counter=0;
while ! curl --insecure https://localhost:8143/ > /dev/null 2>&1 ; do
        printf ".";
        tries_counter=$((tries_counter+1));
        if [[ "$tries_counter" -gt 5 ]]; then
                printf "\n";
                echo "Selftest failed: The app is not completely online. Please check the app logs using 'pm2 logs' as nodejs user.";
                exit 1;
        fi
        sleep 2;
done;

echo "[OK]";

echo "--------------------------------------";
echo "THE APPLICATION IS READY TO USE."
echo "--------------------------------------";
