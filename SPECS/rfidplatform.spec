#definitions
%define _topdir		%{_usrsrc}/redhat
%define finaldir	/opt/rfidmonitor
%define buildroot	%{_tmppath}/%{name}-%{version}-root

Name: 		RFIDPlatformServerPreparationPackage
Version:	0.1
Release:	1
Summary:	Monitoring Platform - ITAIPU's DAM Piracema channel use case.
Group:		Applications/System
License:	GPLv3
Vendor:		CELTAB celtab@pti.org.br
Packager:	Gustavo Valiati <gustavovaliati@gmail.com>
Source:		RFIDPlatformServerPreparationPackage-0.1.tar
URL:		https://github.com/CELTAB/rpm-rfidplatform.git
Prefix:		%{_prefix}
Requires:	/bin/bash, /bin/sh
Buildroot:	%{buildroot}
ExclusiveArch:	x86_64
Exclusiveos:	Linux
AutoReqProv: no


%description

RFIDPlatformServerPreparationPackage is able to prepare the server side
application for the RFIDMonitor project. After installing the package,
the Monitoring Platform will be online, ready to interact with the database
server and the Collecting Points, receiving and processing the RFID data.
The package comes with nodejs, pm2 and a post-install script to help in
the configuration of database connection, ssl certs, and a small self test.
Be aware it does not include the database server.

%prep
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

%setup -q

%build

%install
mkdir -p %{buildroot}%{finaldir};
mkdir -p %{buildroot}/usr/local/;
tar -xf node-v4.4.0-linux-x64.tar.gz -C %{buildroot}/usr/local/ --strip 1;
rm %{buildroot}/usr/local/LICENSE ;
rm %{buildroot}/usr/local/README.md ;
rm %{buildroot}/usr/local/CHANGELOG.md ;

tar -xf pm2.tar -C %{buildroot};
tar -xf platform.tar -C %{buildroot}%{finaldir};
tar -xf installation_resources.tar -C %{buildroot}%{finaldir};

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

%pre

# Open TCP port 80, 443, 8124;
printf "Firewall - opening port 443/tcp: ";
firewall-cmd --add-port=443/tcp --permanent;
printf "Firewall - opening port 80/tcp: ";
firewall-cmd --add-port=80/tcp --permanent;
printf "Firewall - opening port 8124/tcp: ";
firewall-cmd --add-port=8124/tcp --permanent;

# Redirect port 80 to 8180 and Redirect port 443 to 8143;
printf "Firewall - redirecting port 443/tcp to 8143: ";
firewall-cmd --add-forward-port=port=443:proto=tcp:toport=8143 --permanent;
printf "Firewall - redirecting port 80/tcp to 8180: ";
firewall-cmd --add-forward-port=port=80:proto=tcp:toport=8180 --permanent;
printf "Firewall - reloading: ";
firewall-cmd --reload;

# Create nodejs user;
printf "Creating 'nodejs' user: ";
adduser nodejs -g users || true ;

%post

printf "Changing permissions to %{finaldir} ..."
chown -R nodejs:users %{finaldir} &&
echo "Done." &&
printf "Deploying pm2 startup script..." &&
sudo su -c "env PATH=$PATH:/usr/local/bin pm2 startup redhat -u nodejs --hp /home/nodejs > /dev/null 2>&1" &&
echo "Done." &&
echo "Package installation... Done." &&
printf "\n" &&
echo "[ ! ] Now run the following script as nodejs user:" &&
echo "      %{finaldir}/installation_resources/prepare.sh" &&
printf "\n" || 
exit 1;

%preun
echo "Uninstalling package...";

echo "Closing firewall ports...";
printf "Firewall - closing port 443/tcp: ";
firewall-cmd --remove-port=443/tcp --permanent;
printf "Firewall - closing port 80/tcp: ";
firewall-cmd --remove-port=80/tcp --permanent;
printf "Firewall - closing port 8124/tcp: ";
firewall-cmd --remove-port=8124/tcp --permanent;
printf "Firewall - removing redirection from port 443/tcp to 8143: ";
firewall-cmd --remove-forward-port=port=443:proto=tcp:toport=8143 --permanent;
printf "Firewall - removing redirection from port 80/tcp to 8180: ";
firewall-cmd --remove-forward-port=port=80:proto=tcp:toport=8180 --permanent;
printf "Firewall - reloading: ";
firewall-cmd --reload;

if [ "$(whoami)" == "nodejs" ]; then
	printf "Stopping server and removing from startup... " ; 
	pm2 stop rfidplatform > /dev/null 2>&1 ;
	pm2 delete rfidplatform > /dev/null 2>&1 ;
	pm2 save > /dev/null 2>&1 ;
	echo "Done.";
else
	if sudo -v > /dev/null 2>&1; then
                echo "User: not nodejs. Using 'runuser' ";
		printf "Stopping server and removing from startup... " ;
                sudo runuser -l nodejs -c 'pm2 stop rfidplatform > /dev/null 2>&1' ;
		sudo runuser -l nodejs -c 'pm2 delete rfidplatform > /dev/null 2>&1' ;
		sudo runuser -l nodejs -c 'pm2 save > /dev/null 2>&1' ;
                echo "Done."; 
	else
                echo "Failed to use 'sudo' . Does the current user have 'sudo' permissions? Did you type its password too many times wrong? Switch to user 'nodejs' that not requires sudo, or get sudoers permission for the current user.";
                exit 1;
        fi
fi

%postun
echo "[ ! ] WARNING"
echo "The nodejs user was not removed purposely.";
echo "The new or modified files were not removed. Check %{finaldir}";
echo "UNINSTALL FINISHED.";

%files
%{finaldir}
/usr/local/bin/pm2
/usr/local/bin/pm2-dev
/usr/local/bin/npm
/usr/local/bin/node
/usr/local/share/man/man1/node.1
/usr/local/share/systemtap/tapset/node.stp
/usr/local/share/doc/node/
/usr/local/include/node/
/usr/local/lib/node_modules/

%changelog
* Mon Sep 05 2016 Gustavo Valiati <gustavovaliati@gmail.com> v1.0
- Initial release.
