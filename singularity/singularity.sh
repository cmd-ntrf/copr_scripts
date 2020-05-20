#!/bin/sh -x

TAG=$(curl -s -N https://api.github.com/repos/hpcng/singularity/tags | jq -r '.[].name' | grep -m 1 -v rc)
VERSION=$(echo $TAG | sed 's/^v//')
NAME=$(echo $VERSION | cut -d. -f1,2)
curl -L -O https://github.com/hpcng/singularity/releases/download/${TAG}/singularity-$VERSION.tar.gz
tar xf singularity-${VERSION}.tar.gz singularity/singularity.spec
mv singularity/singularity.spec .
sed -i "28 a %global _prefix /opt/software/singularity-${NAME}" singularity.spec
