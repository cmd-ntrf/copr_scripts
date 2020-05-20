#!/bin/sh -x

TAG="slurm-19-05-6-1"
VERSION=$(echo $TAG | cut -d- -f2,3,4,5)
TARNAME=$(echo $VERSION | sed 's/-/./g' | cut -d. -f1,2,3)

curl -L -O https://raw.githubusercontent.com/SchedMD/slurm/slurm-${VERSION}/slurm.spec
sed -i 's/.bz2/.gz/g' slurm.spec
sed -i '/^%configure/a \ \ \ \ \ \ \ \ --prefix=/opt/software/slurm \\' slurm.spec
sed -i 's/python/python3/g' slurm.spec
sed -i '9 a %global _prefix /opt/software/slurm' slurm.spec
curl -L -O https://github.com/SchedMD/slurm/archive/slurm-${VERSION}.tar.gz
tar xvf slurm-${VERSION}.tar.gz
rm slurm-${VERSION}.tar.gz
mv slurm-slurm-${VERSION} slurm-${TARNAME}
cd slurm-${TARNAME}
sed -i -e 's;nvml_includes=".*";nvml_includes="-I/usr/local/cuda-10.1/targets/x86_64-linux/include";g' auxdir/x_ac_nvml.m4
autoconf
automake
cd ..
tar czvf slurm-${TARNAME}.tar.gz slurm-${TARNAME}
rm -rf slurm-${TARNAME}
