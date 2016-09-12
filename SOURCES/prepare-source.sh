#!/bin/sh
sourcesdir=/usr/src/redhat/SOURCES;
cd $sourcesdir;
rm RFIDPlatformServerPreparationPackage-0.1.tar;
if [ ! -d "RFIDPlatformServerPreparationPackage-0.1/platform" ]; then
	git clone https://github.com/CELTAB/rfidmonitor-platform.git RFIDPlatformServerPreparationPackage-0.1/platform &&
	cd RFIDPlatformServerPreparationPackage-0.1/platform &&
	npm run deploy &&
	cd .. &&
	tar -cf platform.tar platform/;
fi
if [ ! -f RFIDPlatformServerPreparationPackage-0.1/node-v4.4.0-linux-x64.tar.gz ]; then
	cd RFIDPlatformServerPreparationPackage-0.1/ ;
	curl -O https://nodejs.org/download/release/v4.4.0/node-v4.4.0-linux-x64.tar.gz ;
fi
cd $sourcesdir/RFIDPlatformServerPreparationPackage-0.1 &&
tar -cf installation_resources.tar installation_resources/ && 
cd $sourcesdir &&
tar -cf RFIDPlatformServerPreparationPackage-0.1.tar RFIDPlatformServerPreparationPackage-0.1/;
