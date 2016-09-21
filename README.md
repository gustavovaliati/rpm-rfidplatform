# rpm-rfidplatform - rfidmonitor-server

## Intro

This is a source to build a rpm package (rfidmonitor-server | temporary name) using the rpmbuild tool.

rfidmonitor-server is able to prepare the server side
application for the RFIDMonitor project. After installing the package,
the Monitoring Platform will be online, ready to interact with the database
server and the Collecting Points, receiving and processing the RFID data.
The package comes with Node.js, PM2 and a post-install script to help in
the configuration of database connection, ssl certs, and a small self test.
Be aware it does not include the database server.

## Building the RPM package

### Requirements

To build the package it is necessary to have:
* Internet connection;
* Node.js v4.4.0;
* Git;
* rpmbuild package;
* O.S.: Redhat 7. 

### Build

Be sure to not use the 'root' user in the building process, then:

1. Place this source in '/usr/src/redhat/' :
```sh
$ sudo mkdir -p /usr/src/redhat;
$ git clone https://github.com/gustavovaliati/rpm-rfidplatform.git /usr/src/redhat ;
```
2. Execute the 'build.sh' script:

```sh
$ cd /usr/src/redhat;
$ ./build.sh;
```

> The script will download the Node.js v4.4.0 bynaries and the 'rfidplatform' application. Then will download and install the application package.json dependencies, and compress everything in a tar file. By the end the script executes the rpmbuild tool, running the spec file over the sources.

## Installing the package

### Requirements

* Operational System: Redhat 7;
* User: root or any user with sudo permissions;
* Database: PostgreSQL server 9.4, running and accessible by remote hosts, and the db user having permissions to create/modify tables.
* NOT necessary: Internet connection or any other tool/software;

### Installing

1. Login with the user 'root' or any other user with sudo permissions;
2. Configure the firewall:
    * 2.1. Open TCP ports 80, 443, 8124:
    ```sh
    # firewall-cmd --add-port=443/tcp --permanent;
    # firewall-cmd --add-port=80/tcp --permanent;
    # firewall-cmd --add-port=8124/tcp --permanent;
    ```
    * 2.2. Redirect ports 80 to 8180 and 443 to 8143:
    ```sh
    # firewall-cmd --add-forward-port=port=443:proto=tcp:toport=8143 --permanent;
    # firewall-cmd --add-forward-port=port=80:proto=tcp:toport=8180 --permanent;
    ```
    * 2.3 Reload the firewall:
    ```sh
    # firewall-cmd --reload;
    ```
3. Install the package:
> The package creates the nodejs user to use it as the app manager. Also create the folders under /opt/rfidmonitor and extract all app files into it, giving the 'nodejs' user the owndership.

```sh
# rpm -ivh rfidmonitor-server-0.1-1.x86_64.rpm
```

4. Configuring the app before the first start:
    * 4.1. Set the database connection information. Open and modify the following file changing the db credentials and directions:
    ```sh
    # vi /opt/rfidmonitor/platform/server/config/db/postgres.json ;
    ```
    > The postgres.json, as the extensions implies, is a JSON file and its structure looks like:
    
    ```json
    {
      "username": "john",
      "password": "myPassword",
      "ipaddress": "192.168.1.1",
      "portnumber": "5432",
      "dbname": "rfidplatform"
    }
    ```
    * 4.2. Place the ssl files. If you already have the 'key.pem' and 'cert.pem', place then into '/opt/rfidmonitor/platform/server/config/ssl/' with the following names respectively 'platform-key.pem' and 'platform-cert.pem'. Otherwise, jump to the next topic that will show you a helper to generate those ssl files.

    * 4.3. Execute the post installation script in order to check, configure and test the application:
    > This script will check your db configuration file (postgres.json), and your ssl files. If your files are missing, it will offer you help to generate the files: in this case, say 'yes' and answer the ssl questions in order to build the files for you. The script will also start up the application, register it for permanent initialization using PM2 and in the end a basic selftest will check if the application is online.
    
    ```sh
    # /opt/rfidmonitor/installation_resources/prepare.sh
    ```
    
    * 4.4. In this step the application should be online localy (localhost), and remotely. If something goes wrong in all the process the final selftest should present a failure. Then, look into the logs using the 'nodejs' with 'pm2 logs' command, or go manually into the logs folder '/opt/rfidmonitor/platform/server/logs/'.

5. Files structure. All the application source is under /opt/rfidmonitor. Node.js and PM2 bynaries are deployed in its default locations. Main files and folders are:
```sh
/opt/rfidmonitor/
/usr/local/bin/pm2
/usr/local/bin/pm2-dev
/usr/local/bin/npm
/usr/local/bin/node
/usr/local/share/man/man1/node.1
/usr/local/share/systemtap/tapset/node.stp
/usr/local/share/doc/node/
/usr/local/include/node/
/usr/local/lib/node_modules/
```

## Uninstalling

To uninstall the application, just run:

> This default uninstall process will stop the application, remove from initialization, and remove every file that have been installed by the package previously, but any new file created by the user in the package structure, such as logs, ssl files, uploaded files. Modified files as configuration files will be removed.

```sh
# rpm -e rfidmonitor-server-0.1-1.x86_64
```

Be aware that, manually, firewall ports must be closed and the 'nodejs' user should be removed. To revert the firewall configuration done in the installation section, execute:
```sh
# firewall-cmd --remove-port=443/tcp --permanent;
# firewall-cmd --remove-port=80/tcp --permanent;
# firewall-cmd --remove-port=8124/tcp --permanent;
# firewall-cmd --remove-forward-port=port=443:proto=tcp:toport=8143 --permanent;
# firewall-cmd --remove-forward-port=port=80:proto=tcp:toport=8180 --permanent;
# firewall-cmd --reload;
```

### Application status/management

To check the rfidplatform application status, it is necessary to use the 'pm2' tool while loggedin as the 'nodejs' user.
> It is mandatory to be logged in as 'nodejs' user.

1. To check the basic status use:
```sh
$ pm2 status
```

2. To check the application logs use:
```sh
$ pm2 logs
```

3. To start/stop/restart the rfidplatform application, use:
```sh
$ pm2 [stop or start or restart] rfidplatform
```

## TODO

* Remove external software from inside the package, and place then as package requirements;
* Prepare the system to be responsive to systemctl calls;

## External software

This source downloads and packages 'Node.js' and 'PM2' in a rpm file. Each of them have
their own documentation and licenses. The rfidmonitor-server does not
change rights or terms of 'Node.js' or 'PM2'. Any doubts about these external softwares
should checked in:
* Nodejs <https://github.com/nodejs>;
* PM2 <https://github.com/Unitech/pm2>;

