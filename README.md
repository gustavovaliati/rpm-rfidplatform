# rpm-rfidplatform

## Building the RPM package

1. Do not use the 'root' user in the building process;
2. Place this source in '/usr/src/redhat/' ; 
  1. sudo mkdir -p /usr/src/redhat;
  2. git clone https://github.com/gustavovaliati/rpm-rfidplatform.git /usr/src/redhat
3. Then, to build the package execute the 'build.sh' script.
  1. cd /usr/src/redhat;
  2. ./build.sh;

