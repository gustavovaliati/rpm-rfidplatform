#!/bin/sh
if [ "$(whoami)" == "root" ]; then
	echo "Do not execute the building process as root.";
	exit 1;
fi

/usr/src/redhat/SOURCES/prepare-source.sh &&
rpmbuild -ba /usr/src/redhat/SPECS/rfidplatform.spec;
