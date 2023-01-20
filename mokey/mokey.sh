#!/bin/bash
set -e

VERSION=0.5.6
GOVERSION=1.13.15
if [ $(uname -m) == "x86_64" ]; then
    ARCH=amd64
else
    ARCH=arm64
fi

curl -L -O https://github.com/ubccr/mokey/archive/v${VERSION}.zip
curl -L -O https://golang.org/dl/go${GOVERSION}.linux-${ARCH}.tar.gz

tar xvf go*.linux-${ARCH}.tar.gz
export PATH=$PATH:$PWD/go/bin

unzip v${VERSION}.zip
cd mokey-${VERSION}
GOARCH=${ARCH} go build .
. scripts/make-release.sh
cd ..

cp mokey-${VERSION}/mokey.spec .
cp mokey-${VERSION}/*linux-amd64.tar.gz .

rm -rf go/ go1.13.15.linux-amd64.tar.gz v${VERSION}.zip mokey-${VERSION}/
