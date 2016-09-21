#!/bin/sh
sourcesdir=/usr/src/redhat/SOURCES;
cd $sourcesdir;
rm rfidmonitor-server-0.1.tar;
if [ ! -d "rfidmonitor-server-0.1/platform" ]; then
	cd $sourcesdir;
	git clone https://github.com/CELTAB/rfidmonitor-platform.git rfidmonitor-server-0.1/platform &&
	cd rfidmonitor-server-0.1/platform &&
	npm run deploy; 
fi
if [ ! -f "rfidmonitor-server-0.1/platform.tar" ]; then
	cd $sourcesdir;
	cd rfidmonitor-server-0.1/ &&
	tar -cf platform.tar platform/;
fi
if [ ! -f rfidmonitor-server-0.1/node-v4.4.0-linux-x64.tar.gz ]; then
	cd $sourcesdir;
	cd rfidmonitor-server-0.1/ ;
	curl -O https://nodejs.org/download/release/v4.4.0/node-v4.4.0-linux-x64.tar.gz ;
fi
cd $sourcesdir/rfidmonitor-server-0.1 &&
tar -cf installation_resources.tar installation_resources/ && 
cd $sourcesdir &&
tar -cf rfidmonitor-server-0.1.tar rfidmonitor-server-0.1/;
