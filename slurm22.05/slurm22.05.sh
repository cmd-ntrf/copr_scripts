#!/bin/bash
set -e

TAG=$(curl -s -N https://api.github.com/repos/schedmd/slurm/tags | jq -r '.[].name' | grep -m 1 slurm-22-05)
VERSION=$(echo $TAG | cut -d- -f2,3,4,5)
TARNAME=$(echo $VERSION | sed 's/-/./g' | cut -d. -f1,2,3)

curl -L -O https://raw.githubusercontent.com/SchedMD/slurm/slurm-${VERSION}/slurm.spec
sed -i '/^%configure/a \ \ \ \ \ \ \ \ --enable-selinux \\' slurm.spec
sed -i '/^%configure/a \ \ \ \ \ \ \ \ --prefix=/opt/software/slurm \\' slurm.spec
# In RedHat 9, in the generated libtool script, if LT_SYS_LIBRARY_PATH is not set
# its value is set to /opt/software/slurm/lib64 which then appears to prevent that
# path to figure in the RPATH of pam_slurm_adopt.so. By setting the value to an
# empty string during the configure, we prevent that from happening.
sed -i '/^%configure/a \ \ \ \ \ \ \ \ LT_SYS_LIBRARY_PATH="" \\' slurm.spec
# auth_jwt.so is missing in Slurm 20.11.7
sed -i '/^%files slurmrestd/a %{_libdir}/slurm/auth_jwt.so' slurm.spec
sed -i '9 a %global _prefix /opt/software/slurm' slurm.spec
sed -i -e "s;QA_RPATHS=0x5;QA_RPATHS=0x7;g" slurm.spec
curl -L -O https://download.schedmd.com/slurm/slurm-${TARNAME}.tar.bz2
tar xf slurm-${TARNAME}.tar.bz2
rm slurm-${TARNAME}.tar.bz2
cd slurm-${TARNAME}
sed -i -e "s;_x_ac_nvml_dirs=\".*\";_x_ac_nvml_dirs=\"$(echo /usr/local/cuda-11.*)\";g" auxdir/x_ac_nvml.m4
curl https://raw.githubusercontent.com/cmd-ntrf/copr_scripts/master/slurm22.05/bug9109.patch | patch -p1
#autoreconf
autoconf
aclocal
automake
cd ..
tar cjSf slurm-${TARNAME}.tar.bz2 slurm-${TARNAME}
rm -rf slurm-${TARNAME}
