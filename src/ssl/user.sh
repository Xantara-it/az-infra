#!/bin/bash

if [ ${EUID} -ne 0 ] ; then
  echo "You are not ROOT"
  exit 1
fi

export USERNAME="${1}"
export PASSWORD="${2}"

ipsec pki --gen --outform pem > "${USERNAME}-key.pem"
ipsec pki --pub --in "${USERNAME}-key.pem" \
  | ipsec pki --issue --cacert caCert.pem --cakey caKey.pem --dn "CN=${USERNAME}" --san "${USERNAME}" --flag clientAuth --outform pem > "${USERNAME}-cert.pem"

openssl pkcs12 -in "${USERNAME}-cert.pem" -inkey "${USERNAME}-key.pem" -certfile caCert.pem -export -out "${USERNAME}.p12" -password "pass:${PASSWORD}"
