#!/bin/bash
set -e

VERSION=0.5.5

curl -L -O https://github.com/ubccr/mokey/archive/v${VERSION}.zip
curl -L -O https://golang.org/dl/go1.13.15.linux-amd64.tar.gz

tar xvf go*.linux-amd64.tar.gz
export PATH=$PATH:$PWD/go/bin

unzip mokey-${VERSION}.zip
cd mokey-${VERSION}
go build .
. scripts/make-release.sh
cd ..

cp mokey-${VERSION}/mokey.spec .
cp mokey-${VERSION}/*linux-amd64.tar.gz .

rm -rf go/ go1.13.15.linux-amd64.tar.gz v${VERSION}.zip mokey-${VERSION}/
