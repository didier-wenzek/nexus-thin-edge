#!/bin/sh

if [ $# -ne 4 ]
then
    echo "usage: $0 DEVICE_CN CLOUD_TENANT KEY.FILE CSR.FILE"
    echo "    Create a certificate signing request for a device"
    echo
    echo "    DEVICE_CN:     the Common Name of the certificate"
    echo "    CLOUD_TENANT:  the Cloud tenant where the device will be registered"
    echo "    KEY.FILE:      the path where the device private key will be stored"
    echo "    CSR.FILE:      the path where the certificate signing request will be stored"
    exit
fi

DEVICE=$1
TENANT=$2
KEY=$3
CSR=$4

SUBJECT="/O=Thin-Edge/OU=$TENANT/CN=$DEVICE"

openssl genrsa -out $KEY 2048
openssl req -out $CSR -key $KEY -new -subj $SUBJECT
