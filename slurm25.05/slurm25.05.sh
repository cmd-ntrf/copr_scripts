#!/bin/bash
set -e

TARNAME=$(curl -L https://download.schedmd.com/slurm/SHA256 | grep slurm-25 | tail -n 2 | head -n 1 | cut -d' ' -f3)
DIRNAME=${TARNAME%.tar.bz2}
TAG=$(echo $DIRNAME | sed 's/\./-/g')
TAG=$(curl -s -N https://api.github.com/repos/schedmd/slurm/tags | jq -r '.[].name' | grep -m 1 $TAG)

curl -L -O https://raw.githubusercontent.com/SchedMD/slurm/${TAG}/slurm.spec
sed -i '/^%configure/a \ \ \ \ \ \ \ \ --enable-selinux \\' slurm.spec
sed -i '/^%configure/a \ \ \ \ \ \ \ \ --prefix=/opt/software/slurm \\' slurm.spec
# In RedHat 9, in the generated libtool script, if LT_SYS_LIBRARY_PATH is not set
# its value is set to /opt/software/slurm/lib64 which then appears to prevent that
# path to figure in the RPATH of pam_slurm_adopt.so. By setting the value to an
# empty string during the configure, we prevent that from happening.
sed -i '/^%configure/a \ \ \ \ \ \ \ \ LT_SYS_LIBRARY_PATH="" \\' slurm.spec
sed -i '9 a %global _prefix /opt/software/slurm' slurm.spec
sed -i -e "s;QA_RPATHS=0x5;QA_RPATHS=0x7;g" slurm.spec
curl -L -O https://download.schedmd.com/slurm/${TARNAME}
tar xf ${TARNAME}
rm ${TARNAME}
cd ${DIRNAME}
autoconf
aclocal
automake
cd ..
tar cjSf ${TARNAME} ${DIRNAME}
rm -rf ${DIRNAME}
