#!/bin/sh
(sudo rpm -e RFIDPlatformServerPreparationPackage-0.1-1.x86_64 || true)  &&
sudo rpm -ivh /usr/src/redhat/RPMS/x86_64/RFIDPlatformServerPreparationPackage-0.1-1.x86_64.rpm;
