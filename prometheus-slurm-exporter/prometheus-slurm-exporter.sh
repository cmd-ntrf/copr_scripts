#!/bin/bash
set -e

VERSION=0.21
curl -L -O https://github.com/guilbaults/prometheus-slurm-exporter/archive/refs/heads/osc.zip
curl -L -O https://raw.githubusercontent.com/cmd-ntrf/copr_scripts/master/prometheus-slurm-exporter/prometheus-slurm-exporter.spec

unzip osc.zip
mv prometheus-slurm-exporter-osc prometheus-slurm-exporter-${VERSION}
tar czvf prometheus-slurm-exporter-${VERSION}.tar.gz prometheus-slurm-exporter-${VERSION}
rm -rf osc.zip prometheus-slurm-exporter-${VERSION}
