#!/bin/sh

if [ $# -ne 0 ]
then
    echo usage: $0
    echo     Get the list of registrations
    exit
fi

HOST=pgw.38.qa.go.nexusgroup.com
ACCOUNT=sag_te_di1_dc1
ACCOUNT_INTERNAL_ID=t4793186911343297060
OFFICER_P12=system_officer_38_sag.p12
OFFICER_PASS=1234

if [ ! -f $OFFICER_P12 ]
then
    echo "missing P12 file for the system officer"
    exit 1
fi

curl -s \
    --cert $OFFICER_P12:$OFFICER_PASS --cert-type P12 \
    -k https://$HOST/api/registrations/$ACCOUNT_INTERNAL_ID/est |

    jq .
