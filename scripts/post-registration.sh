#!/bin/sh

if [ $# -ne 3 ]
then
    echo "usage: $0 CN user password"
    echo "    Register a signing request for a certificate"
    echo
    echo "    CN:        the Common Name for which a signing request is registered."
    echo "    user:      the username that will have to be used for the signing request."
    echo "    password:  the password that will have to be used for the signing request."
    exit 1
fi

CN=$1
USER=$2
PASS=$3

HOST=pgw.38.qa.go.nexusgroup.com
ACCOUNT=sag_te_di1_dc1
ACCOUNT_INTERNAL_ID=t4793186911343297060
OFFICER_P12=system_officer_38_sag.p12
OFFICER_PASS=1234
OFFICER_PEM=system_officer_38_sag.pem

if [ ! -f $OFFICER_P12 ]
then
    echo "missing P12 file for the system officer"
    exit 1
fi

if [ ! -f $OFFICER_PEM ]
then
    openssl pkcs12 -in $OFFICER_P12 -passin pass:$OFFICER_PASS -out $OFFICER_PEM -nodes
fi

REQUEST=$(cat <<EOF
{
  "fqdn": "$CN",
  "realm": "$ACCOUNT",
  "username": "$USER",
  "password": "$PASS",
  "status": "open",
  "validity": "7"
}
EOF
)

DATA=$(curl -s \
    -H "Content-Type: application/json" \
    --cert $OFFICER_P12:$OFFICER_PASS --cert-type P12 \
    --data-binary "$REQUEST" \
    -k https://$HOST/api/registrations/$ACCOUNT_INTERNAL_ID/est)

SIGNED_DATA=$(echo $DATA |
    jq -r .dataToSign |
    openssl base64 -d -A |
    openssl cms -sign -signer $OFFICER_PEM -binary -outform DER -nodetach |
    openssl base64 -e |
    tr -d '\r\n')

SIGNED_REQUEST=$(cat <<EOF
{
  "fqdn": "$CN",
  "realm": "$ACCOUNT",
  "username": "$USER",
  "password": "$PASS",
  "status": "open",
  "validity": "7",
  "signature": "$SIGNED_DATA"
}
EOF
)

curl -s \
    -H "Content-Type: application/json" \
    --cert $OFFICER_P12:$OFFICER_PASS --cert-type P12 \
    --data-binary "$SIGNED_REQUEST" \
    -k https://$HOST/api/registrations/$ACCOUNT_INTERNAL_ID/est
