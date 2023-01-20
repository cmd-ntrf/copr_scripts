#!/bin/bash
set -e

VERSION=0.5.6
curl -L https://github.com/ubccr/mokey/archive/v${VERSION}.tar.gz -o mokey-${VERSION}.tar.gz
curl -L -O https://raw.githubusercontent.com/cmd-ntrf/copr_scripts/master/mokey/mokey.spec

