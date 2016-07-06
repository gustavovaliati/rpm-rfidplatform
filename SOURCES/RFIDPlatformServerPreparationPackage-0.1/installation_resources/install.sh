#!/bin/sh
BASE_FOLDER="/opt/rfidmonitor/installation_resources/";

printf "Executing script to create ssl cert files..." &&
$BASE_FOLDER/resources/prepare_ssl.sh &&
echo "Done." &&
printf "Executing script to selftest" &&
$BASE_FOLDER/resources/platform_selftest.sh &&
echo "Done." &&
printf "Executing script to prepare pm2 to get the app online..." &&
$BASE_FOLDER/resources/prepare_startup.sh;
echo "Done." ;

