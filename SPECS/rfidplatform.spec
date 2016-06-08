Summary: Monitoring Platform.
%define version 0.1
Group: ? Development/Languages
Name: rfidplatform
Prefix: ? /usr
Provides: ? jikes
Release: 1
Source: rfidplatform-%{version}.tar.gz
URL: https://github.com/CELTAB/rfidmonitor-platform
Version: %{version}
Buildroot: /tmp/rpm-rfidplatform
%description
A platform for rfidmonitoring.
%prep

%setup -q

%build
./configure CXXFLAGS=-O3 --prefix=$RPM_BUILD_ROOT/usr
make

%install
rm -rf $RPM_BUILD_ROOT
make install

%clean
rm -rf $RPM_BUILD_ROOT
The clean section starts with a %clean statement
