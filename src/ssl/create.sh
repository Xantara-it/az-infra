#!/bin/bash

if [ ${EUID} -ne 0 ] ; then
  echo "You are not ROOT"
  exit 1
fi

if [ ! -f caKey.pem ] ; then 
  ipsec pki --gen --outform pem > caKey.pem
fi

if [ ! -f caCert.pem ] ; then
  ipsec pki --self --in caKey.pem --dn "CN=Xantara IT VPN CA" --ca --outform pem > caCert.pem
fi

if [ ! -f caCert.txt ] ; then
  openssl x509 -in caCert.pem -outform der | base64 | tee caCert.txt
fi
