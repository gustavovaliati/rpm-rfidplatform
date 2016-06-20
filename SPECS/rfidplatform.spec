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
URL:		www.celtab.org.br
Vendor:		CELTAB celtab@pti.org.br
Packager:	Gustavo Valiati <gustavovaliati@gmail.com>
#Source:		https://github.com/CELTAB/rpm-rfidplatform.git
Source:		RFIDPlatformServerPreparationPackage-0.1.tar
Prefix:		%{_prefix}
#BuildRequires:	?
#Requires:	?
Buildroot:	%{buildroot}
ExclusiveArch:	x86_64
Exclusiveos:	Linux


%description
nothing yet
#TODO

%prep
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

%setup -q

%build

%install
mkdir -p %{buildroot}%{finaldir};
install -m 755 prepare_ssl.sh %{buildroot}%{finaldir}
install -m 755 prepare_startup.sh %{buildroot}%{finaldir}
install -m 755 platform.tar %{buildroot}%{finaldir}

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

%pre
printf "Checking node... ";
output=$(sudo su -c "env PATH=$PATH:/usr/local/bin node -v");
if echo "$?" > dev/null ; then
	expVersion="v4.4.0";
	if [ "$output" == "$expVersion" ]; then
		echo "SUCCESS.";
	else
		echo "FAIL: Expected version $expVersion but version $output found.";
		exit 1;
	fi
        
else
        echo "FAIL: Node probably not installed.";
	exit 1;
fi

printf "Checking npm... ";
output=$(sudo su -c "env PATH=$PATH:/usr/local/bin npm -v");
if echo "$?" > dev/null ; then
	echo "SUCCESS.";
        
else
        echo "FAIL: Node probably not installed.";
	exit 1;
fi

printf "Checking pm2... ";
output=$(sudo su -c "env PATH=$PATH:/usr/local/bin pm2 -v" | tail -1); #GET LAST LINE ONLY
if echo "$?" > dev/null ; then
	expVersion="1.1.3";
	if [ "$output" == "$expVersion" ]; then
		echo "SUCCESS.";
	else
		echo "FAIL: Expected version $expVersion but version $output found.";
		exit 1;
	fi
        
else
        echo "FAIL: Node package [pm2] probably not installed.";
	exit 1;
fi


printf "Checking user [nodejs]...";
if getent passwd nodejs > /dev/null 2>&1 ; then
        echo "SUCCESS: user already created."
else
	printf "Creating..."
        if adduser nodejs -g users --system --home-dir /home/nodejs && mkdir /home/nodejs && chown -R nodejs:users /home/nodejs > /dev/null 2>&1 ; then
                echo "SUCCESS: user has been created.";
        else
                echo "FAIL: failed while creating user [nodejs]";
                exit 1;
        fi
fi

printf "Checking hability to give permissions to nodejs user for %{finaldir}...";
if chown -R nodejs:users %{finaldir} > /dev/null 2>&1 ; then
        echo "SUCCESS.";
else
        echo "FAIL.";
        exit 1;
fi
%post
printf "Decompressing platform source...";
tar -xf %{finaldir}/platform.tar -C  %{finaldir} &&
rm %{finaldir}/platform.tar &&
echo "Done." &&
printf "Changing permissions to %{finaldir} ..."
chown -R nodejs:users %{finaldir} &&
echo "Done." &&
printf "Executing script to create ssl cert files..." &&
#%%{finaldir}/prepare_ssl.sh &&
openssl genrsa -out /opt/rfidmonitor/platform/server/config/ssl/platform-key.pem 1024 &&
openssl req -new -key /opt/rfidmonitor/platform/server/config/ssl/platform-key.pem -out /opt/rfidmonitor/platform/server/config/ssl/platform-cert-req.csr &&
openssl x509 -req -in /opt/rfidmonitor/platform/server/config/ssl/platform-cert-req.csr -signkey /opt/rfidmonitor/platform/server/config/ssl/platform-key.pem -out /opt/rfidmonitor/platform/server/config/ssl/platform-cert.pem &&
echo "Done." &&
printf "Executing script to prepare pm2 to get the app online..." &&
%{finaldir}/prepare_startup.sh &&
echo "Done." &&
printf "Deploying pm2 startup script..." &&
sudo su -c "env PATH=$PATH:/usr/local/bin pm2 startup redhat -u nodejs --hp /home/nodejs" &&
echo "Done." || 
exit 1;


%preun
echo "test preun";

%postun
echo "test postun";

%files
%defattr(-,root,root)
%attr(755,root,root) %{finaldir}/prepare_ssl.sh
%attr(755,root,root) %{finaldir}/prepare_startup.sh
%attr(755,root,root) %{finaldir}/platform.tar

%changelog

