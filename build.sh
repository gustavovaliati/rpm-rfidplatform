#!/bin/sh
sudo ls;
/usr/src/redhat/SOURCES/prepare-source.sh &&
sudo rpmbuild -ba /usr/src/redhat/SPECS/rfidplatform.spec;
