#!/bin/sh
finaldir=/opt/rfidmonitor;
ssldir=$finaldir/platform/server/config/ssl;

cd $finaldir &&
openssl genrsa -out $ssldir/platform-key.pem 1024 &&
openssl req -new -key $ssldir/platform-key.pem -out $ssldir/platform-cert-req.csr &&
openssl x509 -req -in $ssldir/platform-cert-req.csr -signkey $ssldir/platform-key.pem -out $ssldir/platform-cert.pem ;
