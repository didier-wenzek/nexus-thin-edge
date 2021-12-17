#!/bin/sh

if [ $# -ne 3 ]
then
    echo "usage: $0 csr.pem previous.cert previous.key"
    echo "    Post a signing certificate to renew a certificate and display the certificate once signed by the CA"
    echo
    echo "    csr.pem:   the certificate signing request"
    echo "    previous.cert:   the certificate to be renewed"
    echo "    previous.key:    the private key associated to the certificate"
    exit
fi

CSR=$1
CERT=$2
PKEY=$3

HOST=pgw.38.qa.go.nexusgroup.com:8444
ACCOUNT=sag_te_di1_dc1

curl -s -H "Content-Type: application/pkcs10" \
    --data-binary @$CSR \
    --cert $CERT --key $PKEY \
    -k https://$HOST/est/$ACCOUNT/simplereenroll |
    ./add-pkcs7-header.sh |
    openssl pkcs7 -print_certs |
    ./extract-cert.sh
