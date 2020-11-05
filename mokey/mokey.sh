#!/bin/bash
set -e

curl -L -O https://github.com/ubccr/mokey/archive/master.zip
curl -L -O https://golang.org/dl/go1.13.15.linux-amd64.tar.gz

tar xvf go*.linux-amd64.tar.gz
export PATH=$PATH:$PWD/go/bin

unzip master.zip
cd mokey-master
go build .
. scripts/make-release.sh
cd ..

cp mokey-master/mokey.spec .
cp mokey-master/*linux-amd64.tar.gz .

rm -rf go/ go1.13.15.linux-amd64.tar.gz master.zip mokey-masters