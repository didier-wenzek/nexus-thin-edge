#!/bin/sh

if [ $# -ne 0 ]
then
    echo usage: $0
    echo     Get the signing certificate
    exit
fi

HOST=pgw.38.qa.go.nexusgroup.com
ACCOUNT=sag_te_di1_dc1

curl -s http://$HOST/est/$ACCOUNT/cacerts |
    ./add-pkcs7-header.sh |
    openssl pkcs7 -print_certs |
    ./extract-cert.sh
