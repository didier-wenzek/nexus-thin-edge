#!/bin/sh

if [ $# -ne 3 ]
then
    echo "usage: $0 csr.pem user password"
    echo "    Post a signing certificate and display the certificate once signed by the CA"
    echo
    echo "    csr.pem:   the certificate signing request"
    echo "    user:      the temporary user assigned for that request by the registerer"
    echo "    password:  the temporary password forged for that request by the registerer"
    exit
fi

CSR=$1
USER=$2
PASS=$3

HOST=pgw.38.qa.go.nexusgroup.com:8443
ACCOUNT=sag_te_di1_dc1

curl -s -H "Content-Type: application/pkcs10" \
    --data-binary @$CSR \
    --user "$USER:$PASS" --digest \
    -k https://$HOST/est/$ACCOUNT/simpleenroll |

    ./add-pkcs7-header.sh |
    openssl pkcs7 -print_certs |
    ./extract-cert.sh
