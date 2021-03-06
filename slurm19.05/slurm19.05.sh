#!/bin/bash
set -e

TAG=$(curl -s -N https://api.github.com/repos/schedmd/slurm/tags | jq -r '.[].name' | grep -m 1 slurm-19-05)
VERSION=$(echo $TAG | cut -d- -f2,3,4,5)
TARNAME=$(echo $VERSION | sed 's/-/./g' | cut -d. -f1,2,3)

curl -L -O https://raw.githubusercontent.com/SchedMD/slurm/slurm-${VERSION}/slurm.spec
curl https://raw.githubusercontent.com/cmd-ntrf/copr_scripts/master/slurm19.05/1be5492.patch | patch -p1
sed -i '/^%configure/a \ \ \ \ \ \ \ \ --prefix=/opt/software/slurm \\' slurm.spec
sed -i 's/python$/python3/g' slurm.spec
sed -i '9 a %global _prefix /opt/software/slurm' slurm.spec

# CentOS 8 has hardened build
sed -i '59 a %undefine _hardened_build' slurm.spec
sed -i '60 a %global _hardened_cflags "-Wl,-z,lazy"' slurm.spec
sed -i '61 a %global _hardened_ldflags "-Wl,-z,lazy"' slurm.spec

curl -L -O https://download.schedmd.com/slurm/slurm-${TARNAME}.tar.bz2
tar xf slurm-${TARNAME}.tar.bz2
rm slurm-${TARNAME}.tar.bz2
cd slurm-${TARNAME}
sed -i -e 's;nvml_includes=".*";nvml_includes="-I/usr/local/cuda-11.1/targets/x86_64-linux/include";g' auxdir/x_ac_nvml.m4
sed -i -e 's;#!/usr/bin/env python;#!/usr/bin/env python3;g' doc/html/shtml2html.py
curl https://raw.githubusercontent.com/cmd-ntrf/copr_scripts/master/slurm19.05/bug9109.patch | patch -p1
autoconf
aclocal
automake
cd ..
tar cjSf slurm-${TARNAME}.tar.bz2 slurm-${TARNAME}
rm -rf slurm-${TARNAME}
