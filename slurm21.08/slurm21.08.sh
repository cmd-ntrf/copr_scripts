#!/bin/bash
set -e

TAG=$(curl -s -N https://api.github.com/repos/schedmd/slurm/tags | jq -r '.[].name' | grep -m 1 slurm-21-08)
VERSION=$(echo $TAG | cut -d- -f2,3,4,5)
TARNAME=$(echo $VERSION | sed 's/-/./1' | sed 's/-/./1')

curl -L -O https://raw.githubusercontent.com/SchedMD/slurm/slurm-${VERSION}/slurm.spec
sed -i '/^%configure/a \ \ \ \ \ \ \ \ --enable-selinux \\' slurm.spec
sed -i '/^%configure/a \ \ \ \ \ \ \ \ --prefix=/opt/software/slurm \\' slurm.spec
# auth_jwt.so is missing in Slurm 20.11.7
sed -i '/^%files slurmrestd/a %{_libdir}/slurm/auth_jwt.so' slurm.spec
sed -i '9 a %global _prefix /opt/software/slurm' slurm.spec
if cat /etc/redhat-release | grep -q "release 9"; then
    sed -i '10 a %define _lto_cflags %{nil}' slurm.spec
fi
curl -L -O https://download.schedmd.com/slurm/slurm-${TARNAME}.tar.bz2
tar xf slurm-${TARNAME}.tar.bz2
rm slurm-${TARNAME}.tar.bz2
cd slurm-${TARNAME}
sed -i -e "s;_x_ac_nvml_dirs=\".*\";_x_ac_nvml_dirs=\"$(echo /usr/local/cuda-11.*)\";g" auxdir/x_ac_nvml.m4
curl https://raw.githubusercontent.com/cmd-ntrf/copr_scripts/master/slurm21.08/bug9109.patch | patch -p1
autoconf
aclocal
automake
cd ..
tar cjSf slurm-${TARNAME}.tar.bz2 slurm-${TARNAME}
rm -rf slurm-${TARNAME}
