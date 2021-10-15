#!/bin/sh

FILE=$1

if [ -z "$FILE" ]
then
	openssl req -noout -text
else
	openssl req -in $FILE -noout -text
fi
