#!/bin/bash
set -e

VERSION=3.2.3

curl -L -O https://github.com/openpmix/openpmix/releases/download/v${VERSION}/pmix-${VERSION}.tar.bz2

tar xf pmix-${VERSION}.tar.bz2 pmix-${VERSION}/contrib/pmix.spec
mv pmix-${VERSION}/contrib/pmix.spec .

rm -rf pmix-${VERSION}/