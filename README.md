# rpm-rfidplatform

## Intro

This is a source to build a rpm package (RFIDPlatformServerPreparationPackage) using the rpmbuild tool.

RFIDPlatformServerPreparationPackage is able to prepare the server side
application for the RFIDMonitor project. After installing the package,
the Monitoring Platform will be online, ready to interact with the database
server and the Collecting Points, receiving and processing the RFID data.
The package comes with nodejs, pm2 and a post-install script to help in
the configuration of database connection, ssl certs, and a small self test.
Be aware it does not include the database server.

## Requirements

* Internet connection;
* Node.js v4.4.0;
* Git;
* rpmbuild package;
* O.S.: Redhat 7

## Building the RPM package

1. Do not use the 'root' user in the building process;
2. Place this source in '/usr/src/redhat/' ; 
```
sudo mkdir -p /usr/src/redhat;
git clone https://github.com/gustavovaliati/rpm-rfidplatform.git /usr/src/redhat ;
```
3. Then, to build the package execute the 'build.sh' script.
```
cd /usr/src/redhat;
./build.sh;
```
