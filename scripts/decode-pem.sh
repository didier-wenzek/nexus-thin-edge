#!/bin/sh

FILE=$1

if [ -z "$FILE" ]
then
	openssl x509 -noout -text
else
	openssl x509 -in $FILE -noout -text
fi
