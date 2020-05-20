#!/bin/sh -x
export VERSION=3.4.2
curl -L -O https://github.com/sylabs/singularity/releases/download/v$VERSION/singularity-$VERSION.tar.gz
tar xf singularity-${VERSION}.tar.gz singularity/singularity.spec
mv singularity/singularity.spec .
sed -i '28 a %global _prefix /opt/software/singularity-3.4' singularity.spec
